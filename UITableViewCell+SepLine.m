//
//  UITableViewCell+SepLine.m
//  taoqianbao
//
//  Created by tim on 17/3/1.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "UITableViewCell+SepLine.h"


@implementation UITableViewCell(SepLine)

-(void)setSepLineColor:(UIColor*)color{
    NSArray *subViews  = [self subviews];
    for (UIView *view in subViews ) {
        
        if ([NSStringFromClass(view.class) isEqualToString:@"_UITableViewCellSeparatorView"]) {
            
            view.backgroundColor = color ;
            view.width = self.width - view.mj_x * 2;
            
            if(self.isTopLine){
                view.mj_y = 0;
                
            }else{
                view.mj_y = self.height - 1;
                
            }
            
            view.hidden = 0;// [self hideCellSeparatorLine];
            
            
            
        }
        
    }
    
}
-(void)resetSepLine{
    NSArray *subViews  = [self subviews];
    for (UIView *view in subViews ) {
        
        if ([NSStringFromClass(view.class) isEqualToString:@"_UITableViewCellSeparatorView"]) {
            
            view.backgroundColor = HEX_RGB(0xcccccc);
            view.width = self.width - view.mj_x * 2;

            if(self.isTopLine){
                view.mj_y = 0;
                
            }else{
                view.mj_y = self.height - 1;
                
            }
            
            view.hidden = [self hideCellSeparatorLine];
            
            
        }
        
    }
}



#pragma mark 自定义属性

static const void * HideCellSeparatorLineKey = &HideCellSeparatorLineKey;

-(void)setHideCellSeparatorLine:(BOOL)hideCellSeparatorLine
{
    objc_setAssociatedObject(self, HideCellSeparatorLineKey, @(hideCellSeparatorLine), OBJC_ASSOCIATION_ASSIGN);
    
    [self resetSepLine];
    
    
}

-(BOOL)hideCellSeparatorLine
{
    id obj = objc_getAssociatedObject(self, HideCellSeparatorLineKey);
    
    return [obj boolValue];
}

static const void * IsTopLineKey = &IsTopLineKey;

-(void)setIsTopLine:(BOOL)isTopLine
{
    objc_setAssociatedObject(self, IsTopLineKey, @(isTopLine), OBJC_ASSOCIATION_ASSIGN);
    
    [self resetSepLine];
    
    
}

-(BOOL)isTopLine
{
    id obj = objc_getAssociatedObject(self, IsTopLineKey);
    
    return [obj boolValue];
}

@end
