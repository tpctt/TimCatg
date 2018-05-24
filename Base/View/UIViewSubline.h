//
//  UIViewSubline.h
//  taoqianbao
//
//  Created by tim on 16/9/12.
//  Copyright © 2016年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIViewSubline : UIView
@property (strong,nonatomic) IBInspectable UIColor *lineColor; ///下划线颜色
@property (assign,nonatomic) IBInspectable CGFloat distanceLeading ; ///下划线到两边的间隔
@property (assign,nonatomic) IBInspectable BOOL hideLine ; ///下划线到两边的间隔

@end
