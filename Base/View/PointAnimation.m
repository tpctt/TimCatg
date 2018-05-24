//
//  PointAnimation.m
//  KehuFox
//
//  Created by tim on 16/12/5.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import "PointAnimation.h"
@interface PointAnimation ()<CAAnimationDelegate>
@property (strong,nonatomic) NSMutableArray *btnArray;
AS_SINGLETON(PointAnimation)
@end

@implementation PointAnimation
DEF_SINGLETON(PointAnimation)
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.btnArray = [NSMutableArray array];
    }
    return self;
}

+(void)showJifen:(BOOL)jifen number:(NSInteger )num title:(NSString *)title
{
    GCD_main(
             [[PointAnimation sharedInstance]showJifen:jifen number:num title:title];
    )
    
}
-(void)showAnimationWith:(UIButton*)btn after:(CGFloat)after
{
    {
        
        //向右移动；使用关键帧动画，移动路径为预定的直线路径
        CGPoint fromPoint = btn.center;
        CGPoint toPoint = CGPointMake(fromPoint.x , fromPoint.y + [UIScreen mainScreen].bounds.size.height * 0.6 );
        
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:fromPoint];
        [path addLineToPoint:toPoint];
        
        
        CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animation];
        pathAnimation.keyPath = @"position";
        //set path
        pathAnimation.path = path.CGPath;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        //            pathAnimation.rotationMode = kCAAnimationRotateAuto;
        //            [btn.layer addAnimation:pathAnimation forKey:@"PathAnimation"];
        
        //透明度变化
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animation];
        opacityAnimation.keyPath = @"opacity";
        opacityAnimation.values = @[@(0.5),
                                    @(1.0),
                                    @(0.9),
                                    @(0.8),
                                    @(0.0)];
        opacityAnimation.calculationMode = kCAAnimationPaced;
        //            [btn.layer addAnimation:opacityAnimation forKey:@"OpacityAnination"];
        
        //配置动画组
        CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc] init];
        animationGroup.animations = @[pathAnimation,opacityAnimation];
        animationGroup.duration = 1.2;
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
        
        animationGroup.delegate = self;
        animationGroup.beginTime = CACurrentMediaTime() + after;
        
        
        [btn.layer addAnimation:animationGroup forKey:@"GroupAnimation"];
        
        
        //            [btn removeFromSuperview];
        
        
        
    }
}
-(void)showJifen:(BOOL)jifen number:(NSInteger )num title:(NSString *)title
{
    ///小于大于 显示,等于0 不显示 动画
    if( num == 0 ) return;
    
    UIButton *btn = [UIButton new];
    UIImage *image = [UIImage imageNamed:jifen?@"p_integral-":@"p_gold-"];
    image = [image imageByScalingAndCroppingToSize:CGSizeMake(60, 60)];
    
    [btn setImage:image forState:0];
    [btn setTitle:title forState:0];
    
    [btn setTitleColor:[UIColor colorWithString:jifen?@"#ff6600":@"#ffee03"] forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:30];
    
    
    [btn sizeToFit ];
    
    
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1000 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
    
            [view addSubview:btn];
            
            btn.centerX = view.centerX;
            btn.centerY = 20;
            
            if (self.btnArray.count > 0 ) {
                [self showAnimationWith:btn after:0.3];
                
            }else{
                [self showAnimationWith:btn after:0];
                
            }
            
            
//        });
    
        
//    });
    
    
    
    [self.btnArray addObject:btn];
    
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIView *temp;
    for (UIButton *btn in self.btnArray ) {
        if ([btn.layer animationForKey:@"GroupAnimation"]==anim){
            temp = btn;
            break;
        }

    }
    
    [temp removeFromSuperview];
    [_btnArray removeObject:temp];
    
    
//
}

@end
