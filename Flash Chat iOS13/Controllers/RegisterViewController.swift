//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This is because it shows strong password overlay
        passwordTextfield.textContentType = .oneTimeCode
    }
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let pass = passwordTextfield.text {
            emailTextfield.text = nil
            passwordTextfield.text = nil
            Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
                if let err = error {
                    print(err)
                } else {
                    // sucessfull login
                    self.performSegue(withIdentifier: "RegisterToChat", sender: self)
                }
            }
        }
    }
    
}

extension UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}
