//
//  XTPageMenuView.swift
//  PageMenu
//
//  Created by Tong on 2018/4/25.
//  Copyright © 2018年 Feng. All rights reserved.
//

import UIKit
import Foundation

fileprivate let XTMenuTabTag = 1000

protocol XTPageMenuViewDelegate: NSObjectProtocol {
    
    /// 点击菜单
    ///
    /// - Parameter index: 点击菜单的下标
    func clickMenu(at index: NSInteger)
}


class XTPageMenuView: UIView {
    
    weak var menuDelegate: XTPageMenuViewDelegate?
    
    /// 配置参数Model
    var configureModel: XTPageMenuModel! {
        
        didSet {
            setConfigureModel()
        }
    }
    
    /// 当前选中下标
    var selectIndex: Int = 0 {
        
        didSet {
            setCurrentSelectIndex()
        }
    }
    
    /// 标题数组
    private var titles = [String]()
    
    /// 当前选中 control
    private var selectControl: UIControl?
    
    /// 上一个选中 control
    private var lastControl: UIControl?
    
    /// 上一个选中的 label
    private var lastSelectLabel: UILabel?
    
    private var singleMenuWidth: CGFloat {
        
        get {
            
            if self.titles.count == 0 {
                return self.configureModel.singleTabMenuWidth
            }
            
            return self.configureModel.singleTabMenuWidth > 0 ? self.configureModel.singleTabMenuWidth : self.bounds.width / CGFloat(self.titles.count)
        }
    }
    
    /// 当前下标
    private lazy var markView: UIView = { [unowned self] in
        
        let view = UIView()
        view.isHidden = false
        self.addSubview(view)
        return view
    }()
    
    
    /// 分割线
    private lazy var separateLine: UIView = { [unowned self] in
        
        let line = UIView(frame: CGRect(x: 0, y: self.bounds.height - 0.5, width: self.bounds.width, height: 0.5))
        self.addSubview(line)
        return line
    }()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.separateLine.frame = CGRect(x: 0, y: self.bounds.height - 0.5, width: self.bounds.width, height: 0.5)
        
        if self.selectControl != nil {
            self.markView.center.x = self.selectControl!.center.x
        }
    }
}


// MARK: - 设置数据
extension XTPageMenuView {
    
    
    /// 设置配置信息
    fileprivate func setConfigureModel() {
        
        self.markView.backgroundColor = self.configureModel.markLineColor
        self.separateLine.backgroundColor = self.configureModel.separateLineColor
        self.separateLine.isHidden = self.configureModel.hideSeparateLine
        
        titles.removeAll()
        titles += configureModel.menuTitles
        self.createMenuView()
    }
    
    /// 设置当前选中下标
    fileprivate func setCurrentSelectIndex() {
        
        self.selectControl = self.getCurrentSelectControl(at: self.selectIndex)
        
        guard self.selectControl != nil else {
            return
        }
        
        guard self.lastControl != self.selectControl else {
            return
        }
        
        let label = self.getCurrentControlLabel(control: self.selectControl!, at: self.selectIndex)
        
        guard label != nil else {
            return
        }
        
        self.lastControl = self.selectControl
        
        if label != self.lastSelectLabel {
            label?.textColor = self.configureModel.titleSelectColor
        }
        
        self.lastSelectLabel?.textColor = self.configureModel.titleNormalColor
        self.lastSelectLabel = nil
        self.lastSelectLabel = label
        
        var titleWidth: CGFloat = self.getLabel(label!, textWidth: label!.text!)
        
        titleWidth = titleWidth > self.singleMenuWidth ? self.singleMenuWidth : titleWidth
        
        if self.markView.frame.equalTo(CGRect.zero) {
            
            self.markView.frame = CGRect(x: 0, y: self.bounds.height - self.configureModel.markLineHeight - self.configureModel.markLineSpaceBottom, width: titleWidth, height: self.configureModel.markLineHeight)
        } else {
            
            self.markView.frame.size.width = titleWidth
        }
        
        UIView.animate(withDuration: 0.1) {
            self.markView.center.x = self.selectControl!.center.x
        }
    }
}


// MARK: - 创建视图
extension XTPageMenuView {
    
    
    /// 创建菜单
    fileprivate func createMenuView() {
        
        if titles.isEmpty {
            return
        }
        
        self.markView.isHidden = false;
        
        let titleCount = CGFloat(titles.count)
        
        let viewWidth = self.bounds.width
        
        let viewHeight = self.bounds.height
        
        let menuWidth = configureModel.singleTabMenuWidth > 0 ? configureModel.singleTabMenuWidth: (viewWidth / titleCount)
        
        let spaceX = (viewWidth - menuWidth * titleCount) / 2.0
        
        for index in 0 ..< titles.count {
            
            // 创建点击 UIControl
            let control = UIControl(frame: CGRect(x: spaceX + menuWidth * CGFloat(index), y: 0, width: menuWidth, height: viewHeight))
            control.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(.flexibleLeftMargin)
            control.tag = XTMenuTabTag + index
            control.addTarget(self, action: #selector(clickMenuContol(_:)), for: .touchUpInside)
            control.backgroundColor = configureModel.backNormalColor
            self.addSubview(control)
            
            // 创建显示文本
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: menuWidth, height: viewHeight))
            label.autoresizingMask = UIViewAutoresizing.flexibleLeftMargin.union([.flexibleWidth, .flexibleTopMargin, .flexibleHeight])
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: configureModel.titleNormalFontSize)
            label.textColor = self.configureModel.titleNormalColor
            label.text = titles[index]
            label.tag = XTMenuTabTag + 100 + index
            label.numberOfLines = 0
            control.addSubview(label)
        }
        
        self.selectIndex = 0
    }
}


// MARK: - 点击事件
extension XTPageMenuView {
    
    /// 点击标题
    @objc func clickMenuContol(_ control: UIControl) {
        
        if control.tag == self.selectIndex + XTMenuTabTag {
            return
        }
        
        self.selectIndex = control.tag - XTMenuTabTag
        
        if self.menuDelegate != nil {
            self.menuDelegate!.clickMenu(at: self.selectIndex)
        }
    }
    
}

// MARK: - Private Method
extension XTPageMenuView {
    
    /// 获取当前选中 control
    fileprivate func getCurrentSelectControl(at index: NSInteger) -> UIControl? {
        
        let contorl = self.viewWithTag(XTMenuTabTag + index)
        return contorl as? UIControl
    }
    
    /// 获取当前选中的 label
    fileprivate func getCurrentControlLabel(control: UIControl, at index:NSInteger) -> UILabel? {
        
        let label = control.viewWithTag(XTMenuTabTag + 100 + index)
        return label as? UILabel
    }
    
    /// 获取 label 的文本宽度
    fileprivate func getLabel(_ label: UILabel, textWidth text: String) -> CGFloat {
        
        let rect = NSString(string: text).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.bounds.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : label.font], context: nil)
        
        return rect.width
    }
    
}














