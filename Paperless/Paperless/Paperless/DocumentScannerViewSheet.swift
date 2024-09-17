//
//  DocumentScannerViewSheet.swift
//  Paperless
//
//  Created by Marvin Barsal on 16.09.24.
//

import SwiftUI
import SwiftData

struct DocumentScannerViewSheet: View {
    @Binding var isShowing: Bool
    @Binding var documentName: String
    @Binding var selectedFolder: Folder?
    
    var folders: [Folder]
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Dokument benennen")) {
                    TextField("Name des Dokuments", text: $documentName)
                        .onChange(of: documentName) { newValue in
                            // Überprüfen, ob ungültige Zeichen vorhanden sind
                            if newValue.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
                                documentName = newValue.filter { $0.isLetter || $0.isNumber }
                            }
                        }
                }
                
                Section(header: Text("Ordner auswählen")) {
                    if folders.isEmpty {
                        Text("Keine Ordner verfügbar").foregroundColor(.gray)
                    } else {
                        Picker("Ordner", selection: $selectedFolder) {
                            Text("Kein Ordner ausgewählt").tag(nil as Folder?)
                            ForEach(folders, id: \.self) { folder in
                                Text(folder.name).tag(folder as Folder?)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dokument speichern")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        resetInputs()  // Eingabewerte nur bei Abbrechen zurücksetzen
                        isShowing = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        if documentName.isEmpty || selectedFolder == nil {
                            print("Dokumentname oder Ordner fehlt.")
                        } else {
                            onSave()  // Dokument speichern
                            isShowing = false
                            resetDocumentState()  // Nur den Dokumentnamen nach dem Speichern zurücksetzen
                        }
                    }
                }
            }
        }
    }

    /// Eingabewerte vollständig zurücksetzen (nur bei Abbrechen)
    private func resetInputs() {
        documentName = ""
        selectedFolder = nil
    }

    /// Zentralen Zustand zurücksetzen (nach Speichern)
    private func resetDocumentState() {
        documentName = ""
        selectedFolder = nil  // Ordnerauswahl nach dem Speichern zurücksetzen
    }
}

#Preview {
    DocumentScannerViewSheet(
        isShowing: .constant(true),
        documentName: .constant("Example Document"),
        selectedFolder: .constant(nil),
        folders: [Folder(name: "Folder 1"), Folder(name: "Folder 2")],
        onSave: {
            print("Document saved")
        }
    )
}
