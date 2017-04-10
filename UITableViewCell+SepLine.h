//
//  UITableViewCell+SepLine.h
//  taoqianbao
//
//  Created by tim on 17/3/1.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (SepLine)

@property (assign, nonatomic)   BOOL hideCellSeparatorLine;///隐藏分割线,默认 NO
@property (assign, nonatomic)   BOOL isTopLine;///分割线显示在顶部还是底部,默认 NO

-(void)setSepLineColor:(UIColor*)color;
-(void)resetSepLine;

@end
