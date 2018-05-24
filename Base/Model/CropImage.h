//
//  CropImage.h
//  KehuFox
//
//  Created by tim on 16/12/8.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CropImageBlock)( UIImage *cropImage);

@interface CropImage : NSObject
+(void)cropImage:(UIImage *)image rate:(CGFloat)rate block:(CropImageBlock)block;

@end
