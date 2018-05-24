//
//  LocationTools.h
//  GmLoanClient
//
//  Created by WBYAN on 16/6/15.
//  Copyright © 2016年 GomeFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^ResultBlock)(CLLocation *location, CLPlacemark *pl, NSString *error, BOOL loading);

@interface LocationTools : NSObject
//单例
+ (instancetype)sharedInstance;

- (void)getCurrentLocation:(ResultBlock)block;
- (void)getCurrentLocationWithOutName:(ResultBlock)block;

@end
