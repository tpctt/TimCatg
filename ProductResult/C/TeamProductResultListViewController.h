//
//  GoldListViewController.h
//  KehuFox
//
//  Created by tim on 16/11/15.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import "BaseViewController.h"

///我的团队的某个人的 业绩详情
@interface TeamProductResultListViewController : BaseViewController

@property (strong,nonatomic) NSString *id;///产品 id
@property (strong,nonatomic) NSString *user_id;

@end
