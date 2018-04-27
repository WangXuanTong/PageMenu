//
//  XTPageMenuModel.swift
//  PageMenu
//
//  Created by Tong on 2018/4/25.
//  Copyright © 2018年 Feng. All rights reserved.
//

import UIKit

class XTPageMenuModel: NSObject {
    
    /// menu 的大小(默认)
    var pageMenuFrame: CGRect = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 44, width: UIScreen.main.bounds.width, height: 40)
    
    /// menu 标题
    var menuTitles = [String]()
    
    /// 标题的正常颜色
    var titleNormalColor: UIColor = UIColor.black
    
    /// 标题选中颜色
    var titleSelectColor: UIColor = UIColor.red
    
    /// 背景颜色
    var backNormalColor: UIColor = UIColor.clear
    
    /// 背景选中颜色
    var backSelectColor: UIColor = UIColor.clear
    
    /// 标记线颜色
    var markLineColor: UIColor = UIColor.red
    
    /// 分割线颜色
    var separateLineColor: UIColor = UIColor.lightGray
    
    /// 标题正常字体大小
    var titleNormalFontSize: CGFloat = 15.0
    
    /// 单个菜单选项的宽度
    var singleTabMenuWidth: CGFloat = 0.0
    
    /// 标记线的高度
    var markLineHeight: CGFloat = 2.0
    
    /// 当前选中标识到底部的距离
    var markLineSpaceBottom: CGFloat = 0.0
    
    /// 是否隐藏分割线
    var hideSeparateLine = false
    
}









