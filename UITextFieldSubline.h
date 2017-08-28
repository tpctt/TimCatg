//
//  TQB.h
//  taoqianbao
//
//  Created by tim on 16/9/8.
//  Copyright © 2016年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE

@interface  UITextFieldSubline :UITextField

@property (strong,nonatomic) IBInspectable UIColor *lineColor; ///下划线颜色
@property (strong,nonatomic) IBInspectable NSNumber *isPhone; ///是否是手机号输入,
@property (assign,nonatomic) IBInspectable BOOL showEyeForPwd; ///是否显示rightView 为eye图像

@property (assign,nonatomic) IBInspectable NSInteger maxLength; ///最大长度
@property (assign,nonatomic) IBInspectable BOOL hideLine ; ///下划线到两边的间隔
@property (assign,nonatomic) IBInspectable CGFloat distanceLeading ; ///下划线到两边的间隔
@property (assign,nonatomic) IBInspectable CGFloat lineHeight ; ///下划线到两边的间隔

-(void)setLeftText:(NSString*)string;

@end
