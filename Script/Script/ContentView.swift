////
////  ContentView.swift
////  Script
////
////  Created by Alessandro Ricci on 16/02/24.
////
//
//import SwiftUI
//import PDFKit
//
//struct LibraryScriptsView: View {
//    @EnvironmentObject var importedFileModel: ImportedFileModel
//    @State private var searchText = ""
//    
//    let columns = [GridItem(.flexible()), GridItem(.flexible())]
//    
//    @EnvironmentObject var vm: ScriptsViewModel
//    @State private var presentImporter = false
//    @State private var selectedFileURL: URL?
//    @State private var errorMessage: String?
//    
//    var viewModel = FileViewModel()
//    
//    var body: some View {
//        
//        NavigationStack{
//            
//            HStack{
//                ScrollView{
//                    LazyVGrid(columns: columns) {
//                        ForEach(viewModel.files)
//                        { file in
//                            NavigationLink{
//                                ScriptView(resourceName: file.fileName)
//                            } label: {
//                                
//                                VStack {
//                                    Image(file.image)
//                                        .resizable()
//                                        .frame(width: 135, height: 154)
//                                        .clipped()
//                                        .foregroundColor(.gray)
//                                    
//                                    Text(file.title)
//                                        .font(.system(size: 25))
//                                        .foregroundColor(Color("black1"))
//                                    Text(file.authorName)
//                                        .fontWeight(.light)
//                                        .font(.system(size: 20))
//                                        .foregroundColor(Color("black1"))
//                                    
//                                    
//                                }
//                                
//                            }
//                            
//                            
//                        }
//                        VStack {
//                            
//                            ForEach(vm.scripts) { script in
//                                NavigationLink {
//                                    PDFViewer(pdf: script)
//                                } label: {
//                                    VStack {
//                                        Image("pdf1")
//                                            .resizable()
//                                            .frame(width: 135, height: 154)
//                                            .clipped()
//                                            .foregroundColor(.gray)
//                                        
//                                        Text(script.documentURL!.lastPathComponent)
//                                            .font(.system(size: 25))
//                                            .foregroundColor(Color("black1"))
//                                        Text("Author")
//                                            .fontWeight(.light)
//                                            .font(.system(size: 20))
//                                            .foregroundColor(Color("black1"))
//                                    }
//                                  
//                                }
//                                
//                            }
//                            
//                        }
//                        
//                    }
//                    
//                }
//            }
//            .navigationBarItems(trailing:
//                                    Button(action:
//                                            {
//                presentImporter = true
//            })
//                                {
//                Image(systemName: "plus")
//                    .font(.system(size: 20))
//            })
//            .fileImporter(isPresented: $presentImporter, allowedContentTypes: [.pdf]) { result in
//                switch result {
//                case .success(let url):
//                    if url.startAccessingSecurityScopedResource() {
//                        print(url)
//                        if let pdfDoc = PDFDocument(url: url) {
//                            vm.scripts.append(pdfDoc)
//                            url.stopAccessingSecurityScopedResource()
//                        } else {
//                            print("Couldn't create PDF file from URL: \(url)")
//                        }
//                    } else {
//                        print("No access to security scoped resource for URL: \(url)")
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
//            .alert(isPresented: Binding<Bool>(
//                get: { errorMessage != nil },
//                set: { _ in errorMessage = nil }
//            )) {
//                Alert(title: Text("Error"), message: Text(errorMessage ?? ""), dismissButton: .default(Text("OK")))
//            }
//        }
//        .navigationTitle("Scripts")
//        .searchable(text: $searchText)
//    }
//}
//
//
////#Preview {
////    LibraryScriptsView()
////}

