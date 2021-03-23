//
//  Password.swift
//  password-gen
//
//  Created by Joshua Schrader on 23.03.21.
//

import Foundation

class Password {
    
    static private let words: [String] = getWords()
    
    /**
     Only used once to load words in "words.txt"
     
     - Returns: Array of Strings containing words.txt
     */
    static private func getWords() -> [String] {
        let fileURLProject = Bundle.main.path(forResource: "words", ofType: "txt")
        var readStringProject = ""
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed reading from URL: \(String(describing: fileURLProject)), Error: " + error.localizedDescription)
        }
        var words: [String] = []
        for line in readStringProject.split(separator: "\n") {
            words.append(String(line))
        }
        return words
    }
    
    /**
     Checks if password contains characters a-z, A-Z, 0-9 and special characters.
     
     - Parameter pw: The password to check
     - Returns: Tuple containing four Bool types
     */
    static func checkExpressions(_ pw: String) -> (Bool, Bool, Bool, Bool) {
        let range = NSRange(location: 0, length: pw.count)
        let capitalRegex = try! NSRegularExpression(pattern: "[A-Z]")
        let lowerRegex   = try! NSRegularExpression(pattern: "[a-z]")
        let numberRegex  = try! NSRegularExpression(pattern: "[0-9]")
        let specialRegex = try! NSRegularExpression(pattern: "[!@#$%^&*(),.?\":{}|<>\\/;_+°-]")
        
        return (capitalRegex.firstMatch(in: pw, options: [], range: range) != nil,
                  lowerRegex.firstMatch(in: pw, options: [], range: range) != nil,
                 numberRegex.firstMatch(in: pw, options: [], range: range) != nil,
                specialRegex.firstMatch(in: pw, options: [], range: range) != nil)
    }
    
    /**
     Creates password containing two words, two numbers and a special character.
     
     - Returns: a string containing a password.
     */
    static func makePassword() -> String {
        var special: [Character] = []
        for s in "[!@#$%^&*(),.?\":{}|<>\\/;_+°-]" {
            special.append(s)
        }
        
        var password: String = ""
        password += words[Int.random(in: 0..<words.count)]
        password += String(Int.random(in: 0...9))
        password += String(Int.random(in: 0...9))
        password += String(special[Int.random(in: 0..<special.count)])
        password += words[Int.random(in: 0..<words.count)]
        
        return password
    }
}
