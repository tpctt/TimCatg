//
//  TQBJiaodandCompleteViewController.h
//  taoqianbao
//
//  Created by tim on 17/2/28.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "BaseViewController.h"

#import "JiaodanCompleteVC_Protocal.h"


@interface TQBJiaodandCompleteViewController : BaseViewController<JiaodanCompleteVC_Protocal>

@property (strong,nonatomic) NSString *identify_key;
@property (strong,nonatomic) NSString *recommadPath;

@end
