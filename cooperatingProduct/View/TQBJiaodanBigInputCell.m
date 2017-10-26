
//
//  TQBJiaodanBigInputCell.m
//  KehuFox
//
//  Created by tim on 2017/8/29.
//  Copyright © 2017年 timRabbit. All rights reserved.
//

#import "TQBJiaodanBigInputCell.h"
#import "TQBJiaodanDynamicInputObject.h"
#import <SuggestInputView/SuggestInputView.h>
#import "UITableViewCell+SepLine.h"

@interface TQBJiaodanBigInputCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;

@property (weak, nonatomic ) IBOutlet GCPlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *currectNumL;
@property (weak, nonatomic) IBOutlet UILabel *availableNumL;

@end

@implementation TQBJiaodanBigInputCell

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
    
    LayerColorWidth(self.textView, 4, HEX_RGB(0xd2d2d2), 0.5);
    self.textView.placeholder = @"请输入您的问题...";
    self.textView.text = @"";
    
    @weakify(self);
    [self.textView.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        
        [self setTextViewNumber];
        
    }];
}


-(void)setTextViewNumber
{
    NSInteger maxNum = 50;
    
    NSInteger num = self.textView.text.length;
    
    if( num >= maxNum ) {
        self.textView.text = [self.textView.text substringToIndex:maxNum];
    }
    if( num > maxNum ) {
        SHOWMSG(@"字数已经大于50");
    }
    
    num = self.textView.text.length;
    
    self.currectNumL.text = @(num).stringValue;
    self.availableNumL.text = [NSString stringWithFormat:@"/%ld", maxNum - num];
    
    
    self.model.value = self.textView.text;
    self.model.extra.disPlayName = self.textView.text;
    
    NSString *key = self.model.name ;
    NSString *value = self.model.value ;
    
    [self saveValue:value forKey:key isAct:NO];
    
    
}

-(void)setModel:(TQBJiaodanDynamicInputObject *)model
{
//    @weakify(self);
    if ( super.model==model &&YES== [super.model.extra.disPlayName isEqualToString:model.extra.disPlayName] ) {
        
        return;
        
    }
    
    
    super.model= model;
    self.titleL.text  = model.title;
    self.subTitleL.text  = model.extra.sub_title;
   
    self.textView.text = model.value;
    
    [self setTextViewNumber];

    {
        
        NSString *key = self.model.name ;
        NSString *value = self.model.value ;
        
        [self saveValue:value forKey:key isAct:YES];
        
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
