# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development

This is a native Swift/SwiftUI iOS application built with Xcode. There is no CLI build system — all builds are done through Xcode.

**To build and run:** Open `MTGDraft/MTGDraft.xcodeproj` in Xcode and use ⌘R to run.

**No tests are currently configured** — the project has no test targets.

## Architecture

The app is a Magic: The Gathering draft manager using SwiftUI + Core Data.

**Entry point:** `MTGDraft/MTGDraftApp.swift` — bootstraps the app, injects the Core Data `managedObjectContext` into the SwiftUI environment, and presents `ContentView`.

**Persistence:** `MTGDraft/Persistence.swift` — singleton `PersistenceController` wrapping an `NSPersistentContainer`. Supports an in-memory mode for SwiftUI previews. The Core Data schema is defined in `MTGDraft/MTGDraft.xcdatamodeld/`.

**Feature modules** live in subdirectories under `MTGDraft/`:
- `SetList/` — In-progress. `SetListViewModel` (observable object) + `SetListView`. Not yet wired into the main app.

The current Core Data model has a single `Item` entity with a `timestamp` Date attribute — this is Xcode's template scaffold and will need to be replaced with MTG-domain entities.
