//
//  UIViewSubline.m
//  taoqianbao
//
//  Created by tim on 16/9/12.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "UIViewSubline.h"

@implementation UIViewSubline

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        _distanceLeading = 5;
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    _distanceLeading = 5;

}
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    if(!self.hideLine){
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, self.lineColor?self.lineColor.CGColor: [UIColor fromHexValue:0xcccccc].CGColor);
        
        CGContextFillRect(context, CGRectMake(_distanceLeading, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame)-2*_distanceLeading, 0.5));
        
    }
    
    
}
@end
