//
//  ViewController.swift
//  Lets Talk About Everything
//
//  Created by aytaç bulanık on 26.12.2022.
//

import UIKit
import Firebase

class AnaVC : UIViewController {

    
    @IBOutlet weak var sgmntKategoriler: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var fikirler = [Fikir]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.estimatedRowHeight = 80
        //tableView.rowHeight = UITableView.automaticDimension
        getFirestoreFikir()
    }

    @IBAction func sgmntKategorilerTiklandi(_ sender: UISegmentedControl) {
        
    }
    
    func getFirestoreFikir() {
        Firestore.firestore().collection(Fikirler_REF).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snap = snapshot {
                    if snap.documents.count > 0 {
                        let data = snap.documents
                        for veri in data {
                            let documentId = veri.documentID
                            guard let kulaniciAdi = veri[Kullanici_Adi] as? String , let fikirText = veri[Fikir_Text] as? String , let begeniSayisi = veri[Begeni_Sayisi] as? Int, let kategori = veri[Kategori] as? String , let eklenmeTarihi = veri[Eklenme_Tarihi] as? Timestamp, let yorumSayisi = veri[Yorum_Sayisi] as? Int else {return}
                            let trueDate = eklenmeTarihi.dateValue()
                            let newFikir = Fikir(kullaniciAdi: kulaniciAdi, eklenmeTarihi: trueDate, fikirText: fikirText, yorumSayisi: yorumSayisi, begeniSayisi: begeniSayisi, documentId: documentId)
                            self.fikirler.append(newFikir)
                        }
                        self.tableView.reloadData()
                    }
                }
            
            
            }
        }
    }
    
}

extension AnaVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fikirler.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fikirCell", for: indexPath) as! FikirCell
        cell.fikirCellUpdate(fikir: fikirler[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}

