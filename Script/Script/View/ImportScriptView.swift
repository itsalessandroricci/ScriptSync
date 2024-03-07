//
//  ImportScriptView.swift
//  Script
//
//  Created by Alessandro Ricci on 19/02/24.
//


import SwiftUI
import UniformTypeIdentifiers

struct ImportScriptView: View {
    @EnvironmentObject var importedFileModel: ImportedFileModel
    
    @State private var searchText = ""
    let columns: [GridItem] =
    [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
   
    
    @State private var showingFilePicker = false
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                Button(action: {
                    showingFilePicker = true
                }) {
                    VStack{
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 140))
                        Text("Import File")
                            .font(.system(size:80))
                    }
                    
                    
                }
                .foregroundColor(Color("black1"))
//                .opacity(0.4)
                
                
                .padding()
                .fileImporter(
                    isPresented: $showingFilePicker,
                    allowedContentTypes: [.plainText, .pdf],
                    allowsMultipleSelection: false
                ) { result in
                do {
                    let fileURL = try result.get().first
                    importedFileModel.setFile(fileURL)
                    // Esegui qui l'azione con il file URL selezionato
                    // Ad esempio, puoi leggere il contenuto del file
                } catch {
                    // Gestisci gli errori
                    print("Error importing file: \(error.localizedDescription)")
                }
            }
        }
        .foregroundColor(Color("black1"))
        .opacity(0.4)
        
        .navigationBarItems(trailing: Button(action:
                                                {
            showingFilePicker = true
        })
                            {
            Image(systemName: "plus")
                .font(.system(size: 20))
        })
        .navigationTitle("Scripts")
        .searchable(text: $searchText)
        
        
    }
    }
}


#Preview {
    ImportScriptView()
}
