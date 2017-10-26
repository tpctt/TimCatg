//
//  JiaoDanInputCell.h
//  Wedai
//
//  Created by 中联信 on 15/9/30.
//  Copyright © 2015年 Tim.rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQBJiaodanBaseCell.h"


static NSString *const ReloadSectionNotifaction = @"reloadSectionNotifaction";


@interface TQBJiaoDanInputCell : TQBJiaodanBaseCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextField *value;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dotCC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeadingCC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueFieldCC;


-(BOOL)becomeFirstResponder;

@end
