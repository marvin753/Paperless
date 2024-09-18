//
//  ScannedDocumentsView.swift
//  Paperless
//
//  Created by Marvin Barsal on 15.09.24.
//

import SwiftUI
import SwiftData

struct ScannedDocumentsView: View {
    @EnvironmentObject var documentState: DocumentState  // Verwende den zentralen Zustand
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Folder>()) var folders: [Folder]
    @State private var showCreateFolderAlert = false
    @State private var newFolderName = ""
    @State private var showSettings = false  // Neue @State-Variable für das Anzeigen des Fullscreen-Modals
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Spacer(minLength: 0)
                
                // Verschieben des gesamten Header-Bereichs (Titel und Symbole) weiter nach oben
                HStack {
                    Text("Dokumente")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            showCreateFolderAlert = true
                        }) {
                            Image("add")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 29, height: 29)
                        }

                        Button(action: {
                            showSettings = true  // Öffnet das Fullscreen Modal für die Settings
                        }) {
                            Image(systemName: "gearshape.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 29, height: 29)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 7)  // Verschiebt den Header-Bereich weiter nach oben

                ScrollView {
                    if folders.isEmpty {
                        HStack {
                            Text("Keine Ordner vorhanden")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding()
                    } else {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                            ForEach(folders, id: \.self) { folder in
                                NavigationLink(value: folder) {
                                    VStack {
                                        Image("folder2")
                                            .resizable()
                                            .frame(width: 64, height: 64)
                                            .foregroundColor(.black)
                                        Text(folder.name)
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16) // Fügt links und rechts 16 Punkte Abstand hinzu
                        .padding(.top, 20)
                    }
                }
            }
            .alert("Neuen Ordner", isPresented: $showCreateFolderAlert) {
                TextField("Ordnername", text: $newFolderName)
                Button("Erstellen", action: createNewFolder)
                Button("Abbrechen", role: .cancel) { }
            } message: {
                Text("Ordnernamen eingeben.")
            }
            .navigationDestination(for: Folder.self) { folder in
                FolderContentView(folder: folder)
            }
            .fullScreenCover(isPresented: $showSettings) { // Bei .sheet wird Pop-up angezeigt & <- full screen
                SettingsView(showSettings: $showSettings)  // Fullscreen SettingsView
            }
        }
    }
    
    private func createNewFolder() {
        if !newFolderName.isEmpty {
            let newFolder = Folder(name: newFolderName)
            modelContext.insert(newFolder)
            newFolderName = ""
        }
    }
}

#Preview {
    ScannedDocumentsView()
}
