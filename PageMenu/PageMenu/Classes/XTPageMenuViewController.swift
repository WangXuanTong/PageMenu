//
//  XTPageMenuViewController.swift
//  PageMenu
//
//  Created by Tong on 2018/4/26.
//  Copyright © 2018年 Feng. All rights reserved.
//

import UIKit


// MARK: - - - - - - - - - - - - - - - - - General Configuration - - - - - - - - - - - - - - - - -
class XTPageMenuViewController: UIViewController, XTPageMenuViewDelegate, UIScrollViewDelegate {

    
    /// 是否是导航栏菜单
    var isNavigationMenu = false
    
    /// 当前选中下标
    var currentSelectIndex: NSInteger = 0 {
        
        didSet {
            setCurrentSelectIndex()
        }
    }
    
    /// 菜单配置信息
    private var confingureModel: XTPageMenuModel!
    
    /// 菜单视图
    private lazy var menuView: XTPageMenuView = { [unowned self] in
        
        let aMenuView = XTPageMenuView.init(frame: self.confingureModel.pageMenuFrame)
        aMenuView.menuDelegate = self
        
        if self.isNavigationMenu {
            self.navigationItem.titleView = aMenuView
        } else {
            self.view.addSubview(aMenuView)
        }
        
        return aMenuView
    }()
    
    /// 滚动视图
    private lazy var scrollView: UIScrollView = { [unowned self] in
        
        let top = self.isNavigationMenu ? (UIApplication.shared.statusBarFrame.height + 44) : (self.confingureModel.pageMenuFrame.height + self.confingureModel.pageMenuFrame.minY)
        
        var scrollViewFrame = CGRect(x: 0, y: top, width: self.view.bounds.width, height: self.view.bounds.height - self.confingureModel.pageMenuFrame.size.height - self.confingureModel.pageMenuFrame.origin.y)

        if self.isNavigationMenu {
            scrollViewFrame = CGRect(x: 0, y: top, width: self.view.bounds.width, height: self.view.bounds.height - top)
        }
        
        
        let aScrollView = UIScrollView.init(frame: scrollViewFrame)
        aScrollView.delegate = self
        aScrollView.isPagingEnabled = true
        aScrollView.showsVerticalScrollIndicator = false
        aScrollView.showsHorizontalScrollIndicator = false
        aScrollView.scrollsToTop = false
        aScrollView.clipsToBounds = true
        aScrollView.bounces = false
        aScrollView.backgroundColor = UIColor.orange
        self.view.addSubview(aScrollView)
        
        if self.navigationController != nil {
            aScrollView.panGestureRecognizer.require(toFail: (self.navigationController!.interactivePopGestureRecognizer!))
        }
        
        return aScrollView
    }()
    
    
    /// 子控制器数量
    private var viewCount = 0
    
    /// 子控制器数组
    private var subControllers: Array? = [UIViewController]()
    
    /// 当前选中的菜单下标，需要复写
    func currentSelectControllerIndex(index: NSInteger) {
        
    }
    
    // MARK: - Init And Dealloc
    deinit {
        
        // 移除子控制器
        if self.subControllers != nil {
            
            for subController in self.subControllers! {
                
                subController.willMove(toParentViewController: nil)
                subController.removeFromParentViewController()
            }
        }
        
        self.subControllers = nil
    }
}


// MARK: - - - - - - - - - - - - - - - - - Life Cycle - - - - - - - - - - - - - - - - -
extension XTPageMenuViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            
        } else {
            self.extendedLayoutIncludesOpaqueBars = false
            self.automaticallyAdjustsScrollViewInsets = false;
        }
        
        self.view.backgroundColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - - - - - - - - - - - - - - - - - Delegate Response - - - - - - - - - - - - - - - - -

// MARK: - XTPageMenuViewDelegate
extension XTPageMenuViewController {
    
    /// 点击选择菜单
    func clickMenu(at index: NSInteger) {
        self.scrollSubControl(to: index)
    }
    
}

// MARK: - UIScrollViewDelegate
extension XTPageMenuViewController {
    
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
        let pageWidth = scrollView.bounds.width
        let index = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        
        if self.currentSelectIndex == Int(index) {
            return
        }
        
        self.currentSelectIndex = Int(index)
    }

    
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
}


// MARK: - - - - - - - - - - - - - - - - - Public Events - - - - - - - - - - - - - - - - -
extension XTPageMenuViewController {

    /// 配置 menu 的参数（必须先设置 configureModel 之后才可以调用 setMenuView(_:) 方法）
    func setPageMenu(configureModel: XTPageMenuModel) {
        
        self.confingureModel = configureModel
        
        self.menuView.configureModel = configureModel
        
        self.view.addSubview(self.scrollView)
    }
    
    /// 设置子控制器
    func setMenuView(subControllers: [UIViewController]) {
        
        if subControllers.count == 0 || subControllers.count != self.confingureModel.menuTitles.count {
            return
        }
        
        self.viewCount = subControllers.count
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.width * CGFloat(self.viewCount), height: 0)

        self.subControllers?.removeAll()
        self.subControllers = subControllers
        
        for controller in subControllers {
            
            self.addChildViewController(controller)
            controller.didMove(toParentViewController: self)
        }
        
        // 预加载视图（少于4个）
        for index in 0 ..< subControllers.count {

            if index > 3 {
                return
            }
            
            let controller = subControllers[index]
           
            if controller.view.superview == nil {
                
                controller.view.frame = CGRect(x: CGFloat(index) * self.scrollView.bounds.width, y: self.scrollView.bounds.minY, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
                self.scrollView.addSubview(controller.view)
            }
        }
    }
}


// MARK: - - - - - - - - - - - - - - - - - Setter Methods - - - - - - - - - - - - - - - - -
extension XTPageMenuViewController {
    
    /// 设置当前选中下标
    private func setCurrentSelectIndex() {
        
        if self.currentSelectIndex >= self.viewCount {
            return
        }
        
        // 加载大于4个的视图
        let controller = self.subControllers![self.currentSelectIndex]
        
        if controller.view.superview == nil {
            
            controller.view.frame = CGRect(x: CGFloat(self.currentSelectIndex) * self.scrollView.bounds.width, y: self.scrollView.bounds.minY, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
            self.scrollView.addSubview(controller.view)
        }
        
        if CGFloat(self.currentSelectIndex) * self.scrollView.bounds.width <= self.scrollView.contentSize.width {
            self.scrollView.contentOffset = CGPoint(x: CGFloat(self.currentSelectIndex) * self.scrollView.bounds.width, y: 0)
        }
        
        self.menuView.selectIndex = self.currentSelectIndex
        
        self.currentSelectControllerIndex(index: self.currentSelectIndex)
    }
}


// MARK: - - - - - - - - - - - - - - - - - Private Methods - - - - - - - - - - - - - - - - -
extension XTPageMenuViewController {
    
    /// 滚动到指定下标
    ///
    /// - Parameter index: 下标
    private func scrollSubControl(to index: NSInteger) {
        
        self.currentSelectIndex = index
        self.scrollView.contentOffset = CGPoint(x: CGFloat(index) * self.scrollView.bounds.width, y: 0)
    }
    
}
















