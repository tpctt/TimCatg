//
//  UITextViewWithTitle.h
//  taoqianbao
//
//  Created by tim on 16/9/12.
//  Copyright © 2016年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewSubline.h"
IB_DESIGNABLE
@interface UITextViewWithTitle : UIView 

@property (weak, nonatomic) IBOutlet   UILabel *titleL;
@property (weak, nonatomic) IBOutlet  GCPlaceholderTextView *textView;
@property (strong, nonatomic)   IBInspectable NSString *title;


@end
