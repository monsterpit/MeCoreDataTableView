//
//  ViewController.swift
//  MeCoreDataTableView
//
//  Created by MB on 6/17/19.
//  Copyright © 2019 MB. All rights reserved.
//
//https://medium.com/@jamesrochabrun/parsing-json-response-and-save-it-in-coredata-step-by-step-fb58fc6ce16f


import UIKit
import CoreData
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        if let photo = fetchedhResultController.object(at: indexPath) as? Photo {
            cell.setPhotoCellWith(photo: photo)
        }
            return cell
        
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

 
       // clearData()
        updateTableContent()
    }

    func updateTableContent() {
        do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(self.fetchedhResultController.sections?[0].numberOfObjects)")
        } catch let error  {
            print("ERROR: \(error)")
        }
        
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
                
                self.clearData()
                
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
    
    
//    func allrecords(){
//
////        let appDelegate = UIApplication.shared.delegate as! AppDelegate
////        let context = appDelegate.persistentContainer.viewContext
////
////        print("database all records value mate")
////        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pet")
////        request.returnsObjectsAsFaults = false
//
//
//      let container =  CoreDataStack.shared.persistentContainer
//        let context = container.viewContext
//
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
//        request.returnsObjectsAsFaults = false
//
//        do {
//            let result = try context.fetch(request)
//
//            for i in result as! [NSManagedObjectContext]{
//                i.value(forKey: "author") as! String
//            }
//
//        }
//        catch let error{
//            print(error.localizedDescription)
//        }
//    }
//
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
        frc.delegate = self
        return frc
    }()
    
    
    private func clearData() {
        do {
            let context = CoreDataStack.shared.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.shared.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}
