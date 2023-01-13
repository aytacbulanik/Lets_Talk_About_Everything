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
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(begeniGuncelle))
        begeniImage.addGestureRecognizer(tap)
        begeniImage.isUserInteractionEnabled = true
    }
    @objc func begeniGuncelle() {
        Firestore.firestore().collection(Fikirler_REF).document(secilenFikir.documentId!).setData([Begeni_Sayisi : secilenFikir.begeniSayisi + 1], merge: true)
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
        }
    }
    
    @objc func imgFikirSeceneklerPressed() {
        delegate?.seceneklerFikirPressed(fikir: secilenFikir)
    }


}

protocol FikirDelegate {
    func seceneklerFikirPressed(fikir : Fikir)
}
