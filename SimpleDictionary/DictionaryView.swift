//
//  DictionaryView.swift
//  SimpleDictionary
//
//  Created by khoasdyn on 24/10/25.
//

import SwiftUI

struct DictionaryView: View {
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

struct DefinitionCard: View {
    let entry: DictionaryEntry.PartiallyGenerated
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Word and pronunciation
            if let word = entry.word {
                HStack(alignment: .firstTextBaseline) {
                    Text(word)
                        .font(.largeTitle)
                        .bold()
                    
                    if let pronunciation = entry.pronunciation {
                        Text(pronunciation)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            if let emojis = entry.emojis {
                HStack(spacing: 8) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.title)
                    }
                }
                .padding(.vertical, 4)
            }
            
            // Part of speech tag
            if let pos = entry.partOfSpeech {
                Text(pos.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(colorForPartOfSpeech(pos))
                    .foregroundStyle(.white)
                    .cornerRadius(6)
            }
            
            // Definition
            if let definition = entry.definition {
                Text(definition)
                    .font(.body)
            }
            
            // Examples
            if let examples = entry.examples, !examples.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Examples:")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    ForEach(Array(examples.enumerated()), id: \.offset) { index, example in
                        if let sentence = example.sentence {
                            HStack(alignment: .top, spacing: 8) {
                                Text("\(index + 1).")
                                    .foregroundStyle(.secondary)
                                Text(sentence)
                                    .italic()
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func colorForPartOfSpeech(_ pos: PartOfSpeech) -> Color {
        switch pos {
        case .noun: return .blue
        case .verb: return .green
        case .adjective: return .purple
        case .adverb: return .orange
        case .pronoun: return .pink
        case .preposition: return .red
        case .conjunction: return .brown
        case .interjection: return .yellow
        }
    }
}
