//
//  Yorum.swift
//  Lets Talk About Everything
//
//  Created by aytaç bulanık on 3.01.2023.
//

import Foundation
import Firebase

class Yorum {
    private(set) var kullaniciAdi : String!
    private(set) var eklenmeTarihi : Date!
    private(set) var yorumText : String!
    private(set) var documentId : String!
    private(set) var kullaniciId : String!
    
    init(kullaniciAdi: String, eklenmeTarihi: Date, yorumText: String, documentId : String, kullaniciId : String) {
        self.kullaniciAdi = kullaniciAdi
        self.eklenmeTarihi = eklenmeTarihi
        self.yorumText = yorumText
        self.documentId = documentId
        self.kullaniciId = kullaniciId
    }
    class func yorumlariGetir(snapshot : QuerySnapshot?) -> [Yorum] {
        var yorumlar = [Yorum]()
        guard let snap = snapshot else {return yorumlar}
        for document in snap.documents {
            let veri = document.data()
            let yorumText = veri[YORUM_TEXT] as? String ?? ""
            let eklenmeTarihi = veri[Eklenme_Tarihi] as? Timestamp ?? Timestamp()
            let kullaniciAdi = veri[Kullanici_Adi] as? String ?? ""
            let kullaniciId = veri[KULLANICI_ID] as? String ?? ""
            let documentId = document.documentID
            let newYorum = Yorum(kullaniciAdi: kullaniciAdi, eklenmeTarihi: eklenmeTarihi.dateValue(), yorumText: yorumText, documentId: documentId, kullaniciId: kullaniciId)
            yorumlar.append(newYorum)
        }
        return yorumlar
    }
}
