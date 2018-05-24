//
//  UIButtonSubline.m
//  KehuFox
//
//  Created by tim on 16/11/14.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import "UIButtonSubline.h"

@implementation UIButtonSubline

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
    
    if(!self.hideLine  ){
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, self.lineColor?self.lineColor.CGColor: [UIColor fromHexValue:0xcccccc].CGColor);
        
        CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
        
    }
    
}

@end
