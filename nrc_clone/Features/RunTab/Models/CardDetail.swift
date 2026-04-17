//
//  CardDetail.swift
//  nrc_clone
//
//  Created by Kenneth Sieu on 3/31/26.
//

import Foundation

struct CardDetail: Identifiable {
    let id = UUID()
    var img: String
    var title: String
    var description: String?
    var category: String?
    var length: Int?
    var type: String?
}

