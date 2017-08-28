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
        self.lineColor = [UIColor whiteColor];
        self.lineWidth = 0.5;

    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
//    self.cornerRadius = 5;
    self.lineColor = BlueC;

    
}
-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.layer.borderColor = _lineColor.CGColor;
    self.layer.borderWidth = _lineWidth;
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = _cornerRadius > 0?true:false;
    
}
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.borderColor = _lineColor.CGColor;
    self.layer.borderWidth = _lineWidth;
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = _cornerRadius > 0?true:false;
}
-(void)setLineWidth:(CGFloat)lineWidth
{
    
    _lineWidth = lineWidth;
    self.layer.borderColor = _lineColor.CGColor;
    self.layer.borderWidth = _lineWidth;
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = _cornerRadius > 0?true:false;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
