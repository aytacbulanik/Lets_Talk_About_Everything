//
//  YorumlarVC.swift
//  Lets Talk About Everything
//
//  Created by aytaç bulanık on 3.01.2023.
//

import UIKit
import Firebase

class YorumlarVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yorumTextField: UITextField!
    
    var secilenFikir : Fikir!
    var yorumlar = [Yorum]()
    var fikirRef : DocumentReference!
    let firestore = Firestore.firestore()
    var kullaniciAdi : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fikirRef = firestore.collection(Fikirler_REF).document(secilenFikir.documentId)
        if let adi = Auth.auth().currentUser?.displayName {
            kullaniciAdi = adi
        }
        
    }
    
    @IBAction func yorumEklebuttonPressed(_ sender: Any) {
        guard let yorumText = yorumTextField.text else {return}
        firestore.runTransaction { transaction, errorPointer in
            let secilenFikirKayit : DocumentSnapshot
            do {
                try secilenFikirKayit = transaction.getDocument(self.firestore.collection(Fikirler_REF).document(self.secilenFikir.documentId))
                
                guard let eskiYorumSayisi = (secilenFikirKayit.data()?[Yorum_Sayisi] as? Int) else {return nil}
                transaction.updateData([Yorum_Sayisi : eskiYorumSayisi + 1], forDocument: self.fikirRef)
                let yeniYorumRef = self.firestore.collection(Fikirler_REF).document(self.secilenFikir.documentId).collection(YORUMLAR_REF).document()
                
                transaction.setData([YORUM_TEXT : yorumText,
                                 Eklenme_Tarihi : FieldValue.serverTimestamp(),
                                   KULLANICIADI : self.kullaniciAdi
                                    ], forDocument: yeniYorumRef)
                
            } catch let hata {
                print("hata meydana geldi" , hata.localizedDescription)
            }
            return nil
        } completion: { nesne, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.yorumTextField.text = ""
            }
        }
    }
    
}


extension YorumlarVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        yorumlar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "yorumCell", for: indexPath) as? YorumCell {
            cell.gorunumAyarla(yorum : yorumlar[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
