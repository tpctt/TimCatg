//
//  UITextField+TQBStatisticalTextFiled.h
//  taoqianbao
//
//  Created by Zhang Wuyang on 2017/7/4.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (TQBStatisticalTextFiled)

@property (nonatomic, strong) NSString *statistialKey;

@property (nonatomic, copy)   NSString *statistialTag;

@property (nonatomic, copy)   NSString *recordTime;

-(void)recordWithKey:(NSString * )recordKey recordTag:(NSString * )recordTag;

@end
