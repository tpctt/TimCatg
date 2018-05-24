//
//  BaseViewController+Funcs.m
//  taoqianbao
//
//  Created by tim on 16/11/3.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "UIViewController+Funcs.h" 
#import <UINavigationBar+Color.h>

@interface UIViewController  ()<GJWNavigationColorSource>

@end

@implementation UIViewController (Funcs)

 
-(void)removeVCfromNav:(UIViewController*)vc
{
    NSMutableArray *vcArray = vc.navigationController.viewControllers.mutableCopy ;
    [vcArray removeObject:vc];
    vc.navigationController.viewControllers =vcArray;
    
}

#pragma mark  导航栏

-(void)setBackAsWhite:(BOOL)white{}

-(void)setNavBarShowClearColor:(BOOL)clear
{
    
}

-(void)setNavBarShowWithAlpha:(BOOL)clear
{
#if TimCustomNAV
    ///不透明
    if (  clear >= 0 && clear < 1) {
        
        [self setBackAsWhite:NO ];
//        [self.navigationController.navigationBar gjw_setBackgroundColor:[[self navigationBarInColor ] colorWithAlphaComponent:1- clear]  ];
        [(GJW_NavigationBar *)self.navigationController.navigationBar gjw_setBackgroundColor:NavBarMC ];
        
    }else{
        
        [self setBackAsWhite:NO ];
        
        [(GJW_NavigationBar *)self.navigationController.navigationBar gjw_setBackgroundColor:[self navigationBarInColor ] ];
//        [self.navigationController.navigationBar gjw_setBackgroundColor:[[self navigationBarInColor ] colorWithAlphaComponent:1- clear]  ];

        return;
    }
    
    
    return;
    
#else
    
    if( /* DISABLES CODE */ (0) ){
        //HIDE
        ///不透明
        if ( !clear ) {
            
            //        self.navigationController.navigationBar.translucent = NO;
            self.navigationController.navigationBar.shadowImage = nil;
            
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NavBarMC  size:CGSizeMake(1, 128)] forBarMetrics:UIBarMetricsDefault];
            
            [self.navigationController setNavigationBarHidden:NO];
            
            [self setBackAsWhite:NO ];
            
        }else{
            
            
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            
            [self.navigationController setNavigationBarHidden:YES];
            
            [self setBackAsWhite:YES ];
            
            
        }
        
    }else{
        //SHOW NAV
        ///不透明
        if (  clear >= 0 && clear < 1) {
            
            //        self.navigationController.navigationBar.translucent = NO;
            self.navigationController.navigationBar.shadowImage = nil;
            
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[NavBarMC colorWithAlphaComponent:1- clear]  size:CGSizeMake(1, 128)] forBarMetrics:UIBarMetricsDefault];
            
            [self setBackAsWhite:NO ];
            
        }else{
            
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            [self setBackAsWhite:YES ];
            
            return;
            
            //        ///透明
            //        self.navigationController.navigationBar.translucent = YES;
            //        self.navigationController.navigationBar.shadowImage = [UIImage new];
            //
            //        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 128)] forBarMetrics:UIBarMetricsDefault];
            //
            //        [self setBackAsWhite:YES ];
            //
            
        }
        
        
    }
    
    
    
#endif
    
    
}

//
//-(void)enableNavPanBack:(BOOL)flag
//{
//    if(flag){
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//            
//        }
//    }else{
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            //        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//            
//        }
//    }
//}

-(void)hidesBarsOnSwipe:(BOOL)flag
{
    self.navigationController.hidesBarsOnSwipe = flag;
}

-(void)stateBarAsWhite:(BOOL)white
{
//    [[UIApplication sharedApplication] setStatusBarStyle:white?UIStatusBarStyleLightContent:UIStatusBarStyleDefault animated:NO];
    int aa  = 0 ;
    if(white == YES){
        aa = 1;
    }else{
        aa = 0;

    }
    //故意,避免更多 js 的动作 ,应该使用 -(UIStatusBarStyle)preferredStatusBarStyle
//    [UIApplication sharedApplication].statusBarStyle = aa;
    [UIApplication sharedApplication].statusBarStyle = 0;
    

}


-(UIViewController *)controllInNav:(UINavigationController*)nav forClass:(Class)class
{
    for (UIViewController *vc in nav.viewControllers ) {
        if ([vc isKindOfClass:class]) {
            return vc;
        }
        
    }
    return nil;
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
