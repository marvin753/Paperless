//
//  DocumentScannerView.swift
//  Paperless
//
//  Created by Marvin Barsal on 15.09.24.
//

import SwiftUI
import SwiftData
import VisionKit

struct DocumentScannerView: UIViewControllerRepresentable {
    @Environment(\.modelContext) private var modelContext
    @Binding var scannedDocument: ScannedDocument?  // Temporäres gescanntes Dokument speichern
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, modelContext: modelContext)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocumentScannerView
        var modelContext: ModelContext

        init(_ parent: DocumentScannerView, modelContext: ModelContext) {
            self.parent = parent
            self.modelContext = modelContext
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            for pageIndex in 0..<scan.pageCount {
                let scannedImage = scan.imageOfPage(at: pageIndex)

                if let imageData = scannedImage.jpegData(compressionQuality: 0.8) {
                    print("Dokument erfolgreich gescannt")
                    DispatchQueue.main.async {
                        let scannedDocument = ScannedDocument(name: "", imageData: imageData)
                        self.parent.scannedDocument = scannedDocument
                        print("Scanned Document Set: \(scannedDocument)")
                    }
                } else {
                    print("Fehler beim Scannen des Dokuments")
                }
            }
            controller.dismiss(animated: true)
        }
    }

}

        
        
        
import SwiftUI
import SwiftData

struct DocumentScannerContainerView: View {
    @Query private var folders: [Folder]
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingScanner = false
    @State private var scannedDocumentName = ""
    @State private var selectedFolder: Folder? = nil
    @State private var scannedDocument: ScannedDocument?
    
    var body: some View {
        VStack {
            Button("Dokument scannen") {
                isShowingScanner = true
            }
            
            // Scanner View wird eingebettet statt modales Sheet
            if let scannedDocument = scannedDocument {
                scannedDocumentView(for: scannedDocument)
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            DocumentScannerView(scannedDocument: $scannedDocument)
        }
        .onAppear {
            loadFoldersIfNeeded()
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
            
            // Speicheroptionen direkt im View
            TextField("Dokumentname", text: $scannedDocumentName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            if folders.isEmpty {
                Text("Keine Ordner verfügbar").foregroundColor(.gray)
            } else {
                Picker("Ordner auswählen", selection: $selectedFolder) {
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
                if !scannedDocumentName.isEmpty, let selectedFolder = selectedFolder {
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
    
    private func loadFoldersIfNeeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Ordner geladen: \(folders.count) Ordner verfügbar.")
            if selectedFolder == nil, let firstFolder = folders.first {
                selectedFolder = firstFolder
            }
        }
    }
    
    private func saveScannedDocument(_ document: ScannedDocument) {
        guard let selectedFolder = selectedFolder else {
            print("Kein Ordner ausgewählt.")
            return
        }

        if scannedDocumentName.isEmpty {
            print("Kein gültiger Dokumentname angegeben.")
            return
        }

        // Dokument benennen und dem Ordner hinzufügen
        document.name = scannedDocumentName
        selectedFolder.documents.append(document)

        // Füge das Dokument dem ModelContext hinzu (Speichern erfolgt automatisch)
        modelContext.insert(document)
        print("Dokument erfolgreich gespeichert.")
        
        // Zurücksetzen der Eingabewerte
        resetDocumentName()
    }

    private func resetDocumentName() {
        scannedDocumentName = ""
        scannedDocument = nil
        // selectedFolder bleibt erhalten
    }
}
