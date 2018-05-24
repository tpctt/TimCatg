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

@interface CPBaseToWebViewController : BaseToWebViewController<GJWNavigationColorSource,GJWNavigationViewControllerPanProtocol  >

@end
