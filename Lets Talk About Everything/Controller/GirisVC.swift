//
//  GirisVC.swift
//  Lets Talk About Everything
//
//  Created by AYTAÇ BULANIK on 1.01.2023.
//

import UIKit
import Firebase

class GirisVC: UIViewController {

    
    @IBOutlet var lblMail: UITextField!
    @IBOutlet var lblSifre: UITextField!
    @IBOutlet var girisYapOut: UIButton!
    @IBOutlet var uyeOlOut: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        girisYapOut.layer.cornerRadius = 10
        uyeOlOut.layer.cornerRadius = 10
    }
    

    @IBAction func GirisYapButtonPressed(_ sender: Any) {
        guard let mail = lblMail.text , let password = lblSifre.text else {return}
        Auth.auth().signIn(withEmail: mail, password: password) {
            kullanici , error in
            if let error = error {
                print("Kullanıcı giriş yapamadı", error.localizedDescription)
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
   
    
}
