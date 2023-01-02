//
//  KayitOlVC.swift
//  Lets Talk About Everything
//
//  Created by AYTAÇ BULANIK on 1.01.2023.
//

import UIKit
import Firebase

class KayitOlVC: UIViewController {

    @IBOutlet var lblMail: UITextField!
    @IBOutlet var lblSifre: UITextField!
    @IBOutlet var lblKullaniciAdi: UITextField!
    @IBOutlet var uyeOlButtonOut: UIButton!
    @IBOutlet var vazgectimButtonOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uyeOlButtonOut.layer.cornerRadius = 10
        vazgectimButtonOut.layer.cornerRadius = 10
    }
    
    
    @IBAction func uyeOlButtonPressed(_ sender: Any) {
        guard let mail = lblMail.text , let password = lblSifre.text , let kullaniciAdi = lblKullaniciAdi.text else {return}
        Auth.auth().createUser(withEmail: mail, password: password) { authResult , error in
            if let error = error {
                print("Kullanıcı oluşturulurken hata meydana geldi", error.localizedDescription)
            }
            let changedRequest = authResult?.user.createProfileChangeRequest()
            changedRequest?.displayName = kullaniciAdi
            changedRequest?.commitChanges(completion: { hata in
                if let hata = hata {
                    print("Kullanıcı adı güncellenmedi",hata.localizedDescription)
                }
            })
            guard let kullaniciId = authResult?.user.uid else {return}
            Firestore.firestore().collection(KULLANICILAR_REF).document(kullaniciId).setData([
                KULLANICIADI : kullaniciAdi,
                KULLANICIOLUSTURULMATARIHI : FieldValue.serverTimestamp()
            ]) { hata in
                if let hata = hata {
                    print("Kullanıcı güncellenemedi", hata.localizedDescription)
                } else {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    @IBAction func vazgectimButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    

}
