//
//  FikirCell.swift
//  Lets Talk About Everything
//
//  Created by aytaç bulanık on 30.12.2022.
//

import UIKit
import Firebase

class FikirCell: UITableViewCell {

    @IBOutlet weak var kullaniciAdiLabel: UILabel!
    @IBOutlet weak var eklenmeTarihiLabel: UILabel!
    @IBOutlet weak var yorumText: UILabel!
    @IBOutlet weak var begeniCountLabel: UILabel!
    @IBOutlet weak var begeniImage: UIImageView!
    @IBOutlet weak var lblYorumSayisi: UILabel!
    @IBOutlet weak var imgSecenekler: UIImageView!
    
    var secilenFikir : Fikir!
    var delegate : FikirDelegate?
    let fireStore = Firestore.firestore()
    var begeniler = [Begeni]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgBegeniTapped))
        begeniImage.addGestureRecognizer(tap)
        begeniImage.isUserInteractionEnabled = true
    }
    
    func begenileriGetir() {
        let begeniSorgu = fireStore.collection(Fikirler_REF).document(secilenFikir.documentId).collection(BEGENI_REF).whereField(KULLANICI_ID, isEqualTo: Auth.auth().currentUser?.uid)
        
        begeniSorgu.getDocuments(completion: {(snapShot , hata) in
            self.begeniler = Begeni.begenileriGetir(snapshot: snapShot)
            
            if self.begeniler.count > 0 {
                // kullanıcı beğeni yapmış
                self.imgSecenekler.image = UIImage(systemName: "star.fill")
            }else {
                // kullanıcı beğeni yapmış
                self.imgSecenekler.image = UIImage(systemName: "star")
            }
        })
    }
    
    @objc func imgBegeniTapped() {
        fireStore.runTransaction { (transaction, errorPointer) -> Any? in
            
            var secilenFikirKayit : DocumentSnapshot? = nil
            
            do {
                try secilenFikirKayit = transaction.getDocument(self.fireStore.collection(Fikirler_REF).document(self.secilenFikir.documentId))
            } catch let hata as NSError {
                print("Beğenide hata oluştu \(hata.localizedDescription)")
            }
            
            guard let eskiBegeniSayisi = (secilenFikirKayit?.data()?[Begeni_Sayisi] as? Int) else {return nil}
            let secilenFikirRef = self.fireStore.collection(Fikirler_REF).document(self.secilenFikir.documentId)
            if self.begeniler.count > 0 {
                transaction.updateData([Begeni_Sayisi : eskiBegeniSayisi-1], forDocument: secilenFikirRef)
                let eskiBegeniRef = self.fireStore.collection(Fikirler_REF).document(self.secilenFikir.documentId).collection(BEGENI_REF).document(self.begeniler[0].documentId)
                transaction.deleteDocument(eskiBegeniRef)
            }else {
                transaction.updateData([Begeni_Sayisi : eskiBegeniSayisi+1], forDocument: secilenFikirRef)
                
                let yeniBegeniRef = self.fireStore.collection(Fikirler_REF).document(self.secilenFikir.documentId).collection(BEGENI_REF).document()
                transaction.setData([KULLANICIADI : Auth.auth().currentUser?.uid ?? ""], forDocument: yeniBegeniRef)
            }
            return nil
        } completion: { nesne, hata in
            if let hata = hata {
                print("\(hata.localizedDescription)")
            }
        }

    }
    
    func fikirCellUpdate (fikir : Fikir, delegate : FikirDelegate?) {
        secilenFikir = fikir
        kullaniciAdiLabel.text = fikir.kullaniciAdi
        yorumText.text = fikir.fikirText
        begeniCountLabel.text = String(fikir.begeniSayisi)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM YYYY, hh:mm"
        let sonHali = dateFormatter.string(from: fikir.eklenmeTarihi)
        eklenmeTarihiLabel.text = sonHali
        lblYorumSayisi.text = "\(fikir.yorumSayisi ?? 0)"
        self.delegate = delegate
        if fikir.kullaniciId == Auth.auth().currentUser?.uid {
            imgSecenekler.isHidden = false
            imgSecenekler.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(imgFikirSeceneklerPressed))
            imgSecenekler.addGestureRecognizer(tap)
        }
        
    }
    
    @objc func imgFikirSeceneklerPressed() {
        delegate?.seceneklerFikirPressed(fikir: secilenFikir)
    }


}

protocol FikirDelegate {
    func seceneklerFikirPressed(fikir : Fikir)
}
