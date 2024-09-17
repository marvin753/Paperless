//
//  ContentView.swift
//  Paperless
//
//  Created by Marvin Barsal on 15.09.24.
//


import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var documentState: DocumentState  // Zentrale Zustand verwenden
    @Environment(\.presentationMode) var presentationMode  // Für das Schließen der Ansicht
    @Environment(\.modelContext) private var modelContext
    
    @State private var showScanner = false
    @State private var scannedDocument: ScannedDocument?
    
    @Query var folders: [Folder]

    var body: some View {
        TabView {
            NavigationView {
                ScannedDocumentsView()
                
            }
            .tabItem {
                HStack {
                    Image(systemName: "folder")
                    Text("Dokumente")
                }
            }
            
            VStack {
                Button(action: {
                    resetDocumentState()  // Zustand zurücksetzen, bevor der Scanner angezeigt wird
                    showScanner = true
                }) {
                    Text("Dokument scannen")
                }
                .sheet(isPresented: $showScanner) {
                    DocumentScannerView(scannedDocument: $scannedDocument)
                }
                
                // Zeige die Speicheroptionen nach dem Scannen an
                if let scannedDocument = scannedDocument {
                    scannedDocumentView(for: scannedDocument)
                }
            }
            .tabItem {
                HStack {
                    Image(systemName: "doc.text.viewfinder")
                    Text("Scannen")
                }
            }
        }
    }
    

    // Eingebettete Speicheransicht nach dem Scannen
    @ViewBuilder
    private func scannedDocumentView(for document: ScannedDocument) -> some View {
        VStack {
            Text("Gescanntes Dokument")
                .font(.headline)
            
            Image(uiImage: UIImage(data: document.imageData)!)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            
            TextField("Dokumentname", text: $documentState.scannedDocumentName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            if folders.isEmpty {
                Text("Keine Ordner verfügbar").foregroundColor(.gray)
            } else {
                Picker("Ordner auswählen", selection: $documentState.selectedFolder) {
                    Text("Kein Ordner ausgewählt").tag(nil as Folder?)
                    ForEach(folders, id: \.self) { folder in
                        Text(folder.name).tag(folder as Folder?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            Button("Speichern") {
                if !documentState.scannedDocumentName.isEmpty, let selectedFolder = documentState.selectedFolder {
                    saveScannedDocument(document)
                } else {
                    print("Fehlende Eingaben zum Speichern.")
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
    }

    private func saveScannedDocument(_ document: ScannedDocument) {
        guard let selectedFolder = documentState.selectedFolder else {
            print("Kein Ordner ausgewählt.")
            return
        }

        if documentState.scannedDocumentName.isEmpty {
            print("Kein Dokumentname angegeben.")
            return
        }

        document.name = documentState.scannedDocumentName
        selectedFolder.documents.append(document)
        modelContext.insert(document)
        print("Dokument erfolgreich gespeichert.")

        resetDocumentState()  // Zustand zurücksetzen
        closeView()  // Ansicht schließen
    }

    private func resetDocumentState() {
        documentState.scannedDocumentName = ""  // Dokumentname zurücksetzen
        documentState.selectedFolder = nil  // Ordnerauswahl zurücksetzen
        scannedDocument = nil  // Gescanntes Dokument zurücksetzen
    }

    private func closeView() {
        // Schließe die Ansicht nach dem Speichern
        presentationMode.wrappedValue.dismiss()
    }
}


#Preview {
    ContentView()
}



