//
//  PageModel.swift
//  Pinch
//
//  Created by Supapon Pucknavin on 24/9/2565 BE.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
