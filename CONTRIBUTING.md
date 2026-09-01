# Contributing

## File Structure

```
.
├── flake.nix              # Flake entry point
├── configuration.nix      # System configuration
├── home.nix              # Home Manager configuration
├── modules/              # Modular configurations
│   ├── aliases.nix       # Shell aliases
│   └── agents.nix        # Agent-specific settings
├── home/                 # User config files
│   ├── .config/          # Application configs
│   ├── .pi/              # Pi configuration
│   ├── .claude/          # Claude Code config
│   ├── AGENTS.md         # Agent documentation
│   └── CLAUDE.md         # Claude instructions
├── scripts/              # Utility scripts
└── tests/                # Test scripts
```

## Making Changes

1. Create a feature branch
2. Make changes to relevant files
3. Test with `bash rebuild.sh`
4. Commit and push

## Testing

Run tests from the `tests/` directory:

```bash
bash tests/pi-calm.test.sh
```
