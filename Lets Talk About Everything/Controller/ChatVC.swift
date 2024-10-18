//
//  ChatVC.swift
//  Lets Talk About Everything
//
//  Created by Aytaç Bulanık on 14.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatVC: UIViewController {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    
    var messages : [Message] = [
        Message(sender: "ayt@gmail.com", body: "Hello"),
        Message(sender: "cyd@gmail.com", body: "Hi"),
        Message(sender: "ayt@gmail.com", body: "Whats up! Whats up! Whats up! Whats up! Whats up! Whats up! Whats up!Whats up! Whats up! Whats up!")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = Constants.appShortName
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logOutFunc))
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    @objc func logOutFunc() {
        let user = Auth.auth()
        do {
            try user.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
   
    @IBAction func sendMessageButton(_ sender: UIButton) {
        guard let messageBody = messageTextField.text , let userMail = Auth.auth().currentUser?.email else { return }
        db.collection(Constants.messageFireStore).addDocument(data:
            ["sender": userMail, "body": messageBody]) { error in
            if error != nil {
                print(error?.localizedDescription)
            }
            self.messageTextField.text = ""
        }
    }
    
}

extension ChatVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.body
        return cell
    }
    
    
    
    
}
