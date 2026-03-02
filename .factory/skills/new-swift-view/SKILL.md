---
name: new-swift-view
description: Creates a new SwiftUI view for the Cultivation iOS app following project conventions. Use when adding any new screen, component, or reusable UI element.
---

# New SwiftUI View

## Steps

1. **Determine placement** — decide which directory under `Cultivation/Views/` fits the view:
   - `Components/` for reusable widgets (cards, rows, badges)
   - `Dashboard/`, `Layout/`, `Scanner/`, `Settings/`, `Onboarding/` for full screens

2. **Create the file** — name it `<Name>View.swift` or `<Name>Card.swift`. One type per file.

3. **Follow project patterns**:
   - `Button { action } label: { view }` — never `Button(action:) { }`
   - Extract sub-views as `private var` computed properties when `body` exceeds ~30 lines
   - Use `@State` for local state; no global ViewModels unless the view is complex
   - Optionals: `@State private var foo: Type?` — no `= nil`
   - Logging: use the shared `Logger` (e.g., `Logger.app.info(...)`)

4. **Register the view** — add it to `MainTabView.swift` or wire it as a `NavigationLink` destination

5. **Lint** — run `swiftlint` and fix all violations before committing

6. **Test** — if the view contains non-trivial logic, add a test in `CultivationTests/`

## Template

```swift
import SwiftUI

struct <Name>View: View {
    var body: some View {
        Text("<Name>View placeholder")
    }
}

#Preview {
    <Name>View()
}
```
