//
//  DraftSetListView.swift
//  MTGDraft
//
//  Created by Adrian Roe on 2/28/26.
//

import SwiftUI

struct DraftSetListView: View {
    @State private var model = DraftSetListViewModel()

    private let columns = [GridItem(.adaptive(minimum: 140), spacing: 16)]

    var body: some View {
        NavigationStack {
            Group {
                if model.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(model.sets) { set in
                                NavigationLink(destination: DraftView(set: set)) {
                                    SetGridCell(set: set)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Draft")
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

struct SetGridCell: View {
    let set: MTGSet

    var body: some View {
        VStack(spacing: 10) {
            SVGImageView(url: set.iconSvgUri)
                .frame(width: 56, height: 56)

            Text(set.name)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    DraftSetListView()
}
