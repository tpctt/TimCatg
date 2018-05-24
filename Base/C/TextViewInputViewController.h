//
//  TextViewInputViewController.h
//  taoqianbao
//
//  Created by tim on 16/9/12.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "BaseViewController.h"

@class GCPlaceholderTextView;

@interface TextViewInputViewController : BaseViewController


@property (strong, nonatomic)   NSString *lastText ;

@property (assign, nonatomic)   NSInteger maxLength ;
@property (assign, nonatomic)   BOOL isPhone ;
@property (assign, nonatomic)   UIKeyboardType keyType ;
 

@end
