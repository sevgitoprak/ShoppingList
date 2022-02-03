//
//  ViewController.swift
//  ShoppingList
//
//  Created by Macbook on 1.02.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var isimDizisi = [String]()
    var idDizisi = [UUID]()
    
    var secilenIsim = ""
    var secilenId : UUID?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(eklemeButonuTiklandi))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        verileriGoster()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(verileriGoster), name: NSNotification.Name(rawValue: "veriGirildi"), object: nil)
    }
    
    @objc func verileriGoster(){
        
        isimDizisi.removeAll(keepingCapacity: false)
        idDizisi.removeAll(keepingCapacity: false)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
        
        do {
            let sonuclar = try context.fetch(fetchRequest)
            for sonuc in sonuclar as! [NSManagedObject]{
                
                if let isim = sonuc.value(forKey: "isim") as? String {
                    isimDizisi.append(isim)
                }
                if let id = sonuc.value(forKey: "id") as? UUID {
                    idDizisi.append(id)
                }
            }
            tableView.reloadData()
                    
        }catch{
            print("hata var")
        }
        
    }
    
    @objc func eklemeButonuTiklandi () {
        
        secilenIsim = ""
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isimDizisi.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = isimDizisi[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.secilenUrünIsmi = secilenIsim
            destinationVC.secilenUrünId = secilenId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenIsim = isimDizisi[indexPath.row]
        secilenId = idDizisi[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }


}

