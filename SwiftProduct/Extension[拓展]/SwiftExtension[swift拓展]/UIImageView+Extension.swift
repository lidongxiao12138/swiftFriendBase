//
//  UIImageView+Extension.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/16.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func setImage(url: String) -> Void {
        self.kf.setImage(with: URL(string: url))
    }
    
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}


