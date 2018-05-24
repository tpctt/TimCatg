//
//  UITextView+TQBStatiscalTextView.m
//  KehuFox
//
//  Created by Zhang Wuyang on 2017/10/13.
//  Copyright © 2017年 timRabbit. All rights reserved.
//

#import "UITextView+TQBStatiscalTextView.h"

@implementation UITextView (TQBStatiscalTextView)
//runtime 绑定

-(NSString *)statistialKey{
    NSObject *obj = objc_getAssociatedObject(self,  @selector(statistialKey));
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    }
    return nil;
}

-(void)setStatistialKey:(NSString *)statistialKey{
    
    objc_setAssociatedObject(self,  @selector(statistialKey), statistialKey,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}



-(NSString *)recordTime{
    
    NSObject *obj = objc_getAssociatedObject(self,  @selector(recordTime));
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    }
    return nil;
}


-(void)setRecordTime:(NSString *)recordTime{
    objc_setAssociatedObject(self,  @selector(recordTime), recordTime,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)statistialTag {
    NSObject *obj = objc_getAssociatedObject(self,  @selector(statistialTag));
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    }
    return nil;
}

- (void)setStatistialTag:(NSString *)value {
    objc_setAssociatedObject(self,  @selector(statistialTag), value,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)recordWithKey:(NSString * )recordKey recordTag:(NSString * )recordTag{
    
    self.statistialKey = recordKey;
    self.statistialTag = recordTag;
    
    
//    [self  addta]
//    [self addTarget:self action:@selector(textFiledEditDidBegin) forControlEvents:UIControlEventEditingDidBegin];
//    [self addTarget:self action:@selector(textFiledEditDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    
}

-(void)textFiledEditDidBegin{
    
    NSDate *senddate = [NSDate date];
    self.recordTime =  [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    
}


-(void)textFiledEditDidEnd{
    @try {
        NSString * currentTime = [NSString stringWithFormat:@"%ld",(long)[ [NSDate date] timeIntervalSince1970]];
        [[TQBStatistialFunction sharedSingleton] recordEvent:self.statistialTag
                                             segmentationKey:self.statistialKey
                                                segmentation:@{quxiaoshijian:currentTime,dianjishiajin:self.recordTime}];
        
    } @catch (NSException *exception) {
        [[Countly sharedInstance]recordHandledException:exception];
    } @finally {
        
    }
    
    
}
@end
