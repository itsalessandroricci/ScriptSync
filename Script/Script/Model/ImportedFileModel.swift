//
//  ImportedFileModel.swift
//  Script
//
//  Created by Alessandro Ricci on 26/02/24.
//

import Foundation

class ImportedFileModel: ObservableObject {
    @Published var fileURL: URL?

    func setFile(_ url: URL?) {
        fileURL = url
    }
}
