//
//  DialogUtil+Hud.m
//  taoqianbao
//
//  Created by tim on 17/3/9.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "DialogUtil+Hud.h"

@implementation DialogUtil(Hud)
- (void)showHud:(UIView *) view withLabel:(NSString *) label
{
    
//    [self showDlg:view withLabel:label];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = label;
    
//    
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
//    [view addSubview:hud];
//    hud.delegate = self;
//    hud.label.text = label;
//
//    [hud showAnimated:YES];
    
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview = [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 0.8f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
#pragma clang diagnostic pop
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 0;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake(([UIApplication sharedApplication].keyWindow.width - LabelSize.width - 20)/2, [UIApplication sharedApplication].keyWindow.height - 100, LabelSize.width+20, LabelSize.height+10);
    
    [[GCDQueue mainQueue]queueBlock:^{
        [UIView animateWithDuration:0.5f animations:^{
            showview.alpha = 0;
        } completion:^(BOOL finished) {
            [showview removeFromSuperview];
        }];
    } afterDelay:2.0f];
}

#pragma clang diagnostic pop

@end
