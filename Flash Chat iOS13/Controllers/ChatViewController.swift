//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "🐸PepeChat"
        navigationItem.hidesBackButton = true

    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            
            // If successfull we should go back to the root view controller
            navigationController?.popToRootViewController(animated: true)
        } catch let sighOutError as NSError {
            print("Error signing out: %@", sighOutError)
        }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    

}
