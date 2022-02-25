//
//  DetailsViewController.swift
//  MyShoppingList
//
//  Created by Macbook on 3.02.2022.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var PriceTextField: UITextField!
    @IBOutlet weak var SizeTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var choosenProductName = ""
    var choosenProductId : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if choosenProductName != "" {
            
            saveButton.isHidden = true
            
            if let uuidString = choosenProductId?.uuidString {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let results = try context.fetch(fetchRequest)
                    
                    if results.count>0 {
                        for result in results as! [NSManagedObject]{
                            if let name = result.value(forKey: "name") as? String {
                                NameTextField.text = name
                            }
                            if let price = result.value(forKey: "price") as? Int {
                                PriceTextField.text = String(price)
                            }
                            if let size = result.value(forKey: "size") as? String {
                                SizeTextField.text = size
                            }
                            if let gorselData = result.value(forKey: "image") as? Data {
                                let image = UIImage(data: gorselData)
                                imageView.image = image
                            }
                        }
                    }
                    
                } catch {
                    
                }
                
            }
        }
        else {
            saveButton.isHidden = false
            saveButton.isEnabled = false
            NameTextField.text = ""
            PriceTextField.text = ""
            SizeTextField.text = ""
        }
        
        
        

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeTheKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
    }
    @IBAction func SaveButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        
        let shopping = NSEntityDescription.insertNewObject(forEntityName: "Shopping", into: context)
        shopping.setValue(NameTextField.text, forKey: "name")
        shopping.setValue(SizeTextField.text, forKey: "size")
        
        if let price = Int(PriceTextField.text!){
            shopping.setValue(price, forKey: "price")
        }
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        shopping.setValue(data, forKey: "image")
        
        shopping.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("Saved")
        } catch{
            print("Fault")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "data sent"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @objc func chooseImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        saveButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func closeTheKeyboard(){
        
        view.endEditing(true)
    }
   
}
