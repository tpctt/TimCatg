//
//  UIView+CornerRadius.h
//  taoqianbao
//
//  Created by tim on 16/12/30.
//  Copyright © 2016年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIView (CornerRadius)
@property (assign,nonatomic) IBInspectable CGFloat timCornerRadius;
@property (strong,nonatomic) IBInspectable UIColor *timlineColor;
@property (assign,nonatomic) IBInspectable CGFloat timLineWidth;


- (UIView*)subViewOfClassName:(NSString*)className;

@end
