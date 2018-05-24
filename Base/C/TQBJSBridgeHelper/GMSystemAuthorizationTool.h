//
//  GMSystemAuthorizationTool.h
//  Borrowers
//
//  Created by GOMEMYF on 16/5/30.
//  Copyright © 2016年 GOME. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <CoreLocation/CoreLocation.h>



@interface GMSystemAuthorizationTool : NSObject
// 判断用户通讯录是否开启授权
+ (void)checkAddressBookAuthorization:(void (^)(bool isAuthorized ,ABAuthorizationStatus authorStatus))block;

// 判断用户相册是否开启授权
+ (void)checkPhotographAlbumAuthorization:(void (^)(bool isAuthorized))block;


// 判断用户相机是否开启授权
+ (void)checkCameraAuthorization:(void (^)(bool isAuthorized ,AVAuthorizationStatus authorStatus))block;

//定位授权
+ (void)checkLocationAuthorization:(void (^)(bool isAuthorized , CLAuthorizationStatus status))block;

@end


