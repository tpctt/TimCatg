//
//  TQBJiaodanCellManager.m
//  taoqianbao
//
//  Created by tim on 17/2/28.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodanCellManager.h"

#import "TQBJiaodanVerifyViewModel.h"
#import "TQBJiaodanDynamicInputObject.h"

#import "TQBJiaoDanInputCell.h"
#import "TQBSectionTableViewCell.h"
#import "TQBJiaodanRadioCell.h"
#import "TQBJiaodanBigInputCell.h"

#import "UITableViewCell+SepLine.h"
#import "TQBJiaodanSectionHeader.h"

#import <GCDObjC.h>


@interface TQBJiaodanCellManager()

@property (strong, nonatomic)   NSMutableDictionary *customStoreCells;
//@property (strong, nonatomic)   TQBJiaodanDynamicInputObjectGroup *group;
@property (strong, nonatomic)   NSArray<TQBJiaodanDynamicInputObjectGroup *> *group_array;

@end

@implementation TQBJiaodanCellManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.customStoreCells = [NSMutableDictionary dictionary ];
        self.dataModel = [NSMutableDictionary dictionary ];
        
//        self.group = [[TQBJiaodanDynamicInputObjectGroup alloc] init];
        
    }
    return self;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.group_array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TQBJiaodanDynamicInputObjectGroup *group = [self.group_array objectAtIndex:section];
     
    if (group.selected == YES) {
        return group.allShowItems.count;

    }
    else{
        return 0;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TQBJiaodanDynamicInputObjectGroup *group = [self.group_array objectAtIndex:indexPath.section];
    TQBJiaodanDynamicInputObject *object = [group.allShowItems objectAtIndex:indexPath.row];
    
    ///多层结构, 是否显示
    if (object.extra.hide == YES) {
        return 0;
    }
    
    
    if (object.type_enum == InputObjectType_hide) {
        
        return 0;
        
    }
    else    if (object.type_enum == InputObjectType_label) {
        
        return UITableViewAutomaticDimension;
        
        return 32;
        
    }
    else  if (object.type_enum == InputObjectType_input ||
              object.type_enum == InputObjectType_digit ||
              object.type_enum == InputObjectType_number
              
              ) {
        return 54;
        
    }else if (object.type_enum == InputObjectType_select) {
        return 54;
        
    }else if (object.type_enum == InputObjectType_select_mutli) {
        return 54;
        
    }
    else if (object.type_enum == InputObjectType_radio) {
        return 100;
    }
    else if (object.type_enum == InputObjectType_checkbox) {
        return 100;
    }
    
    else  if (object.type_enum == InputObjectType_time_YMD
              ) {
        return 54;
        
    }
    else  if (object.type_enum == InputObjectType_time_YM_YM
              ) {
        return 54;
        
    }
    else  if (object.type_enum == InputObjectType_city_level2
              ) {
        
        return 54;
        
    }
    else  if (object.type_enum == InputObjectType_car_type
              ) {
        
        return 54;
        
    }
    else  if (object.type_enum == InputObjectType_car_license_plate
              ) {
        
        return 54;
        
    }
    else  if (object.type_enum == InputObjectType_big_input
              ) {
        
        return 154;
        
    }
//    else if (object.type_enum == InputObjectType_image) {
//        return 54;
    
//    }else if (object.type_enum == InputObjectType_image_id_photo
////              ||object.type_enum == InputObjectType_image_id_photo_back
//              ) {
//        return 200;
//        
//    }
    
        
//    }else if (object.type_enum == InputObjectType_contact_name||
//              object.type_enum == InputObjectType_contact_mobile) {
//        return 54;
//        
//    }else if (object.type_enum == InputObjectType_image_verifyCode) {
//        return 54;
//        
//    }else if (object.type_enum == InputObjectType_picture) {
//        
//        return UITableViewAutomaticDimension;
//        
//    }
    return 54;
    
}



///不使用reusable
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TQBJiaodanDynamicInputObjectGroup *group = [self.group_array objectAtIndex:indexPath.section];
    TQBJiaodanDynamicInputObject *object = [group.allShowItems objectAtIndex:indexPath.row];
    TQBJiaodanDynamicInputObject *nextObject = [group.allShowItems safeObjectAtIndex:indexPath.row+1];
    
    object.identify_key = self.identify_key;

    
    //    object.type_enum = InputObjectType_image;
    
    TQBJiaodanBaseCell *baseCell = nil;
    
    
    if (object.type_enum == InputObjectType_label) {
        TQBSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TQBSectionTableViewCell"];
        
        cell.string = object.title;
        
        
        return cell;
    }
    else  if (object.type_enum == InputObjectType_input ||
              object.type_enum == InputObjectType_digit ||
              object.type_enum == InputObjectType_number
              
              ) {
        
        TQBJiaodanBaseCell *cell = [self getCellForClass:[TQBJiaoDanInputCell class] object:object];

        baseCell = cell;
        
    }
  
    
    
    
//    else if (object.type_enum == InputObjectType_image) {
//        
//        TQBJiaodanBaseCell *cell = [self getCellForClass:[TQBJiaodanImageSelectCell class] object:object];
//        
//        baseCell = cell;
//        
//    }
//    else if (object.type_enum == InputObjectType_image_id_photo
////             ||object.type_enum == InputObjectType_image_id_photo_back
//             ) {
//        
//        TQBJiaodanBaseCell *cell = [self getCellForClass:[TQBJiaodanImageInputCell class] object:object];
//        
//        baseCell = cell;
//        
//        
//       
//    }
    
    
    else if (object.type_enum == InputObjectType_select||
             object.type_enum == InputObjectType_select_mutli) {
        
        TQBJiaodanBaseCell *cell = [self getCellForClass:[TQBJiaoDanInputCell class] object:object];
        
        baseCell = cell;
       
       
        
    }
    else if (object.type_enum == InputObjectType_radio||
             object.type_enum == InputObjectType_checkbox) {
        
        TQBJiaodanBaseCell *cell = [self getCellForClass:[TQBJiaodanRadioCell class] object:object];
        
        baseCell = cell;
        
        
    }
    else  if (object.type_enum == InputObjectType_time_YMD ||
              object.type_enum == InputObjectType_time_YM_YM
              
              ) {
        
        TQBJiaodanBaseCell *cell = [self getCellForClass:[TQBJiaoDanInputCell class] object:object];
        
        baseCell = cell;
        
    }
    else if (object.type_enum == InputObjectType_city_level2) {
        
        TQBJiaodanBaseCell *cell = [self getCellForClass:[TQBJiaoDanInputCell class] object:object];
        
        baseCell = cell;
    }
    else if (object.type_enum == InputObjectType_car_type ||
             object.type_enum == InputObjectType_car_license_plate
             ) {
        
        TQBJiaodanBaseCell *cell = [self getCellForClass:[TQBJiaoDanInputCell class] object:object];
        
        baseCell = cell;
    }
    else if (object.type_enum == InputObjectType_big_input) {
        TQBJiaodanBaseCell *cell = [self getCellForClass:[TQBJiaodanBigInputCell class] object:object];

        baseCell = cell;
        
    }
    
    
    
    if (baseCell) {
        
        baseCell.dataDelegate = self;

        
        baseCell.indexPath = indexPath;
        baseCell.dataModel = _dataModel;
        baseCell.model = object;
        baseCell.nextModel = nextObject;
        
        baseCell.theme = self.theme;
        baseCell.hideCellSeparatorLine = [self hideCellSepLine:indexPath];
        baseCell.clipsToBounds = YES;
        
        return baseCell;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
    
}
#pragma mark - Table view delegate source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    TQBJiaodanDynamicInputObjectGroup *group = [self.group_array objectAtIndex:section];
    if (group.title.length !=0) {
        if (group.desc.length == 0) {
            return 44;
        }
        return 85;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TQBJiaodanDynamicInputObjectGroup *group = [self.group_array objectAtIndex:section];
    if (group.title.length !=0) {
        
        @weakify(self);
        TQBJiaodanSectionHeader *header = [[TQBJiaodanSectionHeader alloc] init];
        
        [header setObject:group section:section];
        
        [[header.actBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             @strongify(self);
             
             group.selected = !group.selected;
             [self.table reloadData];
             //             [self.table reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationTop];
             
         }];
        if (group.toggle == NO) {
            header.actBtn.hidden = YES;
        }
        return header;
        
    }else{
        return nil;
    }
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



//获取 cell
-(nullable TQBJiaodanBaseCell *)getCellForClass:(Class)class object:(TQBJiaodanDynamicInputObject *)object{
    
    TQBJiaodanBaseCell  *cell = [self.customStoreCells objectForKey:object.name];
    
    if(cell == nil){
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(class) owner:nil options:nil];
        for (id oneObject in array) {
            if ([oneObject isKindOfClass:class]) {
//                    cell = (TQBJiaoDanInputCellContactName *)oneObject;
                cell = (TQBJiaodanBaseCell *)oneObject;

            }
        }
        if (cell) {
            [self.customStoreCells setObject:cell forKey:object.name];
        }
        
    }

    return cell;
    
}

///?是否异常分割线
-(BOOL)hideCellSepLine:(NSIndexPath *)indexPath{
    TQBJiaodanDynamicInputObjectGroup *group = [self.group_array objectAtIndex:indexPath.section];
//    TQBJiaodanDynamicInputObject *object = [group.allShowItems objectAtIndex:indexPath.row];
    TQBJiaodanDynamicInputObject *nextObject = [group.allShowItems safeObjectAtIndex:indexPath.row+1];
    
    if(nextObject == nil ) return YES;
    
    InputObjectType type_enum = nextObject.type_enum ;
    if (type_enum == InputObjectType_label) {
        return YES;
    }
    
    return NO;
    
}



-(void)resetAllShowItems
{
    for (TQBJiaodanDynamicInputObjectGroup *group in self.group_array) {
        [group resetAllShowItems];
        
        
        ///获取数据之后 按照 data 处理数据
        if (self.dataModel != nil) {
            for (TQBJiaodanDynamicInputObject *object in group.allShowItems ) {
                
                if( object.name){
                    NSString *value = [self.dataModel valueForKey:object.name];
                    
                    if (value.length) {
                        object.value = value;
                        
                    }
                    
                }
            }
        }
        

    }
    
    
    
}

-(BOOL)checkDataModel:(NSString **)msg
{
    return [self checkDataModel:msg checkAll:NO];
}
-(BOOL)checkDataModel:(NSString **)msg checkAll:(BOOL)checkAll
{

    BOOL flag = YES;

    for (TQBJiaodanDynamicInputObjectGroup *group in self.group_array) {
        
        NSArray *array = group.allShowItems;
        for (TQBJiaodanDynamicInputObject *object in array ) {
            if (object.extra.hide == YES) {
                continue;
            }
            if (object.type_enum == InputObjectType_label) {
                continue;
            }
            
            
            if (object.type_enum == InputObjectType_hide && object.value  && object.name ) {
                [self.dataModel setObject:object.value forKey:object.name];
                
            }
            
            NSString *key = object.name;
            NSString *value = [self.dataModel objectForKey:key] ;
            
            
            if( value.length == 0 && object.required == YES )
            {
                if (object.type_enum == InputObjectType_digit ||
                    object.type_enum == InputObjectType_input ||
                    object.type_enum == InputObjectType_number
                    
                    ) {
                    NSString *showMsg = [NSString stringWithFormat:@"请输入%@",object.title];
                    *msg = showMsg;
                    
                }else{
                    NSString *showMsg = [NSString stringWithFormat:@"请选择%@",object.title];
                    *msg = showMsg;
                    
                }
                
                {
                    
                    NSIndexPath *path = [NSIndexPath indexPathForRow:[array indexOfObject:object] inSection:[self.group_array indexOfObject:group]];
                    [self.table scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                    
                    [[GCDQueue mainQueue] queueBlock:^{
                    
                        TQBJiaodanBaseCell *cell = [self.table cellForRowAtIndexPath:path];
                        if (cell) {
                            [cell becomeFirstResponder];
                        }
                        
                    } afterDelay:0.5];
                    
                    
                }
                
                
                flag = NO;
                if (checkAll) {
                    
                }else{
                    return  NO;
                    
                }
            }
        }
    
    }
    
    return  flag;

}
///清除 dataModel 里面多余的数据
-(void)cleanOtherInfoFromDataModel
{
    NSMutableDictionary *info = [NSMutableDictionary    dictionary];

    for (TQBJiaodanDynamicInputObjectGroup *group in self.group_array) {
        
        NSArray *allShowItems = group.allShowItems ;
        for (TQBJiaodanDynamicInputObject *object  in allShowItems) {
            if (object.extra.hide == YES ) {
                continue;
            }
            
            NSString *key = object.name;
            id value = [self.dataModel objectForKey:key] ;
            if (value) {
                [info setObject:value forKey:key];
                
            }
          
        }
        
//        NSArray *Keys = [allShowItems valueForKey:@"name"];
//        for (NSString *key in Keys ) {
//
//
//        }
        
       
        
    }
    
    [self.dataModel removeAllObjects];
    [self.dataModel addEntriesFromDictionary:info];
    
    
    
}
///处理 数据到dataModel
-(void)initInfoToDataModel
{
    NSMutableDictionary *info = [NSMutableDictionary    dictionary];
    
    for (TQBJiaodanDynamicInputObjectGroup *group in self.group_array) {
        
        NSArray *allShowItems = group.objects ;
        
        
        for (TQBJiaodanDynamicInputObject *object in allShowItems ) {
            id value = object.value ;
            if (value) {
                ///设置 dataModel 数据
                [info setObject:value forKey:object.name];
                ///初始化 displayname
                [object initDisplayNameIfNeed];
                
            }
        }
    }
    
    [self.dataModel removeAllObjects];
    [self.dataModel addEntriesFromDictionary:info];
    
    
    
}
-(void)setItemsArray:(NSArray *)itemsArray
{
//    self.group.objects = self.itemsArray;
//    self.group.objects = itemsArray;
    
    
    _itemsArray = itemsArray;
    
    self.group_array = itemsArray;
    
    
    [self initInfoToDataModel];
    
    
    [self resetAllShowItems];
    
}

//选择项发生了变化
- (void)opetionsDidChanged:(NSArray <TQBJiaodanDynamicInputOptionObject *>* __nullable)opetions
{
    NSMutableArray *showArray = [NSMutableArray array];
    NSMutableArray *hideArray = [NSMutableArray array];
    
    for (TQBJiaodanDynamicInputOptionObject *option in opetions) {
        [showArray addObjectsFromArray:option.extra.show];
        [hideArray addObjectsFromArray:option.extra.hide];
    }
    if (showArray.count + hideArray.count == 0) {
        return;
    }
    
    
    BOOL flag  = NO; //是否刷新
    for (TQBJiaodanDynamicInputObjectGroup *group in self.group_array ) {
        for (TQBJiaodanDynamicInputObject *object in group.objects ) {
            for (NSString *show in showArray ) {
                if ([show isEqualToString:object.name]) {
                    object.extra.hide = NO;
                    flag = YES;
                    
                }
            }
            
            for (NSString *hide in hideArray ) {
                if ([hide isEqualToString:object.name]) {
                    object.extra.hide = YES;
                    
                    object.value = nil;
                    [self.dataModel removeObjectForKey:object.name];
                    
                    flag = YES;
                    
                }
            }
            
            
        }
    }
    
    
    if (flag == YES) {
        [self.table reloadData];
    }
    
}

@end
