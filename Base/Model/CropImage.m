//
//  CropImage.m
//  KehuFox
//
//  Created by tim on 16/12/8.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import "CropImage.h"
#import "AliImageReshapeController.h"
@interface CropImage ()  <ALiImageReshapeDelegate>
@property (nonatomic,copy) CropImageBlock block;

AS_SINGLETON(CropImage);

@end
@implementation CropImage

DEF_SINGLETON(CropImage)
+(void)cropImage:(UIImage *)image rate:(CGFloat)rate block:(CropImageBlock)block
{
    [[CropImage sharedInstance]cropImage:image rate:rate block:block];

}
-(void)cropImage:(UIImage *)image rate:(CGFloat)rate block:(CropImageBlock)block
{
    _block = block;
    
    AliImageReshapeController *vc = [[AliImageReshapeController alloc] init];
    vc.sourceImage = image;
    vc.reshapeScale = rate;
    vc.delegate = self;
 
    [[AppDelegate shareInstance].navVC pushViewController:vc animated:YES];

    
//    [[AppDelegate shareInstance].navVC presentViewController:vc animated:0 completion:^{
//        
//    }];
    
    
    
    
    
}


- (void)imageReshaperController:(AliImageReshapeController *)reshaper didFinishPickingMediaWithInfo:(UIImage *)image
{
    _block(image);
    
//    [reshaper dismissViewControllerAnimated:YES completion:nil];
    [reshaper.navigationController popViewControllerAnimated:1];
    
}

- (void)imageReshaperControllerDidCancel:(AliImageReshapeController *)reshaper
{
//    [reshaper dismissViewControllerAnimated:YES completion:nil];
    [reshaper.navigationController popViewControllerAnimated:1];
    
}

@end
