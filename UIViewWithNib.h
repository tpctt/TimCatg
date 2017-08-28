//
//  UIViewWithNib.h
//  taoqianbao
//
//  Created by tim on 16/9/22.
//  Copyright © 2016年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewWithNib : UIView
@property (weak, nonatomic) IBOutlet UIView *view;
-(void)subCommonInit;
@end
