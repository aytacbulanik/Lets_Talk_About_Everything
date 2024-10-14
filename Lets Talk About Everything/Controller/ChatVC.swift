//
//  ChatVC.swift
//  Lets Talk About Everything
//
//  Created by Aytaç Bulanık on 14.10.2024.
//

import UIKit
import FirebaseAuth

class ChatVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
   

}
