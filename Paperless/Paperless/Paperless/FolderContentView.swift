//
//  FolderContentView.swift
//  Paperless
//
//  Created by Marvin Barsal on 16.09.24.
//

import SwiftUI
import SwiftData

// Neue View für die Anzeige des Bildes in voller Größe und zukünftige Funktionalitäten
struct FullImageView: View {
    @EnvironmentObject var documentState: DocumentState
    var scannedDocument: ScannedDocument  // Verwende ScannedDocument statt Document

    var body: some View {
        VStack {
            if let image = UIImage(data: scannedDocument.imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            } else {
                Text("Fehler beim Laden des Bildes.")
                    .foregroundColor(.black)  // Schriftfarbe auf Schwarz geändert
            }

            Spacer()
        }
        .navigationTitle(scannedDocument.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)  // Blendet die TabView aus, wenn diese Ansicht aktiv ist
    }
}


struct FolderContentView: View {
    @EnvironmentObject var documentState: DocumentState  // Zentrale Zustand verwenden
    var folder: Folder

    var body: some View {
        VStack {
            if folder.documents.isEmpty {
                Text("Keine Dokumente in diesem Ordner")
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                        ForEach(folder.documents, id: \.self) { scannedDocument in
                            // Verwende NavigationLink, um zu einer Detailansicht des Dokuments zu wechseln
                            NavigationLink(destination: FullImageView(scannedDocument: scannedDocument)) {
                                VStack {
                                    if let image = UIImage(data: scannedDocument.imageData) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .onAppear {
                                                print("Bild erfolgreich geladen.")
                                            }
                                    } else {
                                        Text("Fehler beim Laden des Bildes.")
                                            .foregroundColor(.black)  // Schriftfarbe auf Schwarz geändert
                                    }
                                    Text(scannedDocument.name)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)  // Schriftfarbe auf Schwarz geändert
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(folder.name)  // Der Ordnername bleibt erhalten
    }
}
