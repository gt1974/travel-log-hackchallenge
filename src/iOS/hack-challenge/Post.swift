//
//  Post.swift
//  hack-challenge
//
//  Created by ravina patel on 5/1/22.
//

import Foundation

class Post {
    
    var id: UUID?
    var title: String?
    var body: String?
    var poster: String?
    var timeStamp: Date?
    var rating: Int?
    
    
    init(id: UUID, title: String?, body: String?, poster: String?, timeStamp: Date?, rating: Int?) {
        self.id = id
        self.title = title
        self.body = body
        self.poster = poster
        self.timeStamp = timeStamp
        self.rating = rating
    }
}

import Foundation
