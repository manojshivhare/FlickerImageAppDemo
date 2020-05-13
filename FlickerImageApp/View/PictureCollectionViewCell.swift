//
//  PictureCollectionViewCell.swift
//  FlickerImageApp
//
//  Created by Manoj Shivhare on 01/01/20.
//  Copyright © 2020 Manoj Shivhare. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var cellNameLabel: UILabel!
    
    
    //Set up value into outlet
    var pictureVM: PhotoViewModel! {
        didSet {
            let imageURLStr = String(format: "https://farm9.staticflickr.com/%@/%@_%@.jpg",self.pictureVM.server,self.pictureVM.id,self.pictureVM.secret)
            
            //download image from url
            NetworkManager.shared.downloadImageFile(urlString: imageURLStr, view: self, success: { (Image) in
                DispatchQueue.main.async {
                    self.cellImageView.image = Image
                }
            }) { (Error) in print(Error.localizedDescription)}
            
            //set contact name
            self.cellNameLabel.text = "\(self.pictureVM.title)"
        }
    }
}
