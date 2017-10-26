

//
//  TQBJiaodanSectionHeader.m
//  KehuFox
//
//  Created by tim on 2017/8/29.
//  Copyright © 2017年 timRabbit. All rights reserved.
//

#import "TQBJiaodanSectionHeader.h"
@interface TQBJiaodanSectionHeader()
@property (weak, nonatomic) IBOutlet UILabel *xunhaoL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UILabel *subTtile;

@end
@implementation TQBJiaodanSectionHeader
-(void)setObject:(TQBJiaodanDynamicInputObjectGroup *)group section:(NSInteger)section
{
    self.xunhaoL.text = @(section + 1 ).stringValue;
    
    self.titleL.text = group.title?:@""  ;
    self.subTtile.text = group.desc?:@""  ;
    
    
    self.actBtn.hidden = !group.toggle;
    self.actBtn.selected = group.selected;


}

-(void)subCommonInit
{
    self.clipsToBounds = YES;
    
    UIImage *image1 = [UIImage imageNamed:@"jiaodan_list_icon_close"];
    UIImage *image2 = [UIImage imageNamed:@"jiaodan_list_icon_turnon"];
    [self.actBtn setImage:image1 forState:UIControlStateSelected];
    [self.actBtn setImage:image2 forState:0];
    
    [self.actBtn setTitle:@"收起" forState:UIControlStateSelected];
    [self.actBtn setTitle:@"展开" forState:0];
    
    self.actBtn.lzType = LZRelayoutButtonTypeLeft;
    self.actBtn.imageSize = image1.size;
    
    @weakify(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:tap];
    
    [[tap rac_gestureSignal]subscribeNext:^(id x) {
        @strongify(self);
        [self.actBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        
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
