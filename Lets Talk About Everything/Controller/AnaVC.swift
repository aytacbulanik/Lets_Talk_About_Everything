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
    private var fikirlerCollectionRef : CollectionReference!
    private var fikirlerListener : ListenerRegistration!
    private var secilenKategori = Kategoriler.Eglence.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fikirlerCollectionRef = Firestore.firestore().collection(Fikirler_REF)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        setListener()
    }
    
    func setListener() {
        fikirlerListener = fikirlerCollectionRef.whereField(Kategori, isEqualTo: secilenKategori)
            .order(by: Eklenme_Tarihi, descending: true)
            .addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.fikirler.removeAll()
                guard let snap = snapshot else {return}
                
                for document in snap.documents {
                    let veri = document.data()
                    let documentId = document.documentID
                    let kulaniciAdi = veri[Kullanici_Adi] as? String ?? ""
                    let fikirText = veri[Fikir_Text] as? String ?? ""
                    let begeniSayisi = veri[Begeni_Sayisi] as? Int ?? 0
                    let yorumSayisi = veri[Yorum_Sayisi] as? Int ?? 0
                    let eklenmeTarihi = veri[Eklenme_Tarihi] as? Timestamp ?? Timestamp()
                    
                    let newFikir = Fikir(kullaniciAdi: kulaniciAdi, eklenmeTarihi: eklenmeTarihi.dateValue(), fikirText: fikirText, yorumSayisi: yorumSayisi, begeniSayisi: begeniSayisi, documentId: documentId)
                            self.fikirler.append(newFikir)
                        }
                        self.tableView.reloadData()
                    }
                }
    }
    

    @IBAction func sgmntKategorilerTiklandi(_ sender: UISegmentedControl) {
        switch sgmntKategoriler.selectedSegmentIndex {
        case 0 : secilenKategori = Kategoriler.Eglence.rawValue
        case 1 : secilenKategori = Kategoriler.Absurt.rawValue
        case 2 : secilenKategori = Kategoriler.Gundem.rawValue
        case 3 : secilenKategori = Kategoriler.Populer.rawValue
        default:
            secilenKategori = Kategoriler.Populer.rawValue
        }
        fikirlerListener.remove()
        setListener()
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
   
    
    
}

