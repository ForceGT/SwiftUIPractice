//
//  ContentView.swift
//  WeScramble
//
//  Created by Gaurav Thakkar on 05/01/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var rootWord = ""
    @State private var usedWords = [String]()
    @State private var newWord = ""
    @State private var userScore = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
        
    var body: some View {
        NavigationView {
            VStack{
                TextField("Enter the word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                  Text($0)
                }
                Text ("The user score is \(userScore)")
            }
            .navigationBarItems(leading: Button("Reset"){
                self.startGame()
            })
            .navigationBarTitle(rootWord)
            .onAppear(perform: startGame)
            .alert(isPresented:$showingError){
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
              
        }
    }
    
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        // exit if the remaining string is empty
        
        // checks if answer is same as root word
        guard answer != rootWord else {
            if (userScore < 0) {
                userScore = 0
            }
            else {
                userScore -= 10
            }
            return
        }
        
        guard answer.count > 0 else {
            if (userScore < 0) {
                userScore = 0
            }
            else {
                userScore -= 10
            }
            return
        }

        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            if (userScore < 0) {
                userScore = 0
            }
            else {
                userScore -= 10
            }
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            if (userScore < 0) {
                userScore = 0
            }
            else {
                userScore -= 10
            }
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            if (userScore < 0) {
                userScore = 0
            }
            else {
                userScore -= 10
            }
            return
        }
        usedWords.insert(answer, at: 0)
        if (answer.count > 5)
        {
            userScore += 10
        }
        else{
            userScore += 5
        }
            
        newWord = ""
    }
    
    func startGame(){
        
        newWord = ""
        usedWords = [String]()
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String (contentsOf: startWordsURL){
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                userScore = 0
                return
            }
        }
        
        // If we are here then surely there was an error
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isReal (word: String) -> Bool {
        
        guard word.count > 3 else {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func isPossible(word : String) -> Bool {
        var tempWord = rootWord

            for letter in word {
                if let pos = tempWord.firstIndex(of: letter) {
                    tempWord.remove(at: pos)
                } else {
                    return false
                }
            }

            return true
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
