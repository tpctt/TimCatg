//
//  TQBJiaodanCellManager.h
//  taoqianbao
//
//  Created by tim on 17/2/28.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQBJiaodanDynamicTheme.h"
#import "TQBJiaodanBaseCell.h"

@class TQBJiaodanDynamicInputOptionObject;
@class TQBJiaodanDynamicInputObjectGroup;


@interface TQBJiaodanCellManager : NSObject<UITableViewDelegate, UITableViewDataSource , TQBJiaodanBaseCellDelegate >
@property (weak,nonatomic) UITableView * _Nullable table;


@property (strong,nonatomic,nonnull) NSArray<TQBJiaodanDynamicInputObjectGroup *> *itemsArray;///未构化的 item, 直接传入 VM.dataArray
@property (strong,nonatomic,nullable) NSString *identify_key; ///唯一 key
@property (strong, nonatomic,nullable) NSMutableDictionary *dataModel; ///传入传出的 model

@property (strong,nonatomic,nullable) TQBJiaodanDynamicTheme *theme;


-(BOOL)checkDataModel:( NSString  *_Nullable __autoreleasing * _Nullable  )msg checkAll:(BOOL)checkAll;

///清除 dataModel 里面多余的数据
-(void)cleanOtherInfoFromDataModel;

-(void)resetAllShowItems;

@end
