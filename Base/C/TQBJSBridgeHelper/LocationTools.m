//
//  LocationTools.m
//  GmLoanClient
//
//  Created by WBYAN on 16/6/15.
//  Copyright © 2016年 GomeFinance. All rights reserved.
//



#import "LocationTools.h"
#import <UIKit/UIDevice.h>
#define isIOS(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)

@interface LocationTools () <CLLocationManagerDelegate>
/** 回调代码块 */
@property (nonatomic, copy) ResultBlock block;

/** 位置管理者 */
@property (nonatomic, strong) CLLocationManager *locationM;

/** 地理编码 */
@property (nonatomic, strong) CLGeocoder *geoC;
@property (nonatomic, assign) BOOL onlyLocationFlag;

@end

@implementation LocationTools
static LocationTools * _instace;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return _instace;
}

#pragma mark -懒加载
-(CLLocationManager *)locationM
{
    if (!_locationM) {
        _locationM = [[CLLocationManager alloc] init];
        _locationM.delegate = self;
        
        // iOS8.0之后, 必须手动请求定位授权
        // 获取info.plist 里面的键值对
        NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
        
        //        NSLog(@"%@", infoDic);
        
        if (isIOS(8.0)) {
            //            [_locationM requestAlwaysAuthorization];
            //            [_locationM requestWhenInUseAuthorization];
            
            // 获取前后台定位描述(看其他开发者到底有没有添加这个key)
            NSString *alwaysStr = infoDic[@"NSLocationAlwaysUsageDescription"];
            
            // 获取前后台定位描述(看其他开发者到底有没有添加这个key)
            NSString *whenInUseStr = infoDic[@"NSLocationWhenInUseUsageDescription"];
            
            // 判断其它开发者, 到底填写的是哪个key
            if([alwaysStr length] > 0)
            {
                [_locationM requestAlwaysAuthorization];
            }
            else if ([whenInUseStr length] > 0)
            {
                [_locationM requestWhenInUseAuthorization];
                // 如果请求的是前台定位授权, 如果想要在后台获取用户位置, 提醒其他开发者, 勾选后台模式location updates
                NSArray *backModes = infoDic[@"UIBackgroundModes"];
                if (![backModes containsObject:@"location"]) {
                    NSLog(@"当前授权模式是前台定位授权, 如果想要在后台获取位置, 需要勾选后台模式location updates");
                }else // 代表当前勾选后台模式, 而且是前台定位授权
                {
                    if(isIOS(9.0))
                    {
                        _locationM.allowsBackgroundLocationUpdates = YES;
                    }
                }
                
            }else
            {
                NSLog(@"如果在iOS8.0之后获取用户位置, 必须主动填写info.plist文件中的key NSLocationAlwaysUsageDescription 或者 NSLocationWhenInUseUsageDescription");
            }
        }else // ios8.0之前
        {
            // 如果请求的是前台定位授权, 如果想要在后台获取用户位置, 提醒其他开发者, 勾选后台模式location updates
            NSArray *backModes = infoDic[@"UIBackgroundModes"];
            if (![backModes containsObject:@"location"]) {
                NSLog(@"当前授权模式, 如果想要在后台获取位置, 需要勾选后台模式location updates");
            }
        }
    }
    return _locationM;
}


#pragma mark -懒加载
-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

- (void)getCurrentLocation:(ResultBlock)block
{
    self.onlyLocationFlag = NO;
    
    // 记录代码块
    self.block = block;
    
    // 获取用户位置信息
    if([CLLocationManager locationServicesEnabled])
    {
        [self.locationM startUpdatingLocation];
        self.block(nil,nil,nil,YES);
    }else
    {
        self.block(nil, nil, @"定位服务未开启",NO);
    }
}
- (void)getCurrentLocationWithOutName:(ResultBlock)block
{
    self.onlyLocationFlag = YES;
    
    // 记录代码块
    self.block = block;
    
    // 获取用户位置信息
    if([CLLocationManager locationServicesEnabled])
    {
        [self.locationM startUpdatingLocation];
        self.block(nil,nil,nil,YES);
    }else
    {
        self.block(nil, nil, @"定位服务未开启",NO);
    }
}

#pragma mark -CLLocationManagerDelegate
/**
 *  定位到之后调用
 *
 *  @param manager   位置管理者
 *  @param locations 位置数组
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    
    // 判断位置是否可用
    if (location.horizontalAccuracy >= 0) {
        if (self.onlyLocationFlag == NO) {
            [self.geoC reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                
                if (error == nil) {
                    CLPlacemark *pl = [placemarks firstObject];
                    self.block(location, pl, nil,NO);
                }else
                {
                    self.block(location, nil, @"反地理编码失败",NO);
                }
            }];
        }else{
            self.block(location, nil, @"不需要反地理编码",NO);

        }
      
    }
    // 如果只需要获取一次位置, 那么在此处停止获取用户位置
    [manager stopUpdatingLocation];
}

/**
 *  当前授权状态发生改变时调用
 *
 *  @param manager 位置管理者
 *  @param status  状态
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            // 用户还未决定
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定");
            break;
        }
            // 问受限
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            self.block(nil, nil, @"访问受限",NO);
            break;
        }
            // 定位关闭时和对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:
        {
            // 定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled])
            {
                NSLog(@"定位开启，但被拒");
                self.block(nil, nil, @"被拒绝",NO);
            }else
            {
                NSLog(@"定位关闭，不可用");
                self.block(nil, nil, @"定位关闭，不可用",NO);
            }
            break;
        }
            // 获取前后台定位授权
        case kCLAuthorizationStatusAuthorizedAlways:
            //        case kCLAuthorizationStatusAuthorized: // 失效，不建议使用
        {
            NSLog(@"获取前后台定位授权");
            break;
        }
            // 获得前台定位授权
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台定位授权");
            break;
        }
        default:
            break;
    }
}
@end
