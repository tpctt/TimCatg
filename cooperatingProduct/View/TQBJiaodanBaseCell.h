//
//  TQBJiaodanBaseCell.h
//  taoqianbao
//
//  Created by tim on 17/3/7.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQBJiaodanDynamicInputObject.h"
#import "TQBJiaodanDynamicTheme.h"

#import <IQUIView+Hierarchy.h>


@protocol TQBJiaodanBaseCellDelegate <NSObject>//协议

- (void)opetionsDidChanged:(NSArray <TQBJiaodanDynamicInputOptionObject *>* __nullable)opetions;

@end

@interface TQBJiaodanBaseCell : UITableViewCell

@property (weak, nonatomic,nullable)   id <TQBJiaodanBaseCellDelegate> dataDelegate;
@property (strong, nonatomic,nullable)   NSIndexPath * indexPath;
@property (strong, nonatomic,nullable)   TQBJiaodanDynamicInputObject * model;
@property (strong, nonatomic,nullable)   TQBJiaodanDynamicInputObject * nextModel;

@property (strong, nonatomic,nullable)   NSMutableDictionary *dataModel;

@property (strong,nonatomic,nullable) TQBJiaodanDynamicTheme *theme; ///传递 cell 分割线的颜色

//-(UIViewController*)viewController;

///设置 key-value,  isAct 用于记录是否是 用户手动操作的,如果是用户操作计入用户行为记录
-(void)saveValue:(id _Nonnull)value forKey:(NSString *_Nonnull)key isAct:(BOOL)isAct opetions:(NSArray <TQBJiaodanDynamicInputOptionObject *>* __nullable)opetions;
-(void)saveValue:(id _Nonnull)value forKey:(NSString *_Nonnull)key isAct:(BOOL)isAct;


@end
