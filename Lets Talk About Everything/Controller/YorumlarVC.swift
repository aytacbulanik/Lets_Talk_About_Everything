//
//  YorumlarVC.swift
//  Lets Talk About Everything
//
//  Created by aytaç bulanık on 3.01.2023.
//

import UIKit

class YorumlarVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yorumTextField: UITextField!
    
    var secilenFikir : Fikir!
    var yorumlar = [Yorum]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    

    
    @IBAction func yorumEklebuttonPressed(_ sender: Any) {
        
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
