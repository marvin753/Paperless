//
//  Item.swift
//  Paperless
//
//  Created by Marvin Barsal on 15.09.24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
