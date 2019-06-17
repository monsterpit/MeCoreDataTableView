//
//  ViewController.swift
//  MeCoreDataTableView
//
//  Created by MB on 6/17/19.
//  Copyright © 2019 MB. All rights reserved.
//

import UIKit

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
                
            case .Error(let error):
                print(error)
                
            }
        }
        
    }

    

}

