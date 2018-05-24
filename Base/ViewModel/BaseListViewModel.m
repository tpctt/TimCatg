//
//  BaseViewModel.m
//  taoqianbao
//
//  Created by tim on 16/9/6.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "BaseListViewModel.h"

//#import <SVProgressHUD.h>
#import <AdSupport/AdSupport.h>

#import <CoreSpotlight/CoreSpotlight.h>
#import "AppDelegate.h"
#import <TimJpush.h>
#import <TimCoreAppDelegate+myJpush.h>

#import "UIDevice+tools.h"

@implementation BaseViewModel
+(void)load
{
    [super load];
    [EasyKit swizzleMethod:@selector(saveJson:) with:@selector(saveJson2:) in:[BaseViewModel class]];
    [EasyKit swizzleMethod:@selector(saveJson:) with:@selector(saveJson2:) in:[BaseListViewModel class]];
    
    
    
}
-(void)saveJson2:(id  _Nullable )json
{
    [BaseViewModel dealSessionID:json];
    [self performSelector:@selector(saveJson2:) withObject:json];
    
}

////全局保存/上传 session_id
static NSString *session_id ;
+(NSString *)session_id{
    return session_id;
}

+(void)dealSessionID:(NSDictionary *)output
{
    if ([output isKindOfClass:[NSDictionary class]]) {
        NSString *temp = [output stringAtPath:@"session_id"];
        if (temp.length) {
            session_id = temp;
            
            [[TMCache sharedCache]setObject:session_id forKey:@"_BaseViewModel_session_id"];
        }else{
            session_id = [BaseViewModel get_session_id];
            
        }
    }
}

+(NSString *)get_session_id
{
    return [[TMCache sharedCache] objectForKey:@"_BaseViewModel_session_id"];
    
}





- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        [self initNetError];
        [BaseViewModel initPointsFor:self];

        if (session_id == nil) {
            session_id = [BaseViewModel get_session_id];
        }
        
    }
    return self;
}
-(NSString *)getCacheKey
{
    NSString *cache = [super getCacheKey];
    NSString *pre = [self.appConnectClient.baseURL path];
    
    NSString *appVersion = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *userId = [TQBUserObject isLoged]?[TQBUserObject sharedInstance].id:@"0";
    
    return [[[pre stringByAppendingString:appVersion]
             stringByAppendingPathComponent:cache] stringByAppendingPathComponent:userId];
    
}

-(void)dealloc
{
    
    NSLog(@"dealloc %@--%@", NSStringFromClass(self.class),self.path );
    
}
+(void)dealPointFor:(NSDictionary *)info
{
    if ([info isKindOfClass:[NSDictionary class]]) {
//        NSLog(@"info==%@",info);

//        NSDictionary *points_alert = [info objectAtPath:@"data/points_alert"];
        NSDictionary *points_alert = [info objectAtPath:@"points_alert"];
        
        if ([points_alert isKindOfClass:[NSDictionary class]]) {
            
//            NSLog(@"points_alert==%@",points_alert);
            
            NSNumber *rank_points = [points_alert  objectForKey:@"rank_points"];
            NSString *rank_points_title = [points_alert  objectForKey:@"rank_points_title"];
            
            
            NSNumber *pay_points = [points_alert  objectForKey:@"pay_points"];
            NSString *pay_points_title = [points_alert  objectForKey:@"pay_points_title"];
            
           
            
        }
        
    }
    
}
////金币
+(void)initPointsFor:(TimBaseViewModel *)vm
{
    
    @weakify(vm);
    
    [vm.command.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(vm);
        
        NSDictionary *info = vm.output;
       
        [BaseViewModel dealPointFor:info];
        
    }];
    [vm.command.errors subscribeNext:^(id x) {
        @strongify(vm);
        
        NSDictionary *info = vm.output;
        
        [BaseViewModel dealPointFor:info];
        
    }];
    
}



-(void)initNetError
{
//    @weakify(self);
    [self.command.errors subscribeNext:^(NSError *error) {
     //   @strongify(self);

        if (error.code == -2 ) {
            ///token 失效
            [[NSNotificationCenter defaultCenter]postNotificationName:TQBNeedLoginNotification object:error ];
            
           
        }
        
    }];
    
    
}
#pragma mark cache

#pragma mark 实现过程




///
+(NSMutableDictionary*)addBaseInfo:(NSDictionary*)info forWeb:(BOOL)forWeb
{
    NSMutableDictionary *mParam = [[NSMutableDictionary alloc] initWithDictionary:info];
    {
        
        if ([TQBUserObject isLoged] && [TQBUserObject sharedInstance].access_token.length  ) {
            [mParam setObject:[TQBUserObject sharedInstance].access_token forKey:@"access_token"];
//            [mParam setObject:@([TQBUserObject sharedInstance].type).stringValue forKey:@"type"];
            
        }
        if([Config sharedInstance].cityModel && [Config sharedInstance].cityModel .id ){
            [mParam setObject:[Config sharedInstance].cityModel .id  forKey:@"city_id"];

        }
        //        front //前端类型 0=pc 1=wap 2=ios 3=android

        [mParam setObject:@( 2 ).stringValue forKey:@"front"];
        
        
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString*  appVersion =[NSString stringWithFormat:@"%@",  [infoDict objectForKey:@"CFBundleShortVersionString"]  ];
        ///现在的app的版本
        [mParam setObject:appVersion forKey:@"version"];

        
        if([AppDelegate shareInstance].registrationID){
            [mParam setObject:[AppDelegate shareInstance].registrationID forKey:@"registration_id"];

        }
        if([AppDelegate shareInstance].deviceToken){
            [mParam setObject:[AppDelegate shareInstance].deviceToken forKey:@"deviceToken"];
            
        }
//        if([ASIdentifierManager sharedManager]. advertisingTrackingEnabled){
//        }
        NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
        if(idfa){
            [mParam setObject:idfa forKey:@"idfa"];
            
        }
        
        
        if(session_id){
            [mParam setObject: session_id forKey:@"session_id"];

        }
        
        ///debug  使用,需要在一次正式版使用
//        [mParam setObject:DEBUG?@"1":@"0" forKey:@"f"];
#if DEBUG
//        [mParam setObject:@"1"forKey:@"if"];
        
//        if(forWeb){
//            ///http  header的 key 需要用 中划线
//            for (NSString *key  in [mParam allKeys]) {
//                if ([key rangeOfString:@"_"].location != NSNotFound) {
//                    NSString *newKey = [key stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
//                    id value = [mParam valueForKey:key];
//                    
//                    //                [mParam removeObjectForKey:key];
//                    [mParam setObject:value forKey:newKey];
//                    
//                }
//                
//            }
//        }

#else
        ///确认发布之后执行的为这里
//        [mParam setObject:@"0" forKey:@"if"];

#endif
    }
    
    
 
    
    
    if(forWeb){
        ///http  header的 key 需要用 中划线
        for (NSString *key  in [mParam allKeys]) {
            if ([key rangeOfString:@"_"].location != NSNotFound) {
                NSString *newKey = [key stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
                id value = [mParam valueForKey:key];
                
//                [mParam removeObjectForKey:key];
                [mParam setObject:value forKey:newKey];
                
            }
            
        }
    }
    
    
    return mParam;
}
//

-(void)dealArrayToSearch:(NSArray *)array
{}
@end



////
@implementation BaseListViewModel

-(void)initNetError
{
//    [self.command.executionSignals.switchToLatest subscribeNext:^(id x) {
//        [BaseViewModel dealSessionID:self.output];
//
//        
//    }];
}



-(void)saveJson2:(id  _Nullable )json
{
    [BaseViewModel dealSessionID:json];
    [self performSelector:@selector(saveJson2:) withObject:json];

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initNetError];
        [BaseViewModel initPointsFor:self];


    }
    return self;
}

///
+(NSMutableDictionary*)addBaseInfo:(NSDictionary*)info forWeb:(BOOL)forWeb
{
    return [BaseViewModel addBaseInfo:info forWeb:YES];
}
//



-(NSString *)getCacheKey
{
    NSString *cache = [super getCacheKey];
    NSString *pre = [self.appConnectClient.baseURL path];
    
    NSString *appVersion = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString *userId = [TQBUserObject isLoged]?[TQBUserObject sharedInstance].id:@"0";
    
    return [[[pre stringByAppendingString:appVersion]
             stringByAppendingPathComponent:cache] stringByAppendingPathComponent:userId];
    
}


@end
