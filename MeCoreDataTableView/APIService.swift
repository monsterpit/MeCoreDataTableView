//
//  APIService.swift
//  MeCoreDataTableView
//
//  Created by MB on 6/17/19.
//  Copyright © 2019 MB. All rights reserved.
//

import Foundation

enum Result <T>{
    case Success(T)
    case Error(String)
}


class APIService{
    let query = "dogs"
    
    lazy var endPoint: String = { return "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=\(query)&nojsoncallback=1#" }()
    
    let playListId = "iBi9LVIrC-fVelw2-I2r-yrEk6SpXfO8"
    
    let apiKey = "AIzaSyCI1oCTXwZzgVv7LDQ8NykSIUEWt247KnU"
    
    lazy var youtubeJSON : String = { return "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playListId)&key=\(apiKey)&maxResults=20"}()
    
    
    
    
    //MARK:-  Normal JSONSerialization
    func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        guard let url = URL(string: endPoint)  else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else{ return}
            do{
                if  let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers] ) as? [String : AnyObject]{
                    guard let itemJsonArray = json["items"] as? [[String : AnyObject]] else {return}
                    DispatchQueue.main.async {
                        completion(.Success(itemJsonArray))
                    }
                    
                }
                
            }
            catch let error{
                completion(.Error(error.localizedDescription))
            }
            
            }.resume()
        
    }
    
    //MARK:-  Decodable JSON
    func getDataWithDecoder(completion: @escaping (Result<[Flickr.item]>) -> Void){
        
        guard let url = URL(string: endPoint)  else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else{ return}
            
            do{
            let json = try JSONDecoder().decode(Flickr.self, from: data)
                
                completion(.Success(json.items))
                
                //Result<[String]>
                //completion(.Success(json.items.map{$0.title}))
                
            
            }
            catch let error{
                completion(.Error(error.localizedDescription))
            }
            
            }.resume()
    }
    
}
