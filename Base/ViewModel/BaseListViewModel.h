//
//  BaseViewModel.h
//  taoqianbao
//
//  Created by tim on 16/9/6.
//  Copyright © 2016年 tim. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TimBaseListViewModel.h>




@interface BaseViewModel : TimBaseViewModel
{
}

+(NSString *)session_id;
-(void)initNetError;

+(void)initPointsFor:(TimBaseViewModel *)vm;

@end




////list 的 VM
@interface BaseListViewModel : TimBaseListViewModel
-(void)initNetError;

@end
