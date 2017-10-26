//
//  TQBJiaodanDynamicTheme.h
//  taoqianbao
//
//  Created by tim on 17/3/6.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TQBJiaodanButtonAgreement;
@class TQBJiaodanLinkObject;

@interface TQBJiaodanDynamicTheme : NSObject
@property (strong,nonatomic,nullable) NSString *title; ///标题
@property (strong,nonatomic,nullable) NSString *tile_color; ///标题颜色
@property (strong,nonatomic,nullable) NSString *title_background_color; ///标题背景色
@property (assign,nonatomic) BOOL back_button_highlight; ///返回按钮是否高亮
@property (strong,nonatomic,nullable) NSString *button_title; ///按钮文字
@property (strong,nonatomic,nullable) NSString *button_color; //按钮文字颜色
@property (strong,nonatomic,nullable) NSString *button_background_color; ///#FC6225" //按钮背景色


@property (strong,nonatomic,nullable) NSString *field_focus_color; ///焦点颜色
@property (strong,nonatomic,nullable) TQBJiaodanButtonAgreement *button_agreement; ///焦点颜色

@property (assign,nonatomic) BOOL show_save_button; ///是否显示保存按钮
@property (nonatomic, strong,nullable) NSString *previous_step; ///上一步 url

+(TQBJiaodanDynamicTheme *_Nonnull)defaultTheme;

@end





@interface TQBJiaodanButtonAgreement : NSObject
@property (strong,nonatomic,nullable) NSString *label; ///申请即代表您同意",
@property (strong,nonatomic,nullable) NSArray<TQBJiaodanLinkObject *>*link; ///

@end

@interface TQBJiaodanLinkObject : NSObject
@property (strong,nonatomic,nullable) NSString *title;///授权协议》",
@property (strong,nonatomic,nullable) NSString *href;/// "https://www.taoqian123.com/"

@end
