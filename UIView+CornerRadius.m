//
//  UIView+CornerRadius.m
//  taoqianbao
//
//  Created by tim on 16/12/30.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "UIView+CornerRadius.h"
#import <objc/runtime.h>

@interface UIView ()

@end

@implementation UIView (CornerRadius)

static const void *LineColor_key  = &LineColor_key;
static const void *CornerRadius_key  = &CornerRadius_key;
static const void *LineWidth_key  = &LineWidth_key;

-(void)setTimlineColor:(UIColor *)lineColor
{

    if(lineColor){
        objc_setAssociatedObject(self, LineColor_key, lineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC  );
        self.layer.borderColor = lineColor.CGColor;
        
    }
}

-(UIColor *)timlineColor{
    return  objc_getAssociatedObject(self, LineColor_key);
}

-(void)setTimCornerRadius:(CGFloat)cornerRadius{
//    _cornerRadius = cornerRadius;
    
    objc_setAssociatedObject(self, CornerRadius_key, @(cornerRadius), OBJC_ASSOCIATION_ASSIGN  );
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0?true:false;
}

-(CGFloat)timCornerRadius{
    return  [objc_getAssociatedObject(self, CornerRadius_key) floatValue];
}

-(void)setTimLineWidth:(CGFloat)lineWidth
{
    objc_setAssociatedObject(self, LineWidth_key, @(lineWidth), OBJC_ASSOCIATION_ASSIGN  );
    self.layer.borderWidth = lineWidth;
    
}

-(CGFloat)timLineWidth
{
    return  [objc_getAssociatedObject(self, LineWidth_key) floatValue];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UIView*)subViewOfClassName:(NSString*)className {
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        
        UIView* resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}

@end
