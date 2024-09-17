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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Spacer(minLength: 0)
                
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
                                        Image(systemName: "folder")
                                            .resizable()
                                            .frame(width: 78, height: 64)
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
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Dokumente")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreateFolderAlert = true
                    }) {
                        Image(systemName: "folder.badge.plus")
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
