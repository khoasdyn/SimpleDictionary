//
//  MainView.swift
//  SimpleDictionary
//
//  Created by khoasdyn on 24/10/25.
//

import SwiftUI

struct MainView: View {
    @State private var generator = DictionaryGenerator()
    @State private var searchWord = ""
    @State private var isSearching = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Search input
                VStack(spacing: 12) {
                    TextField("Enter a word to define", text: $searchWord)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .disabled(isSearching)
                    
                    Button {
                        Task {
                            isSearching = true
                            await generator.defineWord(searchWord)
                            isSearching = false
                        }
                    } label: {
                        if isSearching {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Define")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(searchWord.isEmpty || isSearching)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Show definition
                if let entry = generator.entry {
                    DefinitionCard(entry: entry)
                }
                
                // Show errors
                if let error = generator.error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundStyle(.red)
                        .padding()
                }
            }
            .padding()
        }
        .onAppear {
            generator.prewarmModel()
        }
    }
}
