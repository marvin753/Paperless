//
//  DocumentDetailView.swift
//  Paperless
//
//  Created by Marvin Barsal on 15.09.24.
//

import SwiftUI
import SwiftData

struct DocumentDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let document: ScannedDocument

    var body: some View {
        VStack {
            if let image = UIImage(data: document.imageData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .navigationTitle(document.name)
            } else {
                Text("Fehler beim Laden des Bildes")  // Falls das Bild nicht geladen werden kann
            }
        }
        .padding()
    }
}


