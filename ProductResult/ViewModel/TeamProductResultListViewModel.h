//
//  GoldListViewModel.h
//  KehuFox
//
//  Created by tim on 16/11/16.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import "BaseListViewModel.h"

@interface TeamProductResultListViewModel : BaseListViewModel

///in
@property (strong,nonatomic) NSString *user_id;
@property (strong,nonatomic) NSString  * id;
///out
@property (strong,nonatomic) NSString  * title;

@end
