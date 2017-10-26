//
//  TQBJiaodanStepHeader.m
//  taoqianbao
//
//  Created by tim on 17/2/16.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodanStepHeader.h"

@interface TQBJiaodanStepHeader ()
{
    NSMutableArray *_btnArray , *_arrowArray;
    UIView *_btnView;
    UILabel *_label;
}
@end

@implementation TQBJiaodanStepHeader

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


///////////////////
-(void)commonInit{
    
    
//    [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self  options:nil];
//    
//    [self addSubview:self.view];
//    
//    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.mas_top);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom);
//        
//        
//    }];
    
    [self subCommonInit];
    
}

-(void)subCommonInit
{
    _btnView.backgroundColor = HEX_RGB(0xe6e6e6);

    _btnArray = [NSMutableArray array];
    _arrowArray = [NSMutableArray array];
    
    _btnView = [[UIView alloc] initWithFrame:self.frame];
    _btnView.backgroundColor = [UIColor whiteColor];

    _label = [[UILabel alloc] init];
    _label.text = @"简单五步,实现快速贷款";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = HEX_RGB(0x2e8de6);
    _label.font = MYFONT(14);
    _label.backgroundColor = [UIColor whiteColor];
    

    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@(30));

    }];
    
    [self addSubview:_btnView];
    [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(_label.mas_top).with.offset(-1);
        
    }];
    
    NSArray *btnImageArray = @[@"icon_demand_",@"icon_verification_",@"icon_Qualifications_",@"icon_information-_",@"icon_submit_"];
    
    NSArray *arraowImageArray = @[@"icon_triangle_o",@"icon_triangle_b",@"icon_triangle_v",@"icon_triangle_g"];
    NSString *arrowGray = @"icon_triangle_gray-";
    
    UIButton *preBtn = nil;
    for (int i = 0; i<5; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:self.frame];
        
        UIImage *image_s = [UIImage imageNamed:[NSString stringWithFormat:@"%@s",btnImageArray[i]]];
        UIImage *image_n = [UIImage imageNamed:[NSString stringWithFormat:@"%@n",btnImageArray[i]]];
        
        [btn setImage:image_s forState:UIControlStateSelected];
        if (image_n) {
            
            [btn setImage:image_n forState:0];
        }else{
            
            [btn setImage:image_s forState:0];
        }
        
        [_btnView addSubview:btn];
        
    

        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_btnView);
            make.bottom.equalTo(_btnView);
            
        }];
        
        
        if (i == 0 ) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(_btnView);
                
            }];
            
        }else  if (i == 4 ) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_btnView);
                make.left.equalTo(preBtn.mas_right);

                make.width.equalTo(preBtn.mas_width);
                
            }];
            
        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(preBtn.mas_right);
                make.width.equalTo(preBtn.mas_width);
                
            }];
        }
        
        preBtn = btn;
        
        [_btnArray addObject:btn];
        
        
        btn.tag = i;
        
    }
    
    //arrow
    for (int i = 0; i<4; i++) {
        UIButton *btn = [[UIButton alloc] init];
        
        UIImage *image_s = [UIImage imageNamed:[NSString stringWithFormat:@"%@",arraowImageArray[i]]];
        UIImage *image_n = [UIImage imageNamed:arrowGray];
        
        [btn setImage:image_n forState:0];
        [btn setImage:image_s forState:UIControlStateSelected];

        UIButton *iconBtn = _btnArray[i];
        if (iconBtn) {
            [iconBtn addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(iconBtn.mas_centerY);
                make.right.equalTo(iconBtn);
                
            }];
        }
        
        
        
        [_arrowArray addObject:btn];
        
        
        
    }
    
    [self setSelectIndex:0];
    
    
}

-(void)setSelectIndex:(NSInteger)index{
    if (index >=0 && index <= 4) {
        
        for (int i = 0; i< 5 ; i++) {
            UIButton *iconBtn = [_btnArray safeObjectAtIndex:i];
            UIButton *arrwoBtn = [_arrowArray safeObjectAtIndex:i];
            
            if ( i <= index ) {
                iconBtn.selected = 1;
                arrwoBtn.selected = 1;
            }else{
                iconBtn.selected = 0;
                arrwoBtn.selected = 0;
                
            }
            
        }
    }
    
    if (index != 0 ) {
        [self hideLable:YES];
    }else{
        [self hideLable:NO];
        
    }
}
-(void)hideLable:(BOOL)hide
{
    [_label mas_updateConstraints:^(MASConstraintMaker *make) {
        if (hide) {
            make.height.equalTo(@(0));
            
        }else{
            make.height.equalTo(@(30));
            
        }
        
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
