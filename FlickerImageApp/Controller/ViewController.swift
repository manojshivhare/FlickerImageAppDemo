//
//  ViewController.swift
//  FlickerImageApp
//
//  Created by Manoj Shivhare on 14/05/20.
//  Copyright © 2020 Manoj Shivhare. All rights reserved.
//

import UIKit
import CoreData

struct API {
     static let fullGalleryURL = "https://api.flickr.com/services/rest/?method=flickr.galleries.getPhotos&api_key=d8158e574d6b7daadd8032dd7e00db4c&gallery_id=66911286-72157647277042064&format=json&nojsoncallback=1"
    static let imageSearchURl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=d8158e574d6b7daadd8032dd7e00db4c&format=json&nojsoncallback=1"
}

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
    
    @IBOutlet weak var picturesSearchBar: UISearchBar!
    
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    var pictureVM:[PhotoViewModel]?
    
    var newDataArr:[PhotoModel]? {
        didSet {
            CoreDataStore.deleteAllData()
            // Save them to Core Data
            CoreDataStore.saveContext()
            // Add the new spots to Core Data Context
            self.addNewDataToCoreData(self.newDataArr!)
            // Save them to Core Data
            CoreDataStore.saveContext()
            //setup
            self.setupDataFromCoreDataIntoLocalArr()
        }
    }
    
    //MARK: Setup Data into main Array
    func setupDataFromCoreDataIntoLocalArr(){
        pictureVM?.removeAll()
        DispatchQueue.main.async {
            for data in self.newDataArr! {
                self.pictureVM?.append(PhotoViewModel(id: data.id!, owner: data.owner!, secret: data.secret!, server: data.server!, farm: data.farm ?? 0, title: data.title!, isPublic: data.ispublic ?? 0, isFriend:data.isfriend ?? 0, isFamily: data.isfamily ?? 0))
            }
            self.reloadCollectionView()
        }
    }
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        picturesSearchBar.delegate = self
        self.pictureVM = CoreDataStore.getAllDataFromStore()
        if self.pictureVM!.count == 0 {
            if !Reachability.isConnectedToNetwork(){
                showAlertView(alert: "Alert!", message: "Internet not available")
            }
            else{
                self.callServiceToGetData(urlStr: API.fullGalleryURL)
            }
        }
        else{
            self.reloadCollectionView()
        }
    }
    
    //MARK: Call Service To Get Data
    func callServiceToGetData(urlStr:String) {
        ApiManager.shared.getUserData(urlStr: urlStr, view: self.view) { (photoModel) in
            if photoModel!.count > 0{
                self.newDataArr = photoModel
                //print(self.newDataArr as Any)
                self.reloadCollectionView()
            }
            else{
                self.showAlertView(alert: "Alert!", message: "No Data Found!")
            }
        }
    }
    
    //MARK: Show Alert View
    func showAlertView(alert: String, message:String) {
        let alert = UIAlertController(title: alert, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
       self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Reload CollectionView
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.pictureCollectionView.reloadData()
        }
    }
    
    
    //MARK: Add data into core data
    func addNewDataToCoreData(_ object: [PhotoModel]) {
        for Obj in object {
            let entity = NSEntityDescription.entity(forEntityName: "Flicker", in: CoreDataStore
                .getContext())
            let storeDic = NSManagedObject(entity: entity!, insertInto: CoreDataStore.getContext())
            
            // Set the data to the entity
            storeDic.setValue(Obj.id, forKey: "id")
            storeDic.setValue(Obj.owner, forKey: "owner")
            storeDic.setValue(Obj.secret, forKey: "secret")
            storeDic.setValue(Obj.server, forKey: "server")
            storeDic.setValue(Obj.farm, forKey: "farm")
            storeDic.setValue(Obj.title, forKey: "title")
            storeDic.setValue(Obj.ispublic, forKey: "ispublic")
            storeDic.setValue(Obj.isfriend, forKey: "isfriend")
            storeDic.setValue(Obj.isfamily, forKey: "isfamily")
        }
    }
    
    //MARK: Collection View Delegate and Data Source method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureVM?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCellIdentifier", for: indexPath as IndexPath) as! PictureCollectionViewCell
        
        cell.pictureM = pictureVM![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return indexPath.item == 0 ? CGSize(width: 0, height: 0) : CGSize(width: collectionView.bounds.size.width/2.1, height: collectionView.bounds.size.width/2.1)
    }
    
    //MARK: Call ImageSearch API
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text?.count == 0 {
            return
        }
        let fullSearchUrlStr = API.imageSearchURl + "&tags=\(searchBar.text!)"
        if !Reachability.isConnectedToNetwork(){
           showAlertView(alert: "Alert!", message: "Internet not available")
        }
        else{
           callServiceToGetData(urlStr:fullSearchUrlStr)
        }
    }
}

