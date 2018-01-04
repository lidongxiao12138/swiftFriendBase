//
//  Parameters.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/14.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import Foundation
import SnapKit
import Kingfisher



///当前网络状态 
var NetWordStatus=false

/// baseURL
#if DEBUG
let HttpsUrl="http://api.suxiu365.com/";
let HttpsUrlImage="http://images.suxiu365.com/";
#else
let HttpsUrl="http://api.suxiu365.com/";
let HttpsUrlImage="http://images.suxiu365.com/";
#endif

let TabBar_Title = ["test"]      //标题
let TabBar_StoryName = ["HomeTestViewController"]  //sb名称（UI)
let TabBar_SelectedImage = ["home_select"]        //选择的图片
let TabBar_NoSelectedImage = ["home_normal"]      //未选择图片
