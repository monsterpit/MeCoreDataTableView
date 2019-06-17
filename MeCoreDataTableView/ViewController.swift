//
//  ViewController.swift
//  MeCoreDataTableView
//
//  Created by MB on 6/17/19.
//  Copyright © 2019 MB. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let service = APIService()
        
//        service.getDataWith { (result) in
//            switch result{
//            case .Success(let data):
//                print(data)
//                
//            case .Error(let error):
//                print(error)
//                
//            }
//        }
        
        service.getDataWithDecoder { (result) in
            switch result{
            case .Success(let data):
                print(data)
                self.saveInCoreDataWith(array: data)
            case .Error(let message):
                print(message)
                
                DispatchQueue.main.async {
                     self.showAlertWith(title: "Error", message: message)
                }
               
            }
        }
        
    }

    
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    
//    private func createPhotoEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
//        let context = CoreDataStack.shared.persistentContainer.viewContext
//        if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
//            photoEntity.author = dictionary["author"] as? String
//            photoEntity.tags = dictionary["tags"] as? String
//            let mediaDictionary = dictionary["media"] as? [String: AnyObject]
//            photoEntity.mediaURL = mediaDictionary?["m"] as? String
//            return photoEntity
//        }
//        return nil
//    }
    
//    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
//        _ = array.map{self.createPhotoEntityFrom(dictionary: $0)}
//        do {
//            try CoreDataStack.shared.persistentContainer.viewContext.save()
//        } catch let error {
//            print(error)
//        }
//    }

    
    //Func to save data in Core Data
    private func createPhotoEntityFrom(item: Flickr.item) -> NSManagedObject? {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
            photoEntity.author = item.author
            photoEntity.tags = item.tags
            photoEntity.mediaURL = item.media.m
            
            return photoEntity
        }
        return nil
    }
    
    //Saving Data in core Data 1 by 1
        private func saveInCoreDataWith(array: [Flickr.item]) {
            _ = array.map{self.createPhotoEntityFrom(item: $0)}
            do {
                try CoreDataStack.shared.persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }
    
    //MARK:- Fetching Data
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Photo.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "author", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        return frc
    }()
}

