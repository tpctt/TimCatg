
//
//  TQBJiaodanRadioCell.m
//  KehuFox
//
//  Created by tim on 2017/8/29.
//  Copyright © 2017年 timRabbit. All rights reserved.
//

#import "TQBJiaodanRadioCell.h"
#import "UITableViewCell+SepLine.h"
#import "TQBJiaodanRatioView.h"

@interface TQBJiaodanRadioCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet TQBJiaodanRatioView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;


@end

@implementation TQBJiaodanRadioCell

-(void)initWithoutNib
{
    
}
-(BOOL)resignFirstResponder
{
    [super resignFirstResponder];
  
    return 1;
    
}
-(BOOL)becomeFirstResponder
{
    
    return 1;
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    @weakify(self);

    self.tagView.selectBlock = ^(NSString *title, NSInteger index, BOOL selected) {
        @strongify(self);
        
        NSMutableArray *tempObjs = [NSMutableArray array];
        NSMutableArray *tempIds = [NSMutableArray array];
        NSMutableArray *tempValues = [NSMutableArray array];
        for (NSNumber *number in self.tagView.selectIndexArray) {
            TQBJiaodanDynamicInputOptionObject *obj = [self.model.extra.option safeObjectAtIndex:[number integerValue] - 1 ];
            if (obj) {
                [tempObjs addObject:obj];
                [tempIds addObject:obj.id];
                [tempValues addObject:obj.value];
            }
        }
        
        
        
        NSString *strings = [tempIds componentsJoinedByString:@","];
        self.model.value = strings;

        self.model.extra.disPlayName = [tempValues componentsJoinedByString:@","];

        
        NSString *key = self.model.name ;
        NSString *value = self.model.value ;
        
        
        [self saveValue:value forKey:key isAct:YES opetions:tempObjs];
        
        
    };
    
}




-(void)setModel:(TQBJiaodanDynamicInputObject *)model
{
    if ( super.model==model &&YES== [super.model.extra.disPlayName isEqualToString:model.extra.disPlayName] ) {
        
//        return;
        
    }
    
    [self saveValue:model.value forKey:model.name isAct:NO];

    super.model= model;
    self.titleL.text  = model.title;
    self.subTitleL.text  = model.extra.sub_title;
    
    [self.tagView setTags:self.model.extra.option];
    self.tagView.mutli = self.model.type_enum == InputObjectType_checkbox;
    
    
    {
        NSArray *tempIds = [self.model.value componentsSeparatedByString:@","];
        NSMutableArray *tempNumbers = [NSMutableArray array];
        
        for ( int i = 0 ; i< self.model.extra.option.count ; i++ ) {
            TQBJiaodanDynamicInputOptionObject *obj = [self.model.extra.option safeObjectAtIndex: i ];
            
            for (NSString *ID in tempIds) {
                if ([ID integerValue] == [obj.id integerValue]) {
                    [tempNumbers addObject:@(i)];
                }
            }
        }
        
        [self.tagView setSelectIndexArray:tempNumbers];

        
    }
    
}

#pragma mark 下拉按钮的动作


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


///避免nav 作为vc的parent返回了
-(UIViewController*)viewController
{
    UIViewController*vc= [super viewController ];
    if (vc.parentViewController) {
        if ([vc.parentViewController isKindOfClass:[UINavigationController class]]) {
            return vc;
        }
        return vc.parentViewController;
        
    }
    
    return vc;
    
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self resetSepLine];
    
    
}

@end
