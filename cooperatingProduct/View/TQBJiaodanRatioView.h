//
//  TQBManagerTagView.h
//  taoqianbao
//
//  Created by tim on 17/4/24.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSString *title,NSInteger index,BOOL selected);
@interface TQBJiaodanRatioView : UIView
@property (assign,nonatomic) BOOL mutli;
@property (copy,nonatomic) SelectBlock selectBlock;

@property (assign,nonatomic) NSInteger selectIndex; ///选中的 index
@property (strong,nonatomic) NSArray *selectIndexArray; ///选中的 index


-(void)setTags:(NSArray *)tags ;


@end
