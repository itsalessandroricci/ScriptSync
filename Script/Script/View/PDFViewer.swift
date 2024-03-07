//
//  PDFViewer.swift
//  Script
//
//  Created by Alessandro Ricci on 28/02/24.
//

import SwiftUI
import PDFKit

struct PDFViewer: View {
    @State var isGobboShowing: Bool = false
    
    
    var pdf: PDFDocument

    var body: some View {
        NavigationStack{
            
            PDFKitViews(pdf: pdf)
                .edgesIgnoringSafeArea(.all)
                .navigationBarItems(
                    trailing: trailingButtons
                )
                .sheet(isPresented: $isGobboShowing, content: {
                    GobboView(pdfFile: pdf)
                })
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
                isGobboShowing = true
            }, label: {
                Image(systemName: "chart.bar.doc.horizontal")
            })
            Button(action: {
                // Azione per il button Leading
            }) {
                Text("Done")
                    .foregroundColor(.blue)
            }
            
        }
    }

}

struct PDFKitViews: UIViewRepresentable {
    var pdf: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        
        pdfView.document = pdf
        pdfView.autoScales = true
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
            uiView.document = pdf
    }
}
