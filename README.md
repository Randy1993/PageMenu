
## Introduction
LZPageMenu is a powerful controller section, not only supports multiple styles of sub-menu, support for carrying the head view, support for Obejective-C and Swift, and supports CocoaPods.Not only to achieve the function, but also from memory and performance optimization, such as how to ensure that the current layer only one sub-controller display, and how to complete the menu sub-view of the reuse. Therefore LZPageMenu implementation and the mainstream of the realization of probably there are differences, but there may be more problems, the project is in its infancy, look forward to your advice!

## The basic effect
![The basic effect.gif](http://upload-images.jianshu.io/upload_images/2077842-aefa600eef091ba4.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## Supported styles

#### Dot：
![Dot.PNG](http://upload-images.jianshu.io/upload_images/2077842-794cd2a05a507e0c.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### Image：
![Image.PNG](http://upload-images.jianshu.io/upload_images/2077842-5a0b59d0e2641caf.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### Square：
![Square.PNG](http://upload-images.jianshu.io/upload_images/2077842-bec5ef723289f00b.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### SolidOval：
![SolidOval.PNG](http://upload-images.jianshu.io/upload_images/2077842-6cdb5a62797d5e70.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### HollowOval：
![HollowOval.PNG](http://upload-images.jianshu.io/upload_images/2077842-77a147ed91626514.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### Custom Location：
![Custom.PNG](http://upload-images.jianshu.io/upload_images/2077842-45b530e0fd348595.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### NavigationBar：
![NavigationBar.PNG](http://upload-images.jianshu.io/upload_images/2077842-05aade4795bff179.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### NSAttributeString：
![NSAttributeString.PNG](http://upload-images.jianshu.io/upload_images/2077842-b005027044431cc9.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### Average Width：

![Average.PNG](http://upload-images.jianshu.io/upload_images/2077842-5094566d0fad4943.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### Custom Width：
![Custom.PNG](http://upload-images.jianshu.io/upload_images/2077842-6aaa6d06005e9fa2.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### UpdateTitles：
![UpdateTitles.gif](http://upload-images.jianshu.io/upload_images/2077842-7ec4fe9bf6bf6914.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### Custom Menu：
![Custom.gif](http://upload-images.jianshu.io/upload_images/2077842-72a923543a81501d.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### StretchHead：
![StretchHead.gif](http://upload-images.jianshu.io/upload_images/2077842-01b163fd95f8a71f.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### OffsetHead：
![OffsetHead.gif](http://upload-images.jianshu.io/upload_images/2077842-d986bf6936cca891.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### One more tables：
![Table.PNG](http://upload-images.jianshu.io/upload_images/2077842-e24f118d57f419a9.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## Usage
Add LZPageMenu and LZPageMenuProtocols two files to the project，LZPageMenuProtocols.swift specifies the properties and methods that can be used，LZPageMenu.swift is the control's implementation code.For more details, please refer to the sample project.You can refer to the following ways to use：
```
 pageMenu = LZPageMenu.init(frame: CGRect.init(x: 0.0, y: 0.0, width: Demo.screenWidth, height: Demo.screenHeight - Demo.naviBarHeight()))
        for index in 1...10 {
            let vc = InfoViewController()
            vc.infoLabel.text = "Number:\(index)"
            vc.title = "Number:\(index)"
            pageMenu.viewControllers.append(vc)
        }
        pageMenu.selectionIndicatorType = .dot
        pageMenu.selectionIndicatorHeight = 5.0
        pageMenu.reloadData()
        view.addSubview(pageMenu.view)
```
All available properties, methods are provided in the LZPageMenuProtocols.swift file：

For example, set the indicator line：
```
/// Whether to display the indicator line, default is true
    var needShowSelectionIndicator: Bool {get set}
    /// The height of the indicator line, default is 2
    var selectionIndicatorHeight: Float  {get set}
    /// Indicator line offset, that is the distance retracted of up and down , the value will affect the width and height of the indicator line. Dot and Image types default center, line, ellipse, etc. have same height with menu. default is (0,0,0,0)
    var selectionIndicatorOffset: UIEdgeInsets {get set}
    /// The color of the indicator line, default is red
    var selectionIndicatorColor: UIColor {get set}
    /// The type of the indicator line, default is line
    var selectionIndicatorType: LZSelectionIndicatorType {get set}
    /// This value is useful when the indicator line is of type SelectionIndicatorTypeImage, default is nil
    var selectionIndicatorImage: UIImage? {get set}
    /// When the indicator line is SelectionIndicatorTypeImage type, used to control the width of the picture, if you do not set the value, the default is in the center, and take the original width of the picture.
    var selectionIndicatorImageWidth: Float?  {get set}
    /// Whether to make the indicator line equal to the width of the text, default is YES
    var selectionIndicatorWithEqualToTextWidth: Bool {get set}
```

## Welcome to raise issues, fork
