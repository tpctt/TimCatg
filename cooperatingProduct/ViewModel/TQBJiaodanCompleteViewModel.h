//
//  TQBJiaodanCompleteViewModel.h
//  taoqianbao
//
//  Created by tim on 17/2/28.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "BaseListViewModel.h"

@interface TQBJiaodanCompleteViewModel : BaseListViewModel
@property (nonatomic, strong) NSString *identify_key;
@property (strong,nonatomic) NSString *recommadPath; ///推荐的产品 path

///
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, strong) NSString *order_id;

@end
