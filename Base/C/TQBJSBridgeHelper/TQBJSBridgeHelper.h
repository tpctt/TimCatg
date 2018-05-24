//
//  TQBJSBridgeHelper.h
//  taoqianbao
//
//  Created by tim on 2017/8/7.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WKWebViewJavascriptBridge.h"
#import "WebViewJavascriptBridge.h"

#import "GMSystemAuthorizationTool.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIDevice+tools.h"

#import <AdSupport/AdSupport.h>

//通讯录
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


//
#import "TQBPreviewController.h"

#import "SXAddressBookManager.h"

#import "LocationTools.h"

#import "UIImage+Rotate.h"

#import "Config.h"
#import "AppDelegate.h"
#import <TimCoreAppDelegate+myJpush.h>
#import <TimCoreAppDelegate+share.h>

#import <YMCitySelect.h>
#import "TQBShareResultViewModel.h"


@interface TQBJSBridgeHelper : NSObject < UIWebViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,ABPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate >


@property WebViewJavascriptBridge * bridge;

@property (nonatomic, strong) NSString* currentUrl;
@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, weak) BaseToWebViewController* webViewController;

///注入 js, 设置 webview 之后用
-(void)injectJSBridge;
///webViewController 的动作下穿
-(void)viewWillAppear;

-(void)unInject;

@property (nonatomic, copy) WVJBResponseCallback responseCallback;//通用,无需权限验证的
@property (nonatomic, copy) WVJBResponseCallback navbarRightBtnresponseCallback;//右上角的按钮
@property (nonatomic, copy) WVJBResponseCallback loginResponseCallback;//通用,无需权限验证的
@property (nonatomic, copy) WVJBResponseCallback regResponseCallback;//通用,无需权限验证的
@property (nonatomic, copy) WVJBResponseCallback imageResponseCallback;//照片
@property (nonatomic, copy) WVJBResponseCallback locationResponseCallback;//定位
@property (nonatomic, strong) WVJBResponseCallback phoneCallBack;//拨打电话
@property (nonatomic, strong) WVJBResponseCallback addressBookCallBack; //获取通讯录
@property (nonatomic, strong) WVJBResponseCallback shareCallBack; //分享回调
@property (nonatomic, strong) WVJBResponseCallback previewImageCallBack; // 预览回调


@property(nonatomic,strong)NSArray<SXPersonInfoEntity *>*personEntityArray;



@end
