//
//  TQBJiaodanCompleteViewModel.m
//  taoqianbao
//
//  Created by tim on 17/2/28.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodanCompleteViewModel.h"

@implementation TQBJiaodanCompleteViewModel

-(void)initialize
{
    
    [super initialize];
    
    //    self.allowCacheData = YES;
    
//    self.path = @"apply/done";
    
    @weakify(self)
    
    self.inputBlock = ^(NSMutableDictionary *para ) {
        
        @strongify(self)
        
        self.path = self.recommadPath;
        
        if (para && self. identify_key     ) {
            [para setObject:self.identify_key forKey:@"identify_key"];
        }
        
        //        if (para && self. inputInfo     ) {
        //            [para addEntriesFromDictionary:self.inputInfo];
        //
        //        }
        //
        
        return para;
        
    };
    
    
    //    /这里吧 detail 转出 list
    self.block = ^(NSDictionary *para ) {
        @strongify(self)
        self.tips = [para objectForKey:@"tips"];
        self.title = [para objectForKey:@"title"];
        self.order_id = [para objectForKey:@"order_id"];
        
        NSArray *array = [NSObject mj_objectArrayWithKeyValuesArray:para[@"recommend_product"]];
        
        return array;
        
    };
    
}
@end
