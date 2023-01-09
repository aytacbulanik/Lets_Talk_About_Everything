//
//  FikirEkleVC.swift
//  Lets Talk About Everything
//
//  Created by aytaç bulanık on 30.12.2022.
//

import UIKit
import Firebase

class FikirEkleVC: UIViewController {

    @IBOutlet weak var sgmntKategoriler: UISegmentedControl!
    @IBOutlet weak var txtKullaniciAdi: UITextField!
    @IBOutlet weak var txtFikir: UITextView!
    @IBOutlet weak var btnPaylasOut: UIButton!
    var secilenKategori : String = Kategoriler.Eglence.rawValue
    let fikirText = "Lütfen Fikrinizi giriniz..."
    override func viewDidLoad() {
        super.viewDidLoad()

        txtFikir.layer.cornerRadius = 7
        btnPaylasOut.layer.cornerRadius = 8
        txtFikir.text = fikirText
        txtFikir.delegate = self
    }
    

    @IBAction func kategoriDegisTiklandi(_ sender: UISegmentedControl) {
        switch sgmntKategoriler.selectedSegmentIndex {
        case 0 : secilenKategori = Kategoriler.Eglence.rawValue
        case 1 : secilenKategori = Kategoriler.Absurt.rawValue
        case 2 : secilenKategori = Kategoriler.Gundem.rawValue
        default:
            secilenKategori = Kategoriler.Eglence.rawValue
        }
    }
    
    @IBAction func paylasButtonPressed(_ sender: UIButton) {
        guard let kullaniciAdi = txtKullaniciAdi.text , let fikirText = txtFikir.text else {return}
        Firestore.firestore().collection(Fikirler_REF).addDocument(data:
        [Kategori : secilenKategori,
         Begeni_Sayisi : 0,
         Yorum_Sayisi : 0,
         Fikir_Text : fikirText,
         Eklenme_Tarihi : FieldValue.serverTimestamp(),
         Kullanici_Adi : kullaniciAdi,
        KULLANICI_ID : Auth.auth().currentUser?.uid ?? ""
                                                                    ]
                                                                 
        ) { hata in
            if let hata = hata {
                print(hata)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
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
