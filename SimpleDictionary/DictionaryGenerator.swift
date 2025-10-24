//
//  DictionaryGenerator.swift
//  SimpleDictionary
//
//  Created by khoasdyn on 24/10/25.
//

import Foundation
import FoundationModels
import Observation

@Observable
@MainActor
final class DictionaryGenerator {
    var error: Error?
    private var session: LanguageModelSession
    private(set) var entry: DictionaryEntry.PartiallyGenerated?
    
    init() {
        let instructions = Instructions {
            "You are a friendly dictionary for learners of all ages."
            "Provide detailed, thorough definitions that fully explain each word."
            "Use 2-3 sentences for definitions, including meaning, context, and usage."
            "Avoid using complex words in your definitions."
            "Create natural, everyday example sentences that show how the word is used."
            "Each example should be different and show various contexts."
        }
        
        self.session = LanguageModelSession(tools: [], instructions: instructions)
    }
    
    func defineWord(_ word: String) async {
        // Reset previous entry
        self.entry = nil
        self.error = nil
        
        do {
            let prompt = Prompt {
                "Define the word '\(word)' in simple, beginner-friendly language."
                "Provide exactly 3 example sentences showing different uses of this word."
                "Here is an example of the format, but create original content:"
                DictionaryEntry.exampleHappy
            }
            
            let stream = session.streamResponse(
                to: prompt,
                generating: DictionaryEntry.self,
                includeSchemaInPrompt: false
            )
            
            for try await partialResponse in stream {
                self.entry = partialResponse.content
            }
            
        } catch {
            self.error = error
        }
    }
    
    func prewarmModel() {
        session.prewarm()
    }
}
