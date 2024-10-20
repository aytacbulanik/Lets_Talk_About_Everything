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
    
    var messages : [Message] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = Constants.appShortName
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logOutFunc))
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        getMessageData()
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
        db.collection(Constants.collectionName).addDocument(data:[
            Constants.senderFristore: userMail, Constants.bodyFristore: messageBody , Constants.dateFirestore : Date().timeIntervalSince1970
            ]) { error in
            if error != nil {
                if let error {
                    print(error.localizedDescription)
                }
            }
            self.messageTextField.text = ""
        }
    }
    
    func getMessageData() {
        db.collection(Constants.collectionName)
            .order(by: Constants.dateFirestore, descending: false)
            .addSnapshotListener { querySnapshot, error in
            if error != nil {
                if let error {
                    print(error.localizedDescription)
                }
            }
            self.messages.removeAll(keepingCapacity: true)
            if let snapShot =  querySnapshot?.documents {
                for snap in snapShot {
                    let data = snap.data()
                    let body = data[Constants.bodyFristore] as? String ?? ""
                    let sender = data[Constants.senderFristore] as? String ?? ""
                    let message = Message(sender: sender, body: body)
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension ChatVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageLabel.textColor = .white
            cell.labelView.backgroundColor = UIColor(named: "sendColor")
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageLabel.textColor = .white
            cell.labelView.backgroundColor = UIColor(named: "watchColor")
        }
        return cell
    }
    
    
    
    
}
