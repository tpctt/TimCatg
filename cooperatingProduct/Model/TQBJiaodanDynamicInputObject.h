//
//  TQBJiaodanDynamicInputObject.h
//  taoqianbao
//
//  Created by tim on 17/2/17.
//  Copyright © 2017年 tim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQBJiaodanImageObject.h"

@class TQBJiaodanDynamicInputOptionObject;
@class TQBJiaodanDynamicInputObject;
@class Extra;

@interface TQBJiaodanDynamicInputObjectGroup : NSObject
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL toggle;//是否显示
@property (nonatomic, strong) NSArray <TQBJiaodanDynamicInputObject*> *objects;

@property (nonatomic, assign) BOOL selected;//是否选择

//OUT
@property (nonatomic, strong, readonly) NSArray <TQBJiaodanDynamicInputObject*> *allShowItems;

-(void)resetAllShowItems;


@end

typedef NS_ENUM(NSInteger , InputObjectType  ) {
    //字段类型  目前共有
    InputObjectType_hide = 0 , /*hide*/

    InputObjectType_label  , /*(标签)*/
    InputObjectType_input, /*(文本输入框),*/
    InputObjectType_digit, /*(整数),*/
    InputObjectType_number, /*(小数),*/
//    InputObjectType_image, /*(图片上传, 图片统一用basic64字符串处理),*/
    
    InputObjectType_radio, /*(单选框)*/
    InputObjectType_checkbox, /*(多选框)*/
    InputObjectType_select, /*(下拉选择),*/
    InputObjectType_select_mutli, /*(下拉选择),多选*/
    
//    InputObjectType_image_id_photo, /*身份证*/
//    InputObjectType_image_id_photo_back, /*身份证背面*/

    InputObjectType_time_YMD, /*时间- YMD*/
    InputObjectType_time_YM_YM, /*时间- YM*/
    

    
    InputObjectType_city_level2, /*2级城市*/
//    InputObjectType_city_level3, /*3级城市*/
    
//    InputObjectType_contact_name, /*联系人姓名*/
//    InputObjectType_contact_mobile, /*联系人电话*/
//    InputObjectType_image_verifyCode, /*图像验证码*/
//    InputObjectType_picture, /*显示大图*/
//    InputObjectType_bankList, /*bankList*/

    InputObjectType_car_type, /*车辆型号选择*/
    InputObjectType_car_license_plate, /*车牌归属地*/
    InputObjectType_big_input, /* 大文本框输入*/



    
          
};


 NSArray *getInputObjectTypeArray();

const NSString* changeTypeToString(InputObjectType type);
const InputObjectType changeTypeToEnum(NSString *type);



///动态列表的最小单位
@interface TQBJiaodanDynamicInputObject : NSObject

//@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, strong) Extra *extra;
//@property (nonatomic, strong) NSString *categoryTitle;
//@property (nonatomic, strong) NSString *categoryId;
/*
 "label",    //字段类型  目前共有
 label(标签),
 input(文本输入框),
 digit(整数),
 number(小数),
 image(图片上传, 图片统一用basic64字符串处理),
 select(下拉选择),
 radio(单选框)
 */
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) InputObjectType type_enum;
@property (nonatomic, assign) BOOL required;//是否必须输入


@property (nonatomic, strong) NSString *title;

///option 保存的 id
//@property (nonatomic, strong) NSString *templete_id;

@property (nonatomic, strong) NSString *value;
///key
@property (nonatomic, strong) NSString *name;


///自己添加的
@property (nonatomic, assign) BOOL isDisplay;
@property (nonatomic, assign) BOOL needReflash;///是否需要强制刷新
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSArray *city_list;///城市列表
@property (nonatomic, strong) NSArray<TQBJiaodanImageObject* > *img_list;//图片列表

@property (strong,nonatomic) NSString *identify_key;


///下级对象
-(NSArray *)subArray;
///自动完成 displayname
-(void)initDisplayNameIfNeed;


@end


@class OptionExtra;
///动态列表的最小单位 的选择对象
@interface TQBJiaodanDynamicInputOptionObject : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) OptionExtra *extra;

@property (nonatomic, strong) NSArray <TQBJiaodanDynamicInputObject*>*child_field;

@end


///动态列表的最小单位 的拓展
@interface Extra : NSObject
@property (nonatomic, assign) BOOL hide;//默认状态 是否显示 0 显示 1 不显示

@property (nonatomic, assign) CGFloat min;
@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) NSInteger maxlength;

@property (nonatomic, strong) NSString *disPlayName;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) BOOL readonly;///只读

@property (nonatomic, strong) NSString *default_img;

///
@property (nonatomic, strong) NSString *sub_title;
@property (nonatomic, strong) NSString *addon;
@property (nonatomic, strong) NSString *toast;//有数据的时候 没动作直接提示内容

@property (nonatomic, strong) NSArray <TQBJiaodanDynamicInputOptionObject*>*option;

@end


///选项 的拓展
@interface OptionExtra : NSObject

@property (nonatomic, strong) NSArray < NSString*>*show;//显示字段key
@property (nonatomic, strong) NSArray < NSString*>*hide;//隐藏字段key


@end

