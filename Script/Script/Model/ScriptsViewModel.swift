//
//  ScriptsViewModel.swift
//  Script
//
//  Created by Alessandro Ricci on 28/02/24.
//

import Foundation
import PDFKit

class ScriptsViewModel: ObservableObject {
    @Published var scripts: [PDFDocument] = []
    
}

extension PDFDocument: Identifiable {
    public var id: UUID {
        return UUID()
    }
}

