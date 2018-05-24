//
//  UIViewWithNib.m
//  taoqianbao
//
//  Created by tim on 16/9/22.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "UIViewWithNib.h"
@interface UIViewWithNib()
{
    
}
@end

@implementation UIViewWithNib


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
        
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        
    }
    return self;
}

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    
    
    [self commonInit];
    
    
}



-(void)subCommonInit
{}

///////////////////
-(void)commonInit{
    
    
    [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self  options:nil];
    
    [self addSubview:self.view];
    
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        
        
    }];
 
    [self subCommonInit];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
