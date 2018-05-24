//
//  UITextView+TQBStatiscalTextView.h
//  KehuFox
//
//  Created by Zhang Wuyang on 2017/10/13.
//  Copyright © 2017年 timRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (TQBStatiscalTextView)

@property (nonatomic, strong) NSString *statistialKey;

@property (nonatomic, copy)   NSString *statistialTag;

@property (nonatomic, copy)   NSString *recordTime;

-(void)recordWithKey:(NSString * )recordKey recordTag:(NSString * )recordTag;
@end
