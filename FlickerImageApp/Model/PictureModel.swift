//
//  PictureModel.swift
//  FlickerImageApp
//
//  Created by Manoj Shivhare on 14/05/20.
//  Copyright © 2020 Manoj Shivhare. All rights reserved.
//

import Foundation

struct PictureModel:Codable {
    var photos : Pictures?
    var stat : String?
}

struct Pictures :Codable {
    var photo : [PhotoModel]
}

struct PhotoModel : Codable {
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?
}
