//
//  TQBStatistialFunction.h
//  taoqianbao
//
//  Created by Zhang Wuyang on 2017/6/27.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQBStatistialFunction : NSObject



+ (TQBStatistialFunction *)sharedSingleton;


//带字典的数据
-(void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation;


-(void)recordEvent:(NSString *)key segmentationKey:(NSString *)segmentationKey segmentation:(NSDictionary * )segmentation  indexpath:(NSIndexPath *)indexpath;

//记录
-(void)recordEvent:(NSString *)key segmentationKey:(NSString *)segmentationKey segmentation:(NSDictionary * )segmentation;

//
-(NSString *)indexPathTransformString:(NSIndexPath * )indexPath;

//保存用户xinx
-(void)save;

@end
