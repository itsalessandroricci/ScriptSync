//
//  PDFViewer.swift
//  Script
//
//  Created by Alessandro Ricci on 28/02/24.
//

import SwiftUI
import PDFKit

struct PDFViewer: View {
    var pdf: PDFDocument

    var body: some View {
        Scr(pdf: pdf)
            .edgesIgnoringSafeArea(.all)
    }
}

struct PDFKitView: UIViewRepresentable {
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
