//
//  ProductDetailGetUrlViewModel.h
//  KehuFox
//
//  Created by tim on 17/3/23.
//  Copyright © 2017年 timRabbit. All rights reserved.
//

#import "BaseListViewModel.h"

@interface ProductDetailGetUrlViewModel : BaseViewModel
//in
@property (strong,nonatomic) NSString *productID;

//subject_id
@property (nonatomic, strong) NSString *subject_id;
@property (nonatomic, strong) NSString *idenifer;

//out
@property (strong,nonatomic) NSString *href;
///返回产品申请类型  0为站外产品跳转到href 1为接口产品使用API申请
@property (assign,nonatomic) NSInteger apply_type;
@property (assign,nonatomic) NSInteger count_num;
@property (strong,nonatomic) NSString *identify_key;//API接入特有 申请流程唯一标识
@property (strong,nonatomic) NSString *first_step;//API接入特有 的第一步

@end

