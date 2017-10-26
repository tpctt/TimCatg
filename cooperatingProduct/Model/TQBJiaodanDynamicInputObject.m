//
//  TQBJiaodanDynamicInputObject.m
//  taoqianbao
//
//  Created by tim on 17/2/17.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodanDynamicInputObject.h"
static NSArray *  InputObjectTypeArray = nil;
 NSArray *getInputObjectTypeArray(){
    if(InputObjectTypeArray == nil){
        InputObjectTypeArray = @[
                                 @"hide",//隐藏
                                 @"label",//(标签),
                                 @"input",//(文本输入框),
                                 @"digit",//(整数),
                                 @"number",//(小数),
//                                 @"image",//(图片上传, 图片统一用basic64字符串处理),
                                 
                                 @"radio",//(单选框)
                                 @"checkbox",//(多选框)
                                 @"select",//(下拉选择),
                                 @"select_mutli",//(下拉选择),多选
                                 
//                                 @"photo",///身份证图片
//                                 @"image_id_photo_back",///身份证背面图片
 
                                 @"date", //ymd时间
                                 @"time", //yymm时间
                                 @"city", //城市
                                 
//                                 @"contact_name", //联系人姓名
//                                 @"contact_mobile", //联系人电话
//                                 @"imageVerifyCode", // 图片验证码
//                                 @"picture", // 大图
//                                 @"bankList", // bankList
                                 @"car_type", // 车辆型号选择*
                                 @"license_plate",//车牌归属地
                                 @"textarea", // 文本输入框

                                 ];
    }
   
    return InputObjectTypeArray;
}

const NSString* changeTypeToString(InputObjectType type){
    return getInputObjectTypeArray()[type];
}

const InputObjectType changeTypeToEnum(NSString *type)
{
    NSArray *array = getInputObjectTypeArray() ;
    for (NSInteger i  = 0 ; i < array.count;  i++ ) {
        NSString *string = array[i];
        if ([string isEqualToString:type]) {
            return i;
        }
    }
    return 0;
}


@implementation TQBJiaodanDynamicInputObjectGroup
-(BOOL)selected
{
    if (self.toggle == YES) {
        return _selected;
    }else{
        return YES;
    }
    
}

-(void)resetAllShowItems;

{
    NSMutableArray *array = [NSMutableArray array ];
    for(TQBJiaodanDynamicInputObject *obj in self.objects  ){
         
        [array addObject:obj];
        [array addObjectsFromArray:obj.subArray];
        
        
    }
//    return array;
    
    _allShowItems = array;
    
    
}

+(NSDictionary*)mj_objectClassInArray
{
    return @{
             @"objects":[TQBJiaodanDynamicInputObject class],
            
             };
    
}
@end


@implementation TQBJiaodanDynamicInputObject
+(NSDictionary*)mj_objectClassInArray
{
    return @{
             @"city_list":[TQBCityGroupsModel class],
             @"img_list":[TQBJiaodanImageObject class],

             };
    
}

- (void)mj_keyValuesDidFinishConvertingToObject{
    self.type_enum = changeTypeToEnum(self.type);
    if (self.extra == nil ) {
        self.extra = [Extra new];
    }
}


-(NSArray *)subArray
{
    if (self.extra.option) {
        
        for(TQBJiaodanDynamicInputOptionObject *option in self.extra.option  ){
            if ([option.value isEqualToString:self.value]) {
                //选中
//                return option.child_field;
                
                if (option.child_field.count == 0) {
                    return nil;
                    
                }else{
                    NSMutableArray *optionChildArray = [NSMutableArray array];
                    
                    for (TQBJiaodanDynamicInputObject *childObject in option.child_field) {
                        [optionChildArray addObject:childObject];
                        [optionChildArray addObjectsFromArray:childObject.subArray];
                    }
                    
                    return optionChildArray;
                }
                
            }
        }
        
    }
    return nil;
}


-(void)initDisplayNameIfNeed
{
    
    TQBJiaodanDynamicInputObject *object = self;
    ///处理 displayname
    if (object.extra.disPlayName == nil     ) {
        InputObjectType type_enum = object.type_enum;
        if( object.type_enum == InputObjectType_time_YMD ){
            if([object.value integerValue] > 0 ){
                object.extra.disPlayName = [TimeTool formatTime:[object.value integerValue] formatWith:@"yyyy-MM-dd"];
            }
            
        }else if( object.type_enum == InputObjectType_time_YM_YM ){
            if([object.value integerValue] > 0 ){
                object.extra.disPlayName = [TimeTool formatTime:[object.value integerValue] formatWith:@"yyyy-MM"];
            }
        }else if(type_enum == InputObjectType_select ||
                 type_enum == InputObjectType_radio ){
            
            ///从 option  里面填充数据
            for (TQBJiaodanDynamicInputOptionObject *obj in object.extra.option ) {
                if (object. value.length && [object.value integerValue] == [obj.id integerValue]) {
                    object.extra.disPlayName =  obj.value;
                    
                    break;
                    
                }
            }
        }else if (type_enum == InputObjectType_select_mutli ||
                  type_enum == InputObjectType_checkbox ){
            
            NSArray *tempIds = [object.value componentsSeparatedByString:@","];
            NSMutableArray *tempNumbers = [NSMutableArray array];
            NSMutableArray *selectObjects = [NSMutableArray array];
            
            ///从 option  里面填充数据
            for ( int i = 0 ; i<object.extra.option.count ; i++ ) {
                TQBJiaodanDynamicInputOptionObject *obj = [object.extra.option safeObjectAtIndex: i ];
                
                for (NSString *ID in tempIds) {
                    if ([ID integerValue] == [obj.id integerValue]) {
                        [tempNumbers addObject:@(i)];
                        ///
                        [selectObjects addObject:obj.value];
                        
                    }
                }
            }
            
            NSString *displayName = [selectObjects componentsJoinedByString:@","];
            object.extra.disPlayName =  displayName;
            
        }
        
        
    }
}
@end




@implementation TQBJiaodanDynamicInputOptionObject
+(NSDictionary*)mj_objectClassInArray
{
    return @{
             @"child_field":[TQBJiaodanDynamicInputObject class],
             @"extra":[OptionExtra class],

             };
    
}
@end

@implementation Extra
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"disPlayName":@"display",
             
             };
}
+(NSDictionary*)mj_objectClassInArray
{
    return @{
             @"option":[TQBJiaodanDynamicInputOptionObject class],
             
             };
    
}
@end

@implementation OptionExtra

@end

