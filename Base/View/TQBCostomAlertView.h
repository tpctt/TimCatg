//
//  TQBCostomAlertView.h
//  taoqianbao
//
//  Created by Taoqian123 on 2017/10/25.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQBCostomAlertView : UIView

@property (strong, nonatomic) UIView *backgroundView;

/**需要展示的customView*/
@property (strong, nonatomic) UIView *contentView;

/**是否需要动画展示出来  default is YES*/
@property (nonatomic,assign) BOOL isAnim;

/**展示*/
- (void)show;

/**隐藏*/
- (void)hide;

@end
