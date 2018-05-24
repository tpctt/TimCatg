//
//  TQBCostomAlertView.m
//  taoqianbao
//
//  Created by Taoqian123 on 2017/10/25.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBCostomAlertView.h"

@interface TQBCostomAlertView ()


@end

@implementation TQBCostomAlertView

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor =  [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];

        [self addSubview:_backgroundView];
    }
    return self;
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    _contentView.center = self.center;
    [self addSubview:_contentView];
}

- (void)show {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSArray *windowViews = [window subviews];
    if(windowViews && [windowViews count] > 0){

        [window addSubview:self];
        
    }
}


- (void)hide {

    [self removeFromSuperview];
    
}

- (void)showBackground
{
    
    if (self.isAnim) {
        _backgroundView.alpha = 0;
        [UIView beginAnimations:@"fadeIn" context:nil];
        [UIView setAnimationDuration:0.35];
        _backgroundView.alpha = 0.6;
        [UIView commitAnimations];
    }else{
        _backgroundView.alpha = 0.6;
    }
    
    
}




@end
