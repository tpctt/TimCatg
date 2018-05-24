//
//  BaseToWebViewController.m
//  taoqianbao
//
//  Created by tim on 16/9/25.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "BaseToWebViewController.h"
#import "UIViewController+Funcs.h"

#import "BaseListViewModel.h"
#import <TimCoreAppDelegate+share.h>

#import "TQBShareResultViewModel.h"
#import "WebViewURLProtocol.h"
#import "TQBJSBridgeHelper.h"

#import <NJKWebViewProgress.h>
#import "KH_msg_tabbar_ViewController.h"
#import "KHXShareManager.h"
#import "FunImageDetailObject.h"

// Controllers

// Model

// Views


//#define <#macro#> <#value#>


@interface BaseToWebViewController ()<NJKWebViewProgressDelegate>

//@property (nonatomic, strong) <#type#> *<#name#>
{
    ///维护自定义 header 的 historylist
    NSMutableArray *_historyList; //堆栈
    NSMutableURLRequest *_preRequest;
    NSInteger _historyIndex ; ///指针
    
    UIButton *backBtn;
    
}



@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) TQBJSBridgeHelper *jsBridgeHelper;
@property (nonatomic,strong) NJKWebViewProgress *progressManager222;

@end

@implementation BaseToWebViewController


#pragma mark - View Controller LifeCyle
-(void)webviewDidClose
{
    [self.jsBridgeHelper unInject];
    self.progressManager222.progressDelegate = nil;
    self.progressManager222 = nil;
    
}
static bool modelVC = NO;
-(void)jumpToWebFrom:(UIViewController *)vc vcIsNav:(BOOL)vcIsNav
{
    [self jumpToWebFrom:vc vcIsNav:vcIsNav withAddress:nil];
}

-(void)jumpToWebFrom:(UIViewController *)vc vcIsNav:(BOOL)vcIsNav  withAddress:(NSString *)address
{
    
//    NSArray *aa = @[];
//    NSLog(@"%@",[aa objectAtIndex:4]);
    
    
    address = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)address, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

    if(address.length == 0){
        
        return;
    }
    
    self.url = [NSURL URLWithString:address];
    
    GCD_main(
        if( modelVC ){

            BaseNavViewController *nav = [[BaseNavViewController alloc] initWithNavigationBarClass:[GJW_NavigationBar class] toolbarClass:nil];
            nav.viewControllers = @[self];

            
            [vc presentViewController:nav animated:1 completion:^{
                
            }];
            
        }else{
            if ([vc isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController*)vc;
                [nav pushViewController:self animated:1];
            }else{
                [[AppDelegate shareInstance].navVC pushViewController:self animated:1];
            }
        }
    )
    
    
    
    
}
-(void)closeWebView
{
    if( modelVC ){
        [self.navigationController dismissViewControllerAnimated:1 completion:^{
            
        }];
        
    }else{
        [self.navigationController popViewControllerAnimated:1];
        
    }
    [self webviewDidClose];
}

///分享到3方数据
-(void)shareInfo:(NSString *)url
{
//    tqb://shareInfo?title=aa&&content=bb&&imageUrl=encode的 URL1 &&herf=encode的 URL2
    NSURL *url2 = [NSURL URLWithString:url];
    NSDictionary *dict = [url2 params];
    if (dict.allKeys.count == 0) {
        url2 = [NSURL URLWithString:[url2.absoluteString urldecode  ]];
        dict =  [url2 params];
    }
    
    NSString *title = [dict objectForKey:@"title"];
    NSString *content = [dict objectForKey:@"content"];
    NSString *imageUrl = [dict objectOfAny:@[@"image",@"imageUrl"]];
    NSString *herf = [dict objectForKey:@"href"];
    //获取分享 id
    NSString *count = [dict objectForKey:@"count"];
    
    imageUrl = [imageUrl urldecode];
    herf = [herf urldecode];
    
    if(!self.shareModel){
        self.shareModel = [[TQBShareResultViewModel alloc] init];
        
    }
    

    if(title && content && imageUrl && herf ){
        
        [[AppDelegate shareInstance]shareInfo:title content:content image:imageUrl url:herf actionSheet:self.rightBtn onShareStateChanged:^(BOOL sucess, NSString *msg) {
            
            if (sucess == YES) {
                if (count) {
                    self.shareModel.para = count;
                    [self.shareModel.command execute:nil];
                    
                }
            }
        } activePlatforms:nil];
    }
}
///分享到3方数据
-(void)shareInfoImage:(NSString *)url
{
    //    tqb://shareInfo?title=aa&&content=bb&&imageUrl=encode的 URL1 &&herf=encode的 URL2
    NSURL *url2 = [NSURL URLWithString:url];
    NSDictionary *dict = [url2 params];
    if (dict.allKeys.count == 0) {
        url2 = [NSURL URLWithString:[url2.absoluteString urldecode  ]];
        dict =  [url2 params];
    }
    
    NSString *title = [dict objectForKey:@"title"];
    NSString *content = [dict objectForKey:@"content"];
    NSString *imageUrl = [dict objectOfAny:@[@"image",@"imageUrl"]];
    NSString *herf = [dict objectForKey:@"href"];
    //获取分享 id
    NSString *count = [dict objectForKey:@"count"];
    
    imageUrl = [imageUrl urldecode];
    herf = [herf urldecode];
    
    
    FunImageShareObject *OBJ = [FunImageShareObject new];
    OBJ.title = title;
    OBJ.content = content;
    OBJ.image = imageUrl;
    OBJ.href = herf;
    OBJ.count = count;
    
    
    [[KHXShareManager sharedInstance]shareWith:OBJ from:self.rightBtn isImage:YES];
    
}

///打开一个新网页
-(void)openWebUrl:(NSString *)url
{
    NSURL *url2 = [NSURL URLWithString:url];
    NSDictionary *dict = [url2 params];
    if (dict.allKeys.count == 0) {
        url2 = [NSURL URLWithString:[url2.absoluteString urldecode  ]];
        dict =  [url2 params];
    }
    NSString *herf = [dict objectForKey:@"url"];
    
    BaseToWebViewController *webVC = [[BaseToWebViewController alloc] initWithURLString:herf];
    
    [self.navigationController pushViewController:webVC animated:YES];
    
    
}
///去登录
-(void)jumpToLogin:(NSString *)url
{
    
    
    NSURL *url2 = [NSURL URLWithString:url];
    NSDictionary *dict = [url2 params];
    if (dict.allKeys.count == 0) {
        url2 = [NSURL URLWithString:[url2.absoluteString urldecode  ]];
        dict =  [url2 params];
    }
    NSString *access_token = [dict objectForKey:@"access_token"];
    
    if(access_token.length){
     
        [TQBUserObject sharedInstance].access_token = access_token;
        return;
    }
    
    if( modelVC ){
//        [self.navigationController dismissViewControllerAnimated:1 completion:^{
//            
//        }];
        
        
    }else{
//        [self.navigationController popViewControllerAnimated:1];
        TQBLoginViewController *loginVC = [[TQBLoginViewController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:1];
        
        [self addNotifaction_login];
        
        
    }
//    [self webviewDidClose];
    
    
    
}
//打开产品详情页
-(void)openProductView:(NSString *)url
{
    
    NSURL *url2 = [NSURL URLWithString:url];
    NSDictionary *dict = [url2 params];
    if (dict.allKeys.count == 0) {
        url2 = [NSURL URLWithString:[url2.absoluteString urldecode  ]];
        dict =  [url2 params];
    }
    NSString *id = [dict objectForKey:@"id"];
    NSString *idenifer = [dict objectForKey:@"idenifer"];
    
   
    
}
///打开经理详情页
-(void)openDirectorView:(NSString *)url
{
    
    NSURL *url2 = [NSURL URLWithString:url];
    NSDictionary *dict = [url2 params];
    if (dict.allKeys.count == 0) {
        url2 = [NSURL URLWithString:[url2.absoluteString urldecode  ]];
        dict =  [url2 params];
    }
    NSString *id = [dict objectForKey:@"id"];
    
    
   
}
///打开信用卡详情页
-(void)openCreditCardView:(NSString *)url
{
    
    NSURL *url2 = [NSURL URLWithString:url];
    NSDictionary *dict = [url2 params];
    if (dict.allKeys.count == 0) {
        url2 = [NSURL URLWithString:[url2.absoluteString urldecode  ]];
        dict =  [url2 params];
    }
    NSString *id = [dict objectForKey:@"id"];
    
  
    
    
}
///打开推送设置
-(void)open_push_set:(NSString *)url
{
    
    NSURL *url2 = [NSURL URLWithString:url];
    NSDictionary *dict = [url2 params];
    if (dict.allKeys.count == 0) {
        url2 = [NSURL URLWithString:[url2.absoluteString urldecode  ]];
        dict =  [url2 params];
    }
    NSString *id = [dict objectForKey:@"id"];
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

    }
    
    
}
///打开优惠券
-(void)openYouhuiquan:(NSString *)url
{
    
    NSURL *url2 = [NSURL URLWithString:url];
    NSDictionary *dict = [url2 params];
    if (dict.allKeys.count == 0) {
        url2 = [NSURL URLWithString:[url2.absoluteString urldecode  ]];
        dict =  [url2 params];
    }
    NSString *id = [dict objectForKey:@"id"];
    
    [[Config sharedInstance] gotoInquiryWith:self.view];
    
    
}
///打开消息列表
-(void)openmsg:(NSString *)url
{
    
    NSURL *url2 = [NSURL URLWithString:url];
    NSDictionary *dict = [url2 params];
    if (dict.allKeys.count == 0) {
        url2 = [NSURL URLWithString:[url2.absoluteString urldecode  ]];
        dict =  [url2 params];
    }
    NSString *index = [dict objectForKey:@"index"];
    
    if([TQBUserObject isLoged ] == NO   ){
        [[Config sharedInstance]gotoLogin];
        return;
    }
    
    KH_msg_tabbar_ViewController *vc =[[KH_msg_tabbar_ViewController alloc] init];
    vc.index = [index integerValue];
    [self.navigationController pushViewController:vc animated:1];

}


-(void)addNotifaction_login
{
    @weakify(self);
    [TQBUserObject sharedInstance].enableLoginRegNotifaction = NO;
    ///监听登录
    [[[[[NSNotificationCenter defaultCenter]rac_addObserverForName:TQBLoginNotification object:nil]
       merge:
       [[NSNotificationCenter defaultCenter]rac_addObserverForName:TQBRegNotification object:nil] ] take:1]
     
     subscribeNext:^(NSNotification * noti ) {
         @strongify(self);

         [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
         return ;

//         NoticeUserInfoType type = [noti.name isEqualToString:TQBRegNotification]? NoticeUserInfoType_REG:NoticeUserInfoType_LOG ;
         
         NSMutableDictionary *header= [[_preRequest allHTTPHeaderFields] mutableCopy];
//         [header removeObjectForKey:@"front"];
         
         
         
         NSDictionary *baseInfo  = [BaseViewModel addBaseInfo:nil forWeb:YES];
         for (NSString *key in [baseInfo allKeys] ) {
             [_preRequest  addValue:[baseInfo objectForKey:key] forHTTPHeaderField:key];
             
         }
         _preRequest.allHTTPHeaderFields =  header;
         
         
         
//         [self.webView.scrollView.mj_header beginRefreshing];
         
         [self.webView loadRequest:_preRequest];
         
         
         
     }];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}   
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showUrlWhileLoading = NO;
        
    }
    return self;
}

-(instancetype)initWithURLString:(NSString *)urlString
{
    self = [super initWithURLString:urlString];
    if (self) {
        self.showUrlWhileLoading = NO;
        
    }
    return self;
}

-(instancetype)initWithURL:(NSURL *)url
{
    self = [super initWithURL:url];
    if (self) {
        self.showUrlWhileLoading = NO;
        
    }
    return self;
}



-(void)initJsBridgeHelper
{
    self.jsBridgeHelper = [[TQBJSBridgeHelper alloc] init];
    self.jsBridgeHelper.webView = self.webView;
    self.jsBridgeHelper.webViewController = self;
    [self.jsBridgeHelper injectJSBridge];
    
    
}

- (void)showPlaceholderTitle
{
    [super showPageTitles];
    if ([self.title hasPrefix:@"http"] || [self.title hasPrefix:@"Loading"]) {
        self.title = @"";
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // 注册拦截请求的NSURLProtocol
//    [NSURLProtocol registerClass:[WebViewURLProtocol class]];
    
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    
    [self initialNavigationBar];
    
    [self setCustomBackItem];
    
    [self disableWebCache:YES];
    
    ///whoxx 全线去掉这个功能
//    [self addMJHeaderOnWebView];
    
    [self setBackAsWhite:YES];
    
    [self initJsBridgeHelper];
    
    ///避免 js/progress 冲突
    self.progressManager222 = [self valueForKeyPath:@"_progressManager"];
    self.progressManager222.webViewProxyDelegate = nil;
    
    NSLog(@"%@,,",[self valueForKeyPath:@"_progressManager"]);
    
    
    _historyList = [NSMutableArray array  ];
    
    [self.closeBtn setTitle:nil forState:UIControlStateSelected];
    [self.closeBtn setImage:[UIImage imageNamed:@"tag_btn_close_del.png"] forState:UIControlStateSelected];
    
    @weakify(self);
    [RACObserve(self.webView, loading)subscribeNext:^(id x) {
        @strongify(self);
        self.closeBtn.selected = self.webView.loading;
        
    }];
    
    self.rightBtn = [[UIButton alloc] init];
    self.rightBtn.titleLabel.font = MYFONT(15);

    //分享功能
    
    [ self.shareModel.command.executing subscribeNext:^(NSNumber *executing) {
        
        
    }];
    
    
    
    
    [ [self.shareModel.command.errors deliverOnMainThread] subscribeNext:^(NSError *error) {
        
        SHOWMSG(error.localizedDescription);
        
    }];
    
    
    [[self.shareModel.command.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id x) {
        
        
    }];
    

    [self setNavBarShowWithAlpha:NO];
    [self setBackAsWhite:YES];
    
    
    GJW_NavigationBar *bar = [self.navigationController navigationBar];
    [bar gjw_setBackgroundColor:[self navigationBarInColor]];
    [bar gjw_setTitleAttributes:[self navigationTitleAttributes]];
    [bar gjw_setShadowImage:[self navigationBarShadowImage]];
    
    
    
#ifdef __IPHONE_11_0
    
    if (@available(iOS 11.0, *) ){
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if ([UIDevice isPhoneX]) {
            self.webView.scrollView.contentInset = UIEdgeInsetsMake(88, 0, 40, 0);//导航栏如果使用系统原生半透明的，top设置为64
            
        }else{
            self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);//导航栏如果使用系统原生半透明的，top设置为64
            
        }
        self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
        //            self.webView.mj_y = 20 ;
        //            self.webView.mj_h -= 20 ;
        
    }
    
#else
    
#endif
    
    ///强制处理显示 title,
    self.didFinishLoadHandler = ^(UIWebView *webView) {
        @strongify(self);
        [self webViewProgress:self.progressManager222 updateProgress:1];
        
    };
    
    self.navigationButtonsHidden = YES;
    
}

//下拉刷新
-(void)addMJHeaderOnWebView
{
    @weakify(self);
    
    //下拉刷新
    self.webView.scrollView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        @strongify(self);
        
        [self.webView reload];
        //        [self.webView.scrollView.mj_header endRefreshing];
        [self.webView.scrollView.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:1 ];
        
    }];
    self.navigationButtonsHidden = YES;
    
    
}
//禁用缓存?
-(void)disableWebCache:(BOOL)disable
{
    if (disable) {
        //禁用缓存
        self.urlRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        
    }
}

///使用自定义的返回按钮
-(void)setCustomBackItem
{
    
    //    self.navigationButtonsHidden = YES;
    //    self.showDoneButton
    self.applicationLeftBarButtonItems = @[[self backBarButtonItem],[self closeBarButtonItem] ];
    
    //    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    @weakify(self);
    self.navigationItem.leftItemsSupplementBackButton = NO;
    [RACObserve(self.navigationItem, leftItemsSupplementBackButton)subscribeNext:^(id x) {
        @strongify(self);
        if(self.navigationItem.leftItemsSupplementBackButton) self.navigationItem.leftItemsSupplementBackButton=  NO;
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
        
        if(self.rightBtn){
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
            
            
        }
        
        
    }];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    self.navigationItem.leftItemsSupplementBackButton = NO;

    
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    self.navigationItem.leftItemsSupplementBackButton = NO;
    [self.jsBridgeHelper viewWillAppear];
    
    
}

-(UIBarButtonItem *)backBarButtonItem{
    UIBarButtonItem *item ;
    if (item) {
        return item;
    }
    
    if (!item) {
        //        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:NULL];
        
        UIImage *image  = [[UIImage imageNamed:@"nav_return.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        backBtn = [[UIButton alloc] initNavigationButton:image];
        //item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backItemAct:)];
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        backBtn.width = 24;

        item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        [backBtn addTarget:self action:@selector(backItemAct:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return item;
}

-(UIBarButtonItem *)closeBarButtonItem{
    UIBarButtonItem *item ;
    if (item) {
        return item;
    }
    
    if (!item) {
//        item = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target: self action:@selector(clsoeItemAct:)];
        
//        UIImage *image  = [[UIImage imageNamed:@"nav_return.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        _closeBtn = [[UIButton alloc] initNavigationButtonWithTitle:@"关闭" color: TextColor];
        _closeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
        //item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backItemAct:)];
        

        _closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        item = [[UIBarButtonItem alloc] initWithCustomView:_closeBtn];
        
        [_closeBtn addTarget:self action:@selector(clsoeItemAct:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return item;
}

-(void)clsoeItemAct:(id)sender
{
    [self.navigationController popViewControllerAnimated:1];
    [self webviewDidClose];

}

-(void)backItemAct:(id)sender
{
    _historyIndex --;
    
    NSMutableURLRequest *request = [_historyList safeObjectAtIndex:_historyIndex - 1 ];
    if (request) {
        [self.webView loadRequest:request];
    }else
    {
        
        [[TQBStatistialFunction sharedSingleton] recordEvent:dianji_fanhui segmentationKey: dianji_fanhui segmentation:@{@"action":@"goback",
                                                                                                                         @"viewname":@"网页"}];
        [self.navigationController popViewControllerAnimated:1];
        [self webviewDidClose];

    }

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSURLProtocol unregisterClass:[WebViewURLProtocol class]];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

//    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%@ %@", NSStringFromSelector(_cmd) , self );
    
}

#pragma mark - Override

#pragma mark - Initial Methods

- (void)initialNavigationBar
{
//    self.navigationItem.title = <#title#>;
}


#pragma mark - Target Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark -
#pragma mark UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];

    if ([self.progressManager222 respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.progressManager222 webViewDidFinishLoad:webView ];
    }

    
    if (NO == [_historyList containsObject:_preRequest]) {
        
        
//        _historyList = [_historyList safeSubarrayWithRange:NSMakeRange(0, _historyIndex)].mutableCopy;
        if (_historyIndex>=0) {
            [_historyList insertObject:_preRequest atIndex:_historyIndex];
            _historyIndex ++;

        }else{
            
            [_historyList insertObject:_preRequest atIndex:0];
            _historyIndex = 0 ;

        }
        
    }
    
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL flag = [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    if (flag == NO) {
        return NO;
    }
    if ([self.progressManager222 respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        [self.progressManager222 webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    
    
//    return YES;
    ///通过 url 关闭 webview
    /// 当 webview 调用 tqb_close_webview:// XX 的时候 app 关闭当前网页
    //4.1
    if ([request.URL.absoluteString hasPrefix:@"tqb_close_webview://"]) {
        [self closeWebView];
        return NO;
    }
    //4.2
    if ([request.URL.absoluteString hasPrefix:@"tqb://close_webview"]) {
        [self closeWebView];
        return NO;
    }
    if ([request.URL.absoluteString hasPrefix:@"tqb://jump_vc"]) {
        [self jumpToLogin:request.URL.absoluteString];
        return NO;
    }
    ///分享图片专用
    if ([request.URL.absoluteString hasPrefix:@"tqb://shareInfoImage"]) {
        [self shareInfoImage:request.URL.absoluteString];
        return NO;
    }
    ///4.3
    if ([request.URL.absoluteString hasPrefix:@"tqb://shareInfo"]) {
        [self shareInfo:request.URL.absoluteString];
        return NO;
    }
  
    
    ///客狐2.0
    if ([request.URL.absoluteString hasPrefix:@"tqb://openWebUrl"]) {
        [self openWebUrl:request.URL.absoluteString];
        return NO;
    }
    ///tqb5.1.1
    if ([request.URL.absoluteString hasPrefix:@"tqb://openProductView"]) {
        [self openProductView:request.URL.absoluteString];
        return NO;
    }
    ///tqb5.1.1
    if ([request.URL.absoluteString hasPrefix:@"tqb://openDirectorView"]) {
        [self openDirectorView:request.URL.absoluteString];
        return NO;
    }
    ///tqb5.1.1
    if ([request.URL.absoluteString hasPrefix:@"tqb://openCreditCardView"]) {
        [self openCreditCardView:request.URL.absoluteString];
        return NO;
    }
    ///kehu2.0.2
    if ([request.URL.absoluteString hasPrefix:@"tqb://open_push_set"]) {
        [self open_push_set:request.URL.absoluteString];
        return NO;
    }
    ///kehu2.0.2
    if ([request.URL.absoluteString hasPrefix:@"tqb://openYouhuiquan"]) {
        [self openYouhuiquan:request.URL.absoluteString];
        return NO;
    }
    ///kehu2.0.2
    if ([request.URL.absoluteString hasPrefix:@"tqb://openmsg"]) {
        [self openmsg:request.URL.absoluteString];
        return NO;
    }
    

    
    if ([request.URL.absoluteString hasPrefix:@"tqb://customerService"]) {
        
        [[Config sharedInstance] gotoKehu:YES];

        return NO;
    }
    
    
    
    NSLog(@"%@",request.URL.host );
//    if(request.URL.host==nil){
//        if([request.URL.absoluteString isEqualToString:@"about:blank"]){
//            ///about:blank
//            return NO;
//        }
//    }
//    
    
    
    
    ///只添加 header 到自己的服务器的 domain
    if([request.URL.host hasSuffix:@"taoqian123.com"] ||
       [request.URL.host hasSuffix:@"taoqian123.dev"] ||
       [request.URL.host hasSuffix:@"taoqian123.net"] ||
       [request.URL.host hasSuffix:@"kehufox.com"] ||
       [request.URL.host hasSuffix:@"kehufox.dev"] ||
       [request.URL.host hasSuffix:@"kehufox.net"] ||
       [request.URL.host hasSuffix:@"taoqian123.taoqian123.com.cn"] ||
       [request.URL.host hasSuffix:@"kehufox.taoqian123.com.cn"]  ||
       [request.URL.host hasSuffix:@"whoxx.taoqian123.com.cn"] ||
       [request.URL.host hasSuffix:@"whoxx.cc"] ||
       [request.URL.host hasSuffix:@"cusfox.com"]
       
       
       )
    {
        
        NSString *front1 =  [[request allHTTPHeaderFields] objectForKey:@"front"];
        //    NSString *front2 =  [[self.urlRequest allHTTPHeaderFields] objectForKey:@"front"];
        
        
        BOOL headerIsPresent = (front1.length!= 0) ;
        self.jsBridgeHelper.currentUrl = [request.URL absoluteString];

        if(headerIsPresent) return YES;
        
        NSMutableURLRequest *mRequest = [request mutableCopy];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *baseInfo  = [BaseViewModel addBaseInfo:nil forWeb:YES];
                for (NSString *key in [baseInfo allKeys] ) {
                    [mRequest  addValue:[baseInfo objectForKey:key] forHTTPHeaderField:key];
                    
                }
                // set the new headers
                
                if(request){
                    _preRequest = mRequest;
                }
                
                
                // reload the request
                [webView loadRequest:mRequest ];
                
            });
        });
        return NO;

    }else{
        
        if(request){
            _preRequest = request.mutableCopy;
        }
        self.jsBridgeHelper.currentUrl = [request.URL absoluteString];
        return YES;
        
    }
    
   
    
//    return [super webView:webView shouldStartLoadWithRequest:mRequest navigationType:navigationType];
    
    
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [super webViewDidStartLoad:webView];

    if ([self.progressManager222 respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.progressManager222 webViewDidStartLoad:webView];
    }

}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    if ([super respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
//        [super webView:webView didFailLoadWithError:error];
//    }

    if ([self.progressManager222 respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.progressManager222 webView:webView didFailLoadWithError:error];
    }
    
}




#pragma mark - Privater Methods


#pragma mark - Setter Getter Methods

-(void)setBackAsWhite:(BOOL)white
{
    [backBtn setImage: [UIImage imageNamed:white?@"nav_return_white":@"nav_return.png"]  forState:0];
    [ self.closeBtn setTitleColor:white?[UIColor whiteColor]:TextColor forState:0];
    
}
-(void)setBackBtnImage:(UIImage*)image
{
    [backBtn setImage: image forState:0];
    
}

//-(void)backItemAct:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:1];
//    
//}


-(void)enableCloseBtn:(BOOL)enable
{
    self.closeBtn.hidden = !enable;
}

#if TimCustomNAV
-(UIColor *)navigationBarOutColor
{
    return [self navigationBarInColor];
}
-(UIColor *)navigationBarInColor
{
    return  MC;

}
-(UIImage *)navigationBarShadowImage
{
    UIColor *color = [self navigationBarInColor];
    
    if( CGColorEqualToColor(color.CGColor, NavBarMC.CGColor) ){
        return nil;
        
    }else{
        return [UIImage new];
        
    }
    
}
- (BOOL)enablePanBack
{
    return YES;
}
- (NSDictionary *)navigationTitleAttributes
{
    return   @{
               NSForegroundColorAttributeName: HEX_RGB(0xffffff) ,
               NSFontAttributeName:[UIFont systemFontOfSize:18],
               
               };
    
}

#endif
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark 屏幕旋转
//视图控制器实现的方法
- (BOOL)shouldAutorotate{
    //是否允许转屏
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIInterfaceOrientationMask result = [super supportedInterfaceOrientations];
    //viewController所支持的全部旋转方向
    return result;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //对于present出来的控制器，要主动的更新一个约束，让wmPlayer全屏，更安全
    return UIInterfaceOrientationLandscapeRight;
    
}


@end
