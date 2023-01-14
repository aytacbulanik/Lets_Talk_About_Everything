//
//  YorumDuzenleVC.swift
//  Lets Talk About Everything
//
//  Created by MacBookPro on 14.01.2023.
//

import UIKit
import Firebase

class YorumDuzenleVC: UIViewController {

    @IBOutlet weak var yorumTextView: UITextView!
    @IBOutlet weak var guncelleButtonOut: UIButton!
    
    var yorumVerisi : (secilenYorum : Yorum , secilenFikir : Fikir)!
    override func viewDidLoad() {
        super.viewDidLoad()

        yorumTextView.layer.cornerRadius = 10
        guncelleButtonOut.layer.cornerRadius = 10
        if let yorumVerisi = yorumVerisi {
            yorumTextView.text = yorumVerisi.secilenYorum.yorumText!
        }
    }
    

    @IBAction func guncelleButtonPressed(_ sender: Any) {
        guard let yorumText = yorumTextView.text, yorumTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != true else {return}
        Firestore.firestore().collection(Fikirler_REF).document(yorumVerisi.secilenFikir.documentId).collection(YORUMLAR_REF).document(yorumVerisi.secilenYorum.documentId).updateData([YORUM_TEXT : yorumText]) { hata in
            
            if let hata = hata {
                print("Yorum güncellenemedi \(hata.localizedDescription)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
    

}
