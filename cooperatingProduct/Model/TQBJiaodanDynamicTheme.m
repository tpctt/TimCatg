//
//  TQBJiaodanDynamicTheme.m
//  taoqianbao
//
//  Created by tim on 17/3/6.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodanDynamicTheme.h"

@implementation TQBJiaodanDynamicTheme
+(TQBJiaodanDynamicTheme *)defaultTheme
{
    TQBJiaodanDynamicTheme *defaultTheme = [TQBJiaodanDynamicTheme new ];
    {
        defaultTheme.title = @"发起询价";
        defaultTheme.tile_color = @"0xffffff";
        defaultTheme.title_background_color = @"0x252731";
     
        defaultTheme.back_button_highlight = YES;
        
        defaultTheme.button_title = @"发起询价";
        defaultTheme.button_color = @"0xffffff";
        defaultTheme.button_background_color = @"0xff8309";

        defaultTheme.field_focus_color = @"0xff8309";
        
        {
            TQBJiaodanButtonAgreement *button_agreement = [TQBJiaodanButtonAgreement new];
            button_agreement.label = @"";
            {
                TQBJiaodanLinkObject *linkObject = [TQBJiaodanLinkObject new];
                linkObject.title = @"《询价服务协议》";
                linkObject.href = [Config sharedInstance].xunjia_service_agreement;
                
                button_agreement.link = @[linkObject];
            }
            
            
            defaultTheme.button_agreement = button_agreement;
//            defaultTheme.button_agreement = nil;

        }
        
        defaultTheme.show_save_button = NO;
        defaultTheme.previous_step = nil;

    }
    
    return defaultTheme;

    
}

@end


@implementation TQBJiaodanButtonAgreement
+(NSDictionary*)mj_objectClassInArray
{
    return @{
             @"link":[TQBJiaodanLinkObject class],
             
             };
    
}
@end


@implementation TQBJiaodanLinkObject

@end


