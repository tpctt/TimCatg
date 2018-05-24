//
//  BaseViewController.h
//  taoqianbao
//
//  Created by tim on 16/9/5.
//  Copyright © 2016年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Scene.h>
#import <UIScrollView+EmptyDataSet.h>
#import "TQBUITableView.h"

#import "TQBScrollAdView.h"
#import "UIViewController+Funcs.h"

#import <GJWNavigationColorSource.h>
#import <UINavigationBar+Color.h>

//#import "DialogUtil+Hud.h"

@interface BaseViewController : Scene <UITableViewDelegate,UITableViewDataSource , DZNEmptyDataSetSource, DZNEmptyDataSetDelegate ,  SDCycleScrollViewDelegate ,GJWNavigationColorSource,GJWNavigationViewControllerPanProtocol  >

//统计需要
@property (nonatomic, strong) NSString * customTitleName;

@property (strong,nonatomic) TQBUITableView *table;
@property (strong,nonatomic) NSMutableArray *dataArray;

-(void)initTable:(BOOL)group;
-(void)regNibs:(NSArray <Class>*)array;


///自定义的返回按钮动作
-(void)backItemAct:(id)sender;
-(void)setBackAsWhite:(BOOL)white;
-(void)setBackBtnImage:(UIImage*)image;

-(void)enableNavPanBack:(BOOL)flag;
-(UIBarButtonItem *)backBarButtonItem;

///兼容 ios11, 设置 scroll 的安全区域
-(void)setScrollForSafeArea:(UIScrollView *)scrollView;
+(void)setScrollForSafeArea:(UIScrollView *)scrollView;

@end
