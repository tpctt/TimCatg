//
//  MYFDefines.h
//  GomeLoanClientV3
//
//  Created by ru on 17/1/3.
//  Copyright © 2017年 GMJK. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef _MYFDefines_h
#define _MYFDefines_h


// 让测试选择: SIT环境/开发环境/准生产环境
#define __Choose_Evn__               // 发布（-） 注释掉选择测试环境
#define __Face_Plus_Release__          // 发布（+） 打开Face++线上地址

// 测试的时候关闭
#define _TalkingData




//MARK: 配置文件
#define CommonConfig [GMStorageConversionModel storageConversionCommonConfig]
#define UiTextConfig [GMStorageConversionModel storageConversionUiShownTextConfig]



// 屏幕尺寸
#define KScreenBounds [UIScreen mainScreen].bounds
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

// 适配X轴、Y轴方向
#define KScaleX (KScreenWidth/375.0)
#define KScaleY (KScreenHeight/667.0)


// 导航栏的颜色
#define KNavBarBgColor RGBCOLOR(215, 46, 37)

/**
 *  标准蓝 APP主色 button填充色
 */
#define COLOR_MAIN_BLUE_29A1EF          @"#29a1ef"

/**
 *  蓝灰  分割线
 */
#define CLOKR_LIGHTGRAY_E236E9          @"#e2e6e9"
#define COLOR_SUREBUTTON @"#FE5722"
//view的背景颜色
#define ViewBgColor [UIColor colorWithRed:(241)/255.0f green:(245)/255.0f blue:(248)/255.0f alpha:(1)]
#define miaobianColor [UIColor colorWithRed:(232)/255.0f green:(232)/255.0f blue:(232)/255.0f alpha:(1)]


//TouchID
#define KTOUCHIDKEY @"touchid"

//记录手势开关状态
#define SaveGesSwitchStatus @"savegesswitchstatus"

//验证输入密码的次数
#define printCount 5

#define MessageWrong @"密码错误，还可以再输入%d次"

// 个人中心Tag
#define kSettingButtonTag 1
#define KNameButtonTag 2
#define kMessageButtonTag 3

#define kAlterButtonTag 4
#define kCancelButtonTag 5
#define kConfirmButtonTag 6



// 获取当前App版本号
#define currentVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/**
 *  适配缩放比例
 */
#define GMLAYOUTRATE_FORPLUS(orginLayout) (CGFloat)(layoutRateByHeightForPlus(orginLayout))
#define GMLAYOUTRATE(orginLayout) (CGFloat)(layoutRateByHeight(orginLayout))
#define GMLAYOUTRATE_OC(orginLayout) [GMLayoutRate layoutRateByOCHeight:orginLayout]
#define GMLAYOUTRATEFORPLUS_OC(orginLayout) [GMLayoutRate layoutRateByOCHeightForPlus:orginLayout]


typedef NS_ENUM(NSUInteger, GMCustomerIndetityAuthorticationStep)
{
    GMCustomerIndetityAuthorticationNotDefine = 0,          //  未初始化
    GMCustomerIndetityAuthorticationStepNone,           //  identityValidation: 0  faceValidation: 0
    GMCustomerIndetityAuthorticationStepFirst,          //  identityValidation: 1  faceValidation: 0
    GMCustomerIndetityAuthorticationStepSecond,         //  identityValidation: 1  faceValidation: 1
};

///控制器push源类型
typedef NS_ENUM(NSInteger, PushType) {
    PushTypeDefault, /*美易分*/
    PushType5050,
    PushType0012,
    PushFromCashLoan  /*来自现金贷*/
};


typedef NS_ENUM(NSInteger,HttpRequestType) {
    HttpRequestTypeGet      =0,
    HttpRequestTypePost     =1,
    HttpRequestTypePut      =2,
    HttpRequestTypeDelete   =3,
    HttpRequestTypeImage,
};

typedef NS_ENUM(NSInteger,ApplyForProgessStatus) {
    ApplyForProgessStatusHandling                       =0,         ///  正在处理          U
    ApplyForProgessStatusRefuse                         =1,         ///  拒绝             R
    ApplyForProgessStatusPass                           =2,         ///  通过             A
    ApplyForProgessStatusCancleBeforeActive             =3,         ///  激活前取消        C
    ApplyForProgessStatusSign                           =4,         ///  签署             N
    ApplyForProgessStatusAbandon                        =5,         ///  放弃             J
    ApplyForProgessStatusWaittingMessage                =6,         ///  待补件           B
};



#define ApplicationDelegate   ((AppDelegate *)[[UIApplication sharedApplication] delegate])


//全局单例UserAccountManager
#define contextManager [UserAccountManager sharedInstance]


// 适配X轴、Y轴方向
#define KScaleX (KScreenWidth/375.0)
#define KScaleY (KScreenHeight/667.0)

// 屏幕尺寸
#define DEVICE_BOUNDS [UIScreen mainScreen].bounds
#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define KInset 15
#define Wfont14 [UIFont systemFontOfSize:GMFONTSCALE(12) weight:3]
//调整还款界面的间距
#define AdjustPayDayViewMargin 10

// 判断IPHONE类型
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_4 ([[UIScreen mainScreen] bounds].size.height <= 480)
#define ShortSystemVersion  [[UIDevice currentDevice].systemVersion floatValue]

// 判别系统版本
#define IS_IOS_6 (ShortSystemVersion < 7)
#define IS_IOS_7 (ShortSystemVersion >= 7 && ShortSystemVersion < 8)
#define IS_IOS_8 (ShortSystemVersion >= 8)
#define IOS9_OR_LATER (ShortSystemVersion >= 9)
// 判别设备类型
#define IS_PORTRAIT UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) || UIDeviceOrientationIsPortrait(self.interfaceOrientation)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/**
 *  蓝色的文字,辅助色
 */
#define COLOR_BLUE_3399FF               @"#3399ff"
// 自定义RGB色值
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
// 自定义有透明度的RGB色值
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 全局背景色
#define KGlobalViewBgColor [UIColor colorWithRGBString:@"#FAFAFA"]

// 描边颜色
#define KDecorateLineColor  RGBCOLOR(232,232,232)

// 正常距离边缘的距离
#define KNormalMargin  15

// 导航栏标题颜色
#define KNavTitColor [UIColor colorWithRGBString:@"#333333"]

// 导航栏标题字体大小
#define KNavTitleFont Font(17)

// 允许底部按钮点击时的颜色
#define KBtnNormalBgColor [UIColor colorWithRGBString:@"#FE5722"]

// 不允许底部按钮点击时的颜色
#define KBtnDisableBgColor  [UIColor colorWithRGBString:@"#DADADA"]

// 全局通用的橘黄色
#define KGlobalTitColor [UIColor colorWithRGBString:@"#FFA11B"]

// 表视图标题颜色
#define KTableTitCol353231   [UIColor colorWithRGBString:@"#353231"]

// 表视图右边文字颜色
#define KTableDescTitCol333333   [UIColor colorWithRGBString:@"#333333"]

// NSUserDefault存储
#define KUserDefaults        [NSUserDefaults standardUserDefaults]


// 字体
#define GMFONTSCALE(originFont) DEVICE_HEIGHT > 568 ? originFont : (originFont - 2)

#define Font(fontSize)  (IOS9_OR_LATER?[UIFont fontWithName:@"PingFangSC-Regular" size:GMFONTSCALE(fontSize)]:[UIFont systemFontOfSize:GMFONTSCALE(fontSize)])



#define BoldFont(fontSize) ((IOS9_OR_LATER)?([UIFont fontWithName:@"PingFangSC-Semibold" size:GMFONTSCALE(fontSize)]):([UIFont boldSystemFontOfSize:GMFONTSCALE(fontSize)]))

//正则
//只能输入中文
#define chineseRegex  @"^[u4e00-u9fa5],{0,}$"
//验证手机号码
#define  telRegex = @"1[3|5|7|8|][0-9]{9}"
//银行卡正则
#define bankRegex =@"/^(\d{16}|\d{19})$/";
//验证码正则表达式
#define VerificationCodeRegex =@"/^(\d{4}|\d{6})$/"


// 配置文件
#define CommonConfig [GMStorageConversionModel storageConversionCommonConfig]
#define UiTextConfig [GMStorageConversionModel storageConversionUiShownTextConfig]

//FIXME: - 屏蔽NSLog
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

// 调试模式
#ifdef DEBUG
#define GMLOG(...) NSLog(__VA_ARGS__);
#define GMLOG_METHOD NSLog(@"%s", __func__);
#else
#define GMLOG(...);
#define GMLOG_METHOD;
#endif


#ifdef DEBUG
#define DebugLog( s, ... ) printf( "<%s:(%d)> %s %s\n\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding], __LINE__,__func__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding])
#else
#define DebugLog( s, ... )
#endif

#define TopicBtnColor [UIColor colorWithRGBString:@"fe5722"]

// 获取系统色值
#define KBackgroundColor   RGBACOLOR(239, 239, 244, 0.8)
#define KLightBlueColor    RGBCOLOR(84, 141, 235)
#define KBlackColor        [UIColor blackColor]
#define KDarkGrayColor     [UIColor darkGrayColor]
#define KLightGrayColor    [UIColor lightGrayColor]
#define KWhiteColor        [UIColor whiteColor]
#define KGrayColor         [UIColor grayColor]
#define KRedColor          [UIColor redColor]
#define KGreenColor        [UIColor greenColor]
#define KBlueColor         [UIColor blueColor]
#define KCyanColor         [UIColor cyanColor]
#define KYellowColor       [UIColor yellowColor]
#define KMegentaColor      [UIColor magentaColor]
#define KOrangeColor       [UIColor orangeColor]
#define KPurpleColor       [UIColor purpleColor]
#define KBrownColor        [UIColor brownColor]
#define KClearColor        [UIColor clearColor]


#pragma mark - customer define

#pragma mark - 字体大小定义
/****字体大小定义开始***/
#define font8 [UIFont systemFontOfSize:GMFONTSCALE(8)]
#define font9 [UIFont systemFontOfSize:GMFONTSCALE(9)]
#define font10 [UIFont systemFontOfSize:GMFONTSCALE(10)]
#define font11 [UIFont systemFontOfSize:GMFONTSCALE(11)]
#define font12 [UIFont systemFontOfSize:GMFONTSCALE(12)]
#define font13 [UIFont systemFontOfSize:GMFONTSCALE(13)]
#define font14 [UIFont systemFontOfSize:GMFONTSCALE(14)]
#define font15 [UIFont systemFontOfSize:GMFONTSCALE(15)]
#define font16 [UIFont systemFontOfSize:GMFONTSCALE(16)]
#define font17 [UIFont systemFontOfSize:GMFONTSCALE(17)]
#define font18 [UIFont systemFontOfSize:GMFONTSCALE(18)]
#define font19 [UIFont systemFontOfSize:GMFONTSCALE(19)]
#define font20 [UIFont systemFontOfSize:GMFONTSCALE(20)]
#define font21 [UIFont systemFontOfSize:GMFONTSCALE(21)]
#define font22 [UIFont systemFontOfSize:GMFONTSCALE(22)]
#define font23 [UIFont systemFontOfSize:GMFONTSCALE(23)]
#define font24 [UIFont systemFontOfSize:GMFONTSCALE(24)]
#define font25 [UIFont systemFontOfSize:GMFONTSCALE(25)]
#define font26 [UIFont systemFontOfSize:GMFONTSCALE(26)]
#define font27 [UIFont systemFontOfSize:GMFONTSCALE(27)]
#define font28 [UIFont systemFontOfSize:GMFONTSCALE(28)]
#define font29 [UIFont systemFontOfSize:GMFONTSCALE(29)]
#define font30 [UIFont systemFontOfSize:GMFONTSCALE(30)]
#define font36 [UIFont systemFontOfSize:GMFONTSCALE(36)]
#define font39 [UIFont systemFontOfSize:GMFONTSCALE(39)]
#define font40 [UIFont systemFontOfSize:GMFONTSCALE(40)]
#define font41 [UIFont systemFontOfSize:GMFONTSCALE(41)]
#define font42 [UIFont systemFontOfSize:GMFONTSCALE(42)]
#define font43 [UIFont systemFontOfSize:GMFONTSCALE(43)]
#define font44 [UIFont systemFontOfSize:GMFONTSCALE(44)]
#define ResentMonReturnTableViewCellHIGHT 70

#define boldfont16 [UIFont boldSystemFontOfSize:GMFONTSCALE(16)]
#define boldfont17 [UIFont boldSystemFontOfSize:GMFONTSCALE(17)]
#define boldfont18 [UIFont boldSystemFontOfSize:GMFONTSCALE(18)]
#define boldfont19 [UIFont boldSystemFontOfSize:GMFONTSCALE(19)]
#define boldfont20 [UIFont boldSystemFontOfSize:GMFONTSCALE(20)]
#define boldfont21 [UIFont boldSystemFontOfSize:GMFONTSCALE(21)]
#define boldfont22 [UIFont boldSystemFontOfSize:GMFONTSCALE(22)]
#define boldfont23 [UIFont boldSystemFontOfSize:GMFONTSCALE(23)]
#define boldfont24 [UIFont boldSystemFontOfSize:GMFONTSCALE(24)]
#define boldfont25 [UIFont boldSystemFontOfSize:GMFONTSCALE(25)]
#define boldfont34 [UIFont boldSystemFontOfSize:GMFONTSCALE(34)]
/****字体大小定义结束***/

#pragma mark - 自定义颜色
/****自定义颜色开始***/
#define COLOR_GRAY_333333              @"#333333"
#define COLOR_LIGHTGRAY_666666          @"#666666"
#define COLOR_LIGHTGRAY_999999          @"#999999"
#define COLOR_WHITE                     @"#ffffff"
#define COLOR_BLACK                     @"#000000"
#define COLOR_NEXTBUTTON                @"#FE5722"
/**
 *  橘黄  状态字段（表等待） 提示图标
 */
#define COLOR_YELLOW_FE5722             @"#fe5722"
//横线颜色
#define COLOR_LINE @"#E8E8E8"
//借钱须知按钮颜色
#define COLOR_LOANNOTICEBUTTON @"#4A90E2"
//下拉框选中高亮颜色
#define COLOR_PULLDOWNSELECTED @"#FF8212"
#define COLOR_LIGHTGRAY_EEEEEE          @"#eeeeee"
#define COLOR_YELLOW_FF8212             @"#ff8212"
//查看按钮颜色
#define COLOR_CHECKBUTTON @"#4A90E2"
/**
 *  APP主色调
 */
#define COLOR_MAIN_COLOR                @"#ff8212"
//alertView color
#define COLOR_BUTTONBACKGROUND @"#F18030"
#define COLOR_BUTTONTITLE @"#F4A151"

/**
 *  背景颜色
 */
#define COLOR_MAIN_BACKGOROUNDCOLOR     @"#F1F5F8"

/****自定义颜色结束***/
#define GMBUTTONHEIGHT47  47

// 保存用户的登录信息
//
#define LOGIN_PLIST @"loginPlist"

#endif /* MYFDefines_h */
