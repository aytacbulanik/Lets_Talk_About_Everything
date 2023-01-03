//
//  YorumCell.swift
//  Lets Talk About Everything
//
//  Created by aytaç bulanık on 3.01.2023.
//

import UIKit

class YorumCell: UITableViewCell {

    @IBOutlet weak var lblKullaniciAdi: UILabel!
    @IBOutlet weak var lblTarih: UILabel!
    @IBOutlet weak var lblYorumText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func gorunumAyarla(yorum : Yorum) {
        
        lblKullaniciAdi.text = yorum.kullaniciAdi
        lblYorumText.text = yorum.yorumText
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM YYYY, hh:mm"
        let sonHali = dateFormatter.string(from: yorum.eklenmeTarihi)
       lblTarih.text = sonHali
    }
}
