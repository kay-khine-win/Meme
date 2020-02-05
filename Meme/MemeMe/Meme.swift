//
//  Meme.swift
//  MemeMe
//
//  Created by Kay Khine win on 4/2/20.
//  Copyright © 2020 Kay Khine win. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let top: String
    let bottom: String
    let image: UIImage
    let memedImage: UIImage
    init(topText: String!, bottomText: String!, image: UIImage!, memedImage: UIImage!) {
        self.top = topText
        self.bottom = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}
