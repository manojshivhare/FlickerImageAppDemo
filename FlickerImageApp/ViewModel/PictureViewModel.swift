//
//  PictureViewModel.swift
//  FlickerImageApp
//
//  Created by Manoj Shivhare on 01/01/20.
//  Copyright © 2020 Manoj Shivhare. All rights reserved.
//

import Foundation

struct PhotoViewModel {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    let is_primary: Int
    let has_comment: Int
    
    init(Photo: PhotoModel) {
        self.id = Photo.id
        self.owner = Photo.owner
        self.secret = Photo.secret
        self.server = Photo.server
        self.farm = Photo.farm
        self.title = Photo.title
        self.ispublic = Photo.ispublic
        self.isfriend = Photo.isfriend
        self.isfamily = Photo.isfamily
        self.is_primary = Photo.is_primary
        self.has_comment = Photo.has_comment
    }
}

struct SubPictureViewModel {
    var page: Int
    var pages : Int
    var perpage : Int
    var total : Int
    var photo : [PhotoModel]
    
    init(subPic:Pictures) {
        self.page = subPic.page
        self.pages = subPic.pages
        self.perpage = subPic.perpage
        self.total = subPic.total
        self.photo = subPic.photo
    }
}

struct PictureViewModel {
    var photos: Pictures
    let stat: String
 
    init(picture: PictureModel) {
        self.photos = picture.photos
        self.stat = picture.stat
    }
}
