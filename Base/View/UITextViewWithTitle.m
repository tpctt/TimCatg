//
//  UITextViewWithTitle.m
//  taoqianbao
//
//  Created by tim on 16/9/12.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "UITextViewWithTitle.h"
@interface UITextViewWithTitle()
@property (strong, nonatomic) IBOutlet UIView *view;


@end

@implementation UITextViewWithTitle
-(void)setTitle:(NSString *)title
{
    if(_title != title){
        _title = title;
        
        self.titleL.text = title;
        
    }
}

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    
//    self.hideLine = YES;

    [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self  options:nil];
    [self addSubview:self.view];
    
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        
        
    }];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
