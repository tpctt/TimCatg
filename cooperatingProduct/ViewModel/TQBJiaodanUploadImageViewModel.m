//
//  SuggestViewModel.m
//  KehuFox
//
//  Created by tim on 16/11/15.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import "TQBJiaodanUploadImageViewModel.h"
@interface TQBJiaodanUploadImageViewModel ()
@property (strong,nonatomic) NSString *text;

@end

@implementation TQBJiaodanUploadImageViewModel
-(void)initialize
{
    [super initialize];
    
    @weakify(self)
    self.path= @"profile/upload-img";
    
    self.inputBlock = ^(NSMutableDictionary *para) {
        
        @strongify(self)
        
        
        if (self.text) {
            [para setObject:self.text forKey:@"content"];
            
        }
        if (self.original_img_ids.count) {
            [para setObject:[self.original_img_ids componentsJoinedByString:@","] forKey:@"original_img_ids"];
            
        }
        if (self.identify_key ) {
            [para setObject:self.identify_key forKey:@"identify_key"];

        }
        [para setObject:self.img_type forKey:@"img_type"];

        
        return para;
        
    };
    self.formDataInputBlock = ^(id <AFMultipartFormData>  _Nullable formData) {
        
        @strongify(self)
        
        
       
        
        if (self.images) {
            
//            NSMutableArray *imageDatas = [NSMutableArray array];
            
            
//            [para setObject:self.images forKey:@"pic"];
            NSInteger I =0 ;
            for (UIImage *image  in self.images) {
                
                NSData *data  =  [TQBUserTool zipImageWithImage:image max:2];

                if(data){
//                    [imageDatas addObject:data];
                    [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"img[%ld]",(long)I++] fileName:@"img.png"mimeType:@"image/png" ];
                    
                }

            }
            
        }
        
        
//        return para;
        
    };
    
    self.outputBlock = ^(NSDictionary *dict){
        @strongify(self)
        
        self.imagePaths = [TQBJiaodanImageObject mj_objectArrayWithKeyValuesArray:dict];
        
        return self.imagePaths;
        
//        self.msg = [dict objectForKey:@"msg"];
//        return self.msg;
        
    };
    
}
@end







///TQBJiaodanGetImageViewModel
@interface TQBJiaodanGetImageViewModel ()
@property (strong,nonatomic) NSString *text;

@end

@implementation TQBJiaodanGetImageViewModel
-(void)initialize
{
    [super initialize];
    
    @weakify(self)
    self.path= @"profile/get-img";
    
    self.inputBlock = ^(NSMutableDictionary *para) {
        
        @strongify(self)
        
        
        if (self.text) {
            [para setObject:self.text forKey:@"content"];
            
        }
        if (self.identify_key ) {
            [para setObject:self.identify_key forKey:@"identify_key"];

        }
        
        [para setObject:self.img_type forKey:@"img_type"];
        
        
        return para;
        
    };
    self.formDataInputBlock = ^(id <AFMultipartFormData>  _Nullable formData) {
        
    };
    
    self.outputBlock = ^(NSDictionary *dict){
        @strongify(self)
        
        
        self.default_img = [dict objectForKey:@"default_img"];
        self.title = [dict objectForKey:@"title"];
        
        
        NSArray *array = [TQBJiaodanImageObject mj_objectArrayWithKeyValuesArray:dict[@"img_list"]];
        self.imageObjects = array;
        
        return array;
        
        
    };
    
}
@end
