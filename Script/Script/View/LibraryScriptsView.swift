//
//  LibraryScriptsView.swift
//  Script
//
//  Created by Alessandro Ricci on 19/02/24.
//

import SwiftUI
import PDFKit

struct LibraryScriptsView: View {
    
    @EnvironmentObject var importedFileModel: ImportedFileModel
    @State private var searchText = ""
    
    @State private var isSelectionMode = false
    @State private var selectedDocuments: Set<PDFDocument> = []
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @EnvironmentObject var vm: ScriptsViewModel
    @State private var presentImporter = false
    @State private var selectedFileURL: URL?
    @State private var errorMessage: String?
    @State var appoggio = ScriptsViewModel()
    
    
    let gridRows = [GridItem(.adaptive(minimum: 20))]
    
    var viewModel = FileViewModel()
    
    var filteredFiles: [PDFDocument] {
        if searchText.isEmpty {
            return vm.scripts
        } else {
            return vm.scripts.filter { $0.documentURL!.lastPathComponent.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        
        NavigationStack{
            ScrollView{
                LazyVGrid(columns: columns, alignment: .center, spacing: 20, content: {
                    ForEach(filteredFiles.indices, id: \.self) { index in
                        let pdfDocument = filteredFiles[index]
                        let isSelected = selectedDocuments.contains(pdfDocument)
                        NavigationLink(destination: PDFViewer(pdf: pdfDocument)) {
                            VStack {
                                if isSelectionMode {
                                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                        .onTapGesture {
                                            if isSelected {
                                                selectedDocuments.remove(pdfDocument)
                                            } else {
                                                selectedDocuments.insert(pdfDocument)
                                            }
                                        }
                                }
                                
                                Image("pdf1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 154)
                                    .clipped()
                                    .foregroundColor(.gray)
                                
                                Text(pdfDocument.documentURL!.deletingPathExtension().lastPathComponent)
                                    .font(.system(size: 20))
                                    .lineLimit(1)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("black1"))
                                
                                Text("Author")
                                    .fontWeight(.light)
                                    .font(.system(size: 16))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("black1"))
                            }
//                            .onTapGesture {
//                                if isSelectionMode {
//                                    if isSelected {
//                                        selectedDocuments.remove(pdfDocument)
//                                    } else {
//                                        selectedDocuments.insert(pdfDocument)
//                                    }
//                                } else {
//
//                                    navigateToPDF(pdfDocument)
//                                }
//                            }
                        }
                    }
                })
            }
            .navigationBarItems(trailing:
                HStack {
                    
                    Button(action: {
                        if isSelectionMode {
                            deleteSelectedDocuments()
                            isSelectionMode = false
                        } else {
                            presentImporter = true
                        }
                    }) {
                        Image(systemName: isSelectionMode ? "trash" : "plus")
                            .font(.system(size: 25))
                    }
                if isSelectionMode {
                    Button(action: {
                        deleteSelectedDocuments()
                        isSelectionMode = false
                    }) {
                        Text("Done")
                            .font(.system(size: 25))
                    }
                }
                    if !isSelectionMode {
                        Button(action: {
                            isSelectionMode.toggle()
                        }) {
                            Image(systemName: "pencil")
                                .font(.system(size: 25))
                        }
                    }
                }
            )
            
            .fileImporter(isPresented: $presentImporter, allowedContentTypes: [.pdf]) { result in
                switch result {
                case .success(let url):
                    if url.startAccessingSecurityScopedResource() {
                        print(url)
                        if let pdfDoc = PDFDocument(url: url) {
                            vm.scripts.append(pdfDoc)
                            print("Ciao")
                            
                            url.stopAccessingSecurityScopedResource()
                        } else {
                            print("Couldn't create PDF file from URL: \(url)")
                        }
                    } else {
                        print("No access to security scoped resource for URL: \(url)")
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { errorMessage != nil },
                set: { _ in errorMessage = nil }
            )) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Scripts")
        }
        
        .searchable(text: $searchText)
        
    }
    private func showDeleteConfirmationAlert(for document: PDFDocument) {
        guard let index = vm.scripts.firstIndex(of: document) else {
            return
        }
        
        let alert = UIAlertController(title: "Delete File", message: "Are you sure you want to delete this file?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            vm.deleteScript(at: index)
        })
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    private func navigateToPDF(_ pdfDocument: PDFDocument) {
        if let index = vm.scripts.firstIndex(of: pdfDocument) {
            vm.selectedScriptIndex = index
        }
    }
    private func deleteSelectedDocuments() {
        for document in selectedDocuments {
            if let index = vm.scripts.firstIndex(of: document) {
                vm.deleteScript(at: index)
            }
        }
        selectedDocuments.removeAll()
    }
    
}



#Preview {
    LibraryScriptsView()
        .environmentObject(ImportedFileModel())
        .environmentObject(ScriptsViewModel())
}

