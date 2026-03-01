//
//  SetListView.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import SwiftUI

struct SetListView: View {
    @State private var model = SetListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if model.isLoading {
                    ProgressView()
                } else {
                    List(model.filteredSets) { set in
                        NavigationLink(destination: CardListView(set: set)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(set.name)
                                    .font(.headline)
                                HStack(spacing: 4) {
                                    Text(set.code.uppercased())
                                    Text("·")
                                    Text("\(set.cardCount) cards")
                                    if let released = set.releasedAt {
                                        Text("·")
                                        Text(released)
                                    }
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sets")
            .searchable(text: $model.searchQuery, prompt: "Search by name or code")
        }
        .task {
            await model.loadSets()
        }
        .alert("Error", isPresented: Binding(
            get: { model.error != nil },
            set: { if !$0 { model.error = nil } }
        )) {
            Button("OK") { model.error = nil }
        } message: {
            Text(model.error?.localizedDescription ?? "")
        }
    }
}

#Preview {
    SetListView()
}
