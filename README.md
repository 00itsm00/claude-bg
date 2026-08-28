# claude-bg

Run [Claude Code](https://docs.claude.com/en/docs/claude-code) as a persistent background instance (via `tmux`) with Remote Control on by default, so you get a phone/`claude.ai/code` link as soon as it starts. Run multiple instances at once, each pinned to its own project directory.

## Install (any Ubuntu box)

```bash
curl -fsSL https://raw.githubusercontent.com/00itsm00/claude-bg/main/install.sh | sudo bash
```

This installs `claude-bg` to `/usr/local/bin`, and installs `tmux` via `apt` if it isn't already present.

Or, from a local clone:

```bash
git clone https://github.com/00itsm00/claude-bg.git
cd claude-bg
sudo ./install.sh
```

## Requirements

- Ubuntu (or any Linux with `apt`)
- `tmux` (auto-installed by `install.sh` if missing)
- The `claude` CLI on `PATH`

## Usage

```
claude-bg start /root/hc            # start & print the remote link (instance 'hc')
claude-bg start ~/project-b beta    # explicit name overrides the directory basename
claude-bg list                      # see what's running and where
claude-bg attach hc                 # or: claude-bg attach /root/hc
claude-bg restart hc                # relaunch in its last directory
claude-bg stop hc                   # or: claude-bg stop /root/hc
claude-bg stop all                  # stop everything
```

Instance name defaults to the directory's basename. Anywhere a `[name]` is expected, you can pass the full directory path instead — its basename is used to find the matching instance. Omitting `[name]`/`[dir]` uses the `default` instance.

Every instance starts with Remote Control already on (`claude --remote-control <name>`), so the phone/`claude.ai/code` link is ready as soon as `start` returns. The one-time "trust this folder" prompt is confirmed automatically.
