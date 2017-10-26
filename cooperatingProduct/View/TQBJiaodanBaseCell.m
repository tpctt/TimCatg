//
//  TQBJiaodanBaseCell.m
//  taoqianbao
//
//  Created by tim on 17/3/7.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodanBaseCell.h"
#import "UITableViewCell+SepLine.h"
#import <GCDObjC.h>


@implementation TQBJiaodanBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)saveValue:(id _Nonnull)value forKey:(NSString *_Nonnull)key isAct:(BOOL)isAct opetions:(NSArray <TQBJiaodanDynamicInputOptionObject *>*)opetions
{
    [self saveValue:value forKey:key isAct:isAct];
    
    
    
    if (key && value) {
        
        if (self.dataDelegate && [self.dataDelegate respondsToSelector:@selector(opetionsDidChanged:)]) {
            [self.dataDelegate opetionsDidChanged:opetions];
        }
    }
    
}

-(void)saveValue:(id)value forKey:(NSString *)key isAct:(BOOL)isAct
{

    NSLog(@"key:%@ - value:%@",key,value);
    if (key && value) {
        [self.dataModel setObject:value forKey:key];
        
    }
    
    
    
    if(isAct){
        
        @try {
            
            [[TQBStatistialFunction sharedSingleton] recordEvent: faqixunjiaye
                                                 segmentationKey:dongtaibiaodan_cz
                                                    segmentation:@{@"type":self.model.type ,
                                                                   @"required":@(self.model.required),
                                                                   @"title":self.model.title,
                                                                   @"name":self.model.name,
                                                                   @"display":self.model.extra.disPlayName?:@"",
                                                                   @"value":value
                                                                   }
             
                                                       indexpath:_indexPath];;
            
        } @catch (NSException *exception) {
            [[Countly sharedInstance]recordHandledException:exception];
        } @finally {
            
        }

//        NSString *title = self.theme.title;
    
    }
}
-(BOOL)becomeFirstResponder
{
    UIColor *color = [UIColor colorWithString:self.theme.field_focus_color];
    [self setSepLineColor:color];
    
    
    [[GCDQueue mainQueue] queueBlock:^{
        
        [self resetSepLine];
        
    } afterDelay:1];
 
    return NO;
    
}

@end
