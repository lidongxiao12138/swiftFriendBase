//
//  String+Kingfisher.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/20.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func userAgentString() -> String {
        var userAgent = ""
        userAgent = "\(String(describing: Bundle.main.infoDictionary?[(kCFBundleExecutableKey as String?)!] ?? Bundle.main.infoDictionary?[(kCFBundleIdentifierKey as String?)!]))/\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? Bundle.main.infoDictionary?[(kCFBundleVersionKey as String?)!] ?? "") (\(UIDevice.current.model); iOS \(UIDevice.current.systemVersion); Scale/%0.2f)"
        if userAgent != "" {
            if !userAgent.canBeConverted(to: .ascii) {
                let mutableUserAgent: String = userAgent
                if(CFStringTransform(mutableUserAgent as! CFMutableString, nil, ("Any-Latin; Latin-ASCII; [:^ASCII:] Remove" as CFString), false)) {
                    userAgent = mutableUserAgent
                }
            }
            return userAgent
        }
        else {
            return ""
        }
    }
}
