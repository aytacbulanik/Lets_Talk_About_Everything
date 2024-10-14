//
//  LogInVC.swift
//  Lets Talk About Everything
//
//  Created by Aytaç Bulanık on 10.10.2024.
//

import UIKit
import FirebaseAuth

class LogInVC: UIViewController {

    @IBOutlet weak var logInButtonOut: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        logInButtonOut.layer.cornerRadius = 10
    }
    

    @IBAction func logInButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            self.performSegue(withIdentifier: "ToChatSegue", sender: self)
        }
        
    }
    

}
