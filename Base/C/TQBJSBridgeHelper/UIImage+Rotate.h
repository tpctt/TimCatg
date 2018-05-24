//
//  UIImage+Rotate.h
//  JSBridgeDemo
//
//  Created by gomeguomingyue on 2017/5/11.
//  Copyright © 2017年 gomeguomingyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotate)

/** 纠正图片的方向 */
- (UIImage *)fixOrientation;

/** 按给定的方向旋转图片 */
- (UIImage*)rotate:(UIImageOrientation)orient;

/** 垂直翻转 */
- (UIImage *)flipVertical;

/** 水平翻转 */
- (UIImage *)flipHorizontal;

/** 将图片旋转degrees角度 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转radians弧度 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

- (UIImage *)fixOrientation:(UIImage *)aImage;

@end
