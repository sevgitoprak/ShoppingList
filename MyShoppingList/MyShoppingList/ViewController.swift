//
//  ViewController.swift
//  MyShoppingList
//
//  Created by Macbook on 3.02.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String] ()
    var idArray = [UUID] ()
    
    var choosenName = ""
    var choosenId : UUID?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        getDatas()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getDatas), name: NSNotification.Name(rawValue: "data sent"), object: nil)
    }
    
    @objc func getDatas () {
        
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        
        let appDeelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDeelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            
            if results.count>0
            {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        nameArray.append(name)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                }
            }
            
            tableView.reloadData()
            
        } catch{
            print("hata var")
        }
    }
    
    @objc func addButtonClicked(){
        
        choosenName = ""
        performSegue(withIdentifier: "toDetailsVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        cell.textLabel?.font = UIFont (name: "ArchitectsDaughter-Regular", size: 16)
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as? DetailsViewController
            destinationVC?.choosenProductName = choosenName
            destinationVC?.choosenProductId = choosenId
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenName = nameArray[indexPath.row]
        choosenId = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
            
            let uuidString = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id=%@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let sonuclar = try context.fetch(fetchRequest)
                if sonuclar.count>0 {
                    for sonuc in sonuclar as! [NSManagedObject]{
                        if let id = sonuc.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row]{
                                
                                context.delete(sonuc)
                                nameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                                do{
                                    try context.save()
                                }catch{
                                    print("hata var")
                                }
                                break
                            }
                        }
                    }
                }
                
            } catch{
                print("hata var")
            }
            
        }
    }
    

}

