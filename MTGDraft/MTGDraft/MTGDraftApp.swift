//
//  MTGDraftApp.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import SwiftUI

@main
struct MTGDraftApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                SetListView()
                    .tabItem { Label("Sets", systemImage: "square.stack") }

                DecksView()
                    .tabItem { Label("Decks", systemImage: "rectangle.stack") }

                DraftSetListView()
                    .tabItem { Label("Draft", systemImage: "shuffle") }
            }
        }
    }
}
