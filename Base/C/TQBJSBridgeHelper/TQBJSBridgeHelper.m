//
//  TQBJSBridgeHelper.m
//  taoqianbao
//
//  Created by tim on 2017/8/7.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJSBridgeHelper.h"

@interface TQBJSBridgeHelper()
@property (strong,nonatomic) NSString *activePath;
@property (strong,nonatomic) UIButton *rightBtn;
@end


@implementation TQBJSBridgeHelper
- (void)viewDidLoad {
    //清理缓存
    [self deleteWebCache];
    
    
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)addSomeNotify
{
    {
        __weak typeof(self) weakSelf = self;
        
        [TQBUserObject sharedInstance].enableLoginRegNotifaction = NO;
        ///监听登录
        [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:TQBLoginNotification object:nil]
          merge:
          [[NSNotificationCenter defaultCenter]rac_addObserverForName:TQBRegNotification object:nil] ]
         
         subscribeNext:^(NSNotification * noti ) {
             
             if (weakSelf.loginResponseCallback) {
                 NSDictionary * dict = @{@"code":@"0",@"msg":@"sucess",@"data":[TQBUserObject sharedInstance].access_token?:@""};
                 weakSelf.loginResponseCallback([weakSelf DictTOjsonString:dict]);
                 weakSelf.loginResponseCallback = nil;
                 
             }
             
         }];
        
        
        ///监听注册
        [[[NSNotificationCenter defaultCenter]rac_addObserverForName:TQBRegNotification object:nil]
         
         subscribeNext:^(NSNotification * noti ) {
             
             if (weakSelf.regResponseCallback) {
                 NSDictionary * dict = @{@"code":@"0",@"msg":@"sucess",@"data":[TQBUserObject sharedInstance].access_token?:@""};
                 weakSelf.regResponseCallback([weakSelf DictTOjsonString:dict]);
                 weakSelf.regResponseCallback = nil;
                 
             }
             
         }];
        
        
    }
    
    
}
-(void)injectJSBridge
{
    [self addSomeNotify];
    
    //初始化环境和相关组件
    if (_bridge) {
        return;
    }
    /*
     WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
     configuration.userContentController = [WKUserContentController new];
     
     WKPreferences *preferences = [WKPreferences new];
     preferences.javaScriptCanOpenWindowsAutomatically = YES;
     preferences.minimumFontSize = 30.0;
     configuration.preferences = preferences;
     */
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self.webViewController];

    //注册方法
    __weak typeof(self) weakSelf = self;
    
    ///拍照
    [_bridge registerHandler:@"chooseImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"call back chooseImage:%@",data);
        weakSelf.imageResponseCallback = responseCallback;
        
        ///album 从相册选图，camera 使用相机，无数据/其他的时候 二者都允许
        NSString *source = [data objectForKey:@"sourceType"];
        if ([source isEqualToString:@"album"]) {
            [weakSelf photographAction];
            
        }else  if ([source isEqualToString:@"camera"]) {
            [weakSelf cameraAction];
            
        }else{
            //初始化AlertView
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择"
                                                            message:nil
                                                           delegate:weakSelf
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"相机",nil];
            //通过给定标题添加按钮
            [alert addButtonWithTitle:@"相册"];
            //显示AlertView
            [alert show];
        }
        
    }];
    // 预览一组图片
    [_bridge registerHandler:@"previewImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.previewImageCallBack  = responseCallback;
        
        NSDictionary * info = (NSDictionary * )data;
        NSArray * array  = [info objectForKey:@"urls"];
        TQBPreviewController  *vc = [[TQBPreviewController alloc] init];
        vc.imageArray = array;
        
        //nil判定
        [weakSelf.webViewController.navigationController pushViewController:vc animated:YES];
        
        
    }];
    
    //拨打电话
    [_bridge registerHandler:@"makePhoneCall" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"call back makePhoneCall:%@",data);
        weakSelf.phoneCallBack = responseCallback;
        
        //直接从data中解析
        
        NSDictionary * dict = (NSDictionary *)data;
        NSString * phone = [dict objectForKey:@"phoneNumber"];
        
        [weakSelf makePhoneCall:phone];
        
    }];
    
    //设置系统粘贴版内容
    [_bridge registerHandler:@"setClipboardData" handler:^(id data, WVJBResponseCallback responseCallback) {
        //直接从data中解析
        NSString  * string = (NSString *)data;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = string;
        NSLog(@"%@",pasteboard.string);
    }];
    
    
    //  获取系统剪贴板内容
    [_bridge registerHandler:@"getClipboardData" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //直接从data中解析
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        responseCallback( [weakSelf DataTOjsonString:pasteboard.string]);
    }];
    
    //获取经纬度
    [_bridge registerHandler:@"getLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"call back getLocation:%@",data);
        weakSelf.locationResponseCallback = responseCallback;
        [weakSelf locationAction];
    }];
    
    
    // 获取通讯录功能
    [_bridge registerHandler:@"getAddressBook" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.addressBookCallBack = responseCallback;
        [weakSelf getAllAddressBookInformation];
        
    }];
    
    
    // 获取通讯录功能 (获取一个通讯录)
    [_bridge registerHandler:@"getContact" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.addressBookCallBack = responseCallback;
        [weakSelf getAddressBookInformation];
        
    }];
    
    
    //登录
    [_bridge registerHandler:@"login" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.loginResponseCallback  = responseCallback;
        
        [[Config sharedInstance]gotoLogin];
        //  登录通知
        
    }];
    //注册
    [_bridge registerHandler:@"register" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.regResponseCallback  = responseCallback;
        
        NSDictionary *info = data;
        NSString *idenify = [info objectForKey:@"idenify"];
        
        [[Config sharedInstance]gotoReg];
        
    }];
    //注销
    [_bridge registerHandler:@"logout" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.responseCallback  = responseCallback;
        
        [UIAlertView showWithTitle:@"注销登录?" message: nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
                [TQBUserObject logout];
                [[NSNotificationCenter defaultCenter]postNotificationName:TQBUpdateUserInfoNotification object:nil];
                
                NSDictionary * dict = @{@"code":@"0",@"msg":@"注销成功"};
                self.responseCallback([self DictTOjsonString:dict]);
                
                
            }else{
                NSDictionary * dict = @{@"code":@"-1",@"msg":@"用户取消"};
                self.responseCallback([self DictTOjsonString:dict]);
                
                
            }
        }];
        
        
    }];
    
    //获取设备选型
    [_bridge registerHandler:@"getDeviceInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.responseCallback  = responseCallback;
        [weakSelf getDeviceInfo];
        
    }];
    //获取设备选型
    [_bridge registerHandler:@"getUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.responseCallback  = responseCallback;
        [weakSelf getUserInfo];
        
    }];
    
    //获取分享信息
    [_bridge registerHandler:@"shareInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.shareCallBack  = responseCallback;
        
        NSDictionary *info = data;
        [weakSelf shareSomeInfo:info];
        
        
    }];
    
    
    //获取协议版本
    [_bridge registerHandler:@"jsProxyVer" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.responseCallback  = responseCallback;
        
        NSDictionary * dict = @{@"code":@"0",@"msg":@"获取JS功能版本成功",@"data":@"v0.1"};
        weakSelf.responseCallback([weakSelf DictTOjsonString:dict]);
        
        
        
    }];
    
    
    
    //设置导航栏相关的代码
    [self setNavigationBar];
    
    
    
}
-(void)unInject
{
    [self.bridge setWebViewDelegate:nil];
    self.webView = nil;
    self.webViewController = nil;
    self.bridge = nil;

}


-(void)getUserInfo
{
    //app软件
    NSDictionary *appInfoDict = [[NSBundle mainBundle] infoDictionary];
    NSString*  appVersion =[NSString stringWithFormat:@"%@",  [appInfoDict objectForKey:@"CFBundleShortVersionString"]  ];
    
    NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    
    
    NSDictionary *info =
    @{@"accesstoken":[TQBUserObject sharedInstance].access_token?:@"",
      @"session_id":[BaseViewModel session_id]?:@"",
      @"registration_id":[AppDelegate shareInstance].registrationID?:@"",
      @"deviceToken":[AppDelegate shareInstance].deviceToken?:@"",
      
      
      
      @"font":@"2",
      @"channel_id":@"0",///AppStore
      @"city_id":[Config sharedInstance].cityModel.id?:@"",//假如是成都
      @"appver":appVersion,
      @"imei":idfa
      
      
      };
    
    self.responseCallback([self DataTOjsonString:info]);
    
    
}
-(void)getDeviceInfo
{
    NSDictionary *info = [self getSystemInfo:nil block:nil];
    self.responseCallback([self DataTOjsonString:info]);
    
    
}
-(void)makePhoneCall:(NSString *)phone
{
    __weak typeof(self) weakSelf = self;
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:str]]) {
        UIWebView  *  callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [weakSelf.webViewController.view addSubview:callWebview];
        weakSelf.phoneCallBack([weakSelf DataTOjsonString:@"设备支持拨打电话"]);
        
    }else{
        NSDictionary * dict = @{@"code":@"-1",@"msg":@"设备不支持拨打电话"};
        weakSelf.phoneCallBack([weakSelf DictTOjsonString:dict]);
        
    }
    
}
//
///获取系统信息
-(NSMutableDictionary*)getSystemInfo:(BOOL)flag block:(void (^)(NSMutableDictionary*))block
{
    static  NSMutableDictionary *staticInfo ;
    if(staticInfo) return staticInfo;
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary ];
    //系统
    NSString *systemName = [UIDevice currentDevice].systemName;
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    NSString *freeDiskSpaceInMB = [UIDevice freeDiskSpaceInMB];
    
    
    NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    
    
    //硬件
    
    NSString *platform = [UIDevice platformString];
    NSString *screenSize = NSStringFromCGSize([UIScreen mainScreen].bounds.size);
    //    NSString *screenScale = @([UIScreen mainScreen].scale).stringValue;
    
    
    NSString *CPUType = [UIDevice getCPUTypeString];
    NSString *batteryLevel = @([UIDevice currentDevice].batteryLevel).stringValue;
    
    
    //网络
    NSString *deviceSSID = [UIDevice getDeviceSSID];
    NSString *macAddress = [UIDevice getMacAddress];
    NSString *SIMcarrier = [UIDevice getSIMcarrier];
    
    //2/3/4g
    NSString *netWorkType = [UIDevice getNetWorkType];
    
    
    //app软件
    NSDictionary *appInfoDict = [[NSBundle mainBundle] infoDictionary];
    NSString*  appVersion =[NSString stringWithFormat:@"%@",  [appInfoDict objectForKey:@"CFBundleShortVersionString"]  ];
    
    
    
    
    
    ///系统——
    [info setObject:systemName forKey:@"system_name"];
    [info setObject:systemVersion forKey:@"osVer"];
    
    
    
    
    
    ///硬件——
    [info setObject:platform forKey:@"platform"];
    
    
    ///网络——
    if(deviceSSID)
        [info setObject:deviceSSID  forKey:@"wifissid"];
    if(macAddress)
        [info setObject:macAddress  forKey:@"macAddress"];
    if(SIMcarrier)
        [info setObject:SIMcarrier  forKey:@"SIMcarrier"];
    if(netWorkType)
        [info setObject:netWorkType  forKey:@"netWorkType"];
    
    
    
    
    [info setObject:idfa forKey:@"imei"];
    
    [info setObject:appVersion forKey:@"appVer"];
    
    
    
    
    
    
    staticInfo = info;
    return info;
    
}
-(void)setNavigationBar
{
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(BaseToWebViewController) *weakWebVC = self.webViewController;
    
    [_bridge registerHandler:@"setNavigationBarTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.responseCallback  = responseCallback;
        
        NSDictionary * info = (NSDictionary * )data;
        weakWebVC.title = [info objectForKey:@"title"];
        
        
        
    }];
    
    [_bridge registerHandler:@"setNavigationBarColor" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.responseCallback  = responseCallback;
        
        NSDictionary * info = (NSDictionary * )data;
        NSString * frontColor = [info objectForKey:@"frontColor"];
        NSString * backgroundColor = [info objectForKey:@"backgroundColor"];
        
        //TODO 通用的 navbar 配置
        
        GJW_NavigationBar *bar = [weakWebVC.navigationController navigationBar];
        [bar gjw_setBackgroundColor:[weakSelf colorWithHexString:backgroundColor alpha:1]];
        [bar gjw_setTitleAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[self colorWithHexString:frontColor alpha:1]}];
        [bar gjw_setShadowImage:nil];
        
        
        //        [weakWebVC.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[self colorWithHexString:frontColor alpha:1]}] ;
        //        weakWebVC.navigationController.navigationBar.barTintColor = [self colorWithHexString:backgroundColor alpha:1];
        
        
    }];
    
    [_bridge registerHandler:@"showNavigationBar" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.responseCallback  = responseCallback;
        
        weakWebVC.navigationController.navigationBarHidden = NO;
        
    }];
    
    
    [_bridge registerHandler:@"hideNavigationBar" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.responseCallback  = responseCallback;
        
        weakWebVC.navigationController.navigationBarHidden = YES;
        
    }];
    
    //    给右上角设置一个按钮,方便网页实现对应的功能
    [_bridge registerHandler:@"setNavbarRightBtn" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.navbarRightBtnresponseCallback  = responseCallback;
        NSDictionary * info = (NSDictionary * )data;
        [weakSelf setNavBarRightBtn:info];
        
    }];
    
    
    [self setWeb];
    
    
    [RACObserve(self.webViewController.navigationItem, rightBarButtonItem)subscribeNext:^(id x) {
        
    }];
    [RACObserve(self.webViewController.navigationItem, rightBarButtonItems)subscribeNext:^(id x) {
        
    }];
}
-(void)setCurrentUrl:(NSString *)currentUrl
{
    if (_currentUrl == currentUrl) {
        return;
    }
    _currentUrl = currentUrl;
    
    [self checkRightBtnState];
    
}
-(void)viewWillAppear
{
    [self checkRightBtnState];
    
}
-(void)checkRightBtnState{
    
    if (self.activePath && [self.currentUrl hasPrefix:self.activePath]) {
        ///add
//        self.webViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView: self.rightBtn ];

        
        if (self.rightBtn) {
            NSMutableArray *rightItems = [self.webViewController.navigationItem.rightBarButtonItems mutableCopy];
            if (rightItems == nil) {
                rightItems = [NSMutableArray array];
                
            }
            
            
            UIBarButtonItem *temp = nil;
            
            for (UIBarButtonItem *item in rightItems ) {
                if (item.customView == self.rightBtn) {
                    temp = item;
                    break;
                }
            }
            
            
            
            
            
            if (temp) {
            
            }else{
                [rightItems addObject:[[UIBarButtonItem alloc]initWithCustomView: self.rightBtn ]];
                self.webViewController.navigationItem.rightBarButtonItems = rightItems;
                
            }
        }
        
     
    
    }else{
        ///清除
        if (self.rightBtn) {
            NSMutableArray *rightItems = [self.webViewController.navigationItem.rightBarButtonItems mutableCopy];
            if (rightItems == nil) {
                rightItems = [NSMutableArray array];
                
            }
            
            UIBarButtonItem *temp = nil;
            
            for (UIBarButtonItem *item in rightItems ) {
                if (item.customView == self.rightBtn) {
                    temp = item;
                    break;
                }
            }
            
            if (temp) {
                [rightItems removeObject:temp];
                self.webViewController.navigationItem.rightBarButtonItems = rightItems;
            }
        }
        
    }
    
}
//    给右上角设置一个按钮,方便网页实现对应的功能
-(void)setNavBarRightBtn:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    
    NSString * frontColor = [info objectForKey:@"frontColor"]; //文本颜色
    NSString * title = [info objectForKey:@"title"]; //文本
    NSString * imageUrl = [info objectForKey:@"imageUrl"];//按钮图片
    NSString * activePath = [info objectForKey:@"activePath"];//按妞 有效的 url 前缀
    
    
    if (self.rightBtn) {
        NSMutableArray *rightItems = [self.webViewController.navigationItem.rightBarButtonItems mutableCopy];
        UIBarButtonItem *temp = nil;
        
        for (UIBarButtonItem *item in rightItems ) {
            if (item.customView == self.rightBtn) {
                temp = item;
                break;
            }
        }
        
        if (temp) {
            [rightItems removeObject:temp];
            self.webViewController.navigationItem.rightBarButtonItems = rightItems;
        }
    }
    
    
    
    UIButton *rightBtn = [[UIButton alloc] initNavigationButtonWithTitle:title color:[UIColor colorWithString:frontColor]];
    [rightBtn addTarget:self action:@selector(navbrRightBtnAct:) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    ///有 imageurl 只显示 imageUrl
    if (imageUrl.length) {
        [rightBtn setTitle:@"" forState:0];
        [rightBtn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:0];
        
    }
    
    
    
    
    
    self.activePath = activePath;
    self.rightBtn = rightBtn;
    
    
    
    
    //    self.webViewController.rightBtn = rightBtn;
    [self checkRightBtnState];
    
    
}

-(void)navbrRightBtnAct:(UIButton*)sender
{
    [_bridge callHandler:@"setNavbarRightBtn2" data:@"uid:123 pwd:123" responseCallback:^(id responseData) {
        NSLog(@"oc请求js后接受的回调结果：%@",responseData);
    }];
}


-(void)setWeb
{
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(BaseToWebViewController) *weakWebVC = self.webViewController;
    
    [_bridge registerHandler:@"navigateTo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary * info = (NSDictionary * )data;
        
        NSString * url = [info objectForKey:@"url"];
        
        
        //        NSRange range = [url rangeOfString:@"taoqian123"];
        
        //        if(range.location != NSNotFound)
        
        //        {
        
        BaseToWebViewController * vc  = [[BaseToWebViewController alloc] initWithURLString:url];
        //        vc.url = url;
        [weakWebVC.navigationController pushViewController:vc animated:YES];
        
        
        //        }else{
        
        
        //        }
        
        
    }];
    
    
    [_bridge registerHandler:@"redirectTo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary * info = (NSDictionary * )data;
        
        NSString * url = [info objectForKey:@"url"];
        
        
        //        NSRange range = [url rangeOfString:@"taoqian123"];
        //
        //        if(range.location != NSNotFound)
        //
        //        {
        
        NSString* htmlPath = url;
        NSURL *baseURL = [NSURL URLWithString:htmlPath];
        [weakSelf.webView loadRequest:[NSMutableURLRequest requestWithURL:baseURL]];
        //
        //        }else{
        //
        //
        //
        //
        //        }
    }];
    
    [_bridge registerHandler:@"navigateBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [weakWebVC clsoeItemAct:nil];
//        [weakWebVC.navigationController popViewControllerAnimated:YES];
        
    }];
    
}



- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

-(void)shareSomeInfo:(NSDictionary *)dict
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(BaseToWebViewController) *weakWebVC = self.webViewController;
    
    
    NSString *title = [dict objectForKey:@"title"];
    NSString *content = [dict objectForKey:@"text"];
    NSString *imageUrl = [dict objectForKey:@"image"];
    NSString *herf = [dict objectForKey:@"url"];
    //获取分享 id
    NSString *count = [dict objectForKey:@"count"];
    
    imageUrl = [imageUrl urldecode];
    herf = [herf urldecode];
    
    if(!self.webViewController.shareModel){
        self.webViewController.shareModel = [[TQBShareResultViewModel alloc] init];
        
    }
    
    
    if(title && content && imageUrl && herf ){
        
        [[AppDelegate shareInstance]shareInfo:title content:content image:imageUrl url:herf actionSheet:self.webViewController.rightBtn onShareStateChanged:^(BOOL sucess, NSString *msg) {
            
            if (sucess == YES) {
                if (count) {
                    weakSelf.webViewController.shareModel.para = count;
                    [weakSelf.webViewController.shareModel.command execute:nil];
                    
                }
                NSDictionary * dict = @{@"code":@"0",@"msg":@"分享成功"};
                weakSelf.shareCallBack([weakSelf DictTOjsonString:dict]);
                
            }else{
                NSDictionary * dict = @{@"code":@"-1",@"msg": msg?:@""};
                weakSelf.shareCallBack([weakSelf DictTOjsonString:dict]);
                
            }
            
        } activePlatforms:nil];
    }else{
        NSDictionary * dict = @{@"code":@"-1",@"msg":@"分享数据缺失"};
        self.shareCallBack([weakSelf DictTOjsonString:dict]);
        
    }
}

-(void)getAllAddressBookInformation
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(BaseToWebViewController) *weakWebVC = self.webViewController;
    
    
    SXAddressBookAuthStatus status = [[SXAddressBookManager manager]getAuthStatus];
    if (status == kSXAddressBookAuthStatusNotDetermined) {
        
        [[SXAddressBookManager manager]askUserWithSuccess:^{
            weakSelf.personEntityArray = [[SXAddressBookManager manager]getPersonInfoArray];
        } failure:^{
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"借钱快未获取通讯录权限" message:@"请在系统设置中允许“借钱快”访问通讯录\n 设置-> 隐私-> 通讯录 -> 借钱快" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertViewController addAction:cancelAction];
            [alertViewController addAction:confirmAction];
            [weakSelf.webViewController presentViewController:alertViewController animated:YES completion:nil];
        }];
        
    }else if (status == kSXAddressBookAuthStatusAuthorized){
        
        self.personEntityArray = [[SXAddressBookManager manager]getPersonInfoArray];
        
        NSMutableArray *data = [NSMutableArray array];
        
        for (NSInteger i = 0;  i < self.personEntityArray.count; i++) {
            
            SXPersonInfoEntity * person = [self.personEntityArray objectAtIndex:i];
            NSArray * phones = [person.phoneNumber?:@"" componentsSeparatedByString:@"."];
            [data addObject:@{@"username":person.fullname?:@"",@"phones":phones}];
            
        }
        _addressBookCallBack([weakSelf DataTOjsonString:data]);
        
    }else{
        NSLog(@"没有权限");
    }
    
}

-(void)getAddressBookInformation{
    
    __weak typeof(self) weakSelf = self;
    
    [GMSystemAuthorizationTool checkAddressBookAuthorization:^(bool isAuthorized, ABAuthorizationStatus authorStatus) {
        
        if (isAuthorized) {
            
            
            [[SXAddressBookManager manager]presentPageOnTarget:self.webViewController chooseAction:^(SXPersonInfoEntity *person) {
                
                
                if (person.phoneNumber.length) {
                    
                }
                
                NSArray * phones = [person.phoneNumber componentsSeparatedByString:@"."];
                NSArray * arrary = [NSArray arrayWithObjects:@{@"username":person.fullname,@"phones":phones}, nil];
                
                _addressBookCallBack([weakSelf DataTOjsonString:arrary]);
                
            }];
        } else {
            
            // 请求授权
            ABAddressBookRef addressBookRef = ABAddressBookCreate();
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                if (granted) { // 授权成功
                    
                } else {  // 授权失败
                    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"借钱快未获取通讯录权限" message:@"请在系统设置中允许“借钱快”访问通讯录\n 设置-> 隐私-> 通讯录 -> 借钱快" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }];
                    [alertViewController addAction:cancelAction];
                    [alertViewController addAction:confirmAction];
                    [weakSelf.webViewController presentViewController:alertViewController animated:YES completion:nil];
                }
            });
            
        }
        
    }];
}


#pragma mark - events handle
-(void)photographAction
{
    __weak typeof(self) weakSelf = self;
    
    //打开相册
    [GMSystemAuthorizationTool checkPhotographAlbumAuthorization:^(bool isAuthorized) {
        if (isAuthorized) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
                    pickerViewController.delegate = weakSelf;
                    pickerViewController.allowsEditing = NO;
                    pickerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    weakSelf.webViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [weakSelf.webViewController presentViewController:pickerViewController animated:YES completion:nil];
                });
            }else{
                NSDictionary * dict = @{@"code":@"-1",@"msg":@"设备不支持相册"};
                weakSelf.responseCallback([weakSelf DictTOjsonString:dict]);
                
            }
        } else {
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"借钱快未获取相册权限" message:@"请在系统设置中允许“借钱快”访问相册\n 设置-> 隐私-> 相册 -> 借钱快" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertViewController addAction:cancelAction];
            [alertViewController addAction:confirmAction];
            [weakSelf.webViewController presentViewController:alertViewController animated:YES completion:nil];
        }
    }];
    
    
}

-(void)cameraAction
{
    __weak typeof(self) weakSelf = self;
    
    //打开相机
    [GMSystemAuthorizationTool checkCameraAuthorization:^(bool isAuthorized, AVAuthorizationStatus authorStatus) {
        if (isAuthorized) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
                    pickerViewController.delegate = weakSelf;
                    pickerViewController.allowsEditing = NO;
                    pickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    weakSelf.webViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [weakSelf.webViewController presentViewController:pickerViewController animated:YES completion:nil];
                });
                
            }else{
                NSDictionary * dict = @{@"code":@"-1",@"msg":@"设备不支持相机"};
                
                weakSelf.imageResponseCallback([weakSelf DictTOjsonString:dict]);
                
            }
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"借钱快获取相机权限" message:@"请在系统设置中允许“借钱快”访问相机\n 设置-> 隐私-> 相机 -> 借钱快" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *concelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //                [self.webViewController.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:concelAction];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertController addAction:confirmAction];
            [weakSelf.webViewController presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
    
    
}
-(void)locationAction
{
    __weak typeof(self) weakSelf = self;
    
    NSLog(@"locationAction");
    //获取经纬度
    [GMSystemAuthorizationTool checkLocationAuthorization:^(bool isAuthorized, CLAuthorizationStatus status) {
        if (isAuthorized) {
            [[LocationTools sharedInstance] getCurrentLocation:^(CLLocation *location, CLPlacemark *pl, NSString *error, BOOL loading) {
                if (pl.locality.length > 0) {
                    
                    
                    NSString * latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
                    
                    NSString * longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
                    
                    NSString *sheng  = pl.administrativeArea;
                    NSString *shi  = pl.locality;
                    NSString *qu  = pl.subLocality;
                    NSString *street  = pl.name;
                    
                    NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@",sheng,shi,qu,street];
                    
                    NSDictionary *info = @{@"latitude":latitude,@"longitude":longitude,@"address":address,
                                           @"addressDetail":@{@"province":sheng,@"city":shi,@"region":qu,@"street":street}};
                    
                    weakSelf.locationResponseCallback([weakSelf DataTOjsonString:info]);
                    
                }
            }];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"借钱快获取位置权限" message:@"请在系统设置中允许“借钱快”访问位置\n 设置-> 隐私-> 位置 -> 借钱快" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *concelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //                [self.webViewController.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:concelAction];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertController addAction:confirmAction];
            [weakSelf.webViewController presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
    
}


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image = [[UIImage alloc] init];
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        if (picker.allowsEditing == YES) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        NSLog(@"是竖屏");
    } else {
        NSLog(@"不是竖屏");
    }
    NSLog(@"image.size = %@",[NSValue valueWithCGSize:image.size]);
    [self handlePicture:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - hundle picture
-(void)handlePicture:(UIImage *)image
{
    image = [image fixOrientation:image];
    //    image = [image rotate:UIImageOrientationLeft];
    //    image = [image imageRotatedByDegrees:0.0f];
    //    NSLog(@"image.size1 = %@",[NSValue valueWithCGSize:image.size]);
    NSData *data = UIImageJPEGRepresentation(image, 0.1f);
    NSString *base64String = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //    NSLog(@"base64String = %@",base64String);
    
    self.imageResponseCallback([self DataTOjsonString:base64String]);
}

#pragma mark - compress iamge
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    if (newSize.width == 0) {
        newSize = image.size;
    }
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - WKNavigationDelegate



#pragma mark - KVO


#pragma mark - delete web cache
-(void)deleteWebCache
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        NSArray *types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@",cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}
#pragma mark - loginout delegate

-(void)didLogin:(id)data
{
    NSDictionary * dict = @{@"code":@"0",@"msg":@"sucess",@"data":data?:@""};
    self.responseCallback([self DictTOjsonString:dict]);
    
}
-(void)didRecevieMsg:(NSString *)msg
{
    NSDictionary * dict = @{@"code":@"-1",@"msg":msg?:@"error"};
    self.responseCallback([self DictTOjsonString:dict]);
    
}
#pragma mark -- A
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld,",(long)buttonIndex);
    
    if (buttonIndex == 1) {
        [self cameraAction];
        
        
    }else if (buttonIndex  == 2){
        [self photographAction];
        
        
    }
    
}


#pragma mark -- ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    //电话号码
    CFStringRef telValue = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    //读取firstname
    //获取个人名字（可以通过以下两个方法获取名字，第一种是姓、名；第二种是通过全名）。
    //第一中方法
    //    CFTypeRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    //    CFTypeRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    //    //姓
    //    NSString * nameString = (__bridge NSString *)firstName;
    //    //名
    //    NSString * lastString = (__bridge NSString *)lastName;
    //第二种方法：全名
    CFStringRef anFullName = ABRecordCopyCompositeName(person);
    
    _addressBookCallBack([NSString stringWithFormat:@"%@, %@",telValue,anFullName]);
    
    [self.webViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

///组装数据
-(NSString*)DataTOjsonString:(NSObject * )object
{
    NSDictionary * dict = @{@"code":@"0",@"msg":@"sucess",@"data":object};
    return [self DictTOjsonString:dict];
    
}
//json 字符串
-(NSString*)DictTOjsonString:(NSObject * )dict
{
    
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    
    //    NSData * getJsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    //    NSDictionary * getDict = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:&error];
    
    //    NSString * string = [getDict objectForKey:@"data"];
    //
    //    //Base64字符串转UIImage图片：
    //    NSData *decodedImgData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //    UIImage *decodedImage = [UIImage imageWithData:decodedImgData];
    //
    //
    //    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    //    imgV.contentMode = UIViewContentModeScaleAspectFit;
    //    [imgV setImage:decodedImage];
    //    [self.view addSubview:imgV];
    
    
    return jsonString;
}


@end
