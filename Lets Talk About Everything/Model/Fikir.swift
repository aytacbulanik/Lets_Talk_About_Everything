//
//  Fikir.swift
//  Lets Talk About Everything
//
//  Created by aytaç bulanık on 30.12.2022.
//

import Foundation
import Firebase

class Fikir {
    private(set) var kullaniciAdi : String!
    private(set) var eklenmeTarihi : Date!
    private(set) var fikirText : String!
    private(set) var yorumSayisi : Int!
    private(set) var begeniSayisi : Int!
    private(set) var documentId : String!
    private(set) var kullaniciId : String!
    
    init(kullaniciAdi: String, eklenmeTarihi: Date, fikirText: String, yorumSayisi: Int, begeniSayisi: Int, documentId: String, kullaniciId: String) {
        self.kullaniciAdi = kullaniciAdi
        self.eklenmeTarihi = eklenmeTarihi
        self.fikirText = fikirText
        self.yorumSayisi = yorumSayisi
        self.begeniSayisi = begeniSayisi
        self.documentId = documentId
        self.kullaniciId = kullaniciId
    }
    
    class func fikirGetir(snapshot : QuerySnapshot?) -> [Fikir] {
        var fikirler = [Fikir]()
        guard let snap = snapshot else {return fikirler}
        for document in snap.documents {
            let veri = document.data()
            let documentId = document.documentID
            let kulaniciAdi = veri[Kullanici_Adi] as? String ?? ""
            let fikirText = veri[Fikir_Text] as? String ?? ""
            let begeniSayisi = veri[Begeni_Sayisi] as? Int ?? 0
            let yorumSayisi = veri[Yorum_Sayisi] as? Int ?? 0
            let eklenmeTarihi = veri[Eklenme_Tarihi] as? Timestamp ?? Timestamp()
            let kullaniciId = veri[KULLANICI_ID] as? String ?? ""
            let newFikir = Fikir(kullaniciAdi: kulaniciAdi, eklenmeTarihi: eklenmeTarihi.dateValue(), fikirText: fikirText, yorumSayisi: yorumSayisi, begeniSayisi: begeniSayisi, documentId: documentId, kullaniciId: kullaniciId)
                fikirler.append(newFikir)
                }
        return fikirler
    }
    
     
}
