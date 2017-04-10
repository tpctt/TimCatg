
//
//  GoldListTableViewCell.m
//  KehuFox
//
//  Created by tim on 16/11/15.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import "TeamProductResultListTableViewCell.h"

@interface TeamProductResultListTableViewCell()


@property (weak, nonatomic) IBOutlet UIButton *stateB;
@property (weak, nonatomic) IBOutlet UIButtonCornerRadius *iconB;


@property (weak, nonatomic) IBOutlet UILabel *NoL;
@property (weak, nonatomic) IBOutlet UILabel *stateL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (strong, nonatomic)  TeamProductResultObject *object;

@end

@implementation TeamProductResultListTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.iconB setBackgroundImage:[UIImage imageWithColor:OrangeC] forState:UIControlStateSelected];
    [self.iconB setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0xFFFFFF)] forState:0];
    
    
    
}
-(void)banding:(TeamProductResultObject*)object
{
    if (object == _object) {
        return;
        
    }
    _object = object;
    
    
//    [self.iconB sd_setBackgroundImageWithURL:[NSURL URLWithString:object.logo] forState:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    
//    self.NoL.text = object.order_sn;
//    self.timeL.text = object.format_created_at;
//    self.stateL.text = object.state_name;
//    
//    self.moneyL.text = object.income_amount;
    
    self.NoL.text = [NSString stringWithFormat:@"货单号:%@", object.order_sn];
    self.stateL.text = [NSString stringWithFormat:@"订单状态:%@", object.state_name];
    self.timeL.text = [NSString stringWithFormat:@"申请时间:%@", object.format_created_at];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
