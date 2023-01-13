//
//  YorumCell.swift
//  Lets Talk About Everything
//
//  Created by aytaç bulanık on 3.01.2023.
//

import UIKit
import Firebase

class YorumCell: UITableViewCell {

    @IBOutlet weak var lblKullaniciAdi: UILabel!
    @IBOutlet weak var lblTarih: UILabel!
    @IBOutlet weak var lblYorumText: UILabel!
    @IBOutlet weak var imgSecenekler: UIImageView!
    var secilenYorum : Yorum!
    var delegate : YorumDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func gorunumAyarla(yorum : Yorum, delegate : YorumDelegate?) {
        secilenYorum = yorum
        lblKullaniciAdi.text = yorum.kullaniciAdi
        lblYorumText.text = yorum.yorumText
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM YYYY, hh:mm"
        let sonHali = dateFormatter.string(from: yorum.eklenmeTarihi)
        lblTarih.text = sonHali
        imgSecenekler.isHidden = true
        self.delegate = delegate
        if yorum.kullaniciId == Auth.auth().currentUser?.uid {
            imgSecenekler.isHidden = false
            imgSecenekler.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(imgYorumSeceneklerPressed))
            imgSecenekler.addGestureRecognizer(tap)
        }
    }
    
    @objc func imgYorumSeceneklerPressed() {
        delegate?.yorumDelegate(yorum: secilenYorum)
    }
}

protocol YorumDelegate {
    func yorumDelegate(yorum : Yorum)
}
