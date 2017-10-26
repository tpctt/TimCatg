//
//  TQB.m
//  taoqianbao
//
//  Created by tim on 17/2/17.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "MMPickerView+add.h"

@implementation MMPickerView(add)
+(void)addTitle:(NSString*)title toolbar:(UIToolbar*)_pickerViewToolBar withOtherItems:(NSArray*)withOtherItems
{
    UILabel *label = [[UILabel alloc] initWithFrame:_pickerViewToolBar.bounds];
    label.mj_x = 0;
    label.mj_w -= 5+ 50;
    
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    
    NSMutableArray *itmes = [NSMutableArray array];
    [itmes addObject:titleItem];
    [itmes addObjectsFromArray:withOtherItems];
    
//    UIToolbar *pickerViewToolBar = [self valueForKey:@"pickerViewToolBar"];
////    UIToolbar *pickerViewToolBar = ;
//    pickerViewToolBar.items = itmes;
    
}
@end
