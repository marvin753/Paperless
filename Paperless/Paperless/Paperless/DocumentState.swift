//
//  DocumentState.swift
//  Paperless
//
//  Created by Marvin Barsal on 17.09.24.
//

import SwiftUI

class DocumentState: ObservableObject {
    @Published var selectedFolder: Folder? = nil
    @Published var scannedDocumentName: String = ""
}

