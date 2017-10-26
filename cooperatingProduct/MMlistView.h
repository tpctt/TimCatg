//
//  MMlistView.h
//  Wedai
//
//  Created by 中联信 on 15/11/3.
//  Copyright © 2015年 Tim.rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MMlistView: UIView

//+(void)showPickerViewInView: (UIView *)view
//                withStrings: (NSArray *)strings
//                withOptions: (NSDictionary *)options
//                 completion: (void(^)(NSArray *selectedString))completion;

+(void)showPickerViewInView: (UIView *)view
                withStrings: (NSArray *)strings
                withOptions: (NSDictionary *)options
                   selected: (void(^)(MMlistView *mmPickView,NSInteger row,NSInteger component))selected
                 completion: (void(^)(NSArray *selectedString))completion
                  withQuest:(NSString*)withQuest;
+(void)showPickerViewInView: (UIView *)view
                withStrings: (NSArray *)strings
                withOptions: (NSDictionary *)options
                   selected: (void(^)(MMlistView *mmPickView,NSInteger row,NSInteger component))selected
                 completion: (void(^)(NSArray *selectedString))completion
                  withQuest:(NSString*)withQuest isMulit:(BOOL)isMulit;


-(void)reloadAllComponentWithPickViewArray:(NSArray *)array;
-(void)reloadComponent:(NSInteger)component withPickViewArray:(NSArray *)array;

+(void)dismissWithCompletion: (void(^)(NSArray *))completion;

@end
