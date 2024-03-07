//
//  FileModel.swift
//  Script
//
//  Created by Alessandro Ricci on 26/02/24.
//

import Foundation
import SwiftUI

struct File: Identifiable {
    
    var id: UUID = UUID()
    var title: String
    var fileName: String
    var image: String
    var authorName: String
    
}

