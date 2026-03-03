# Cultivation — Agent Guide

iOS plant care and garden management app built with SwiftUI + Swift 6.

## Prerequisites

| Tool | Install |
|------|---------|
| Xcode 17+ | App Store or `xcode-select --install` |
| XcodeGen | `brew install xcodegen` |
| SwiftLint | `brew install swiftlint` |
| pre-commit | `brew install pre-commit` |

## Setup

```bash
git clone https://github.com/jbcrane13/Cultivation-2.git
cd Cultivation-2
pre-commit install
xcodegen generate
open Cultivation.xcodeproj
```

## Commands

| Task | Command |
|------|---------|
| Regenerate project | `xcodegen generate` |
| Build | `xcodebuild -scheme Cultivation -configuration Debug build` |
| Test | `xcodebuild test -scheme Cultivation -destination 'platform=iOS Simulator,name=iPhone 16'` |
| Lint | `swiftlint` |
| Lint (strict) | `swiftlint --strict` |
| Lint (autocorrect) | `swiftlint --fix` |

## Architecture

```
Cultivation/
├── App/          # @main entry point, ContentView (onboarding gate)
├── Models/       # Pure Swift value types — Plant, UserPreferences enums
├── Services/     # Business logic, networking (currently empty stubs)
└── Views/
    ├── Components/   # Reusable views: PlantCard, SelectionCard
    ├── Dashboard/    # Main tab — weather card + plant list
    ├── Layout/       # Visual garden grid (LazyVGrid)
    ├── Onboarding/   # 3-step first-run flow (step-based state machine)
    ├── Scanner/      # Camera plant ID (mock UI only, no live capture yet)
    └── Settings/     # Pet-safe toggle, debug reset, location
```

### State management
- `@AppStorage("hasCompletedOnboarding")` — persists onboarding gate
- `@State` — all local view state
- No global state manager (no ViewModel layer yet — add if views grow complex)

### Current mock / stub status
- Weather card: hardcoded to Daphne AL / Zone 8b
- Plant data: hardcoded array in `DashboardView`
- Scanner: UI mock only, no `AVFoundation` or plant ID API
- Services/: empty directory, reserved for future networking/persistence

## Coding Conventions

### SwiftUI patterns
- Use `Button { action } label: { view }` — never `Button(action: { }) { view }`
- Keep `body` under 60 lines; extract subviews as `private var` computed properties
- Name extracted sub-views with the suffix `Step`, `Card`, `Row`, or `Section` as appropriate
- Prefer `.ultraThinMaterial` for overlay backgrounds

### Naming
- Types: `UpperCamelCase`
- Properties/functions: `lowerCamelCase`
- SwiftLint enforces `identifier_name` min 2 / max 50 chars

### Files
- One type per file; filename matches type name
- Max 400 lines per file (SwiftLint warning at 400, error at 600)

### Optionals
- Never `= nil` to initialise optional `@State` — use bare `Type?`
- Prefer `guard let` over force-unwrap; force-unwrap is a SwiftLint error

### Logging
- Use the shared `Logger` from `Services/Logger.swift`
- Never log PII (names, locations, device IDs) without `%{private}` formatter
- Format: `logger.info("action: \(value, privacy: .public)")`

## PR Workflow

1. Branch from `main` — `git checkout -b feat/short-description`
2. Run `swiftlint` before pushing (pre-commit hook enforces this)
3. Regenerate the Xcode project if `project.yml` changed: `xcodegen generate`
4. Open a PR — CI runs lint and tests automatically
5. Squash-merge after CI passes

## Security / Secrets

- Never hardcode API keys — use `.env` (gitignored) or Xcode build settings
- See `.env.example` for the list of required variables
- When adding a new secret: add to `.env.example` with a comment, document in this file

## Adding a New Screen

1. Create `Cultivation/Views/<Area>/<Name>View.swift`
2. Register it in `MainTabView.swift` or as a `NavigationLink` destination
3. Add unit tests in `CultivationTests/` if the view has non-trivial logic
4. Run `swiftlint` — fix all violations before committing

<!-- BEGIN BEADS INTEGRATION -->
## Issue Tracking with bd (beads)

**IMPORTANT**: This project uses **bd (beads)** for ALL issue tracking. Do NOT use markdown TODOs, task lists, or other tracking methods.

### Why bd?

- Dependency-aware: Track blockers and relationships between issues
- Git-friendly: Dolt-powered version control with native sync
- Agent-optimized: JSON output, ready work detection, discovered-from links
- Prevents duplicate tracking systems and confusion

### Quick Start

**Check for ready work:**

```bash
bd ready --json
```

**Create new issues:**

```bash
bd create "Issue title" --description="Detailed context" -t bug|feature|task -p 0-4 --json
bd create "Issue title" --description="What this issue is about" -p 1 --deps discovered-from:bd-123 --json
```

**Claim and update:**

```bash
bd update <id> --claim --json
bd update bd-42 --priority 1 --json
```

**Complete work:**

```bash
bd close bd-42 --reason "Completed" --json
```

### Issue Types

- `bug` - Something broken
- `feature` - New functionality
- `task` - Work item (tests, docs, refactoring)
- `epic` - Large feature with subtasks
- `chore` - Maintenance (dependencies, tooling)

### Priorities

- `0` - Critical (security, data loss, broken builds)
- `1` - High (major features, important bugs)
- `2` - Medium (default, nice-to-have)
- `3` - Low (polish, optimization)
- `4` - Backlog (future ideas)

### Workflow for AI Agents

1. **Check ready work**: `bd ready` shows unblocked issues
2. **Claim your task atomically**: `bd update <id> --claim`
3. **Work on it**: Implement, test, document
4. **Discover new work?** Create linked issue:
   - `bd create "Found bug" --description="Details about what was found" -p 1 --deps discovered-from:<parent-id>`
5. **Complete**: `bd close <id> --reason "Done"`

### Auto-Sync

bd automatically syncs via Dolt:

- Each write auto-commits to Dolt history
- Use `bd dolt push`/`bd dolt pull` for remote sync
- No manual export/import needed!

### Important Rules

- ✅ Use bd for ALL task tracking
- ✅ Always use `--json` flag for programmatic use
- ✅ Link discovered work with `discovered-from` dependencies
- ✅ Check `bd ready` before asking "what should I work on?"
- ❌ Do NOT create markdown TODO lists
- ❌ Do NOT use external issue trackers
- ❌ Do NOT duplicate tracking systems

For more details, see README.md and docs/QUICKSTART.md.

<!-- END BEADS INTEGRATION -->

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd sync
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
