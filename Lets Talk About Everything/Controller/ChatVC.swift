//
//  ChatVC.swift
//  Lets Talk About Everything
//
//  Created by Aytaç Bulanık on 14.10.2024.
//

import UIKit
import FirebaseAuth

class ChatVC: UIViewController {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages : [Message] = [
        Message(sender: "ayt@gmail.com", body: "Hello"),
        Message(sender: "cyd@gmail.com", body: "Hi"),
        Message(sender: "ayt@gmail.com", body: "Whats up!")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = Constants.appShortName
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logOutFunc))
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
        
    }
    
}

extension ChatVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.chatIdentyfire, for: indexPath)
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.body
        return cell
    }
    
    
    
    
}
