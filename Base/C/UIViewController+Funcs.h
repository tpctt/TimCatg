//
//  BaseViewController+Funcs.h
//  taoqianbao
//
//  Created by tim on 16/11/3.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "BaseViewController.h"

@interface UIViewController (Funcs)

 //是否让 navbar 透明
//-(void)setNavBarShowClearColor:(BOOL)clear;
-(void)setNavBarShowWithAlpha:(BOOL)clear;

//-(void)enableNavPanBack:(BOOL)flag;
-(void)setBackAsWhite:(BOOL)white;


-(void)hidesBarsOnSwipe:(BOOL)flag;
-(void)stateBarAsWhite:(BOOL)white;

-(void)removeVCfromNav:(UIViewController*)vc;
-(UIViewController *)controllInNav:(UINavigationController*)nav forClass:(Class)class;

@end
