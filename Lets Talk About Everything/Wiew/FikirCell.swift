//
//  FikirCell.swift
//  Lets Talk About Everything
//
//  Created by aytaç bulanık on 30.12.2022.
//

import UIKit

class FikirCell: UITableViewCell {

    @IBOutlet weak var kullaniciAdiLabel: UILabel!
    @IBOutlet weak var eklenmeTarihiLabel: UILabel!
    @IBOutlet weak var yorumText: UILabel!
    @IBOutlet weak var begeniCountLabel: UILabel!
    @IBOutlet weak var begeniImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    func fikirCellUpdate (fikir : Fikir) {
        kullaniciAdiLabel.text = fikir.kullaniciAdi
        yorumText.text = fikir.fikirText
        begeniCountLabel.text = String(fikir.begeniSayisi)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM YYYY, hh:mm"
        let sonHali = dateFormatter.string(from: fikir.eklenmeTarihi)
        eklenmeTarihiLabel.text = sonHali
    }
    

}
