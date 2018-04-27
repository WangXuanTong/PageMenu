# PageMenu
一个使用 `Swift` 自定义的分页控件。可以把分页控件放在页面上或导航栏上。

### 使用要求

* iOS8.0以上
* Swift语言

### 如何使用

直接下载`Classes`文件下的三个文件，拖到项目里，继承`XTPageMenuViewController`就可以了。
通过配置`XTPageMenuModel`可以配置菜单的相关信息。

相关的参数设置，代码里都有注释

### 参考设置

```
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
    
    /// 获取当前选中的下标
    override func currentSelectControllerIndex(index: NSInteger) {
        
        super.currentSelectControllerIndex(index: index)
        
        print("选中了第\(index + 1)页")
        
    }
}
```
