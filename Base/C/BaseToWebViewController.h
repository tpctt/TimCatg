//
//  BaseToWebViewController.h
//  taoqianbao
//
//  Created by tim on 16/9/25.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "BaseViewController.h"
#import <TOWebViewController.h>

#import <GJWNavigationColorSource.h>
#import <UINavigationBar+Color.h>
#import "TQBShareResultViewModel.h"

@interface BaseToWebViewController : TOWebViewController<GJWNavigationColorSource,GJWNavigationViewControllerPanProtocol  >
@property (strong,nonatomic) UIButton *rightBtn;
///分享的
@property (nonatomic, strong) TQBShareResultViewModel  * shareModel;

-(void)jumpToWebFrom:(UIViewController *)vc vcIsNav:(BOOL)vcIsNav withAddress:(NSString *)address;
-(void)jumpToWebFrom:(UIViewController *)vc vcIsNav:(BOOL)vcIsNav ;

-(void)webviewDidClose;


-(void)setBackAsWhite:(BOOL)white;
-(void)setBackBtnImage:(UIImage*)image;
-(void)backItemAct:(id)sender;
-(void)clsoeItemAct:(id)sender;

-(void)enableCloseBtn:(BOOL)enable;
-(void)addMJHeaderOnWebView;

@end
