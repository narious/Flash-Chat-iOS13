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
    
    // Adding a reference to our database
    let db = Firestore.firestore()
    
    var messages = [
        Message(sender: "seniorPepe@1.com", body: "hey pepe!"),
        Message(sender: "pepe@1.com", body: "hey senior pepe"),
        Message(sender: "seniorPepe@1.com", body: "tonight we good pepe?"),
        Message(sender: "seniorPepe@1.com", body: "In probability theory, a normal (or Gaussian or Gauss or Laplace–Gauss) distribution is a type of continuous probability distribution for a mu")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.delegate = self
        tableView.dataSource = self
        title = K.appName
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        navigationItem.hidesBackButton = true
        
        loadMessages()

    }
    
    func loadMessages() {
        messages = []
        
        // Returns a query snapshot which is a NS object
        db.collection(K.FStore.collectionName).getDocuments { (querySnapshot, error) in
            if let e = error {
                print("An error occured in loading messages from the  firebase db, \(e)")
            } else {
                // Loop through through the sanpshot documents
                if let snapshopDocs = querySnapshot?.documents {
                    for doc in snapshopDocs {
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            self.messages.append(Message(sender: sender, body: messageBody))
                            
                            // We need to releod the data from the dable view, but we need to do asych
                            // since its in the background
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
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
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            // we named it messages a string. & sender field is just "sender"
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField : messageSender,
                                                                      K.FStore.bodyField: messageBody]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("succesfully saved data!")
                }
            }
        }
    }
    

}


extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        return cell
    }
    
    
}

// If we want to intract with the pressing the cells
//extension ChatViewController : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
//    }
//}
