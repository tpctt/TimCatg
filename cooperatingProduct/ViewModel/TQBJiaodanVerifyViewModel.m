
//
//  TQBJiaodanVerifyViewModel.m
//  taoqianbao
//
//  Created by tim on 17/2/21.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodanVerifyViewModel.h"

@implementation TQBJiaodanVerifyViewModel
-(void)initialize
{
    
    [super initialize];
    
    //    self.allowCacheData = YES;
    
    self.path = @"inquiry/post";
    
    @weakify(self)
    
    self.inputBlock = ^(NSMutableDictionary *para ) {
        @strongify(self)

//        self.path = self.verify_step;

        
//        if (para && self. identify_key     ) {
//            [para setObject:self.identify_key forKey:@"identify_key"];
//        }
        
        if (para && self. inputInfo     ) {
            [para addEntriesFromDictionary:self.inputInfo];
            
        }
//        if (para && self. step     ) {
//            [para setObject:self.step forKey:@"step"];
//
//        }
//        if (para     ) {
//            [para setObject:@(self.save_order) forKey:@"save_order"];
//            
//        }
        
        return para;
        
    };
    
    
    
    self.outputBlock = ^(NSDictionary *para ) {
        @strongify(self)
        
        self.next_step = [para objectForKey:@"next_step"];

        
        return self.next_step;
        
    };
    
    
    
}
@end
