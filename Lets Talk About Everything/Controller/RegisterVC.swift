//
//  RegisterVC.swift
//  Lets Talk About Everything
//
//  Created by Aytaç Bulanık on 10.10.2024.
//

import UIKit
import FirebaseAuth

class RegisterVC: UIViewController {

    @IBOutlet weak var registerButtonOut: UIButton!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButtonOut.layer.cornerRadius = 10
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let userName = emailTextField.text, let password = passwordTextField.text, let passwordAgain = passwordAgainTextField.text else { return }
        if password != passwordAgain {
            print("Passwords do not match")
            return
        }
        
        Auth.auth().createUser(withEmail: userName, password: password) { AuthDataResult, error in
            if error != nil {
                if let error {
                    print(error.localizedDescription)
                }
            }
            self.navigationController?.popToRootViewController(animated: true)
            
        }
    }
    
   
}
