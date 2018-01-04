//
//  SystemTool.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/12/11.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation

public final class SystemTool {

    static var  instance : SystemTool {
        
        struct shared {
            static let instance : SystemTool = SystemTool()
        }
        return shared.instance
    }
    
    static let systemColor = UIColor.transferStringToColor("#FDC038")
    static let systemHexString = "#FDC038"
    
}
