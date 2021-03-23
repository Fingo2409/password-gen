//
//  ViewController.swift
//  password-gen
//
//  Created by Joshua Schrader on 21.03.21.
//
//  Icon made by Gregor Cresnar from www.flaticon.com

import Cocoa

extension NSTextField{ func controlTextDidChange(obj: NSNotification){} }

class ViewController: NSViewController, NSTextFieldDelegate {
    
    @IBOutlet weak var checkCapital: NSButton!
    @IBOutlet weak var checkLower: NSButton!
    @IBOutlet weak var checkNumber: NSButton!
    @IBOutlet weak var checkSpecial: NSButton!
    
    @IBOutlet weak var securityColor: NSColorWell!
    @IBOutlet weak var txtPassword: NSTextField!
    
    /**
     Changes state of checkboxes if requierements are met.
     Also changes the color depending on security of password
     */
    func updateSecurity() {
        var value = Double(txtPassword.stringValue.count)
        
        let (capital, lower, number, special) = Password.checkExpressions(txtPassword.stringValue)

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
     "New password" button pressed.
     
     uses makePassword() method to assign a new password to txtPassword textfield.
     repeats until password is at least 12 characters long and met requirements in checkExpressions().
     */
    @IBAction func genPassword(_ sender: Any) {
        repeat {
            txtPassword.stringValue = Password.makePassword()
            updateSecurity()
        } while (Password.checkExpressions(txtPassword.stringValue) != (true, true, true, true) || txtPassword.stringValue.count < 12)
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
