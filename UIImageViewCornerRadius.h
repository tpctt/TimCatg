//
//  UIImageViewCornerRadius.h
//  KehuFox
//
//  Created by tim on 16/11/16.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface UIImageViewCornerRadius : UIImageView
@property (assign,nonatomic) IBInspectable CGFloat cornerRadius;
@property (strong,nonatomic) IBInspectable UIColor *layerColor;

@end
