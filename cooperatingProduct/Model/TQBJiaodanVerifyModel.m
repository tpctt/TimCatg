
//
//  TQBJiaodanVerifyModel.m
//  taoqianbao
//
//  Created by tim on 17/3/9.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodanVerifyModel.h"

@implementation TQBJiaodanVerifyModel
-(UIImage *)getImage{
    if(self.verify_data ){
        NSData *data = [[NSData alloc] initWithBase64EncodedString:self.verify_data options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image  = [UIImage imageWithData:data];
    
        return image;
    }
    return nil;
}
-(UIImage *)image
{
    if (_image==nil) {
        _image = [self getImage];
        
    }
    
    return _image;
    
}
@end
