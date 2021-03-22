//
//  ViewController.swift
//  password-gen
//
//  Created by Joshua Schrader on 21.03.21.
//

import Cocoa

extension NSTextField{ func controlTextDidChange(obj: NSNotification){} }

class ViewController: NSViewController, NSTextFieldDelegate {
    
    let words: [String] = getWords()
    
    /**
     Only used once to load words in "words.txt"
     
     - Returns: Array of Strings containing words.txt
     */
    static func getWords() -> [String] {
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
     
     - Returns: Tuple containing four Bool types
     */
    func checkExpressions() -> (Bool, Bool, Bool, Bool) {
        let range = NSRange(location: 0, length: txtPassword.stringValue.utf16.count)
        let capitalRegex = try! NSRegularExpression(pattern: "[A-Z]")
        let lowerRegex   = try! NSRegularExpression(pattern: "[a-z]")
        let numberRegex  = try! NSRegularExpression(pattern: "[0-9]")
        let specialRegex = try! NSRegularExpression(pattern: "[!@#$%^&*(),.?\":{}|<>\\/;_+°-]")
        
        return (capitalRegex.firstMatch(in: txtPassword.stringValue, options: [], range: range) != nil,
                  lowerRegex.firstMatch(in: txtPassword.stringValue, options: [], range: range) != nil,
                 numberRegex.firstMatch(in: txtPassword.stringValue, options: [], range: range) != nil,
                specialRegex.firstMatch(in: txtPassword.stringValue, options: [], range: range) != nil)
    }
    
    /**
     Changes state of checkboxes if requierements are met.
     Also changes the color depending on security of password
     */
    func updateSecurity() {
        var value = Double(txtPassword.stringValue.count)
        
        let (capital, lower, number, special) = checkExpressions()

        if capital { checkCapital.state = .on } else { checkCapital.state = .off; value*=0.75 }
        if lower   { checkLower.state   = .on } else { checkLower.state   = .off; value*=0.75 }
        if number  { checkNumber.state  = .on } else { checkNumber.state  = .off; value*=0.75 }
        if special { checkSpecial.state = .on } else { checkSpecial.state = .off; value*=0.75 }
        
        switch value {
        case 0...3.99:  securityColor.color = NSColor.red
        case 4...7.99:  securityColor.color = NSColor.orange
        case 8...11.99: securityColor.color = NSColor.yellow
        case 12...:     securityColor.color = NSColor.green
        default:        securityColor.color = NSColor.gray
        }
    }
    
    /**
     Creates password containing two words, two numbers and a special character.
     
     - Returns: a string containing a password.
     */
    func makePassword() -> String {
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
    
    @IBOutlet weak var checkCapital: NSButton!
    @IBOutlet weak var checkLower: NSButton!
    @IBOutlet weak var checkNumber: NSButton!
    @IBOutlet weak var checkSpecial: NSButton!
    
    @IBOutlet weak var securityColor: NSColorWell!
    @IBOutlet weak var txtPassword: NSTextField!
    
    /**
     "New password" button pressed.
     
     uses makePassword() method to assign a new password to txtPassword textfield.
     repeats until password is at least 12 characters long and met requirements in checkExpressions().
     */
    @IBAction func genPassword(_ sender: Any) {
        repeat {
            txtPassword.stringValue = makePassword()
            updateSecurity()
        } while (checkExpressions() != (true, true, true, true) || txtPassword.stringValue.count < 12)
    }
    
    /**
     check if txtPassword.stringValue did change
     */
    func controlTextDidChange(_ obj: Notification) {
        updateSecurity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
    }
}
