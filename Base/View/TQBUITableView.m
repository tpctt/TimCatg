//
//  TQBUITableView.m
//  taoqianbao
//
//  Created by tim on 16/9/23.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "TQBUITableView.h"

@implementation TQBUITableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)reloadData
{
    [super reloadData];
    [self reloadEmptyDataSet];
    
}
@end
