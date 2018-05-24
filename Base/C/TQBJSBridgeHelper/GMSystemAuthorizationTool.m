//
//  GMSystemAuthorizationTool.m
//  Borrowers
//
//  Created by GOMEMYF on 16/5/30.
//  Copyright © 2016年 GOME. All rights reserved.
//


#define ShortSystemVersion  [[UIDevice currentDevice].systemVersion floatValue]
#define SYSTEMIOS9_OR_LATER (ShortSystemVersion >= 9)


#import "GMSystemAuthorizationTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBook/AddressBook.h>
#import <Photos/Photos.h>
#import "SXAddressBookManager.h"


@implementation GMSystemAuthorizationTool

//通讯录授权
+ (void)checkAddressBookAuthorization:(void (^)(bool, ABAuthorizationStatus))block
{

    ABAddressBookRef  addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus != kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if (block) {
                        block(NO,authorizationStatus);
                    }
                } else if (!granted) {
                    if (block) {
                        block(NO,authorizationStatus);
                    }
                } else {
                    if (block) {
                        block(YES,authorizationStatus);
                    }
                }
            });
            
        });
    } else {
        if (authorizationStatus == kABAuthorizationStatusAuthorized) {
            if (block) {
                block(YES,authorizationStatus);
            }
        } else {
            if (block) {
                block(NO,authorizationStatus);
            }
        }
    };
}


// 判断用户相册是否开启授权
+ (void)checkPhotographAlbumAuthorization:(void (^)(bool))block
{
   
    if (SYSTEMIOS9_OR_LATER) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    if (block) {
                        block(YES);
                    }
                } else {
                    if (block) {
                        block(NO);
                    }
                }
            }];
        } else {
            if (status == PHAuthorizationStatusAuthorized)
            {
                block(YES);
            } else {
                block(NO);
            }
        }
    } else {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if (author == ALAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    if (block) {
                        block(YES);
                    }
                } else {
                    if (block) {
                        block(NO);
                    }
                }
            }];
        } else {
            if (author == ALAuthorizationStatusAuthorized)
            {
                block(YES);
            } else {
                block(NO);
            }
        }
        
    }
}

//相机授权
+ (void)checkCameraAuthorization:(void (^)(bool, AVAuthorizationStatus))block
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    //系统的统同意
                    block(YES,authStatus);
                } else {
                    block(NO,authStatus);
                }
            });
        }];
        
    } else if (authStatus == AVAuthorizationStatusAuthorized)
    {
        block(YES,authStatus);
    } else {
        block(NO,authStatus);
        
    }
}

//定位授权
+ (void)checkLocationAuthorization:(void (^)(bool, CLAuthorizationStatus))block
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        block(YES, status);
    } else {
        block(NO, status);
    }
}


@end
