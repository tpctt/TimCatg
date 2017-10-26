//
//  JiaoDanInputCell.m
//  Wedai
//
//  Created by 中联信 on 15/9/30.
//  Copyright © 2015年 Tim.rabbit. All rights reserved.
//

#import "TQBJiaoDanInputCell.h"

#import <IQKeyboardManager/IQUIView+Hierarchy.h>
#import <EasyIOS/MMPickerView.h>
#import <ReactiveCocoa/UIDatePicker+RACSignalSupport.h>
#import <TalkingData.h>
#import <MJExtension.h>

#import "MMlistView.h"
#import "MMDatePickerView.h"
#import "MMPickerView.h"
#import "UIViewSubline.h"
#import "UITableViewCell+SepLine.h"

#import "TimCarTypeSelect.h"
#import <GCDObjC.h>

#import "QFDatePickerView.h"


@interface TQBJiaoDanInputCell()
@property (strong,nonatomic) UIDatePicker *datePicker;
@property (strong,nonatomic) MMPickerView *cityPicker;
@property (weak, nonatomic) IBOutlet UILabel *danwei;
///之前选择的选项,用于优化刷新策略
@property (strong,nonatomic) TQBJiaodanDynamicInputOptionObject *preOption;

@end

@implementation TQBJiaoDanInputCell
-(void)initWithoutNib
{
     
}
-(BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    if(self.value.enabled == YES){
        return [self.value resignFirstResponder];
        
    }else{
        return 1;
    }
    return 1;
    
}
-(BOOL)becomeFirstResponder
{
 
  
    [super becomeFirstResponder];
    
    
    
    if(self.value.enabled == YES){
        [self valueTextAct:nil];
        
        return [self.value becomeFirstResponder];
        
    }else{
        [self subBtnAct:self.subBtn];
        return 1;
    }
    return 1;
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.name.adjustsFontSizeToFitWidth = 1;

    self.datePicker = [[UIDatePicker alloc]init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.value.textAlignment = NSTextAlignmentRight;
    
    @weakify(self);
    [[self.value rac_signalForControlEvents:UIControlEventEditingDidBegin]subscribeNext:^(id x) {
        
        @strongify(self);
        if (self.theme) {
            UIColor *color = [UIColor colorWithString:self.theme.field_focus_color];
            [self setSepLineColor:color];
            
        }
        
    }];
    
    [[self.value rac_signalForControlEvents:UIControlEventEditingDidEnd]subscribeNext:^(id x) {
        
        @strongify(self);
        [self resetSepLine];
        
        
    }];

}


-(void)valueTextAct:(id)sender
{
    @weakify(self);
    
    self.value.inputAccessoryView = nil;
    NSString *key = self.model.name ;
    NSString *value = [self.dataModel objectForKey:key];
    
    if (value) {
        self.value.text = value;
        
    }
    
    RACSignal *signal_end       =      [self.value rac_signalForControlEvents:UIControlEventEditingDidEnd];
    RACSignal *signal_changed   =      [self.value rac_signalForControlEvents:UIControlEventEditingChanged];
    
    ///保存数据的 block
    void (^DataSaveBlock)(BOOL) = ^(BOOL idEndEidt){
        
        if (self.value.text != nil ) {
         
            self.model.value = self.value.text;
            
//            [self.dataModel setObject:self.value.text forKey:key];
        
            ///
            [self saveValue:self.value.text forKey:key isAct:idEndEidt];
            
            

        }
    };
    
    ///检查最大长度block
    void (^MaxLengthCheckBlock)(BOOL) = ^(BOOL idEndEidt){
        if(self.model.extra.maxlength!=0 && self.value.text.length !=0){
            if (self.model.extra.maxlength  < [self.value.text length]) {
                self.value.text = [self.value.text substringToIndex:self.model.extra.maxlength];
            }
        }
    };
    
    ///小数类型,检查小数是否满足格式
    BOOL (^DotCheckBlock)(void) = ^BOOL(void){
        NSString *a =    self.value.text ;
        {
            NSMutableString *strippedString = [NSMutableString
                                               stringWithCapacity:a.length];
            
            NSScanner *scanner = [NSScanner scannerWithString:a];
            NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
            
            while ([scanner isAtEnd] == NO) {
                NSString *buffer;
                if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
                    
                    [strippedString appendString:buffer];
                }
                else {
                    [scanner setScanLocation:([scanner scanLocation] + 1)];
                }
            }
            
            NSMutableString *strippedString2 = [NSMutableString
                                                stringWithCapacity:a.length];
            BOOL hadDot= NO;
            
            for (NSInteger i =0; i<strippedString.length; i++) {
                NSString *subString = [strippedString substringWithRange:NSMakeRange(i, 1)];
                if ([subString isEqualToString:@"."]) {
                    if (hadDot == YES) {
                        
                    }else{
                        hadDot = YES;
                        [strippedString2 appendString:subString];
                    }
                }else{
                    [strippedString2 appendString:subString];
                    
                }
            }
            
            
            
            a = strippedString2;
            //                    return strippedString;
            self.value.text = a ;
            
            return hadDot;
            
        };
        
        //                 self.value.text = a ;
        
        
    };
    
    ///小数点位置检查
    void (^DotLocationCheckBlock)(BOOL,NSInteger) = ^(BOOL  idEndEidt , NSInteger afterDot_length){
        ///小数点前面
        NSRange rang = [self.value.text rangeOfString:@"."];
        NSInteger dot_loc = rang.location;
        NSInteger dot_length = rang.length;
        
        if (dot_length > 0 ) {
            
            if(self.value.text.length - dot_loc > afterDot_length ){
                ///小数点后
                self.value.text = [self.value.text substringToIndex:dot_loc + afterDot_length +1  ];
                //                    self.value.text = [self.value.text substringToIndex:self.model.text_length + self.model.afterDot_length  +1 ];
                
            }else{
                
            }
            ///
        }
    };
    
    
    
    ///最大值检查
    void (^ MaxValueCheckBlock)(BOOL,BOOL) = ^(BOOL  idEndEidt , BOOL hadDot ){
        if (hadDot) {
            
            if(self.model.extra.max != 0 && self.value.text.length != 0){
                if (self.model.extra.max  < [self.value.text floatValue]) {
                    self.value.text = @(self.model.extra.max).stringValue;
                    
                }
            }
            
        }else{
            ///最大值
            if(self.model.extra.max != 0 && self.value.text.length != 0){
                if (self.model.extra.max  < [self.value.text integerValue]) {
                    self.value.text = @(self.model.extra.max).stringValue;
                    
                }
            }
        }
        
    };
    
    ///最小值检查
    void (^ MinValueCheckBlock)(BOOL,BOOL) = ^(BOOL  idEndEidt , BOOL hadDot ){
        
        if (hadDot) {
            if(idEndEidt ==YES && self.model.extra.min !=0 && self.value.text.length !=0){
                if (self.model.extra.min   > [self.value.text floatValue]) {
                    self.value.text = @(self.model.extra.min).stringValue;
                }
            }
            
        }else{
            ///最小值
            if(idEndEidt ==YES && self.model.extra.min !=0 && self.value.text.length !=0){
                if (self.model.extra.min   > [self.value.text integerValue]) {
                    self.value.text = @(self.model.extra.min).stringValue;
                }
            }
        }
        
        
    };
    
    
    ///移除数值 多余的0
    void (^ RemoveNumberPrefixBlock)(BOOL,BOOL) = ^(BOOL  idEndEidt , BOOL hadDot ){
        
        if (hadDot) {
            if(idEndEidt ==YES && self.value.text.length !=0){
                if ( [self.value.text floatValue] != 0  ) {
                    self.value.text = @([self.value.text integerValue] ).stringValue;
                }
            }
            
        }else{
            ///最小值
            if(idEndEidt ==YES  && self.value.text.length !=0){
                if ([self.value.text integerValue] != 0 ) {
                    self.value.text = @([self.value.text integerValue] ).stringValue;
                }
            }
        }
        
        
    };
    
    if (self.model.type_enum == InputObjectType_input ) {
        
      
        //take:1
        [[signal_end takeUntil:self.rac_prepareForReuseSignal ]
         subscribeNext:^(id x) {
             MaxLengthCheckBlock(YES);
             DataSaveBlock(YES);
             
         }];
        
        [[signal_changed takeUntil:self.rac_prepareForReuseSignal ]
         subscribeNext:^(id x) {
             MaxLengthCheckBlock(NO);
             DataSaveBlock(NO);

        }];
        
    }
    
    else    if (self.model.type_enum == InputObjectType_digit ) {
        ///纯数字
        
        
        //take:1
        [[signal_end takeUntil:self.rac_prepareForReuseSignal ]
         subscribeNext:^(id x) {
             @strongify(self);
             
             self.value.text = [self.value.text getOutOfTheNumber];
             
             MinValueCheckBlock(YES,NO);
             
             MaxValueCheckBlock(YES,NO);
             
             RemoveNumberPrefixBlock(YES,NO);
             
             DataSaveBlock(YES);
             
             
         }];
        
        [[signal_changed takeUntil:self.rac_prepareForReuseSignal ]
         subscribeNext:^(id x) {
             @strongify(self);
             
             self.value.text = [self.value.text getOutOfTheNumber];
             
             MinValueCheckBlock(NO,NO);
             
             MaxValueCheckBlock(NO,NO);
             
             RemoveNumberPrefixBlock(NO,NO);

             DataSaveBlock(NO);
             
         }];

        
    }

    else if (self.model.type_enum == InputObjectType_number ) {
       ///小数
        
        //take:1
        [[signal_end takeUntil:self.rac_prepareForReuseSignal ]
         subscribeNext:^(id x) {
             BOOL hadDot = DotCheckBlock();
             
             DotLocationCheckBlock(YES, 2);
             
             MinValueCheckBlock(YES,hadDot);
             
             MaxValueCheckBlock(YES,hadDot);
             
             RemoveNumberPrefixBlock(YES,hadDot);
             
             DataSaveBlock(YES);
             
         }];
        
        [[signal_changed takeUntil:self.rac_prepareForReuseSignal ]
         subscribeNext:^(id x) {
             BOOL hadDot = DotCheckBlock();
            
             DotLocationCheckBlock(NO, 2);
             
             MinValueCheckBlock(NO,hadDot);
             
             MaxValueCheckBlock(NO,hadDot);
             
             RemoveNumberPrefixBlock(NO,hadDot);

             DataSaveBlock(NO);
            
             
         }];
        
    }
    
}


-(void)saveValue:(id)value forKey:(NSString *)key isAct:(BOOL)isAct
{
    if (self.model.extra.hide == YES) {
        self.model.value = nil;
        self.model.extra.disPlayName = nil;
        self.value.text = nil;
        
    }
    
    [super saveValue:value forKey:key isAct:isAct];
    
}
-(void)setModel:(TQBJiaodanDynamicInputObject *)model
{
    @weakify(self);
    if ( super.model==model &&YES== [super.model.extra.disPlayName isEqualToString:model.extra.disPlayName] ) {
        
        return;
        
    }

    
    super.model= model;
    self.name.text  = model.title?:@"";
    self.value.text  = @"";
    self.value.placeholder = model.extra.placeholder;
    
    
    
    
   {
///填充数据
        
        InputObjectType type_enum = model.type_enum;
       
//        NSString *key = self.model.name ;
//        NSString *value = self.model.value ;
//        
//        NSLog(@"key:%@ - value:%@",key,value);
//        [self.dataModel setObject:value forKey:key];
//        
       if( type_enum == InputObjectType_input ||
          type_enum == InputObjectType_number ||
          type_enum == InputObjectType_digit
          ){
           ///输入框
           self.subBtn.hidden = YES;
           self.value.enabled = YES;
           
           
           
           NSString *key = self.model.name ;
           NSString *value = self.model.value ;
           [self saveValue:value forKey:key isAct:NO];
           
        
           [self valueTextAct:nil];
           
           self.value.text = self.model.value;
           
           
           
       }
       
       
        if(type_enum == InputObjectType_select){
            self.subBtn.hidden = NO;
            self.value.enabled = NO;
            
           
            NSString *key = self.model.name ;
            NSString *value = self.model.value ;
            [self saveValue:value forKey:key isAct:NO];
            
            self.value.text = self.model.extra.disPlayName;

            
        }
       
        else
        if( type_enum == InputObjectType_select_mutli ){
            //多选
            self.subBtn.hidden = NO;
            self.value.enabled = NO ;
            
            
            NSString *key = self.model.name ;
            NSString *value = self.model.value ;
            [self saveValue:value forKey:key isAct:NO];
            
            self.value.text = self.model.extra.disPlayName;
            

        }
       
        else
        if( type_enum == InputObjectType_time_YMD ){
            self.subBtn.hidden = NO;
            self.value.enabled = NO;
            
            
            NSString *key = self.model.name ;
            NSString *value = self.model.value ;
            [self saveValue:value forKey:key isAct:NO];
            
            self.value.text = self.model.extra.disPlayName;
            
            
        }
        else
        if( type_enum == InputObjectType_time_YM_YM ){
            self.subBtn.hidden = NO;
            self.value.enabled = NO;
            
            
            NSString *key = self.model.name ;
            NSString *value = self.model.value ;
            [self saveValue:value forKey:key isAct:NO];
            
            self.value.text = self.model.extra.disPlayName;
            
            
            
        }
        else
        if( type_enum == InputObjectType_city_level2 ){
            self.subBtn.hidden = NO;
            self.value.enabled = NO;
            
            NSString *key = self.model.name ;
            NSString *value = self.model.value ;
            [self saveValue:value forKey:key isAct:NO];
            
            self.value.text = self.model.extra.disPlayName;
            
        
        }
       
        else
        if( type_enum == InputObjectType_car_type ||
           type_enum == InputObjectType_car_license_plate ){
            self.subBtn.hidden = NO;
            self.value.enabled = NO;
            
            
            NSString *key = self.model.name ;
            NSString *value = self.model.value ;
            [self saveValue:value forKey:key isAct:NO];
            
            self.value.text = self.model.extra.disPlayName;
            
            
            
        }
       
       
            
       
       
        
        
        ///键盘
        if( type_enum == InputObjectType_input
           ){
            self.value.keyboardType = UIKeyboardTypeDefault;
 
        }else  if(  type_enum == InputObjectType_number
                   ){
            self.value.keyboardType = UIKeyboardTypeDecimalPad;

            
        }else  if(type_enum == InputObjectType_digit
                  ){
            self.value.keyboardType = UIKeyboardTypeNumberPad;
     
        }
        
        
        
        self.danwei.text = model.extra.addon;
        self.danwei.hidden = !model.extra.addon.length;

        ///让没有单位的时候一样对齐
        self.valueFieldCC.constant = model.extra.addon.length ==0 && self.subBtn.hidden ==YES ?16:83;
//       self.valueFieldCC.priority = model.extra.addon.length ==0 && self.subBtn.hidden ==YES ? 750 :1000 ;
       
        
    }
    
    
    ///只读
    if (self.model.extra.readonly) {
        self.subBtn.enabled = NO;
        self.value.enabled = NO;
        
    }
    
    
}

#pragma mark 下拉按钮的动作
///自定义动作,-11
-(void)customAct
{
//    [self.model.tagert performSelector:self.model.act];

}
///普通选项,2
-(void)normalSelectView
{
    {
        
        NSArray *array = [self.model.extra.option valueForKey:@"value"];
        if (!array) {
            SHOWMSG(@"没有可用选项");
            return;
        }
        
        [MMlistView showPickerViewInView:self.viewController.view withStrings:@[array] withOptions:nil selected:^(MMlistView *mmPickView, NSInteger row, NSInteger component) {
            
        } completion:^(NSArray *selectedString) {
            
            NSNumber *select = selectedString[0];
            if (select == nil) {
                return ;
            }
            
            NSInteger row = [select integerValue];
            
            TQBJiaodanDynamicInputOptionObject *obj = [self.model.extra.option safeObjectAtIndex:row];
            if(obj==nil){
                return ;
            }
            
            ///非显示obj的其他对应关系,如房产类型 去处理有无房产的数据
//            if (obj.value_2 && self.model.field_2   ) {
//                [self.dataModel setObject:obj.value_2 forKey:self.model.field_2];
//            }
            
            
            self.value.text = obj.value;
            self.model.extra.disPlayName = self.value.text    ;
            self.model.value = obj.id ;
            
            
            NSString *key = self.model.name ;
            NSString *value = self.model.value ;
            
            
            [self saveValue:value forKey:key isAct:YES opetions:@[obj] ];
            

//            if (self.model.nextArray.count) {
//                YijiaoKehuInputViewController *VC = (YijiaoKehuInputViewController*)self.viewController;
//                NSIndexPath *path = [VC.tableView indexPathForCell:self];
//                [VC.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:1];
//            }
            
            BOOL needReload = YES;
            if ( obj == self.preOption ) {
                needReload = NO;
            }else if(self.preOption.child_field == obj.child_field ){
                needReload = NO;
            }
            
            if(needReload){
                [[NSNotificationCenter defaultCenter]postNotificationName:ReloadSectionNotifaction object:nil];
                
            }
            
            self.preOption = obj;
            
            
        } withQuest:nil];
        
    }
}
///显示年月日显示,5
-(void)showDatePicker_YMD
{
    {
        [MMDatePickerView showPickerViewInView:self.viewController.view maxDate:nil minDate:nil withOptions:nil selected:^(MMDatePickerView *mmPickView, NSDate *date) {
            
        } completion:^(MMDatePickerView *mmPickView, NSDate *date) {
            
            self.value.text = [TimeTool formatDate: date formatWith:@"yyyy-MM-dd"];
            self.model.value =[NSString stringWithFormat:@"%.0f", [ date timeIntervalSince1970]];
            self.model.extra.disPlayName = self.value.text;
            
            
            
            NSString *key = self.model.name ;
            NSString *value = self.model.value ;

            [self saveValue:value forKey:key isAct:YES];
            
            
        }withQuest:nil];
        
    }
    
}
///显示年月显示,6
-(void)showDatePicker_YM
{
    
    {
        QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *string) {
            
            NSDate   *date = nil;
            {
                NSDateFormatter *formater = [[NSDateFormatter alloc] init];
                formater.dateFormat = @"yyyy-MM";
                date = [formater dateFromString:string];
                
            }
            
            
            self.value.text = string;
            self.model.value =[NSString stringWithFormat:@"%.0f", [ date timeIntervalSince1970]];
            self.model.extra.disPlayName = self.value.text;
            
            
            
            NSString *key = self.model.name ;
            NSString *value = self.model.value ;
            
            [self saveValue:value forKey:key isAct:YES];
        
        
        }];
        [datePickerView show];
    }
    
//    {
//        [MMDatePickerView showPickerViewInView:self.viewController.view maxDate:nil minDate:nil withOptions:nil selected:^(MMDatePickerView *mmPickView, NSDate *date) {
//            
//        } completion:^(MMDatePickerView *mmPickView, NSDate *date) {
//            
//            self.value.text = [TimeTool formatDate: date formatWith:@"yyyy-MM"];
//            self.model.value =[NSString stringWithFormat:@"%.0f", [ date timeIntervalSince1970]];
//            self.model.extra.disPlayName = self.value.text;
//            
//            
//            
//            NSString *key = self.model.name ;
//            NSString *value = self.model.value ;
//            
//            [self saveValue:value forKey:key isAct:YES];
//            
//
//            
//        }withQuest: nil ];
//    }
    
    
    
}


///多选,12
-(void)duoxuan
{
    {
        
        NSArray *array = [self.model.extra.option valueForKey:@"title"];
        [MMlistView showPickerViewInView:self.viewController.view withStrings:@[array] withOptions:nil selected:^(MMlistView *mmPickView, NSInteger row, NSInteger component) {
            
        } completion:^(NSArray *selectedString) {
            
            
            NSArray *hadSelectIndex = [selectedString copy];
            NSMutableArray *hadSelectObject = [NSMutableArray array ];

            NSString *selString = @"";
            NSString *valueString = @"";
            
            for(NSNumber *select in hadSelectIndex){
                if (select == nil) {
                    continue ;
                }
                NSInteger row = [select integerValue];
                TQBJiaodanDynamicInputOptionObject *obj = [self.model.extra.option safeObjectAtIndex:row];
                if(obj==nil){
                    continue ;
                }
                if (selString.length==0) {
                    selString = obj. value;
                    valueString = obj.id;
                    
                }else{
                    selString = [NSString stringWithFormat:@"%@,%@",selString,obj.value];
                    valueString = [NSString stringWithFormat:@"%@,%@",valueString,obj.id];
                    
                }
                [hadSelectObject addObject:obj];
                
            }
            if([selString hasSuffix:@","]){
                selString = [selString substringToIndex:selString.length-1];
            }
            if([valueString hasSuffix:@","]){
                valueString = [valueString substringToIndex:valueString.length-1];
            }
            
            
            
            
            self.value.text = selString;
            //                self.value.text = obj.name;
            self.model.extra.disPlayName = self.value.text    ;
            //                self.model.uploadVaule = [NSString stringWithFormat:@"%@",@(obj.value)  ] ;
            self.model.value = valueString;
            
            NSString *key = self.model.name ;
            NSString *value = self.model.value ;
            
            [self saveValue:value forKey:key isAct:YES opetions:hadSelectObject];

            
//            if (self.model.nextArray.count) {
//                YijiaoKehuInputViewController *VC = (YijiaoKehuInputViewController*)self.viewController;
//                NSIndexPath *path = [VC.tableView indexPathForCell:self];
//                [VC.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:1];
//            }
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:ReloadSectionNotifaction object:nil];
            
            
        } withQuest:nil isMulit:YES];
        
    }
}
- (IBAction)subBtnAct:(id)sender {
    if (self.model.isDisplay) {
        return;
    }
    [self.viewController.view endEditing:YES];
    
    
    
    if (self.model.extra.toast) {
        SHOWMSG(self.model.extra.toast);
        return;
    }
    
    
    InputObjectType type_enum = self.model.type_enum;
    if (type_enum == InputObjectType_select) {
        [self normalSelectView];

    }else if (type_enum == InputObjectType_city_level2) {
        [self selectCity2_level];
        
//    }else if (type_enum == InputObjectType_city_level3) {
//        [self selectCity3_level];
        
    }else if (type_enum == InputObjectType_time_YMD) {
        [self showDatePicker_YMD];
        
    }else if (type_enum == InputObjectType_time_YM_YM) {
        [self showDatePicker_YM];
        
    }else if (type_enum == InputObjectType_select_mutli) {
        [self duoxuan];
        
    }else if (type_enum == InputObjectType_car_type) {
        [self car_type];
        
    }else if (type_enum == InputObjectType_car_license_plate) {
        [self car_license_plate];
        
    }
    
    
}
-(void)car_type
{
    @weakify(self);
    
    __block   TimCarTypeSelect *citySelect = nil;
    
    [[Config sharedInstance]gotoCarTypeSelect:^(TimCarTypeSelect *a) {
        citySelect = a;
        
    } selectCar:^(TimCarTypeObj *carModel) {
        @strongify(self);
        
        self.model.value = carModel.id;
        self.model.extra.disPlayName = carModel.value;
        
        
        self.value.text = self.model.extra.disPlayName;
        
        
        NSString *key = self.model.name ;
        NSString *value = self.model.value ;
        
        
        [self saveValue:value forKey:key isAct:YES];
        
        
        
        [citySelect dismissViewControllerAnimated:YES completion:^{
            
        }];
    }] ;
    
    
    
}
-(void)car_license_plate
{
    @weakify(self);
    
    __block   TimCarBelongSelect *citySelect = nil;
    [[Config sharedInstance] gotoCarBelongSelect:^(TimCarBelongSelect *a) {
        citySelect = a;

    } selectCar:^(TimCarBelongObj *carModel) {
        @strongify(self);
        
        self.model.value = carModel.id;
        self.model.extra.disPlayName = carModel.value;
        
        
        self.value.text = self.model.extra.disPlayName;
        
        
        NSString *key = self.model.name ;
        NSString *value = self.model.value ;
        
        
        [self saveValue:value forKey:key isAct:YES];
        
        
        
        [citySelect dismissViewControllerAnimated:YES completion:^{
            
        }];

    }];
    
    
}

///2级城市
-(void)selectCity2_level
{
    @weakify(self);
    
    __block   YMCitySelect *citySelect = nil;
    
    [[Config sharedInstance]gotoCitySelect:^(YMCitySelect *a) {
        citySelect = a;
        
    } selectCity:^(TQBCityModel *cityModel) {
        @strongify(self);
        
        self.model.value = cityModel.id;
        self.model.extra.disPlayName = cityModel.name;
        
        
        self.value.text = self.model.extra.disPlayName;
        
        
        NSString *key = self.model.name ;
        NSString *value = self.model.value ;
        
        
        [self saveValue:value forKey:key isAct:YES];
        
        
        
        [citySelect dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    
    
    
}
///3级城市
-(void)selectCity3_level
{
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


///避免nav 作为vc的parent返回了
-(UIViewController*)viewController
{
    UIViewController*vc= [super viewController ];
    if (vc.parentViewController) {
        if ([vc.parentViewController isKindOfClass:[UINavigationController class]]) {
            return vc;
        }
        return vc.parentViewController;
        
    }
    
    return vc;
    
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self resetSepLine];

    
}
@end
