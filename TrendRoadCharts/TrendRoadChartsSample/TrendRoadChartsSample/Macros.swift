//
//  Macros.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 18/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import Foundation
import UIKit

//屏幕分辨率比例
let screenScale:CGFloat = UIScreen.main.responds(to: #selector(getter: UIScreen.main.scale)) ? UIScreen.main.scale : 1.0

//不同屏幕尺寸字体适配（375，667是因为目前苹果开发一般用IPHONE6做中间层 如果不是则根据实际情况修改）
//相对于iPhone6的宽度比例
let screenWidthRatio:CGFloat =  kScreenWidth / 375;
let screenHeightRatio:CGFloat = kScreenHeight / 667;

//根据传入的值算出乘以比例之后的值
func adaptedWidth(width:CGFloat) ->CGFloat {
    return CGFloat(ceil(Float(width))) * screenWidthRatio
}

func adaptedHeight(height:CGFloat) ->CGFloat {
    return CGFloat(ceil(Float(height))) * screenHeightRatio
}

//判断是那种设备

/*
 4  4s
 */
func iPhone4() ->Bool {
    return UIScreen.main.bounds.size.height == 480.0
}

/*
 5  5s
 */
func iPhone5() ->Bool {
    return UIScreen.main.bounds.size.height == 568.0
}

/*
 6  6s  7
 */
func iPhone6() ->Bool {
    return UIScreen.main.bounds.size.height == 667.0
}

/*
 6plus  6splus  7plus
 */
func iPhone6plus() ->Bool {
    return UIScreen.main.bounds.size.height == 736.0
}

func iPhoneX() -> Bool {
    return UIScreen.main.bounds.size.height == 812.0
}


let kScreenBounds = UIScreen.main.bounds

//屏幕大小
let kScreenSize                           = kScreenBounds.size
//屏幕宽度
let kScreenWidth:CGFloat                  = kScreenSize.width
//屏幕高度
let kScreenHeight:CGFloat                 = kScreenSize.height
//状态栏默认高度
let kStatusBarHeight:CGFloat = (iPhoneX() ? 44.0 : 20.0)
//导航栏默认高度
let kNavBarHeight:CGFloat = 44.0
//Tabbar默认高度
let kTabBarHeight:CGFloat = (iPhoneX() ? 83.0 : 49.0)


////Tabbar默认高度
//func kTabBarHeight() -> NSInteger {
//    return (iPhoneX() ? 83 : 49)
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  2. App Version / Info Plist  设备系统版本
//
///////////////////////////////////////////////////////////////////////////////////////////////////

/* 设备系统相关  */
let kiOSVersion:String        = UIDevice.current.systemVersion         /* iOS系统版本 */
let osType:String             = UIDevice.current.systemName + UIDevice.current.systemVersion




/* app版本  以及设备系统版本 */
let infoDictionary            = Bundle.main.infoDictionary
let kAppName: String?         = infoDictionary!["CFBundleDisplayName"] as? String        /* App名称 */
let kAppVersion: String?      = infoDictionary!["CFBundleShortVersionString"] as? String /* App版本号 */
let kAppBuildVersion: String? = infoDictionary!["CFBundleVersion"] as? String            /* Appbuild版本号 */
let kAppBundleId: String?     = infoDictionary!["CFBundleIdentifier"] as? String                 /* app bundleId */
let platformName: String?     = infoDictionary!["DTPlatformName"] as? String  //平台名称（iphonesimulator 、 iphone）


/* 检查系统版本 */

//版本号相同
func systemVersionEqual(version:String) ->Bool {
    return UIDevice.current.systemVersion == version
}

//系统版本高于等于该version  测试发现只能传入带一位小数点的版本号  不然会报错    具体原因待探究
func systemVersionGreaterThan(version:String) ->Bool{
    return UIDevice.current.systemVersion.compare(version, options: .numeric, range: version.startIndex..<version.endIndex, locale: Locale(identifier:version)) != ComparisonResult.orderedAscending
}


//系统版本低于等于该version  测试发现只能传入带一位小数点的版本号  不然会报错    具体原因待探究
func systemVersionLessThan(version:String) ->Bool{
    return UIDevice.current.systemVersion.compare(version, options: .numeric, range: version.startIndex..<version.endIndex, locale: Locale(identifier:version)) != ComparisonResult.orderedDescending
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  3. catch缓存文件夹和Documents文件夹
//
///////////////////////////////////////////////////////////////////////////////////////////////////

let XHUserDefault = UserDefaults.standard


/// Cache缓存文件夹
let cacheDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last

/// Documents文件夹
let documentsDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first


///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  4. 图片  UIImage 加载本地  以及初始化
//
///////////////////////////////////////////////////////////////////////////////////////////////////

//读取本地图片 （文件名，后缀名）
func loadImage(imageName __imgName__:String,imgExtension __imgExt__:String) -> UIImage {
    return UIImage.init(contentsOfFile: Bundle.main.path(forResource: __imgName__, ofType: __imgExt__)!)!
}

//定义UIImage对象 （文件名）  png格式

func loadPNGImage(imageName __imgName__:String) -> UIImage {
    return UIImage.init(contentsOfFile: Bundle.main.path(forResource: __imgName__, ofType: "png")!)!
}



///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//  5. rgb颜色转换 UIColor
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

//clearColor 透明色
let Clear_Color = UIColor.clear

// rgb颜色转换（16进制->10进制）
func kRGBAColor(R:CGFloat,G:CGFloat,B:CGFloat,A:CGFloat) ->UIColor {
    return UIColor.init(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
}

func kRGBColor(R:CGFloat,G:CGFloat,B:CGFloat) ->UIColor {
    return kRGBAColor(R: R, G: G, B: B, A: 1.0)
}
////主色调
//let kMainColor = kRGBColor(R: 142, G: 190, B: 84)
////背景色
//let kBackgroundColor = kRGBColor(R: 246, G: 246, B: 246)
////字体颜色
//let kTextColor = kRGBColor(R: 102, G: 102, B: 102)
////灰色字体颜色
//let kTextGrayColor = kRGBColor(R: 153, G: 153, B: 153)
////灰色线条
//let kLineGrayColor = kRGBColor(R: 221, G: 221, B: 221)


///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//  6. 字体 UIFont  只列举一种，其他的换名称自己可定义
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////


/// 方正黑体简体字体定义
///
/// - Parameter __SIZE__: 字体大小
/// - Returns: UIFont
func XH_Font_FZHT(size __SIZE__:CGFloat) ->UIFont {
    return UIFont.init(name: "FZHTJW--GB1-0", size: __SIZE__)!
}

//此处只列举一种  其它的查询名字后直接使用


///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//  7. 角度转弧度 弧度转角度
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////


/// 角度转弧度
///
/// - Parameter __ANGLE__: 角度
/// - Returns: 弧度值
func XH_Angle_To_Radian(__ANGLE__:CGFloat) ->CGFloat {
    return (CGFloat(Double.pi) * __ANGLE__ / 180.0)
}


/// 弧度转角度
///
/// - Parameter __RADIAN__: 弧度
/// - Returns: 角度
func XH_Radian_To_Angle(__RADIAN__:CGFloat) ->CGFloat {
    return (CGFloat(__RADIAN__ * 180 / CGFloat(Double.pi)))
}

