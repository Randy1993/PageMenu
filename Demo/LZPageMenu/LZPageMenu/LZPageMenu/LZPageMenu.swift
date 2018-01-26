//
//  LZPageMenu.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/19.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

fileprivate enum LZPageMenuItemType {
   case  viewControllerTitle
   case  customView
   case  averageWidth
   case  customWidth
   case  attribute
}

fileprivate protocol LZPageMenuPrivateProtocol {
    var itemUnselectedWidths: [Float] {get}
    var itemSelectedWidths: [Float] {get}
    var itemUnselectedTextWidths: [Float]? {get}
    var itemSelectedTextWidths: [Float]? {get}
    var menuItemType: LZPageMenuItemType {get}
    var lastSelectedIndex: Int {get set}
    var startScrollIndex: Int {get}
    var showIndicatorInLowestLayer: Bool {get}
    var hadTapMenu: Bool { get set}
    
    func caclulateItemWidth()
    func selectedWidth(index: Int) -> CGFloat
    func unselectedWidth(index: Int) -> CGFloat
    func getSpecialFrame(cellFrame: CGRect, index: Int) -> CGRect
    func setIndicatorHierarchy()
    func tapMenu(itemFrame: CGRect, index: Int)
}

fileprivate class LZPageMenuDynamicItem: NSObject, UIDynamicItem {
    var center: CGPoint
    var bounds: CGRect
    var transform: CGAffineTransform
    
    override init() {
        transform = CGAffineTransform()
        center = CGPoint.zero
        bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
        super.init()
    }
}

fileprivate class LZPageMenuMenuView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    // MARK:LZPageMenuMenuViewCell
    class LZPageMenuMenuViewCell: UICollectionViewCell {
        var titleLabel: UILabel!
        var customView: UIView!
        var verticalSeparator: CALayer!
        weak var configuration: (LZPageMenuPublicProtocol & LZPageMenuPrivateProtocol)! {
            didSet {
                if customView != nil || titleLabel != nil { return }
                
                if configuration.menuItemType == .customView {
                    customView = configuration.customDelegate?.menuItemView()
                    contentView.addSubview(customView)
                } else {
                    titleLabel = UILabel()
                    titleLabel.backgroundColor = UIColor.clear
                    titleLabel.textAlignment = .center
                    contentView.addSubview(titleLabel)
                }
                
                if let _ = configuration.verticalSeparatorWidth {
                    verticalSeparator = CALayer()
                    verticalSeparator.backgroundColor = configuration.verticalSeparatorColor!.cgColor
                    contentView.layer.addSublayer(verticalSeparator)
                }
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            if titleLabel != nil { titleLabel?.frame = contentView.bounds }
            if customView != nil { customView?.frame = contentView.bounds }
            if verticalSeparator != nil { verticalSeparator!.frame = CGRect.init(x: contentView.frame.width - CGFloat(configuration.verticalSeparatorWidth!), y: (contentView.frame.height - CGFloat(configuration.verticalSeparatorHeight!))/2.0, width: CGFloat(configuration.verticalSeparatorWidth!), height: CGFloat(configuration.verticalSeparatorHeight!))}
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            contentView.backgroundColor = UIColor.clear
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
  
    
    // MARK:UICollectionView
    weak var configuration: (LZPageMenuPublicProtocol & LZPageMenuPrivateProtocol)! {
        didSet {
            contentInset = configuration.menuContentInset
            bounces = configuration.enableMenuHorizontalBounce
            isScrollEnabled = configuration.enableMenuScroll
        }
    }
    
    init() {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
       
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        scrollsToTop = false
        dataSource = self
        delegate = self
        backgroundColor = UIColor.clear
        register(LZPageMenuMenuViewCell.self, forCellWithReuseIdentifier:"LZPageMenuMenuViewCellIdentifire")
    }
    
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if configuration.defaultSelectedIndex >= 0 {
            configuration.hadTapMenu = true
            refreshCell(selectedIndex: configuration.defaultSelectedIndex)
            handTap(indexPath: IndexPath.init(item: configuration.defaultSelectedIndex, section: 0))
            configuration.defaultSelectedIndex = -1
        }
        
        if configuration.needShowSelectionIndicator && configuration.showIndicatorInLowestLayer {
            configuration.setIndicatorHierarchy()
        }
    }
    
    // MARK:PrivateMethods
    @objc func handTap(indexPath: IndexPath)  {
        if let attribute = collectionViewLayout.layoutAttributesForItem(at: indexPath) {
            var frame = attribute.frame
            frame = configuration.getSpecialFrame(cellFrame: frame, index: indexPath.item)
            configuration.tapMenu(itemFrame: frame, index: indexPath.item)
        } else {
            perform(#selector(handTap(indexPath:)), with: nil, afterDelay: 0.1)
        }
    }
    
    // MARK:PublicMethods
    func refreshCell(selectedIndex: NSInteger) {
        if selectedIndex >= configuration.viewControllers.count || selectedIndex < 0 || selectedIndex == configuration.lastSelectedIndex { return }
        
        var indexPaths = [IndexPath]()
        indexPaths.append(IndexPath.init(item: selectedIndex, section: 0))
        if (configuration.lastSelectedIndex >= 0) { indexPaths.append(IndexPath.init(item: configuration.lastSelectedIndex, section: 0))}
        configuration.lastSelectedIndex = selectedIndex
        reloadItems(at: indexPaths)
        
        scrollToItem(at: indexPaths[0], at: .centeredHorizontally, animated: true)
    }
    
    // MARK:CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configuration.viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let menuCell = self.dequeueReusableCell(withReuseIdentifier:"LZPageMenuMenuViewCellIdentifire", for: indexPath) as! LZPageMenuMenuViewCell
        menuCell.configuration = configuration
        
        if menuCell.verticalSeparator != nil {
            menuCell.verticalSeparator.isHidden = (indexPath.item == configuration.viewControllers.count - 1 && configuration.hideLastVerticalSeparator ?? true)
        }
        
        switch configuration.menuItemType {
        case .customView:
            configuration.customDelegate?.configView?(view: menuCell.customView, index: indexPath.item, selected: indexPath.item == configuration.lastSelectedIndex)
        case .attribute:
            menuCell.titleLabel.attributedText = configuration.lastSelectedIndex == indexPath.item ? configuration.menuItemSelectedTitles![indexPath.item] : configuration.menuItemUnselectedTitles![indexPath.item]
        case .viewControllerTitle, .averageWidth, .customWidth:
            menuCell.titleLabel.attributedText = nil
            menuCell.titleLabel.text = configuration.viewControllers[indexPath.item].title
            menuCell.titleLabel.textColor = (indexPath.item == configuration.lastSelectedIndex ? configuration.selectedMenuItemLabelColor : configuration.unselectedMenuItemLabelColor)
            menuCell.titleLabel.font = (indexPath.item == configuration.lastSelectedIndex ? configuration.selectedMenuItemLabelFont : configuration.unselectedMenuItemLabelFont)
        }
        
        return menuCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat(configuration.menuHeight) - configuration.menuInset.top - configuration.menuInset.bottom
        let width = configuration.lastSelectedIndex == indexPath.item ? configuration.selectedWidth(index: indexPath.item) : configuration.unselectedWidth(index: indexPath.item)
        
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if configuration.lastSelectedIndex == indexPath.item || configuration.hadTapMenu { return }
        
        configuration.hadTapMenu = true
        refreshCell(selectedIndex: indexPath.item)
        handTap(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(configuration.menuItemSpace)
    }
}

public class LZPageMenu: UIViewController, LZPageMenuPublicProtocol, LZPageMenuPrivateProtocol, UIScrollViewDelegate {
    public var customDelegate: LZPageMenuCustomProtocol?
    public var delegate: LZPageMenuProtocol?
    public var pageMenuBackgroundColor = UIColor.white
    public var viewControllers = [UIViewController]()
    public var menuItemUnselectedTitles: [NSAttributedString]?
    public var menuItemSelectedTitles: [NSAttributedString]?
    public var defaultSelectedIndex = 0
    public var needShowSelectionIndicator = true
    public var selectionIndicatorHeight: Float = 2
    public var selectionIndicatorOffset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
    public var selectionIndicatorColor = UIColor.red
    public var selectionIndicatorType: LZSelectionIndicatorType = .line
    public var selectionIndicatorImage: UIImage?
    public var selectionIndicatorImageWidth: Float?
    public var selectionIndicatorWithEqualToTextWidth = true
    public var menuBottomLineHeight: Float?
    public var menuBottomLineColor: UIColor?
    public var menuBackgroundColor = UIColor.orange
    public var menuHeight: Float = 44
    public var menuInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
    public var menuContentInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)
    public var enableMenuHorizontalBounce = true
    public var enableMenuScroll = true
    public var menuWidth: Float?
    public var averageMenuWitdh = false
    public var showMenuInNavigationBar = false
    public var selectedMenuItemLabelColor = UIColor.red
    public var unselectedMenuItemLabelColor = UIColor.white
    public var selectedMenuItemLabelFont = UIFont.boldSystemFont(ofSize: 18.0)
    public var unselectedMenuItemLabelFont = UIFont.systemFont(ofSize: 16.0)
    public var menuItemSpace: Float = 15.0
    public var menuItemSelectedWidths: [Float]?
    public var menuItemUnselectedWidths: [Float]?
    public var menuItemWidthBasedOnTitleTextWidth = true
    public var scrollAnimationDurationOnMenuItemTap: Float = 0.5
    public var verticalSeparatorWidth: Float?
    public var verticalSeparatorHeight: Float?
    public var verticalSeparatorColor: UIColor?
    public var hideLastVerticalSeparator: Bool?
    public var headView: UIView!
    public var headViewHeight: Float!
    public var stretchHeadView: Bool!
    public var headViewMaxmumOffsetRate: Float!
    public var headViewTopSafeDistance: Float!
    public var headViewBottomSafeDistance: Float!
    
    // MARK: PrivateProperties
    fileprivate var itemUnselectedWidths: [Float] = [Float]()
    fileprivate var itemSelectedWidths: [Float] = [Float]()
    fileprivate var itemUnselectedTextWidths: [Float]?
    fileprivate var itemSelectedTextWidths: [Float]?
    fileprivate var menuItemType: LZPageMenuItemType = .viewControllerTitle
    fileprivate var lastSelectedIndex: Int = -1
    fileprivate var startScrollIndex: Int = -1
    fileprivate var showIndicatorInLowestLayer: Bool = true
    fileprivate var hadTapMenu: Bool = false
    private var contollerScrollView: UIScrollView!
    private var menuScrollView: LZPageMenuMenuView!
    private var menuView: UIView!
    private var panGesture: UIPanGestureRecognizer!
    private var subScrollviews: [Int: Set<UIScrollView>]!
    private var itemIndicator: CALayer!
    private var bottomLine: CALayer?
    private var addedIndexs: Set<Int>!
    private var showInMemoryIndexs: Set<Int>!
    private var headView_Y: NSLayoutConstraint!
    private var headView_Left: NSLayoutConstraint!
    private var headView_Right: NSLayoutConstraint!
    private var headView_Height: NSLayoutConstraint!
    private var animator: UIDynamicAnimator!
    private var inertiaBehavior: UIDynamicItemBehavior!
    private var bounceBehavior: UIAttachmentBehavior!
    private var animatorItem: LZPageMenuDynamicItem!
    private var headViewMaximumOffsetDistance: CGFloat!
    private var panStartY: CGFloat!
    private var panEndY: CGFloat!
    private var panStartPoint: CGPoint!
    private var panScrollView: UIScrollView?
    private var canNotScrollMenuView: Bool!
  
    // MARK: initialization
    init(frame: CGRect) {
        super.init(nibName: nil, bundle: nil)

        view.frame = frame
        addedIndexs = Set<Int>()
        showInMemoryIndexs = Set<Int>()
        
        menuView = UIView()
        menuView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuView)
        
        menuScrollView = LZPageMenuMenuView()
        menuScrollView.translatesAutoresizingMaskIntoConstraints = false
        menuView.addSubview(menuScrollView)
        
        itemIndicator = CALayer()
        menuScrollView.layer.addSublayer(itemIndicator)
        
        contollerScrollView = UIScrollView()
        contollerScrollView.translatesAutoresizingMaskIntoConstraints = false
        contollerScrollView.isPagingEnabled = true
        contollerScrollView.delegate = self
        contollerScrollView.showsHorizontalScrollIndicator = false
        contollerScrollView.showsVerticalScrollIndicator = false
        view.addSubview(contollerScrollView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: PrivateMethods
    func tapMenu(itemFrame: CGRect, index: Int) {
        scrollIndicator(itemFrame)
        scrollViewController(index)
        startScrollIndex = index
    }
    
    // MARK: Scroll
    func scrollViewController(_ index: Int) {
        if index >= viewControllers.count || index < 0 { return }
        
        if index - startScrollIndex > 1 && startScrollIndex >= 0 {
            for tempStartIndex in startScrollIndex...(index - 1) {
                addHadAddedPageAtIndex(tempStartIndex)
            }
        }
        
        if index - startScrollIndex < -1 && startScrollIndex >= 0 {
            for tempStartIndex in (index + 1)...(startScrollIndex - 1) {
                addHadAddedPageAtIndex(tempStartIndex)
            }
        }
        
        addPageAtIndex(index)
        if headView != nil { resetPanGestureData() }
        
        UIView.animate(withDuration: TimeInterval(scrollAnimationDurationOnMenuItemTap), animations: {
            self.contollerScrollView.contentOffset = CGPoint.init(x: CGFloat(index) * self.view.frame.width, y: 0.0)
        }) { (finished) in
            self.removePage()
        }
    }
    
    func scrollIndicator(_ frame: CGRect) {
        if !needShowSelectionIndicator { return }
        
        var width = frame.width - selectionIndicatorOffset.left - selectionIndicatorOffset.right
        var height = CGFloat(selectionIndicatorHeight)
        var x = frame.minX + selectionIndicatorOffset.left
        var y = CGFloat(menuHeight) - menuInset.top - fabs(menuInset.bottom) - height
        if selectionIndicatorOffset.top > 0 {
            y = selectionIndicatorOffset.top
        } else if selectionIndicatorOffset.bottom > 0 {
            y -= selectionIndicatorOffset.bottom
        }
        
        if selectionIndicatorType == .image {
            width = CGFloat(selectionIndicatorImageWidth ?? 0.0)
            if width <= 0.0 && selectionIndicatorImage != nil { width = selectionIndicatorImage!.size.width }
            if selectionIndicatorOffset.left <= 0.0 { x = frame.minX + (frame.width - width)/2.0}
            if height <= 0.0 && selectionIndicatorImage != nil { height = selectionIndicatorImage!.size.height }
        }
        
        if selectionIndicatorType == .dot {
            width = CGFloat(selectionIndicatorHeight)
            if selectionIndicatorOffset.left <= 0.0 { x = frame.minX + (frame.width - width)/2.0 }
        }
       
        UIView.animate(withDuration: TimeInterval(scrollAnimationDurationOnMenuItemTap)) {
            self.itemIndicator.frame = CGRect.init(x: x, y: y, width: width, height: height)
        }
    }
    
    func getCellFrame(_ index: Int) -> CGRect {
        var frame = CGRect.zero
        if let attribute = menuScrollView.layoutAttributesForItem(at: IndexPath.init(item: index, section: 0)) {
            frame = attribute.frame
            
            frame = getSpecialFrame(cellFrame: frame, index: index)
        }

        return frame
    }
    
    // MARK: UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if hadTapMenu || scrollView.contentOffset.x <= 0 ||  scrollView.contentOffset.x >= contollerScrollView.contentSize.width { return }
        
        if headView != nil { resetPanGestureData() }
        
        var goNext = false
        var goPrevious = false
        let rate: CGFloat = 0.5
        if CGFloat(startScrollIndex) * self.view.frame.width < scrollView.contentOffset.x { goNext = true }
        if CGFloat(startScrollIndex) * self.view.frame.width > scrollView.contentOffset.x { goPrevious = true }
        if !goNext && !goPrevious { return }
        
        let currentIndex = Int(goNext ? ceil(scrollView.contentOffset.x / contollerScrollView.frame.width) : floor(scrollView.contentOffset.x / contollerScrollView.frame.width))
        if currentIndex >= self.viewControllers.count || currentIndex < 0 { return }
        
        addHadAddedPageAtIndex(currentIndex)
        
        var needAddNewPage = false
        if goNext { needAddNewPage = fabs(CGFloat(currentIndex - 1) * contollerScrollView.frame.width - scrollView.contentOffset.x)/contollerScrollView.frame.width >= rate }
        if goPrevious { needAddNewPage = fabs(CGFloat(currentIndex + 1) * contollerScrollView.frame.width - scrollView.contentOffset.x)/contollerScrollView.frame.width >= rate }
        
        if !needAddNewPage {
            menuScrollView.refreshCell(selectedIndex: goNext ? currentIndex - 1 : currentIndex + 1)
            scrollIndicator(getCellFrame(goNext ? currentIndex - 1 : currentIndex + 1))
            return
        } else {
            menuScrollView.refreshCell(selectedIndex: currentIndex)
            scrollIndicator(getCellFrame(currentIndex))
        }
        
        if showInMemoryIndexs.contains(currentIndex) { return }
        
        addPageAtIndex(currentIndex)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if hadTapMenu { return }
        startScrollIndex = lastSelectedIndex
        
        removePage()
    }
    
    // MARK: About Pages
    func addHadAddedPageAtIndex(_ index: Int) {
        if index < 0 || index >= self.viewControllers.count { return }
        if !showInMemoryIndexs.contains(index) && addedIndexs.contains(index){
            addPageAtIndex(index)
        }
    }
    
    func addPageAtIndex(_ index: Int) {
        let currentController = viewControllers[index]
        delegate?.willMoveToPage?(controller: currentController, index: index)
        
        currentController.willMove(toParentViewController: self)
        currentController.view.frame = CGRect.init(x: view.frame.width * CGFloat(index), y: 0.0, width: view.frame.width, height: contollerScrollView.contentSize.height)
        addChildViewController(currentController)
        contollerScrollView.addSubview(currentController.view)
        currentController.didMove(toParentViewController: self)
        addedIndexs.insert(index)
        showInMemoryIndexs.insert(index)
    }
    
    func removePage() {
        for index in showInMemoryIndexs {
            if index == lastSelectedIndex { continue }
            
            let oldViewController = viewControllers[index]
            oldViewController.willMove(toParentViewController: nil)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
            oldViewController.didMove(toParentViewController: nil)
            showInMemoryIndexs.remove(index)
        }
        
        hadTapMenu = false
    }
    
    // MARK: Constraint
    func setBaseConstraints() {
        var y: CGFloat = 0.0, left: CGFloat = 0.0, right: CGFloat = 0.0, height: CGFloat = 0.0
        
        if headView != nil {
            headView.translatesAutoresizingMaskIntoConstraints = false
            y = 0; left = 0; right = 0; height = CGFloat(headViewHeight)
            setY(y: y, left: left, right: right, height: height, view: headView, superView: view)
        }

        if !self.showMenuInNavigationBar {
            height = CGFloat(menuHeight)
            setTopMargin(topMargin: y, left: left, right: right, height: height, view: menuView, otherView: headView, superView: view)
        }

        y = 0
        var controllerScrollViewHeight = view.frame.height - CGFloat(self.menuHeight) - CGFloat(headViewTopSafeDistance ?? 0.0) - CGFloat(headViewBottomSafeDistance ?? 0.0)
        if showMenuInNavigationBar { controllerScrollViewHeight += CGFloat(menuHeight) }
        setTopMargin(topMargin: y, left: left, right: right, height: controllerScrollViewHeight, view: contollerScrollView, otherView: menuView, superView: view)
        
        // contentSize
        contollerScrollView.contentSize = CGSize.init(width: view.frame.width * CGFloat(viewControllers.count), height: controllerScrollViewHeight)

        // menuScrollView
        if !showMenuInNavigationBar {
            left = menuInset.left
            y = menuInset.top
            right = -fabs(menuInset.right)
            height = CGFloat(menuHeight) - menuInset.top - fabs(menuInset.bottom)
            setY(y: y, left: left, right: right, height: height, view: menuScrollView, superView: menuView)
        }
    }
    
    func setY(y: CGFloat, left: CGFloat, right: CGFloat, height: CGFloat, view: UIView, superView: UIView) {
        let constraint1 = NSLayoutConstraint.init(item:view, attribute:.top, relatedBy:.equal, toItem:superView, attribute:.top, multiplier: 1.0, constant: y)
        let constraint2 = NSLayoutConstraint.init(item:view, attribute:.left, relatedBy:.equal, toItem:superView, attribute:.left, multiplier: 1.0, constant:left)
        let constraint3 = NSLayoutConstraint.init(item:view, attribute:.right, relatedBy:.equal, toItem:superView, attribute:.right, multiplier: 1.0, constant:right)
        let constraint4 = NSLayoutConstraint.init(item:view, attribute:.height, relatedBy:.equal, toItem:nil, attribute:.notAnAttribute, multiplier: 1.0, constant: height)
       
        superView.addConstraints([constraint1, constraint2, constraint3, constraint4])
        
        if view === headView {
            headView_Y = constraint1
            headView_Left = constraint2
            headView_Right = constraint3
            headView_Height = constraint4
        }
    }
    
    func setTopMargin(topMargin: CGFloat, left: CGFloat, right: CGFloat, height: CGFloat, view: UIView, otherView: UIView?, superView: UIView) {
        var constraint1: NSLayoutConstraint!
        let constraint2 = NSLayoutConstraint.init(item:view, attribute:.left, relatedBy:.equal, toItem:superView, attribute:.left, multiplier: 1.0, constant:left)
        let constraint3 = NSLayoutConstraint.init(item:view, attribute:.right, relatedBy:.equal, toItem:superView, attribute:.right, multiplier: 1.0, constant:right)
        let constraint4 = NSLayoutConstraint.init(item:view, attribute:.height, relatedBy:.equal, toItem:nil, attribute:.notAnAttribute, multiplier: 1.0, constant: height)
        
        if let tempView = otherView {
            constraint1 = NSLayoutConstraint.init(item:view, attribute:.top, relatedBy:.equal, toItem:tempView, attribute:.bottom, multiplier: 1.0, constant:topMargin)
        }
        
        if view === menuView && otherView == nil {
            constraint1 = NSLayoutConstraint.init(item:view, attribute:.top, relatedBy:.equal, toItem:self.view, attribute:.top, multiplier: 1.0, constant:topMargin)
        }
    
        if showMenuInNavigationBar && view === contollerScrollView {
            constraint1 = NSLayoutConstraint.init(item:view, attribute:.top, relatedBy:.equal, toItem:self.view, attribute:.top, multiplier: 1.0, constant:topMargin)
        }
        
        superView.addConstraints([constraint1, constraint2, constraint3, constraint4])
    }
    
    // MARK: showInNavigationBar
    func showInNavigationBar() {
        let parentVC = self.next?.next as? UIViewController
        let navigationBar = parentVC?.navigationController?.navigationBar
        if parentVC == nil || navigationBar == nil { return }
        
        menuView.translatesAutoresizingMaskIntoConstraints = true
        menuScrollView.translatesAutoresizingMaskIntoConstraints = true
        
        var width: Float = menuWidth ?? 0.0
        if width <= 0.0 {
            for tempWidth in itemUnselectedWidths {
                width += tempWidth
            }
            
            width += Float(itemUnselectedWidths.count - 1) * menuItemSpace
            width -= Float(menuInset.left + menuInset.right)
            width -= Float(menuContentInset.left + menuContentInset.right)
        }
        
        if width > Float(navigationBar!.frame.width) { width = Float(navigationBar!.frame.width) }
        menuView.frame = CGRect.init(x: 0.0, y: 0.0, width: Double(width), height: Double(menuHeight))
        menuWidth = width
        
        // If you can not add constraints to a view and then add it to other parent views, it may cause a crash
        menuScrollView.frame = CGRect.init(x: menuInset.left, y: menuInset.top, width: CGFloat(menuWidth!) - menuInset.left - menuInset.right, height: CGFloat(menuHeight) - menuInset.bottom - menuInset.top)
        navigationBar!.addSubview(menuView)
        parentVC!.navigationItem.titleView = menuView
    }
    
    // MARK: HeadView
    func configHeaderView() {
        view.insertSubview(headView, at: 0)
        
        headViewMaxmumOffsetRate = headViewMaxmumOffsetRate ?? 0.5
        headViewTopSafeDistance = headViewTopSafeDistance ?? 0.0
        headViewBottomSafeDistance = headViewBottomSafeDistance ?? 0.0
        stretchHeadView = stretchHeadView ?? true
        headViewMaximumOffsetDistance = CGFloat(headViewMaxmumOffsetRate * headViewHeight)
        panStartY = 0; panEndY = 0; panStartPoint = CGPoint.zero; canNotScrollMenuView = false
        if subScrollviews != nil {
            subScrollviews.removeAll()
        } else {
            subScrollviews = [Int: Set<UIScrollView>]()
        }
        
        for index in 0..<viewControllers.count {
            getScrollViewInView(subView: viewControllers[index].view, index: index)
        }
        
        if panGesture == nil {
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(pan:)))
            panGesture.maximumNumberOfTouches = 1
            view.addGestureRecognizer(panGesture)
            
            animator = UIDynamicAnimator.init(referenceView: view)
            animatorItem = LZPageMenuDynamicItem()
            inertiaBehavior = UIDynamicItemBehavior.init(items: [animatorItem])
            bounceBehavior = UIAttachmentBehavior.init(item: animatorItem, attachedToAnchor: CGPoint.zero)
        }
    }
    
    func resetPanGestureData() {
        panEndY = 0
        panStartY = 0
        panStartPoint = CGPoint.zero
    }
    
    func getScrollViewInView(subView: UIView, index: Int) {
        let scrollView: UIScrollView? = subView as? UIScrollView
    
        if scrollView != nil {
            scrollView!.isScrollEnabled = false
            scrollView!.bounces = false
            if var set = subScrollviews[index] {
                set.insert(scrollView!)
                subScrollviews.updateValue(set, forKey: index)
            } else {
                let set: Set<UIScrollView> = [scrollView!]
                subScrollviews.updateValue(set, forKey: index)
            }
        }
        
        for view in subView.subviews {
            getScrollViewInView(subView: view, index: index)
        }
    }
    
    @objc func panGestureAction(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            panStartPoint = pan.location(in: view)
            panStartY = panStartPoint.y
            panScrollView = getScrollViewAtPoint(panStartPoint)
            forbiddenUserinterface(true)
            removeBounce()
            removeInertia(false)
        }
        
        if pan.state == .changed {
            panEndY = pan.location(in: view).y
            
            let goUp = panEndY < panStartY
            let goDown = panEndY >= panStartY
            
            if !goUp && !goDown { return }
            canNotScrollMenuView = wetherCanScrollMenuView()
            scrollSubView(goUp: goUp, offset: panEndY - panStartY, behavior: nil)
           
            panStartY = panEndY
        }
        
        if pan.state == .ended {
            addInertia(pan.velocity(in: view))
        }
    }

    func scrollSubView(goUp: Bool, offset: CGFloat, behavior: UIDynamicBehavior?) {
        var tempOffset = offset
        // When there is a UIScrollView offset, and the menu is not up to the limit, the offset menu on the slide, the scroll scroll view of the scroll
        var onlyScrollMenuView = false
        if canNotScrollMenuView && !headGoUpToLimit() {
            if !goUp {
                setScrollViewContentOffset(offsetY: goUp ? fabs(tempOffset) : -fabs(tempOffset), scrollView: panScrollView, behavior: behavior)
                return
            } else {
                onlyScrollMenuView = true
            }
        }
        
        tempOffset /= 1.3
        if !stretchHeadView && (!canNotScrollMenuView || onlyScrollMenuView) {
            if goUp {
                if behavior === bounceBehavior { tempOffset *= 1.3 }
                headView_Y.constant -= fabs(tempOffset)
            }
            
            if !goUp {
                headView_Y.constant += tempOffset
                if headView_Y.constant >= headViewMaximumOffsetDistance { headView_Y.constant = headViewMaximumOffsetDistance }
            }
            
            delegate?.headerViewOffsetY?(offsetY: headView_Y.constant - 0)
        }
        
        if stretchHeadView && (!canNotScrollMenuView || onlyScrollMenuView) {
            if goUp {
                if behavior === bounceBehavior { tempOffset *= 1.3 }
                if headView_Height.constant > CGFloat(headViewHeight) {
                    headView_Height.constant -= fabs(tempOffset)
                    headView_Left.constant += fabs(tempOffset)/2
                    headView_Right.constant -= fabs(tempOffset)/2
                } else {
                    headView_Y.constant -= fabs(tempOffset)
                }
            }
            
            if !goUp {

                if headView_Y.constant >= 0 {
                    headView_Y.constant = 0
                    headView_Height.constant += fabs(tempOffset)

                    if headView_Height.constant >= CGFloat(headViewHeight) + headViewMaximumOffsetDistance {
                        headView_Height.constant = CGFloat(headViewHeight) + headViewMaximumOffsetDistance
                    } else {
                        headView_Left.constant -= fabs(tempOffset)/2
                        headView_Right.constant += fabs(tempOffset)/2
                    }
                    
                } else {
                    headView_Y.constant += fabs(tempOffset)
                }
            }

            if headView_Height.constant <= CGFloat(headViewHeight){
                headView_Left.constant = 0
                headView_Right.constant = 0
                headView_Height.constant = CGFloat(headViewHeight)
            }
        
            if headView_Y.constant >= 0 { headView_Y.constant = 0 }
            if headView_Left.constant >= 0 { headView_Left.constant = 0 }
            if headView_Right.constant <= 0 { headView_Right.constant = 0 }
            
            delegate?.headerViewOffsetY?(offsetY: headView_Y.constant - 0, heightOffset: headView_Height.constant - CGFloat(headViewHeight))
        }
    
        if headGoUpToLimit() {
            headView_Y.constant = -fabs(CGFloat(headViewHeight - headViewTopSafeDistance))
            setScrollViewContentOffset(offsetY: goUp ? fabs(tempOffset) : -fabs(tempOffset), scrollView: panScrollView, behavior: behavior)
        }
        
        let condition1 = fabs(tempOffset) < 1.5
        let condition2 = stretchHeadView && headView_Height.constant >= CGFloat(headViewHeight) + headViewMaximumOffsetDistance
        let condition3 = !stretchHeadView && headView_Y.constant >= headViewMaximumOffsetDistance
        if behavior != nil && (condition1 || condition2 || condition3) {
           removeInertia(true)
        }
    }
    
    func setScrollViewContentOffset(offsetY: CGFloat, scrollView: UIScrollView?, behavior: UIDynamicBehavior?) {
        var tempScrollView = scrollView
        
    // If you are animating, you need to re-acquire the scrollView and determine whether it is the inertia from the current page. panStartPoint will be emptied during page switching
        if behavior != nil && tempScrollView == nil && !panStartPoint.equalTo(CGPoint.zero) {
            tempScrollView = getScrollViewAtPoint(view.center)
            panScrollView = tempScrollView
        }
        if tempScrollView == nil { return }
        
        let oldOffset = tempScrollView!.contentOffset
        var newOffset_Y = oldOffset.y + offsetY
        let maxContentsizeY = tempScrollView!.contentSize.height - tempScrollView!.frame.height/2.0
        
        if newOffset_Y >= tempScrollView!.contentSize.height - tempScrollView!.frame.height {
            let addBounceCondition1 = (newOffset_Y >= maxContentsizeY && !animator.behaviors.contains(bounceBehavior))
            let addBounceCondition2 = (offsetY < 1.5 && offsetY >= 0 && !animator.behaviors.contains(bounceBehavior))
            
            if addBounceCondition1 {
                setScrollViewContentOffet(scrollView: tempScrollView!, offset: CGPoint.init(x: 0.0, y: maxContentsizeY))
                removeInertia(false)
            }
            
            if behavior === inertiaBehavior && (addBounceCondition1 || addBounceCondition2) {
                addBounce(center: tempScrollView!.contentOffset, anchorPoint: CGPoint.init(x: 0, y: tempScrollView!.contentSize.height - tempScrollView!.frame.height)) {
                    [unowned self] in
                    
                    if self.animatorItem.center.y <= self.bounceBehavior.anchorPoint.y {
                        self.animatorItem.center = self.bounceBehavior.anchorPoint
                        if self.panScrollView != nil { self.delegate?.subScrollViewDidEndScroll?(subScrollView: self.panScrollView!) }
                        self.removeBounce()
                    }
                    self.setScrollViewContentOffet(scrollView: self.panScrollView!, offset: self.animatorItem.center)
                }
            }
        }
        
        if newOffset_Y <= 0 { newOffset_Y = 0 }
        if behavior == nil && newOffset_Y >= maxContentsizeY { newOffset_Y = maxContentsizeY }
        setScrollViewContentOffet(scrollView: tempScrollView!, offset: CGPoint.init(x: 0.0, y: newOffset_Y))
    }
    
    func setScrollViewContentOffet(scrollView: UIScrollView, offset: CGPoint) {
        scrollView.contentOffset = offset
        delegate?.subScrollViewDidScroll?(subScrollView: scrollView)
    }
    
    func getScrollViewAtPoint(_ point: CGPoint) -> UIScrollView? {
        if let scrollViewSet = subScrollviews[lastSelectedIndex] {
            for scrollView in scrollViewSet {
                var covertFrame = contollerScrollView.convert(scrollView.frame, to: view)
                if covertFrame.minX < 0 {
                    covertFrame.origin.x += contollerScrollView.contentOffset.x
                }
                if covertFrame.contains(point) { return scrollView }
            }
        }
        return nil
    }
    
    func forbiddenUserinterface(_ forbid: Bool) {
        headView.isUserInteractionEnabled = !forbid
        menuView.isUserInteractionEnabled = !forbid
        contollerScrollView.isUserInteractionEnabled = !forbid
    }
    
    func addBounce(center: CGPoint, anchorPoint: CGPoint, action: @escaping ()->Void) {
     
        animatorItem.center = center
        bounceBehavior.anchorPoint = anchorPoint
        bounceBehavior.length = 0
        bounceBehavior.damping = 1
        bounceBehavior.frequency = 2
        bounceBehavior.action = action
        if !animator.behaviors.contains(bounceBehavior) {
            animator.addBehavior(bounceBehavior)
        }
    }
    
    func removeBounce() {
        forbiddenUserinterface(false)
        if animator.behaviors.contains(bounceBehavior) {
            animator.removeBehavior(bounceBehavior)
        }
    }
    
    func addInertia(_ velocity: CGPoint) {
        let goUp = velocity.y < 0
        animatorItem.center = CGPoint.zero
        inertiaBehavior.addLinearVelocity(CGPoint.init(x: 0, y: velocity.y), for: animatorItem)
        inertiaBehavior.resistance = 2.0
        var lastCenter = CGPoint.zero
        inertiaBehavior.action = { [unowned self] in
            let currentY = self.animatorItem.center.y - lastCenter.y;
            self.canNotScrollMenuView = self.wetherCanScrollMenuView()
            self.scrollSubView(goUp: goUp, offset: currentY, behavior: self.inertiaBehavior)
            lastCenter = self.animatorItem.center
        }
        animator.addBehavior(inertiaBehavior)
    }
    
    func removeInertia(_ needBouncehead: Bool) {
        forbiddenUserinterface(false)
        if animator.behaviors.contains(inertiaBehavior) {
            animator.removeBehavior(inertiaBehavior)

            if panScrollView != nil && panScrollView!.contentOffset.y < panScrollView!.contentSize.height - panScrollView!.frame.height { delegate?.subScrollViewDidEndScroll?(subScrollView: panScrollView!) }
        }

        if needBouncehead {
            var lastY: CGFloat = 0.0
            if stretchHeadView && headView_Height.constant > CGFloat(headViewHeight) {
                lastY = headView_Height.constant

                addBounce(center: CGPoint.init(x: 0, y: headView_Height.constant), anchorPoint: CGPoint.init(x: 0, y: CGFloat(headViewHeight))) {
                    [unowned self] in
            
                    if self.animatorItem.center.y <= self.bounceBehavior.anchorPoint.y {
                        self.animatorItem.center = self.bounceBehavior.anchorPoint
                        self.removeBounce()
                    }
                    self.scrollSubView(goUp: true, offset: self.animatorItem.center.y - lastY, behavior: self.bounceBehavior)
                    lastY = self.animatorItem.center.y
                }
            }

            if !stretchHeadView && headView_Y.constant > 0 {
                var offset: CGFloat = 0
                lastY =  headView_Y.constant
                addBounce(center: CGPoint.init(x: 0, y: headView_Y.constant), anchorPoint: CGPoint.zero) {
                     [unowned self] in
                     if self.animatorItem.center.y <= 0.0 {
                        self.animatorItem.center = self.bounceBehavior.anchorPoint
                        self.removeBounce()
                     }
                    offset = lastY - self.animatorItem.center.y
                    self.scrollSubView(goUp: true, offset: offset, behavior: self.bounceBehavior)
                    lastY = self.animatorItem.center.y
                }
            }
        }
    }
    
    func wetherCanScrollMenuView() -> Bool {
        var hadOffsetScrollviewCount = 0
        if let scrollViewSet = subScrollviews[lastSelectedIndex] {
            for scrollView in scrollViewSet {
                if scrollView.contentOffset.y > 0 { hadOffsetScrollviewCount += 1}
            }
        }
        return hadOffsetScrollviewCount > 0
    }
    
    func headGoUpToLimit() -> Bool {
        return headView_Y.constant <= CGFloat(-fabs(headViewHeight - headViewTopSafeDistance))
    }
    
    // MARK: Indicator
    func setupIndicator() {
        if menuBottomLineHeight != nil && menuBottomLineHeight! > 0{
            bottomLine = CALayer.init()
            bottomLine?.frame = CGRect.init(x: 0.0, y: CGFloat(menuHeight - menuBottomLineHeight!), width: view.frame.width, height: CGFloat(menuBottomLineHeight!))
            bottomLine?.backgroundColor = menuBottomLineColor?.cgColor ?? UIColor.red.cgColor
            menuView.layer.addSublayer(bottomLine!)
        } else {
            bottomLine?.isHidden = true
        }
        
        if menuItemType == .customView { showIndicatorInLowestLayer = false }
        itemIndicator.isHidden = !needShowSelectionIndicator
        if !needShowSelectionIndicator { return }
        
        itemIndicator.backgroundColor = selectionIndicatorColor.cgColor
        switch selectionIndicatorType {
        case .image where selectionIndicatorImage != nil:
            itemIndicator.backgroundColor = UIColor.clear.cgColor
            itemIndicator.contents = selectionIndicatorImage!.cgImage
        case .dot, .solidOval, .hollowOval:
            itemIndicator.cornerRadius = CGFloat(selectionIndicatorHeight/2.0)
        default:break
        }
        
        if selectionIndicatorType == .hollowOval {
            itemIndicator.borderColor = selectionIndicatorColor.cgColor
            itemIndicator.borderWidth = 1.0
            itemIndicator.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    // MARK: PublicMethods
    public func reloadData() {
        assert(!viewControllers.isEmpty, "Not allowed to be empty")
        
        self.caclulateItemWidth()
        if showMenuInNavigationBar { showInNavigationBar() }
        if headView != nil && headViewHeight != nil { configHeaderView() }
        
        view.backgroundColor = pageMenuBackgroundColor
        menuView.backgroundColor = menuBackgroundColor
        menuScrollView.backgroundColor = menuBackgroundColor
        contollerScrollView.backgroundColor = pageMenuBackgroundColor
        
        setupIndicator()
        setBaseConstraints()
        
        menuScrollView.configuration = self
        menuScrollView.reloadData()
    }
    
    public func updateTitles() {
        caclulateItemWidth()
        menuScrollView.reloadData()
        scrollIndicator(getCellFrame(lastSelectedIndex))
    }
}

fileprivate extension LZPageMenu {
    func caclulateItemWidth() {
        if !itemSelectedWidths.isEmpty { itemSelectedWidths.removeAll() }
        if !itemUnselectedWidths.isEmpty { itemUnselectedWidths.removeAll() }
        
        var width: Float = 0.0
        
        // customView
        if customDelegate != nil {
            menuItemType = .customView
            for index in 0..<viewControllers.count {
                width = customDelegate!.menuItemUnselectedWidth(index: index)
                itemUnselectedWidths.append(width)
                
                if let customWidth = customDelegate!.menuItemSelectedWidth?(index: index) {
                    itemSelectedWidths.append(customWidth)
                }
            }
            return
        }
     
        // customWidth
        if !menuItemWidthBasedOnTitleTextWidth && menuItemUnselectedWidths != nil {
            menuItemType = .customWidth
           
            if !menuItemUnselectedWidths!.isEmpty { itemUnselectedWidths = menuItemUnselectedWidths!}
            if let widths = menuItemSelectedWidths { itemSelectedWidths = widths }
            
            setupTextWidthsArray()
            for viewController in viewControllers {
                width = Float(viewController.title!.size(withAttributes: [NSAttributedStringKey.font: unselectedMenuItemLabelFont]).width)
                itemUnselectedTextWidths!.append(width)
                width = Float(viewController.title!.size(withAttributes: [NSAttributedStringKey.font: selectedMenuItemLabelFont]).width)
                itemSelectedTextWidths!.append(width)
            }
            return
        }
 
        // attribute
        if menuItemUnselectedTitles != nil {
            menuItemType = .attribute
            for attribute in menuItemUnselectedTitles! {
                
                width = Float(attribute.boundingRect(with: CGSize.init(width: 300, height: CGFloat(menuHeight) - menuInset.top), options:[.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.width)
                itemUnselectedWidths.append(width)
            }
            
            if menuItemSelectedTitles != nil {
                for attribute in menuItemUnselectedTitles! {
                    
                    width = Float(attribute.boundingRect(with: CGSize.init(width: 300, height: CGFloat(menuHeight) - menuInset.top), options:[.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.width)
                    itemSelectedWidths.append(width)
                }
            }
            return
        }
        
        // averageWidth
        if averageMenuWitdh && !menuItemWidthBasedOnTitleTextWidth {
            menuItemType = .averageWidth
            
            setupTextWidthsArray()
            for viewController in viewControllers {
                var totalWidth: Float = menuWidth ?? Float(UIScreen.main.bounds.size.width)
                
                totalWidth -= Float(viewControllers.count - 1) * menuItemSpace
                totalWidth -= Float(menuInset.left + menuInset.right)
                totalWidth -= Float(menuContentInset.left + menuContentInset.right)
                
                width = totalWidth/Float(viewControllers.count)
                itemUnselectedWidths.append(width)
                itemSelectedWidths.append(width)
                
                width = Float(viewController.title!.size(withAttributes: [NSAttributedStringKey.font: unselectedMenuItemLabelFont]).width)
                itemUnselectedTextWidths!.append(width)
                width = Float(viewController.title!.size(withAttributes: [NSAttributedStringKey.font: selectedMenuItemLabelFont]).width)
                itemSelectedTextWidths!.append(width)
            }
            return
        }
        
        for viewController in viewControllers {
            width = Float(viewController.title!.size(withAttributes: [NSAttributedStringKey.font: unselectedMenuItemLabelFont]).width)
            itemUnselectedWidths.append(width)
            width = Float(viewController.title!.size(withAttributes: [NSAttributedStringKey.font: selectedMenuItemLabelFont]).width)
            itemSelectedWidths.append(width)
        }
    }
    
    func selectedWidth(index: Int) -> CGFloat {
        if index >= itemSelectedWidths.count || index < 0 { return unselectedWidth(index: index)}
        return CGFloat(itemSelectedWidths[index])
    }
    
    func unselectedWidth(index: Int) -> CGFloat {
        if index >= itemUnselectedWidths.count || index < 0 { return 0 }
        
        return CGFloat(itemUnselectedWidths[index])
    }
    
    func getSpecialFrame(cellFrame: CGRect, index: Int) -> CGRect {
        let needSpecialCalculate = (menuItemType == .averageWidth || menuItemType == .customWidth) && selectionIndicatorWithEqualToTextWidth
        
        if needSpecialCalculate {
            let width = index == lastSelectedIndex ? selectedWidth(index: index) : unselectedWidth(index: index)
            let x = (cellFrame.size.width - width)/2.0
            return CGRect.init(x: cellFrame.origin.x + x, y: cellFrame.origin.y, width: width, height: cellFrame.size.height)
        }
        
        return cellFrame
    }
    
    func setIndicatorHierarchy() {
         menuScrollView.layer.insertSublayer(itemIndicator, at: 0)
    }
    
    func setupTextWidthsArray() {
        if itemSelectedTextWidths == nil {
            itemSelectedTextWidths = [Float]()
        } else {
            itemSelectedTextWidths!.removeAll()
        }
        
        if itemUnselectedTextWidths == nil {
            itemUnselectedTextWidths = [Float]()
        } else {
            itemUnselectedTextWidths!.removeAll()
        }
    }
}
