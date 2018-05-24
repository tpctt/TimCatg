//
//  UIButtonCornerRadius.m
//  taoqianbao
//
//  Created by tim on 16/9/8.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "UIButtonCornerRadius.h"

@implementation UIButtonCornerRadius
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cornerRadius = 5;
        self.layerColor = [UIColor whiteColor];
        
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
//    self.cornerRadius = 5;
    
    
}
-(void)setLayerColor:(UIColor *)layerColor
{

    _layerColor = layerColor;
    self.layer.borderColor = _layerColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = _cornerRadius > 0?true:false;
    
}
-(void)setCornerRadius:(CGFloat)cornerRadius{
    
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = _layerColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = cornerRadius > 0?true:false;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
