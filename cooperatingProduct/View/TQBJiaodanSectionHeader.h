//
//  TQBJiaodanSectionHeader.h
//  KehuFox
//
//  Created by tim on 2017/8/29.
//  Copyright © 2017年 timRabbit. All rights reserved.
//

#import "UIViewWithNib.h"
#import "TQBJiaodanDynamicInputObject.h"
@interface TQBJiaodanSectionHeader : UIViewWithNib
@property (weak, nonatomic) IBOutlet LZRelayoutButton *actBtn;

-(void)setObject:(TQBJiaodanDynamicInputObjectGroup *)group section:(NSInteger)section;

@end
