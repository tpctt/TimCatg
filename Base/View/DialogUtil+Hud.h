//
//  DialogUtil+Hud.h
//  taoqianbao
//
//  Created by tim on 17/3/9.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <EasyIOS/EasyIOS.h>

@interface DialogUtil(Hud)
- (void)showHud:(UIView *) view withLabel:(NSString *) label;
+(void)showMessage:(NSString *)message;

@end
