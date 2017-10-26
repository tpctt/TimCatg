//
//  TQBJiaodanBaseViewController.h
//  taoqianbao
//
//  Created by tim on 17/2/16.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "BaseViewController.h"
#import "JiaodanCompleteVC_Protocal.h"

#import "KHConfirmInfoViewController.h"

@interface TQBJiaodanBaseViewController : BaseViewController
///API接入特有 申请流程唯一标识
@property (strong,nonatomic) NSString *identify_key;
///第几步
//@property (assign,nonatomic) NSInteger step;
@property (strong,nonatomic) NSString *first_step;//API接入特有 的第一步

//@property (nonatomic, strong) NSArray * dataArray;
@property (strong,nonatomic) UIViewController<JiaodanCompleteVC_Protocal> *completeVC;//完成的第一步

@end
