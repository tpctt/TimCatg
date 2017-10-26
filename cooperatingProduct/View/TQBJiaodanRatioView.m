//
//  TQBManagerTagView.m
//  taoqianbao
//
//  Created by tim on 17/4/24.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodanRatioView.h"
#import "TQBJiaodanDynamicInputObject.h"


@interface TQBJiaodanRatioView ()
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray *tagsViewArray;



@end

@implementation TQBJiaodanRatioView
-(NSArray *)selectIndexArray
{
    NSMutableArray *temp = [NSMutableArray array];
    
    
    UIView *superView = self.scrollView;
    for(UIButton *button in superView.subviews){
        if (![button isKindOfClass:[UIButton class]]) {
            continue;
        }
        
        if ( button.selected == YES) {
            [temp addObject:@(button.tag)];
        }
        
    }
    
    return temp;
    
}
-(void)setSelectIndexArray:(NSArray *)selectIndexArray
{
    for ( int i = 0 ; i< selectIndexArray.count ; i++ ) {
        
        NSNumber *number = [selectIndexArray objectAtIndex:i];
        
        UIButton *btn = [self.scrollView viewWithTag:[number integerValue] + 1 ];
        btn.selected = YES;
        
        
    }
    
}

-(void)btnAct:(UIButton *)btn
{
    
    UIView *superView = [btn superview];
    if (self.mutli == NO) {
        for(UIButton *button in superView.subviews){
            if (![button isKindOfClass:[UIButton class]]) {
                continue;
            }
            
            if(button != btn){
                button.selected = 0;
            }else{
                button.selected = 1;
            }
            
        }
    }else{
        btn.selected = !btn.selected ;
        
        
    }
    
    
    
    if (self.selectBlock) {
        self.selectBlock([btn titleForState:0],btn.tag,btn.selected);
        
    }
    
}
-(void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    UIButton *btn = [self.scrollView viewWithTag:selectIndex + 1 ];
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}


-(void)setTags:(NSArray *)tags
{
    for (UIView *view in self.tagsViewArray ) {
        [view removeFromSuperview];
    }
    
    __block  UIButton *preBtn = nil;
    NSInteger tag1 = 1;
    ///add
    for (TQBJiaodanDynamicInputOptionObject *tag in tags ) {
        UIButton *label= [UIButton new];
        
        [label setContentEdgeInsets:UIEdgeInsetsMake(10, 2, 10, 2)];
        
        NSString * titile = [NSString stringWithFormat:@"  %@",tag.value];
        [label setTitle: titile forState:0];
        label.titleLabel.font = MYFONT(14);
        
        CGFloat width = [UILabel getWidthWithTitle:tag.value font:k_FontSize_14];
        
        
        //左右间距 20 图片大小 15

        width = width + 20 + 15;
        
        [label setTitleColor:HEX_RGB(0xa3a2a2) forState:UIControlStateNormal];
        [label setTitleColor:HEX_RGB(0xff8309) forState:UIControlStateSelected];
        [label setImage:[UIImage imageNamed:@"jiaodan_list_checkbox_normal"] forState:UIControlStateNormal];
        [label setImage:[UIImage imageNamed:@"jiaodan_list_checkbox_selected"] forState:UIControlStateSelected];
        
        label.tag = tag1++;
        [label addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
    
        [self.scrollView addSubview:label];
        [self.tagsViewArray addObject:label];
        //        label.tag = i;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY);
            
            if(preBtn){
                make.left.equalTo(preBtn.mas_right ).with.offset(12);
                
            }else{
                make.left.equalTo(  @(0));
            }
            
            make.width.mas_equalTo(width);
            
            preBtn = label;
            
        }];
    }
    
    if(preBtn){
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(preBtn.mas_right);
        }];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(preBtn.mas_right);
        }];
        
    }
}



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
    [self subCommonInit];
    
}

-(void)subCommonInit
{
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        
    }];
    self.tagsViewArray = [NSMutableArray array];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



