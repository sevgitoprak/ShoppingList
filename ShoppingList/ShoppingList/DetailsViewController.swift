//
//  DetailsViewController.swift
//  ShoppingList
//
//  Created by Macbook on 1.02.2022.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ürünİsmiLabel: UITextField!
    @IBOutlet weak var ürünFiyatiLabel: UITextField!
    @IBOutlet weak var ürünBedeniFiyati: UITextField!
    
    var secilenUrünIsmi = ""
    var secilenUrünId :UUID?
    
    
    @IBAction func kaydetButonuTiklandi(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let alisveris = NSEntityDescription.insertNewObject(forEntityName: "Shopping", into: context)
        
        alisveris.setValue(ürünİsmiLabel.text, forKey: "isim")
        alisveris.setValue(ürünBedeniFiyati.text, forKey: "beden")
        alisveris.setValue(UUID(), forKey: "id")
        
        if let fiyat = Int(ürünFiyatiLabel.text!) {
            alisveris.setValue(fiyat, forKey: "fiyat")
        }
        
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        alisveris.setValue(data, forKey: "gorsel")
        
        do {
            try context.save()
            print("ürün eklendi")
        } catch{
            print("hata var")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("veriGirildi"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if secilenUrünIsmi != ""{
            
            if let uuidstring = secilenUrünId?.uuidString{
                print(uuidstring)
            }
            
            
        }else{
            ürünİsmiLabel.text = ""
            ürünFiyatiLabel.text = ""
            ürünBedeniFiyati.text = ""
        }

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyiKapat))
        view.addGestureRecognizer(gestureRecognizer)
        
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
    }
    
    @objc func klavyeyiKapat () {
        
        view.endEditing(true)
    }
    @objc func gorselSec (){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }


}
