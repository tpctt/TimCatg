//
//  TQBStatistialFunction.m
//  taoqianbao
//
//  Created by Zhang Wuyang on 2017/6/27.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBStatistialFunction.h"
#import "Countly.h"
#import <TimCoreAppDelegate+myJpush.h>

@interface TQBStatistialFunction()

@property (nonatomic, strong) NSString * section ;
@property (nonatomic, strong) NSDictionary * userInfo;



@property (nonatomic, strong) NSString * deviceToken;

@end



@implementation TQBStatistialFunction


//创建单例
+ (TQBStatistialFunction *)sharedSingleton{
    //GCD写法 (执行效率高)
    static TQBStatistialFunction *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;

}

-(instancetype)init{
   
    self = [super init];
    if (self) {
        
        NSDictionary * userInfo  = [BaseListViewModel addBaseInfo:nil forWeb:NO];
        self.deviceToken = [userInfo objectForKey:@"registration_id"];
        
    };
    return self;

}



-(void)recordEvent:(NSString *)key segmentationKey:(NSString *)segmentationKey segmentation:(NSDictionary * )segmentation{
    
    if (segmentation == nil) {
        [[Countly sharedInstance] recordEvent:key segmentation:@{segmentationKey:@""}];
    }else{
        NSString  *string = [self convertToJsonData:segmentation];
        [[Countly sharedInstance] recordEvent:key segmentation:@{segmentationKey:string}];
    }
}

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}


-(NSString *)indexPathTransformString:(NSIndexPath * )indexPath{
    
    NSString * str = [NSString stringWithFormat:@"{%ld,%ld}",(long)indexPath.section,(long)indexPath.row];
    return  str;
}

-(void)recordEvent:(NSString *)key segmentationKey:(NSString *)segmentationKey segmentation:(NSDictionary * )segmentation  indexpath:(NSIndexPath *)indexpath
{
    
    @try {
        
        NSString * index= [self indexPathTransformString:indexpath];
        NSMutableDictionary *temp = [segmentation mutableCopy];
        [temp setObject:index forKey:@"indexPath"];
        NSString  *string = [self convertToJsonData:temp];
        
        [[Countly sharedInstance] recordEvent:key segmentation:@{segmentationKey:string}];
        
    } @catch (NSException *exception) {
        [[Countly sharedInstance]recordHandledException:exception];
        
    } @finally {
        
    }
    
}

-(void)recordEvent:(NSString *)key segmentation:(NSDictionary * )segmentation {

    [[Countly sharedInstance] recordEvent:key segmentation:segmentation];

}

-(void)save
{
    NSDictionary * dict  =  [BaseListViewModel addBaseInfo:nil forWeb:NO];

//    if (self.deviceToken) {
//        [dict setValue:self.deviceToken forKey:@"deviceToken"];
//    }
//    
//    if([AppDelegate shareInstance].registrationID){
//        [dict setValue:[AppDelegate shareInstance].registrationID forKey:@"deviceToken"];
//    }
//    
//    NSDictionary * userInfo  = [BaseListViewModel addBaseInfo:nil forWeb:NO];
//    
//    NSString * session_id =  [userInfo objectForKey:@"session_id"];
//    
//    if (session_id) {
//        [dict setValue:session_id forKey:@"session_id"];
//    }
    
    if (dict) {
        Countly.user.custom  = dict;
        [Countly.user save];
    }
 
}


@end
