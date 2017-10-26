//
//  TQBSectionTableViewCell.m
//  taoqianbao
//
//  Created by tim on 17/2/21.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBSectionTableViewCell.h"

@interface TQBSectionTableViewCell()
@property (strong,nonatomic) UILabel *titleL;
@end

@implementation TQBSectionTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        [self commonInit];
    }
    return self;
}

- (id)init{
    
    self = [super init];
    
    if (self){
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
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];

    }
    return self;
}

-(void)commonInit{
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self addSubview:self.titleL];
    self.titleL.numberOfLines = 0;
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(@22);
        make.right.equalTo(@(-5));
        make.bottom.equalTo(@(-5));
        
    }];
    
    
    self.titleL.textColor = HEX_RGB(0x999999);
    self.titleL.font = MYFONT(12);
    self.titleL.backgroundColor = HEX_RGB(0xf5f5f5);
    
    self.backgroundColor = HEX_RGB(0xf5f5f5);
    self.contentView.backgroundColor = HEX_RGB(0xf5f5f5);
    self.backgroundView.backgroundColor = HEX_RGB(0xf5f5f5);
    

}
-(void)setString:(NSString *)string
{
    if (_string == string) {
        return;
    }
    _string = string;
    
    self.titleL.text = string;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
