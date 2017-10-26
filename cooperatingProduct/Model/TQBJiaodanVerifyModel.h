//
//  TQBJiaodanVerifyModel.h
//  taoqianbao
//
//  Created by tim on 17/3/9.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQBJiaodanVerifyModel : NSObject
@property (strong,nonatomic,nullable) NSString *verify_key; ///verify_code", //验证码key
@property (strong,nonatomic,nullable) NSString *verify_type; ///sms", //验证码类型  sms 为短信  img 为图片
@property (strong,nonatomic,nullable) NSString *verify_data; ///", //如果验证码类型为图片 返回图片base64后的字符串 如果短信验证码为空
@property (strong,nonatomic,nullable) UIImage *image; ///", //如果验证码类型为图片 返回图片base64后的字符串 如果短信验证码为空
@property (strong,nonatomic,nullable) NSString *verify_step; ////jccfc/verify-mobile-captcha" //验证码表单提交地址 //返回值参照当前接口
@property (strong,nonatomic,nullable) NSString *verify_title;


@end
