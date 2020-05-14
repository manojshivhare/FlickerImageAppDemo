//
//  PictureCollectionViewCell.swift
//  FlickerImageApp
//
//  Created by Manoj Shivhare on 14/05/20.
//  Copyright © 2020 Manoj Shivhare. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var cellNameLabel: UILabel!
    
    
    //Set up value into outlet
    var pictureM: PhotoViewModel! {
        didSet {
            let imageURLStr = String(format: "https://farm9.staticflickr.com/%@/%@_%@.jpg",self.pictureM.server,self.pictureM.id,self.pictureM.secret)
            
            //download image from url
            self.getDataFromImageURL(from: URL(string:imageURLStr)!) { (image) in
                self.cellImageView.image = image
            }
            
            //set contact name
            self.cellNameLabel.text = self.pictureM.title
        }
    }
    
    //MARK: Download image from URL
    func getDataFromImageURL(from url: URL, completionBlock: @escaping (UIImage) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else    {
                    return
            }
            DispatchQueue.main.async() { () -> Void in
                completionBlock(image)
            }
        }.resume()
    }
}
