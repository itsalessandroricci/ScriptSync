//
//  GobboView.swift
//  Script
//
//  Created by Alessandro Ricci on 07/03/24.
//

import SwiftUI
import PDFKit


class StringWrapper {
    var value: String
    var isMatched: Bool = false
    var isLine: Bool {
        return self.value.components(separatedBy: " ").count > 1
    }
    
    init(_ value: String) {
        self.value = value
    }
}

extension StringWrapper: Identifiable {
    public var id: UUID {
        return UUID()
    }
}

// Now extend String for your convenience
extension String {
    
    var wrapped: StringWrapper {
        return StringWrapper(self)
    }
}

struct GobboView: View {
    
    @State var pdfFile: PDFDocument
    
    var pdfString: NSMutableAttributedString {
        let pageCount = pdfFile.pageCount
        let pdfToString = NSMutableAttributedString()
        
        for i in 0..<pageCount {
            guard let page = pdfFile.page(at: i) else { continue }
            guard let pageContent = page.attributedString else { continue }
            pdfToString.append(pageContent)
        }
        return pdfToString
        
    }
    
    var pdf: [StringWrapper] {
        
        let pdfRawString = pdfString.string
        
        let pdfRawStringArr = pdfRawString.components(separatedBy: "\n")
        
        return pdfRawStringArr.map { $0.wrapped }
        
        
    }
    
    
    @State private var isRecording = false
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var transcript: String = ""
    
    @State var pdfArr = [[String]]()
    @State var transcriptArr: [String] = []
    var i = 0
    var firstLineIndex: Int {
        pdf.firstIndex(where: {$0.isLine})!
    }
    @State var focusedIndex: Int = 0
    
    var body: some View {
        
        VStack{
            
            if pdfArr.isEmpty {
                
                    ProgressView()
                
            } else {
                
                ScrollView {
                    
//                    Text("\(pdfString)")
                    
                    ScrollViewReader { proxy in
                        ForEach( 0..<pdf.count, id: \.self ) { index in
                            
                            Text(pdf[index].value)
                                .foregroundStyle(!pdf[index].isLine ? .blue : index == focusedIndex ? .black : .gray)
                                .fontWeight(!pdf[index].isLine ? .bold : index == focusedIndex ? .bold : .regular)
                                .padding()
                                .id(index)
                                .onTapGesture {
                                    focusedIndex = index
                                    startActing(text: &transcript)
                                }
                                .onChange(of: focusedIndex) { _ , newValue in
                                    withAnimation(.easeInOut) {
                                        proxy.scrollTo(newValue, anchor: .center)
                                    }
                                }
                        }
                        .onChange(of: speechRecognizer.transcript) { oldValue, newValue in
                            check(transcriptArr: speechRecognizer.transcript.components(separatedBy: " "))

                        }
                        
                        Spacer()
                        
                        
                    }
                    
                }
        }
            HStack{
                
                Button {
                    isRecording = true
                    startActing(text: &transcript)
                } label: {
                    Text("Start")
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
                Button {
                    isRecording = false
                    endActing()
                } label: {
                    Text("Stop")
                }
                .buttonStyle(.borderedProminent)
                
            }
            .padding(.horizontal, 60.0)
            .padding()
            
        }
        .onAppear() {
            focusedIndex = firstLineIndex
        }
        .task {
            await loadScript()
        }
        
    }
        
    private func startActing(text: inout String) {
            
            speechRecognizer.resetTranscript()
            speechRecognizer.startTranscribing()
            
            transcript = speechRecognizer.transcript
            
            transcriptArr = transcript.components(separatedBy: " ")
//            print(transcriptArr)
            
        }
    
    private func loadScript() async {
        for sentence in pdf {
            pdfArr.append(sentence.value.components(separatedBy: " "))
        }
    }
    
    private func check(transcriptArr: [String]) {
        
        //MARK: COMPARE ONLY LAST x WORDS OF TRANSCRIPT
        let limit: Int = 10
        let lastIndex: Int = transcriptArr.endIndex - 1
        var transcriptArrCut: [String] = []
        
        if transcriptArr.count >= limit {
            for x in (0...limit - 1) {
                transcriptArrCut.append(transcriptArr[lastIndex - x])
            }
        } else {
            transcriptArrCut = transcriptArr
        }
        
        self.transcriptArr.removeAll()
        
        for i in (0...pdf.count - 1) {
            var commonWords: [String] = []
            
            let lineWords: [String] = pdf[i].value.lowercased().components(separatedBy: " ")
            
            commonWords = lineWords.filter{transcriptArrCut.contains($0)}
            
            
            //MARK: Percent of common words based on words count
            let percent = (commonWords.count * 100) / lineWords.count
            
            if percent >= 75 {
                if (pdf[i + 1].isLine && i + 1 < pdf.count) {
                    focusedIndex = i + 1
                    pdf[i].isMatched = true
                } else if (pdf[i + 2].isLine && i + 2 < pdf.count) {
                    focusedIndex = i + 2
                    pdf[i].isMatched = true
                }
            } else {
                pdf[i].isMatched = false
            }
            
            print(speechRecognizer.transcript)
            print("---------- transcript end -----------")
            
        }
        
        transcriptArrCut.removeAll()
        speechRecognizer.transcript.removeAll()
    }
        
        private func endActing() {
            
            speechRecognizer.stopTranscribing()
            
        }
}



//
//#Preview {
//    GobboView(pdfFile: PDFDocument(url: URL())
//}
