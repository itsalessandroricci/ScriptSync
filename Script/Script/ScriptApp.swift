//
//  ScriptApp.swift
//  Script
//
//  Created by Alessandro Ricci on 16/02/24.
//

import SwiftUI

@main
struct ScriptApp: App {
    
    @StateObject var importedFileModel = ImportedFileModel()
    @StateObject var vm: ScriptsViewModel = ScriptsViewModel()
    
    var body: some Scene {
        WindowGroup {
            LibraryScriptsView()
                .environmentObject(importedFileModel)
                .environmentObject(vm)
        }
    }
}
