//
//  MMDatePickerView.h
//  Wedai
//
//  Created by 中联信 on 15/11/12.
//  Copyright © 2015年 Tim.rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMDatePickerView : UIView


+(void)showPickerViewInView: (UIView *)view
                    maxDate: (NSDate *)maxDate
                    minDate:(NSDate*)minDate
                withOptions: (NSDictionary *)options
                   selected: (void(^)(MMDatePickerView *mmPickView,NSDate*date ))selected
                 completion: (void(^)(MMDatePickerView *mmPickView,NSDate*date))completion                   withQuest:(NSString*)withQuest;
;

+(void)dismissWithCompletion: (void(^)(MMDatePickerView *mmPickView,NSDate *date))completion;

@end

