//
//  LibraryScriptsView.swift
//  Script
//
//  Created by Alessandro Ricci on 19/02/24.
//

import SwiftUI

struct LibraryScriptsView: View {
    
    @State private var searchText = ""
    let columns: [GridItem] =
    [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var fileURL: URL?
    @State private var showingFilePicker = false
    
    var body: some View {
        
        NavigationStack{
            
            VStack(alignment: .leading){
                
                ScrollView{
                    
                    VStack{
                        NavigationLink{
                            ScriptView(resourceName: "lorem")
                        } label: {
                            Image("prova")
                                .frame(width: 135, height: 174)
                                .clipped()
                                .foregroundColor(.gray)
                        }
                        Text("Script Title")
                            .font(.system(size: 25))
                        Text("Author")
                            .fontWeight(.light)
                            .font(.system(size: 20))
                        
                    }
                    .padding(.trailing, 990)
                    .padding(.top,50)
                    
                    LazyVGrid(columns: columns, spacing: 0) {
                        
                    }
                }
            }
            .navigationBarItems(trailing: Button(action:
                                                    {
                //Action plus button
            })
                                {
                Image(systemName: "plus").foregroundColor(.black)
                    .font(.system(size: 20))
            })
            .navigationTitle("Scripts")
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    LibraryScriptsView()
}
