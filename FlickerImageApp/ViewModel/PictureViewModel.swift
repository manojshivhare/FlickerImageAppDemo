//
//  PictureViewModel.swift
//  FlickerImageApp
//
//  Created by Manoj Shivhare on 14/05/20.
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

    init(id:String,owner:String,secret:String,server:String,farm:Int,title:String,isPublic:Int,isFriend:Int,isFamily:Int) {
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.ispublic = isPublic
        self.isfriend = isFriend
        self.isfamily = isFamily
    }
}

