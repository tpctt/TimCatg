//
//  TQB.h
//  taoqianbao
//
//  Created by tim on 17/2/17.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMPickerView.h>

@interface MMPickerView(add)
+(void)addTitle:(NSString*)title toolbar:(UIToolbar*)_pickerViewToolBar withOtherItems:(NSArray*)withOtherItems;

@end
