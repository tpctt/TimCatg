//
//  ProductDetailGetUrlViewModel.m
//  KehuFox
//
//  Created by tim on 17/3/23.
//  Copyright © 2017年 timRabbit. All rights reserved.
//

#import "ProductDetailGetUrlViewModel.h"

@implementation ProductDetailGetUrlViewModel

-(void)initialize
{
    [super initialize];
    
    self.path = @"product/put";
    
    @weakify(self)
    
    self.inputBlock = ^(NSMutableDictionary *para ) {
        
        @strongify(self)
        
        if (para && self. productID     ) {
            [para setObject:self.productID forKey:@"id"];
        }
        
        if (para && self. subject_id     ) {
            [para setObject:self.subject_id forKey:@"subject_id"];
        }
        if (para && self. idenifer     ) {
            [para setObject:self.idenifer forKey:@"idenifer"];
        }
        
        return para;
        
    };
    
    //
    self.outputBlock = ^(NSDictionary *para ) {
        @strongify(self)
        
        self.apply_type = [para numberAtPath:@"apply_type"].integerValue;
        self.href = [para stringAtPath:@"href"];
        self.count_num = [para numberAtPath:@"count_num"].integerValue;
        self.identify_key = [para stringAtPath:@"identify_key"];
        self.first_step = [para stringAtPath:@"first_step"];
        
        return @(self.apply_type);
        
    };
}
@end
