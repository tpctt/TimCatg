//
//  tools.h
//  taoqianbao
//
//  Created by tim on 17/1/3.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice(tools)
///获取剩余存储空间
+(NSString *)freeDiskSpaceInMB;

///手机型号
+(NSString *)platformString;
///cpu类型
+(NSString*)getCPUTypeString;
///获取当前Wifi的SSID
+ (NSString *)getDeviceSSID;
+ (NSString *)getDeviceBSSID;
///获取 mac 地址,FOR ios7 earlier
+ (NSString *) getMacAddress;

///iOS 获取手机sim卡的运营商（移动，电信，联通） 相关信息
+(NSString *)getSIMcarrier;

//2/3/4g
+(NSString*)getNetWorkType;


+ (NSArray *)loadPerson;
+ (NSArray *)getList;


@end
