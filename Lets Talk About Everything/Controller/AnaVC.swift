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
    private var listenerHandle : AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fikirlerCollectionRef = Firestore.firestore().collection(Fikirler_REF)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        listenerHandle = Auth.auth().addStateDidChangeListener({ auth, user in
            if user == nil {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let girisVC = storyBoard.instantiateViewController(withIdentifier: "GirisVC")
                self.present(girisVC, animated: true)
            } else {
                self.setListener()
            }
        })
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        fikirlerListener.remove()
    }
    
    func setListener() {
        
        if secilenKategori == Kategoriler.Populer.rawValue {
            fikirlerListener = fikirlerCollectionRef
                .order(by: Eklenme_Tarihi, descending: true)
                .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.fikirler.removeAll()
                    self.fikirler = Fikir.fikirGetir(snapshot: snapshot)
                            self.tableView.reloadData()
                        }
                    }
        }else {
            fikirlerListener = fikirlerCollectionRef.whereField(Kategori, isEqualTo: secilenKategori)
                .order(by: Eklenme_Tarihi, descending: true)
                .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.fikirler.removeAll()
                    self.fikirler = Fikir.fikirGetir(snapshot: snapshot)
                            self.tableView.reloadData()
                        }
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
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        }catch let oturumhatasi as NSError{
            print("Çıkış yapılamadı", oturumhatasi.localizedDescription)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yorumSegue" {
            if let hedefVC = segue.destination as? YorumlarVC {
                if let fikirim = sender as? Fikir {
                    hedefVC.secilenFikir = fikirim
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
        cell.fikirCellUpdate(fikir: fikirler[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "yorumSegue", sender: fikirler[indexPath.row])
    }
   
}

extension AnaVC : FikirDelegate {
    func seceneklerFikirPressed(fikir: Fikir) {
       
        let alert  = UIAlertController(title: "Sil", message: "Paylaşımınızı silmek mi istiyorsunuz", preferredStyle: .actionSheet)
        let silAction = UIAlertAction(title: "Paylaşımı Sil", style: .default) { action in
            let yorumlarCollRef = Firestore.firestore().collection(Fikirler_REF).document(fikir.documentId).collection(YORUMLAR_REF)
                        self.yorumlariSil(yorumCollection: yorumlarCollRef) { (hata) in
                            if let hata = hata {
                                debugPrint("tüm yorumları silerken hata oluştu : \(hata.localizedDescription)")
                            }else {
                                Firestore.firestore().collection(Fikirler_REF).document(fikir.documentId).delete { (hata) in
                                    if let hata = hata {
                                        debugPrint("bu fikri silerken hata oluştu : \(hata.localizedDescription)")
                                    }else {
                                        alert.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                        }

            
        }
        
        let iptalAction = UIAlertAction(title: "İptal Et", style: .cancel)
        alert.addAction(silAction)
        alert.addAction(iptalAction)
        present(alert, animated: true)
    }
    
    func yorumlariSil(yorumCollection : CollectionReference , silinecekKayitSayisi : Int = 100 , completion : @escaping (Error?) -> ()) {
            
            yorumCollection.limit(to: silinecekKayitSayisi).getDocuments(completion: {(kayitSetleri , hata) in
                guard let kayitSetleri = kayitSetleri else {
                    completion(hata)
                    return
                }
                guard kayitSetleri.count > 0 else {
                    completion(nil)
                    return
                }
                let batch = yorumCollection.firestore.batch() //birden fazla write işlemi yapmak için bunu kullancağız.
                kayitSetleri.documents.forEach { batch.deleteDocument($0.reference)
                }
                batch.commit { batchHata in
                    if let hata = batchHata {
                        completion(hata)
                    } else {
                        self.yorumlariSil(yorumCollection: yorumCollection, silinecekKayitSayisi: silinecekKayitSayisi, completion: completion)
                    }
                }
            })
        }


}

