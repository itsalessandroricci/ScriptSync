//
//  ScriptView.swift
//  Script
//
//  Created by Alessandro Ricci on 19/02/24.
//

import SwiftUI
import PDFKit

struct ScriptView: View {
    
    var viewModel = FileViewModel()
    
    let pdfDocument: PDFDocument?
    
    init(resourceName: String) {
        if let url = Bundle.main.url(forResource: resourceName, withExtension: "pdf") {
            if let pdf = PDFDocument(url: url) {
                self.pdfDocument = pdf
            } else {
                print("PDF went wrong")
                self.pdfDocument = PDFDocument()
            }
        } else {
            print("URL went wrong")
            self.pdfDocument = PDFDocument()
        }
        
    }
    
    var body: some View {
        
        NavigationStack{
            
            PDFKitView(showing: self.pdfDocument)
            
                
                .navigationBarItems(
                    
                    trailing: trailingButtons
                )
        }
    }
    
    
    var trailingButtons: some View {
        HStack(spacing: 10) {
            
            
            Button(action: {
                // Azione per il terzo button a destra
            }) {
                Image(systemName: "person.2")
            }
            Button(action: {
                // Azione per il secondo button a destra
            }) {
                Image(systemName: "highlighter")
            }
            Button(action: {
                // Azione per il primo button a destra
            }) {
                Image(systemName: "note.text.badge.plus")
            }
            Button(action: {
                // Azione per il button Leading
            }) {
                Text("Done")
                    .foregroundColor(.blue)
            }
            
        }
    }
}

#Preview {
    ScriptView(resourceName: "lorem")
}



struct PDFKitView: UIViewRepresentable {
    
    let pdfDocument: PDFDocument
    
    init(showing pdfDoc: PDFDocument?) {
        self.pdfDocument = pdfDoc!
    }
    
    //you could also have inits that take a URL or Data
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
}
