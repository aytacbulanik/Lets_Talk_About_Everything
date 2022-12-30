//
//  FikirEkleVC.swift
//  Lets Talk About Everything
//
//  Created by aytaç bulanık on 30.12.2022.
//

import UIKit

class FikirEkleVC: UIViewController {

    @IBOutlet weak var sgmntKategoriler: UISegmentedControl!
    @IBOutlet weak var txtKullaniciAdi: UITextField!
    @IBOutlet weak var txtFikir: UITextView!
    @IBOutlet weak var btnPaylasOut: UIButton!
    
    let fikirText = "Lütfen Fikrinizi giriniz..."
    override func viewDidLoad() {
        super.viewDidLoad()

        txtFikir.layer.cornerRadius = 7
        btnPaylasOut.layer.cornerRadius = 8
        txtFikir.text = fikirText
        txtFikir.delegate = self
    }
    

    @IBAction func kategoriDegisTiklandi(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func paylasButtonPressed(_ sender: UIButton) {
        
    }
    
}

extension FikirEkleVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == fikirText {
            textView.text = ""
            textView.textColor = .darkGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = fikirText
            textView.textColor = .lightGray
        }
    }
}
