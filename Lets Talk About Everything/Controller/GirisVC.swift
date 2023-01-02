//
//  GirisVC.swift
//  Lets Talk About Everything
//
//  Created by AYTAÇ BULANIK on 1.01.2023.
//

import UIKit

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
    }
    
    @IBAction func uyeOlButtonPressed(_ sender: Any) {
    }
    
}
