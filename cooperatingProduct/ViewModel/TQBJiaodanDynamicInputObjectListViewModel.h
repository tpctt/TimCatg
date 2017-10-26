//
//  TQBJiaodanDynamicInputObjectListViewModel.h
//  taoqianbao
//
//  Created by tim on 17/2/17.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "BaseListViewModel.h"
#import "TQBJiaodanDynamicTheme.h"

///获取动态列表
@interface TQBJiaodanDynamicInputObjectListViewModel : BaseListViewModel

///in/out
@property (nonatomic, strong) NSString *identify_key;
@property (nonatomic, strong) NSString *next_step;///当前/下一步的  url
@property (nonatomic, strong) NSString *verify_step;///验证的 url

///OUT
//@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) id field;///缓存用
@property (nonatomic, strong) TQBJiaodanDynamicTheme *theme;


@end
