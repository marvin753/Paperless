//
//  Folder.swift
//  Paperless
//
//  Created by Marvin Barsal on 15.09.24.
//

import SwiftData
import SwiftUI

@Model
class Folder {
    var id: UUID = UUID()  // UUID für die eindeutige Identifizierung
    var name: String
    var documents: [ScannedDocument] = []  // Eine Liste von Dokumenten

    init(name: String) {
        self.name = name
    }
}
