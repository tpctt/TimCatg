//
//  UIButtonSubline.h
//  KehuFox
//
//  Created by tim on 16/11/14.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButtonSubline : UIButton
@property (strong,nonatomic) IBInspectable UIColor *lineColor; ///下划线颜色
@property (assign,nonatomic) IBInspectable CGFloat distanceLeading ; ///下划线到两边的间隔
@property (assign,nonatomic) IBInspectable BOOL hideLine ; ///下划线到两边的间隔

@end
