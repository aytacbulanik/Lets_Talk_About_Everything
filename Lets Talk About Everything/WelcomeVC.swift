//
//  WelcomeVC.swift
//  Lets Talk About Everything
//
//  Created by Aytaç Bulanık on 9.10.2024.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var logInButtonOut: UIButton!
    @IBOutlet weak var registerButtonOut: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    var charIndex = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButtonOut.layer.cornerRadius = 10
        registerButtonOut.layer.cornerRadius = 10
       title = "LTAE"
       let titleText = "Lets Talk About Everything"
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
    }
    

   

}
