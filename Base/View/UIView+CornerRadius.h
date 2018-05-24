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


#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

@end
