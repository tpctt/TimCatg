//
//  TeamProductResultListTableViewSubCell.m
//  KehuFox
//
//  Created by tim on 17/3/21.
//  Copyright © 2017年 timRabbit. All rights reserved.
//

#import "TeamProductResultListTableViewSubCell.h"
#import "UITableViewCell+SepLine.h"

@interface TeamProductResultListTableViewSubCell()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *valueL;

@end

@implementation TeamProductResultListTableViewSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.isTopLine = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)banding:(TeamProductResultStateObject *)object
{
    self.titleL.text = object.title;
    self.valueL.text = object.value;
    
    self.hideCellSeparatorLine = !! object.title.length;
    
    
}
@end
