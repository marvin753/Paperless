//
//  PaperlessApp.swift
//  Paperless
//
//  Created by Marvin Barsal on 15.09.24.
//

import SwiftUI
import SwiftData

@main
struct PaperlessApp: App {
    @StateObject private var documentState = DocumentState() // Zentrales State-Objekt
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Folder.self, ScannedDocument.self])  // Registriere die Datenmodelle
                .environmentObject(documentState)  // Dokumentzustand in die Umgebung einfügen
        }
    }
}

