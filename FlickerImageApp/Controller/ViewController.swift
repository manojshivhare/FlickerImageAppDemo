//
//  ViewController.swift
//  FlickerImageApp
//
//  Created by Manoj Shivhare on 14/05/20.
//  Copyright © 2020 Manoj Shivhare. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var picturesSearchBar: UISearchBar!
    
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    var pictureVM = [PhotoViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(animated)
        ApiManager.shared.getUserData { (photoModel) in
            print("%@",photoModel as Any)
            self.pictureVM = (photoModel?.photos.photo.map({return PhotoViewModel(Photo: $0)}))!
            //self.pictureVM = photoArr.map({return PhotoViewModel(Photo: $0)})
//            for photo in photoArr! {
//                self.pictureVM.append(photo)
                print(self.pictureVM)
//            }
            DispatchQueue.main.async {
                self.pictureCollectionView.delegate = self
                self.pictureCollectionView.dataSource = self
                self.pictureCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureVM.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCellIdentifier", for: indexPath as IndexPath) as! PictureCollectionViewCell
        
        cell.pictureVM = pictureVM[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return indexPath.item == 0 ? CGSize(width: 0, height: 0) : CGSize(width: collectionView.bounds.size.width/2.1, height: collectionView.bounds.size.width/2.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

