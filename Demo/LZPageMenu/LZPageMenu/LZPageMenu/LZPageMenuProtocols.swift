//
//  LZPageMenuProperty.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/19.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//
//  All attributes of this file are set by the user for controlling the specific style of PageMenu, data and so on.
//

import UIKit

public enum LZSelectionIndicatorType {
    case line
    /// dot, the diameter is selectionIndicatorHeight
    case dot
    case image
    case square
    case solidOval
    case hollowOval
}

public protocol LZPageMenuPublicProtocol: NSObjectProtocol {
    // MARK: PublicProperties about PageMenu
    /// Proxy for custom menus
    var customDelegate: LZPageMenuCustomProtocol? {get set}
    /// Proxy for menu
    var delegate: LZPageMenuProtocol? {get set}
    /// The background color of the controller's container
    var pageMenuBackgroundColor: UIColor {get set}
    /// The array of controllers
    var viewControllers: [UIViewController] {get set}
    /// Unselected Rich Text Titles. By default, this property is not used and the menu titles is the title of the controller.
    var menuItemUnselectedTitles: [NSAttributedString]? {get set}
    /// Selected Rich Text Titles. By default, this property is not used and the menu titles is the title of the controller.
    var menuItemSelectedTitles: [NSAttributedString]? {get set}
    /// Selected by default，
    var defaultSelectedIndex: Int {get set}
    
    // MARK: PublicProperties about SelectionIndicator
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
    
    // MARK: PublicProperties about Bottom Line
    /// Bottom line height, setting this value to be greater than 0 will display the bottom line of the menu
    var menuBottomLineHeight: Float? {get set}
    /// Bottom line color
    var menuBottomLineColor: UIColor? {get set}
    
    // MARK: PublicProperties about Menu
    /// Menu background color, default is orange
    var menuBackgroundColor: UIColor {get set}
    /// Menu height, default is 44
    var menuHeight: Float {get set}
    /// Setting the menu offset actually sets the UICollectionView frame, the default is (0.0, 0.0, 0.0, 0.0)
    var menuInset: UIEdgeInsets {get set}
    /// Setting the menu content offset actually sets the contentInset of the UICollectionView, default is (0.0, 15.0, 0.0, 15.0)
    var menuContentInset: UIEdgeInsets  {get set}
    /// Whether to allow menu horizontalBounce, the default is YES
    var enableMenuHorizontalBounce: Bool  {get set}
    /// Whether to allow scroll menu, the default is YES
    var enableMenuScroll: Bool {get set}
    var enableControllScrollViewBounce: Bool {get set}
    /// Menu width, is useful when setting the menu item breadth equally or displaying in the navigation bar
    var menuWidth: Float? {get set}
    /// When setting the menu item breadth equally, you need to set the menuWidth, otherwise take the screen width.
    var averageMenuWitdh: Bool {get set}
    /// Show the menu in the navigation bar, must reloadData after adding PageMenu to the parent view
    var showMenuInNavigationBar: Bool {get set}
    
    
    // MARK: PublicProperties about MenuItem
    /// Menu selected color, default is red
    var selectedMenuItemLabelColor: UIColor {get set}
    /// Menu Unselected color, default is white
    var unselectedMenuItemLabelColor: UIColor {get set}
    /// Menu selected font, default is bold-18
    var selectedMenuItemLabelFont: UIFont {get set}
    /// Menu Unselected font, default is 16
    var unselectedMenuItemLabelFont: UIFont  {get set}
    /// The gap between the items, the default is 15.0
    var menuItemSpace: Float  {get set}
    /// This property is not used by default, defaults to use the width of the text, set when you need a custom width
    var menuItemSelectedWidths: [Float]? {get set}
    /// This property is not used by default, defaults to use the width of the text, set when you need a custom width
    var menuItemUnselectedWidths: [Float]? {get set}
    /// Whether Item's width is determined by the width of the text, default is true
    var menuItemWidthBasedOnTitleTextWidth: Bool {get set}
    /// The duration (seconds) for view rolling animation, the default is 0.5
    var scrollAnimationDurationOnMenuItemTap: Float  {get set}
    
    // MARK: PublicProperties about Vertical Line
    /// Vertical divider line will be displayed by setting this property
    var verticalSeparatorWidth: Float? {get set}
    /// Height of vertical divider line
    var verticalSeparatorHeight: Float? {get set}
    /// Color of vertical divider line
    var verticalSeparatorColor: UIColor? {get set}
    /// Whether hide the last Item's vertical division line
    var hideLastVerticalSeparator: Bool? {get set}
    
    // MARK: PublicProperties about Header
    /// Head view
    var headView: UIView! {get set}
    /// Head view height
    var headViewHeight: Float! {get set}
    /// Whether to stretch the head view, default is true
    var stretchHeadView: Bool! {get set}
    /// Head scaling, the largest proportion of offset, default is 0.5
    var headViewMaxmumOffsetRate: Float! {get set}
    /// The top safe distance of the head view, the distance left on the menu when the slide-up limit is reached
    var headViewTopSafeDistance: Float! {get set}
    /// The PageMenu bottom safety distance when there is a head view leaves a safe distance at the bottom
    var headViewBottomSafeDistance: Float! {get set}
    
    func reloadData()
    func updateTitles()
}

/// If you want to customize the menu items, you need to implement the protocol
@objc public protocol LZPageMenuCustomProtocol {
  
    func menuItemView() -> UIView
    func menuItemUnselectedWidth(index: Int) -> Float
    
    @objc optional func menuItemSelectedWidth(index: Int) -> Float
    @objc optional func configView(view: UIView, index: Int, selected: Bool)
}

@objc public protocol LZPageMenuProtocol {
    
    /// This method is called when sliding to a new page
    @objc optional func willMoveToPage(controller: UIViewController, index: Int)
    
    /// Excursion of the head, stretchHeaderView = false
    @objc optional func headerViewOffsetY(offsetY: CGFloat)
    
    /// The offset and height changes that occur to the head during stretching, stretchHeaderView = true
    @objc optional func headerViewOffsetY(offsetY: CGFloat, heightOffset: CGFloat)
    
    /// Sub-controller UISCrollView scrolling
    @objc optional func subScrollViewDidScroll(subScrollView: UIScrollView)
    
    /// Sub-controller UISCrollView ended scrolling
    @objc optional func subScrollViewDidEndScroll(subScrollView: UIScrollView)
}
