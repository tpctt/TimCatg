//
//  UIButtonCornerRadius.h
//  taoqianbao
//
//  Created by tim on 16/9/8.
//  Copyright © 2016年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIButtonCornerRadius : UIButton
@property (assign,nonatomic) IBInspectable CGFloat cornerRadius;
@property (strong,nonatomic) IBInspectable UIColor *lineColor;
@property (assign,nonatomic) IBInspectable CGFloat lineWidth;

@end
