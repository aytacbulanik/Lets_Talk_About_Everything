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
    var yorumlarListener : ListenerRegistration!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fikirRef = firestore.collection(Fikirler_REF).document(secilenFikir.documentId)
        if let adi = Auth.auth().currentUser?.displayName {
            kullaniciAdi = adi
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        yorumlariGetir()
    }
    func yorumlariGetir() {
        yorumlarListener = firestore.collection(Fikirler_REF).document(secilenFikir.documentId).collection(YORUMLAR_REF).order(by: Eklenme_Tarihi, descending: false)
            .addSnapshotListener({ snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.yorumlar.removeAll()
                self.yorumlar = Yorum.yorumlariGetir(snapshot: snapshot)
                self.tableView.reloadData()
            }
        })
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
                                   KULLANICIADI : self.kullaniciAdi,
                                   KULLANICI_ID : Auth.auth().currentUser?.uid ?? ""
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yorumDuzenleSegue" {
            if let gidilecekVC = segue.destination as? YorumDuzenleVC {
            if let yorumVerisi = sender as? (secilenYorum : Yorum , secilenFikir : Fikir) {
                gidilecekVC.yorumVerisi = yorumVerisi
            }
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
            cell.gorunumAyarla(yorum : yorumlar[indexPath.row], delegate : self)
            return cell
        }
        return UITableViewCell()
    }
}

extension YorumlarVC : YorumDelegate {
    func yorumDelegate(yorum: Yorum) {
        let alert = UIAlertController(title: "Yorum Düzenle", message: "Yorumu düzenleyebilir yada silebilirsiniz.", preferredStyle: .actionSheet)
        
        let silButton = UIAlertAction(title: "Yorumu Sil", style: .default) { action in
//            self.firestore.collection(Fikirler_REF).document(self.secilenFikir.documentId).collection(YORUMLAR_REF).document(yorum.documentId).delete(completion: {
//                hata in
//                print("Silme işlemi hatalı , \(hata?.localizedDescription)")
//            })
            
            self.firestore.runTransaction { (transaction,hata) -> Any? in
                let secilenFikirKayıt : DocumentSnapshot
                
                do {
                    try secilenFikirKayıt = transaction.getDocument(self.firestore.collection(Fikirler_REF).document(self.secilenFikir.documentId))
                }catch let hata as NSError {
                    print(hata.localizedDescription)
                    return nil
                }
                
                guard let eskiYorumSayisi = (secilenFikirKayıt.data()?[Yorum_Sayisi] as? Int) else {return}
                transaction.updateData([Yorum_Sayisi : eskiYorumSayisi - 1], forDocument: self.fikirRef)
                let silinecekYorum = self.fikirRef.collection(YORUMLAR_REF).document(yorum.documentId)
                transaction.deleteDocument(silinecekYorum)
                return nil
            } completion: { nesne, hata in
                if let hata = hata {
                    print("Yorumu silerken hata oluştu \(hata.localizedDescription)")
                }
            }

            
        }
        
        let duzenleButton = UIAlertAction(title: "Yorumu Düzenle", style: .default) { action in
            self.performSegue(withIdentifier: "yorumDuzenleSegue", sender: (yorum , self.secilenFikir ))
            self.dismiss(animated: true)
        }
        
        let iptalButton = UIAlertAction(title: "İptal", style: .cancel)
        alert.addAction(silButton)
        alert.addAction(duzenleButton)
        alert.addAction(iptalButton)
        
        present(alert, animated: true)
        
        
        
        
    }
    
    
}
