//
//  WelcomeVC.swift
//  Lets Talk About Everything
//
//  Created by Aytaç Bulanık on 9.10.2024.
//

import UIKit
import FirebaseAuth

class WelcomeVC: UIViewController {

    @IBOutlet weak var logInButtonOut: UIButton!
    @IBOutlet weak var registerButtonOut: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    var charIndex = 0.0
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButtonOut.layer.cornerRadius = 10
        registerButtonOut.layer.cornerRadius = 10
        title = Constants.appShortName
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLTEAWords()
        controlCurrentUser()
    }
    
    func controlCurrentUser() {
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: Constants.chatVC)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getLTEAWords() {
        charIndex = 0.0
        titleLabel.text = ""
        let titleText = Constants.appLongName
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
    
}
