//
//  SuggestViewModel.h
//  KehuFox
//
//  Created by tim on 16/11/15.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import "BaseListViewModel.h"
#import "TQBJiaodanImageObject.h"

@interface TQBJiaodanUploadImageViewModel : BaseViewModel
//in
@property (strong,nonatomic) NSArray * images;///输入的 image
@property (strong,nonatomic) NSString * img_type;///id_photo, id_photo_back
@property (strong,nonatomic) NSString * identify_key;///, identify_key


//OUT
@property (strong,nonatomic) NSArray * imagePaths;///输出的 TQBJiaodanimageObject
@property (strong,nonatomic) NSArray * original_img_ids;///旧的图片id 数组或者 逗号分割字符串 1,2,3,4

@end





//API获取凭证图片
@interface TQBJiaodanGetImageViewModel : BaseViewModel
//in
@property (strong,nonatomic) NSString * img_type;///id_photo, id_photo_back
@property (strong,nonatomic) NSString * identify_key;///, identify_key


//OUT
@property (strong,nonatomic) NSArray * imageObjects;///输出的 TQBJiaodanimageObject
@property (strong,nonatomic) NSString * default_img;
@property (strong,nonatomic) NSString * title;

@end
