//
//  DictionaryEntry.swift
//  SimpleDictionary
//
//  Created by khoasdyn on 24/10/25.
//

import Foundation
import FoundationModels

@Generable
struct DictionaryEntry: Equatable {
    let word: String
    
    @Guide(description: "Simple, beginner-friendly definition that a 10-year-old could understand.")
    let definition: String
    
    @Guide(description: "Part of speech: noun, verb, adjective, adverb, pronoun, preposition, conjunction, or interjection")
    let partOfSpeech: PartOfSpeech
    
    @Guide(description: "Phonetic pronunciation guide")
    let pronunciation: String
    
    @Guide(description: "Exactly 3 example sentences using this word in context.")
    @Guide(.count(3))
    let examples: [Example]
}

@Generable
struct Example: Equatable {
    @Guide(description: "A natural, everyday sentence using the word.")
    let sentence: String
}

@Generable
enum PartOfSpeech: String, CaseIterable {
    case noun
    case verb
    case adjective
    case adverb
    case pronoun
    case preposition
    case conjunction
    case interjection
    
    var color: String {
        switch self {
        case .noun: return "blue"
        case .verb: return "green"
        case .adjective: return "purple"
        case .adverb: return "orange"
        case .pronoun: return "pink"
        case .preposition: return "red"
        case .conjunction: return "brown"
        case .interjection: return "yellow"
        }
    }
}

extension DictionaryEntry {
    static let exampleHappy = DictionaryEntry(
        word: "happy",
        definition: "Feeling good and joyful inside, like when something nice happens to you.",
        partOfSpeech: .adjective,
        pronunciation: "HAP-ee",
        examples: [
            Example(sentence: "I was happy when my friend came to visit me."),
            Example(sentence: "The happy puppy wagged its tail excitedly."),
            Example(sentence: "She felt happy after receiving a good grade on her test.")
        ]
    )
}
