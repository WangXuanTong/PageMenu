//
//  ViewController.swift
//  PageMenu
//
//  Created by Tong on 2018/4/25.
//  Copyright © 2018年 Feng. All rights reserved.
//

import UIKit

class ViewController: XTPageMenuViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 是否打开导航栏
//        self.isNavigationMenu = true
        
        // 配置菜单信息
        let menuModel = XTPageMenuModel()
        menuModel.menuTitles = ["第一页", "第二页", "第三页"]
//        menuModel.pageMenuFrame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: 40)
        
        self.setPageMenu(configureModel: menuModel)
        
        let firstVC = XTFirstViewController()
        let secondVC = XTSecondViewController()
        let thirdVC = XTThirdViewController()
        
        self.setMenuView(subControllers: [firstVC, secondVC, thirdVC])
        
        self.currentSelectIndex = 1
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

