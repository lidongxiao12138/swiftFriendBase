//
//  UIColor+Extension.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/12/8.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation

extension UIColor {
    //MARK: 系统色
    public var systemDefaultColor: String {
        return "#FDC038"
    }
    //MARK: RGB
    static func RGB(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: (a))}
    static func RGB(_ r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: (1))}
    //MARK: 转换 uiimage
    static func imageWithColor(_ color: UIColor) -> UIImage {
        // 描述矩形
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size)
        // 获取位图上下文
        let context: CGContext = UIGraphicsGetCurrentContext()!
        // 使用color演示填充上下文
        context.setFillColor(color.cgColor)
        // 渲染上下文
        context.fill(rect)
        // 从上下文中获取图片
        let theImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        // 结束上下文
        UIGraphicsEndImageContext()
        return theImage
    }
    //MARK: 获取随机色
    static func randomColor() -> UIColor {
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    //MARK: 16进制转换
    static func transferStringToColor(_ colorStr:String) -> UIColor {
        
        var color = UIColor.red
        var cStr : String = colorStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cStr.hasPrefix("#") {
            let index = cStr.index(after: cStr.startIndex)
            cStr = cStr.substring(from: index)
        }
        if cStr.characters.count != 6 {
            return UIColor.black
        }
        let rRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2)
        let rStr = cStr.substring(with: rRange)
        
        let gRange = cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4)
        let gStr = cStr.substring(with: gRange)
        
        let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)
        let bStr = cStr.substring(from: bIndex)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        
        color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
        
        return color
    }
}
