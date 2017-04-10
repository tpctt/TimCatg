//
//  GoldListViewModel.m
//  KehuFox
//
//  Created by tim on 16/11/16.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import "TeamProductResultListViewModel.h"
#import "TeamProductResultObject.h"

@implementation TeamProductResultListViewModel

- (void)initialize {
    
    [super initialize];
//    self.allowCacheData = YES;
    
    @weakify(self)
    
    
    self.path = @"product/proxy-order-list";
    
    
    self.inputBlock = ^NSMutableDictionary *(NSMutableDictionary *para){
        @strongify(self);
        
        [para setObject:self.id forKey:@"id"];
        [para setObject:self.user_id forKey:@"user_id"];
        
        return para;
        
    };
    
    
    self.block = ^NSArray *(NSDictionary *dict){
        
        @strongify(self);
        
        self.title = [dict stringAtPath:@"title"];
//        self.pay_phonts_help = [dict objectAtPath:@"pay_phonts_help"];
        
        NSArray *array=    [TeamProductResultObject mj_objectArrayWithKeyValuesArray:[dict objectForKey:@"order_list"]];
        
        
        return array;
  
        
    };
    
    
    
    
    
}
@end
