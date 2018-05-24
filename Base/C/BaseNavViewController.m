
//
//  BaseNavViewController.m
//  taoqianbao
//
//  Created by tim on 16/9/5.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "BaseNavViewController.h"

#import "UINavigationBar+Color.h"
#import "GJWNavigation.h"


@interface UINavigationItem(CustomBackButton)

@end
@implementation UINavigationItem(CustomBackButton)
//
//+(void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Method originalMethodImp = class_getInstanceMethod(self, @selector(backBarButtonItem));
//        Method destMethodImp = class_getInstanceMethod(self, @selector(myCustomBackButton_backBarbuttonItem));
//        method_exchangeImplementations(originalMethodImp, destMethodImp);
//    });
//}
//
//static char kCustomBackButtonKey;
//
//
//-(UIBarButtonItem *)myCustomBackButton_backBarbuttonItem{
//    UIBarButtonItem *item = [self myCustomBackButton_backBarbuttonItem];
//    if (item) {
//        return item;
//    }
//    item = objc_getAssociatedObject(self, &kCustomBackButtonKey);
//    
//    if (!item) {
////        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:NULL];
//        
//        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_return.png"]];
//        
//        item = [[UIBarButtonItem alloc] initWithCustomView:image];
//        item.tintColor = [UIColor redColor] ;
//        
//        objc_setAssociatedObject(self, &kCustomBackButtonKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        
//        
//        
//    }
//    return item;
//}

@end

@interface BaseNavViewController ()
@property (nonatomic, strong) GJWNavigation *navigation;

@end

@implementation BaseNavViewController
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}








- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
#if TimCustomNAV
    // 在根视图控制器中初始化一次即可， 注意：要设置为成员属性,否则不起作用
    GJWNavigation *navigation = [[GJWNavigation alloc] init];
    navigation.progressFinished = 0.5;
    [navigation joinToNavigationController:self];
    self.navigation = navigation;
#else
    
#endif
    
    // 编译时判断：检查SDK版本
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    // 运行时判断：检查当前系统版本
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f) {
        UIEdgeInsets newSafeArea = self.view.safeAreaInsets;
        newSafeArea.bottom += 49;
        self.additionalSafeAreaInsets = newSafeArea;
        
    } else {
        // 用旧的代替
        self.topLayoutGuide;
    }
#else
    // 用旧的代替
    self.topLayoutGuide;
#endif
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
}

- (void)dealloc {
    objc_removeAssociatedObjects(self);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
