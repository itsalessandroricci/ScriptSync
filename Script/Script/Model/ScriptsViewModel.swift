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
    @Published var selectedScriptIndex: Int? = nil
    
    func deleteScript(at index: Int) {
            scripts.remove(at: index)
        }
}

extension PDFDocument: Identifiable {
    public var id: UUID {
        return UUID()
    }
}

