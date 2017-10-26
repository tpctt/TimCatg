//
//  TQBJiaodanDynamicInputObjectListViewModel.m
//  taoqianbao
//
//  Created by tim on 17/2/17.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodanDynamicInputObjectListViewModel.h"
#import "TQBJiaodanDynamicInputObject.h"

@implementation TQBJiaodanDynamicInputObjectListViewModel


-(void)initialize
{
    
    [super initialize];
//    self.next_step = @"step1";
    
    self.allowCacheData = NO;
    
//    self.path = @"apply/step1";
    
    @weakify(self)
    
    self.inputBlock = ^(NSMutableDictionary *para ) {
        
        @strongify(self)
        
//        self.path = [[self class] getURLFor:self.next_step];
        
        self.path = self.next_step ;
        
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
//        self.field = [para objectForKey:@"field"];
//        self.verify_step = [para objectForKey:@"verify_step"];
//        self.theme =[TQBJiaodanDynamicTheme mj_objectWithKeyValues: [para objectForKey:@"theme"]];
        
        self.theme = [TQBJiaodanDynamicTheme defaultTheme];
        
        NSArray *array = [TQBJiaodanDynamicInputObjectGroup mj_objectArrayWithKeyValuesArray:para];
        
        
        return array;
        
    };
    
}

@end
