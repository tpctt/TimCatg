//
//  TQBJiaodanVerifyViewModel.h
//  taoqianbao
//
//  Created by tim on 17/2/21.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "BaseListViewModel.h"

@interface TQBJiaodanVerifyViewModel : BaseListViewModel
///in
@property (nonatomic, strong) NSDictionary *inputInfo;
//@property (nonatomic, assign) BOOL save_order;



///in/out
//@property (nonatomic, strong) NSString *identify_key;
//@property (nonatomic, strong) NSString *step; ///当前验证的第几步
//@property (nonatomic, strong) NSString *verify_step;///验证的 path, 请求的 url

///out
@property (nonatomic, strong) NSString *next_step;

@end
