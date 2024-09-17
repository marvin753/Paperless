//
//  ScannedDocument.swift
//  Paperless
//
//  Created by Marvin Barsal on 15.09.24.
//

import SwiftData
import SwiftUI

@Model
class ScannedDocument {
    var id: UUID = UUID()
    var name: String
    var imageData: Data

    init(name: String, imageData: Data) {
        self.name = name
        self.imageData = imageData
    }
}
