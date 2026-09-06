# NixOS multi-host / multi-user configuration

This repo is a Nix flake managing multiple NixOS hosts and multiple users via
home-manager. Structure and rationale below so future sessions don't need to
re-derive it.

## Current state

- One host: `skypc` (desktop). A second host, `shrubbery` (ThinkPad laptop),
  is planned but not yet added.
- One user: `ali`. A second user, `ryan`, is planned but not yet added.
- Two MacBooks (personal + corporate) are a further-future extension, to be
  managed with `nix-darwin` — see "Extending to nix-darwin" below.

## Layout

```
flake.nix                          # inputs + mkHost helper + nixosConfigurations
flake.lock

hosts/
  skypc/
    default.nix                    # host-specific config (bootloader, timezone, per-host extras)
    hardware-configuration.nix     # generated on-site, gitignored (see below)
  <hostname>/
    users/
      <username>/
        account.nix                 # OPTIONAL host+user NixOS override (see "Override granularity")
        home.nix                    # OPTIONAL host+user home-manager override

modules/
  nixos/default.nix                # NixOS settings shared by every host
  home-manager/default.nix         # home-manager settings shared by every user

users/
  ali/
    account.nix                    # NixOS account for ali (users.users.ali = {...}), shared across hosts
    home.nix                       # ali's home-manager config, shared across hosts
  <username>/
    account.nix
    home.nix
```

## How a host is declared

`flake.nix` defines `mkHost { hostname, system ? "x86_64-linux", users }`,
which builds one `nixosSystem` by assembling:
- `./hosts/<hostname>` (implicitly `default.nix`)
- `./modules/nixos` (common to every host)
- `home-manager.nixosModules.home-manager`, configured with
  `home-manager.users.<user>` for each user in `users`
- `./users/<user>/account.nix` for each user in `users`

So adding a host is just:
```nix
shrubbery = mkHost {
  hostname = "shrubbery";
  users = [ "ali" "ryan" ];
};
```
plus creating `hosts/shrubbery/default.nix` and (once) `users/ryan/{account,home}.nix`.
`hosts/shrubbery/hardware-configuration.nix` must be generated on that machine
(see below) — it won't exist yet on this checkout.

## Override granularity

Three levels of configuration are supported:
- **Host-specific**: `hosts/<hostname>/default.nix` — applies to that host regardless of user.
- **User-specific**: `users/<user>/{account.nix,home.nix}` — applies to that user regardless of host.
- **Host+user-specific**: `hosts/<hostname>/users/<user>/{account.nix,home.nix}` — OPTIONAL,
  and the two files are independent (create only the one you need):
  - `account.nix` is a **NixOS module**, appended to the host's top-level
    `modules` list. Use it for anything at the NixOS/system level that should
    differ per host for one user — extra `extraGroups` only on one machine, a
    **system** `systemd.services.<name>` unit, host-specific sudoers/SSH
    `authorized_keys`, etc.
  - `home.nix` is a **home-manager module**, appended to that user's
    `home-manager.users.<user>.imports`. Use it for anything home-manager-level
    that should differ per host — packages, dotfiles, and notably **user**
    systemd services (`systemd.user.services.<name>`, i.e. what
    `systemctl --user` manages) — those are a home-manager concern, not a
    NixOS one, so they belong here even though they end up as systemd units.

  Both are picked up automatically by `mkHost` via
  `lib.optional (builtins.pathExists ...)` — nothing else needs to change when
  adding one, **except** the file must be `git add`ed first (see the gotcha
  below — this isn't just about `hardware-configuration.nix`).

## hardware-configuration.nix handling

Each host's `hardware-configuration.nix` is machine-generated
(`nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix`)
and is **not meant to be committed** — it's listed in `.gitignore` via
`hosts/*/hardware-configuration.nix`.

Important Nix flake gotcha, **not specific to this file**: flakes only see
**git-tracked** files, full stop. Any new file — a new host directory, a new
`users/<user>/`, a host+user override — is invisible to `nix build`/
`nix flake check` (silently: `builtins.pathExists` on it returns `false`, no
error) until it's at least `git add`ed. Confirmed by testing: a fresh
`hosts/skypc/users/ali/account.nix` override was silently ignored until
staged.

For `hardware-configuration.nix` specifically, since it's meant to never be
committed, the fix is
`git add --intent-to-add --force hosts/<hostname>/hardware-configuration.nix`
right after generating it — this marks the path as tracked (visible to Nix's
git filter) without staging its actual content, so it never actually gets
committed. **Do this for every new host.**

For everything else (host dirs, user dirs, host+user overrides) that's
*meant* to be committed, a normal `git add` before running `nix flake check`/
`nixos-rebuild` is enough — just don't forget it exists as a step, since the
failure mode is silence, not an error.

## home-manager integration style

Chosen: home-manager as a **NixOS module**
(`home-manager.nixosModules.home-manager`), not standalone
`homeConfigurations`. One `sudo nixos-rebuild switch` updates system and home
config together — simpler day-to-day than a separate `home-manager switch`
command. Trade-off: home-manager changes require the same privileges as a
system rebuild (no unprivileged self-service for non-admin users on a
shared host). Revisit if that becomes a problem (e.g. for `ryan` on a
shared host).

`modules/home-manager/default.nix` and `users/<user>/home.nix` are
deliberately kept **OS-agnostic** (no Linux-specific paths beyond the
`lib.mkDefault` home directory, no NixOS-only assumptions) so they can be
reused as-is under nix-darwin later.

## Extending to nix-darwin (not yet built)

When a MacBook is added, `mkHost` will NOT work as-is — it's NixOS-only.
Needed at that point:
- Add `inputs.nix-darwin`.
- Write a sibling `mkDarwinHost` using `inputs.nix-darwin.lib.darwinSystem`
  instead of `nixpkgs.lib.nixosSystem`, `system = "aarch64-darwin"` default,
  and `home-manager.darwinModules.home-manager` instead of the NixOS module.
- Add `modules/darwin/default.nix` for settings common to Darwin hosts
  (`modules/nixos` doesn't apply there).
- `users/<user>/account.nix` is NixOS-specific (`isNormalUser`, `extraGroups`
  don't exist on Darwin — `users.users.<name>` there mostly just annotates an
  existing macOS account). A Darwin host will need its own account file.
- `users/<user>/home.nix` and `modules/home-manager/default.nix` should carry
  over unchanged — that portability was the point of keeping them
  OS-agnostic. One known fix needed first:
  `modules/home-manager/default.nix` hardcodes
  `home.homeDirectory = lib.mkDefault "/home/${config.home.username}"`,
  which is wrong on Darwin (`/Users/<user>`). Make it
  `pkgs.stdenv.isDarwin`-conditional before adding the first Mac.
- Two MacBooks (personal vs corporate) with a tool allowed on one but not the
  other is exactly the host+user override case above — e.g. a
  `hosts/personal-mbp/users/ali/home.nix` adding the extra package, with no
  corresponding file under `hosts/corp-mbp/`.

## Design references consulted

- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
  (`standard` flavor) — source of the `modules/{nixos,home-manager}` split.
  Note: its stock layout is single-host/single-user; the multi-host/user
  wiring here (`mkHost`, per-host directories, override files) is not from
  that repo.
- vimjoyer's "NixOS 79/80/81 — Flakes + Home Manager Multiuser/Multihost
  Configuration" YouTube series — source of the incremental
  hosts-then-users-then-home-manager builder-function pattern (`mkHost`).
