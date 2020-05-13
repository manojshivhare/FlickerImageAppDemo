//
//  ViewController.swift
//  FlickerImageApp
//
//  Created by Manoj Shivhare on 01/01/20.
//  Copyright © 2020 Manoj Shivhare. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
{
    @IBOutlet weak var picturesSearchBar: UISearchBar!
    
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    var pictureVM: [PhotoViewModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(animated)
        ApiManager.shared.getUserData { (userDic) in
//            print("%@",userDic as Any)
            self.pictureVM? = userDic?.photos.photo
                //userDic?.photos.photo.map({return PhotoViewModel(Photo: $0)}) ?? []
            print(self.pictureVM)
            DispatchQueue.main.async {
                self.pictureCollectionView.delegate = self
                self.pictureCollectionView.dataSource = self
                self.pictureCollectionView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureVM?.photos.photo.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCellIdentifier", for: indexPath as IndexPath) as! PictureCollectionViewCell
        
        //cell.pictureVM = pictureVM?.photos.photo[indexPath.row]
        return cell
    }

}

