//
//  YorumlarVC.swift
//  Lets Talk About Everything
//
//  Created by aytaç bulanık on 3.01.2023.
//

import UIKit
import Firebase

class YorumlarVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yorumTextField: UITextField!
    
    var secilenFikir : Fikir!
    var yorumlar = [Yorum]()
    var fikirRef : DocumentReference!
    let firestore = Firestore.firestore()
    var kullaniciAdi : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fikirRef = firestore.collection(Fikirler_REF).document(secilenFikir.documentId)
        if let adi = Auth.auth().currentUser?.displayName {
            kullaniciAdi = adi
        }
        
    }
    

    
    @IBAction func yorumEklebuttonPressed(_ sender: Any) {
        guard let yorumText = yorumTextField.text else {return}
        firestore.runTransaction(<#T##updateBlock: (Transaction, NSErrorPointer) -> Any?##(Transaction, NSErrorPointer) -> Any?#>, completion: <#T##(Any?, Error?) -> Void#>)
        
    }
    
}

extension YorumlarVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        yorumlar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "yorumCell", for: indexPath) as? YorumCell {
            cell.gorunumAyarla(yorum : yorumlar[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
