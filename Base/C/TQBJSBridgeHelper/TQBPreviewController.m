
//
//  TQBPreviewController.m
//  JSBridgeDemo
//
//  Created by Zhang Wuyang on 2017/7/20.
//  Copyright © 2017年 gomeguomingyue. All rights reserved.
//

#import "TQBPreviewController.h"
#import "MYFDefines.h"
#import <SDCycleScrollView.h>


@interface TQBPreviewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView * cycleScrollerView;

@end

@implementation TQBPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    // Do any additional setup after loading the view.
}


-(void)initUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _cycleScrollerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT )
                                                            delegate:self
                                                    placeholderImage:[UIImage imageNamed:@"tabbar_icon0_normal"]];
    
    _cycleScrollerView.imageURLStringsGroup =self.imageArray;
    
    _cycleScrollerView.infiniteLoop = NO;// 自动滚动时间间隔
    _cycleScrollerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;// 翻页 右下角
    _cycleScrollerView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
    [self.view addSubview:self.cycleScrollerView];
    
    __weak typeof(self) weakSelf = self;

    _cycleScrollerView.clickItemOperationBlock = ^void(NSInteger currentIndex){
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    };

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
