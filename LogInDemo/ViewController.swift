//
//  ViewController.swift
//  LogInDemo
//
//  Created by Ricardo Hui on 30/3/2019.
//  Copyright © 2019 Ricardo Hui. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var label: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var logOutButton: UIButton!
    
    var isLoggedIn = false
    @IBAction func logOut(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        do {
            let results = try context.fetch(request)
            if results.count > 0{
                for result in results as! [NSManagedObject]{
                    context.delete(result)
                    do {
                        try context.save()
                    }catch{
                            print("Indivdual delte failed")
                    }
                }
                
                label.alpha = 0
                logOutButton.alpha = 0
                textField.alpha = 1
                button.setTitle("Log In", for: [])
                button.alpha = 1
                isLoggedIn = false
            }
        }catch{
            print("Delete Failed")
        }
    }

    @IBAction func logIn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        if isLoggedIn{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            
            do {
                let results = try context.fetch(request)
                if (results.count>0){
                    for result in results as! [NSManagedObject]{
                        result.setValue(textField.text, forKey: "name")
                        
                        do {
                            try context.save()
                        }catch{
                            print("Update username save failed")
                        }
                    }
                 label.text = "Hi there" + textField.text! + "!"
                }
            }catch{
                print("Update username failed")
            }
            
        }else{
            let newValue = NSEntityDescription.insertNewObject(forEntityName:"Users", into: context)
            newValue.setValue(textField.text, forKey: "name")
            do {
                try context.save()
                textField.alpha = 1
            
                label.alpha = 1
                label.text = "Hi there " + textField.text! + "!"
                logOutButton.alpha = 1
                button.setTitle("Update username", for: [])
            }catch {
                print("failed to save")
            }

        }
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject]{
                if let username = result.value(forKey:"name") as? String{
                    textField.alpha = 0
                    button.setTitle("Update username", for: [])
                    label.alpha = 1
                    logOutButton.alpha = 1
                    label.text = "Hi there " + username + "!"
                }
                
            }
        } catch  {
            print("Something went wrong!")
        }
    }


}

