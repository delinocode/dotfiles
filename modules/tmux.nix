# tmux configuration.
#
# In this repo the only tmux-related configuration that existed in
# home.nix was:
#   - the tmux aliases, which per the modularization rules stay in
#     modules/aliases.nix ("conserver les alias tmux dans ce fichier");
#   - the tmux package, which lives in modules/packages.nix.
# There was no programs.tmux block, no tmux script, and no tmux
# file to move - so this module intentionally declares nothing.
{ ... }:

{
}
