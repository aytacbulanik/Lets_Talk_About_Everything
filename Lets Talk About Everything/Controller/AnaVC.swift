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

