//
//  BaseToWebViewController.m
//  taoqianbao
//
//  Created by tim on 16/9/25.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "CPBaseToWebViewController.h"
#import "UIViewController+Funcs.h"

#import "BaseListViewModel.h"
#import <TimCoreAppDelegate+share.h>

#import "TQBShareResultViewModel.h"
#import "WebViewURLProtocol.h"
#import "TQBJSBridgeHelper.h"

#import <NJKWebViewProgress.h>


@interface CPBaseToWebViewController ()

{
    BOOL _modelVC;
    UIView * _stateView;
}
@end

@implementation CPBaseToWebViewController


#pragma mark - View Controller LifeCyle


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
        if( _modelVC ){

            BaseNavViewController *nav = [[BaseNavViewController alloc] initWithNavigationBarClass:[GJW_NavigationBar class] toolbarClass:nil];
            nav.viewControllers = @[self];
            [nav setNavigationBarHidden:YES];
            
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
    if( _modelVC ){
        [self dismissViewControllerAnimated:1 completion:^{
            
        }];
        
    }else{
        [self.navigationController popViewControllerAnimated:1];
        
    }

}




- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _modelVC = NO;

    }
    return self;
}   
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showUrlWhileLoading = NO;
        _modelVC = NO;

    }
    return self;
}

-(instancetype)initWithURLString:(NSString *)urlString
{
    self = [super initWithURLString:urlString];
    if (self) {
        self.showUrlWhileLoading = NO;
        _modelVC = NO;

    }
    return self;
}

-(instancetype)initWithURL:(NSURL *)url
{
    self = [super initWithURL:url];
    if (self) {
        self.showUrlWhileLoading = NO;
        _modelVC = NO;

    }
    return self;
}



-(void)closeButtonButtonTapped:(id)sender{
   
    [self closeWebView];

}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.webView.backgroundColor = HEX_RGB(0x41008E);
    self.view.backgroundColor = HEX_RGB(0x41008E);

    
    self.buttonTintColor = HEX_RGB(0xFFFFFF);

    UIBarButtonItem *closeButton  = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonButtonTapped:)];
    self.applicationBarButtonItems = @[closeButton];
    closeButton.tintColor = self.buttonTintColor ;
    

    self.navigationController.toolbar.barTintColor = HEX_RGB(0x41008E);
    
    
    self.navigationButtonsHidden = NO;
    self.showDoneButton = NO;
    self.showActionButton = NO;
    
    self.navigationController.toolbarHidden = YES;
    
    
    
#ifdef __IPHONE_11_0
    
    if (@available(iOS 11.0, *) ){
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if ([UIDevice isPhoneX]) {
            self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 40, 0);//导航栏如果使用系统原生半透明的，top设置为64
            
        }else{
            self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 40, 0);//导航栏如果使用系统原生半透明的，top设置为64
            
        }
        self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
//            self.webView.mj_y = 20 ;
//            self.webView.mj_h -= 20 ;

    }

    _stateView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    [self.view addSubview:_stateView];
    _stateView.backgroundColor = HEX_RGB(0x41008E);
    
#else
    
#endif
    
    
}
//下拉刷新
-(void)addMJHeaderOnWebView
{
//    @weakify(self);
//    
//    //下拉刷新
//    self.webView.scrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
//        
//        @strongify(self);
//        
//        [self.webView reload];
//        //        [self.webView.scrollView.mj_header endRefreshing];
//        [self.webView.scrollView.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:1 ];
//        
//    }];
//    self.navigationButtonsHidden = YES;
    
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
//    [AppDelegate shareInstance].window.windowLevel = UIWindowLevelNormal;
    [[AppDelegate shareInstance].navVC setNavigationBarHidden:NO];

    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [AppDelegate shareInstance].window.windowLevel = UIWindowLevelStatusBar;
    [[AppDelegate shareInstance].navVC setNavigationBarHidden:YES];
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    UIView *progressView = [self valueForKey:@"progressView"];
    if (progressView) {
        [_stateView addSubview:progressView];
        progressView.mj_y = 20;
        
    }
    
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




#pragma mark - Privater Methods


#pragma mark - Setter Getter Methods


#if TimCustomNAV
-(UIColor *)navigationBarOutColor
{
    return [self navigationBarInColor];
}
-(UIColor *)navigationBarInColor
{
    return  NavBarMC;

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
    return UIInterfaceOrientationPortrait  ;
    
}


@end
