//
//  FriendsModel.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 12/28/24.
//

import SwiftUI
import SwiftData

// 1. HUSD: Create a class with @Model macro
@Model
class Friend {
    var name: String
    var number: String
    
    init(name: String, number: String) {
        self.name = name
        self.number = number
    }
}
