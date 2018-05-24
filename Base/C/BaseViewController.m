//
//  BaseViewController.m
//  taoqianbao
//
//  Created by tim on 16/9/5.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController()
{
    UIButton *backBtn;
    BOOL _enableNavPanBack;
    
}
@end



@implementation BaseViewController
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return [EzSystemInfo isDevicePad] ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
//}




//+(void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Method originalMethodImp = class_getInstanceMethod(self, @selector(tableView:didSelectRowAtIndexPath:));
//        Method destMethodImp = class_getInstanceMethod(self, @selector(TQBtableView:didSelectRowAtIndexPath:));
//        method_exchangeImplementations(originalMethodImp, destMethodImp);
//    });
//}

//static char TQBtableView_didSelectRowAtIndexPath_key;

//-(void)TQBtableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
//    
//    
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
//-(UIBarButtonItem *)myCustomBackButton_backBarbuttonItem{
//    
//    UIBarButtonItem *item = [self myCustomBackButton_backBarbuttonItem];
//    if (item) {
//        return item;
//    }
//    item = objc_getAssociatedObject(self, &TQBtableView_didSelectRowAtIndexPath_key);
//
//    if (!item) {
//        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:NULL];
//
//        item.tintColor = [UIColor redColor] ;
//
//        objc_setAssociatedObject(self, &TQBtableView_didSelectRowAtIndexPath_key, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//
//
//    }
//    return item;
//}



//统计需要 获取标题
-(NSString * )getTitle
{
    if (self.customTitleName) {
        return  self.customTitleName;
    }else if(self.title){
        return self.title;
    }else {
        return  NSStringFromClass([self class]);
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark 设置返回按钮
-(UIBarButtonItem *)backBarButtonItem{
    UIBarButtonItem *item ;
    if (item) {
        return item;
    }
    
    if (!item) {
        //        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:NULL];
        if (!backBtn) {
            UIImage *image  = [[UIImage imageNamed:@"nav_return.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            backBtn = [[UIButton alloc] initNavigationButton:image];
            //item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backItemAct:)];
            backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [backBtn addTarget:self action:@selector(backItemAct:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

        
        
    }
    return item;
}

-(void)setBackAsWhite:(BOOL)white
{
    [backBtn setImage: [UIImage imageNamed:white?@"nav_return_white":@"nav_return.png"]  forState:0];
    
}
-(void)setBackBtnImage:(UIImage*)image
{
    [backBtn setImage: image forState:0];

}

-(void)backItemAct:(id)sender
{
    @try {
        [[TQBStatistialFunction sharedSingleton]
         recordEvent:dianji_fanhui
         segmentationKey: dianji_fanhui
         segmentation:@{@"action":@"goback",
                        @"viewname":[self getTitle]}
         ];
        
    } @catch (NSException *exception) {
        [[Countly sharedInstance]recordHandledException:exception];
    } @finally {
        
    }
    
 
    [self.navigationController popViewControllerAnimated:1];
    
}
-(void)enableNavPanBack:(BOOL)flag
{
    _enableNavPanBack = flag;
    
}


-(void)setBackItemAtt{
    self.navigationController.navigationBar.backIndicatorImage = [[UIImage imageNamed:@"nav_return.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [[UIImage imageNamed:@"nav_return.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationItem.backBarButtonItem.title = @"";
    
}
#pragma mark 生命周期
-(void)dealloc
{
    NSLog(@"%@ %@", NSStringFromSelector(_cmd) , self );
}
-(void)viewDidLoad
{
    [super viewDidLoad  ];
    _enableNavPanBack = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    if ( self.navigationController.viewControllers.count > 1 ) {
        
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        self.navigationItem.backBarButtonItem
        
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
        
    }

    
    [self setNavBarShowWithAlpha:NO];
    
    
    GJW_NavigationBar *bar = (GJW_NavigationBar *)[self.navigationController navigationBar];
    [bar gjw_setBackgroundColor:[self navigationBarInColor]];
    [bar gjw_setTitleAttributes:[self navigationTitleAttributes]];
    [bar gjw_setShadowImage:[self navigationBarShadowImage]];
    
    
    
    UIScrollView *scroll = nil;
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            scroll = obj;
            break;
        }
    }
    [self setScrollForSafeArea:scroll];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:[self preferredStatusBarStyle] ];

    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.table reloadData];
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



-(void)setScrollForSafeArea:(UIScrollView *)scrollView
{
    [[self class]setScrollForSafeArea:scrollView];
}
+(void)setScrollForSafeArea:(UIScrollView *)scrollView
{
    if (scrollView == nil) {
        return;
    }
    if ( NO == [scrollView isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
#ifdef __IPHONE_11_0
    
    if (@available(iOS 11.0, *)){
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if ([UIDevice isPhoneX]) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);//导航栏如果使用系统原生半透明的，top设置为64
            
        }else{
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);//导航栏如果使用系统原生半透明的，top设置为64
            
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset;
        
    }
    
#else
    
#endif
}

-(void)initTable:(BOOL)group
{
    self.table = [[TQBUITableView alloc] initWithFrame:CGRectZero style:group?UITableViewStyleGrouped: UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class] )];
    
    [self.view addSubview:self.table];
    
#ifdef __IPHONE_11_0
    
    if (@available(iOS 11.0, *) ){
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if ([UIDevice isPhoneX]) {
            _table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);//导航栏如果使用系统原生半透明的，top设置为64
            
        }else{
            _table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);//导航栏如果使用系统原生半透明的，top设置为64
            
        }
        _table.scrollIndicatorInsets = _table.contentInset;
        
    }
    
#else
    
#endif
   
    
    
    self.table.emptyDataSetSource = self;
    self.table.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.table.tableFooterView = [UIView new];
    
    
    UIEdgeInsets edge = [self tableCellSepEdge:nil];

    if ([   self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [  self.table   setSeparatorInset:edge];
    }
    if ([  self.table respondsToSelector:@selector(setLayoutMargins:)]) {
        [  self.table setLayoutMargins:edge];
    }
    
//    self.table.preservesSuperviewLayoutMargins = false;
    

    
}
-(void)regNibs:(NSArray <Class>*)array
{
    for (Class class in array) {
        
        NSString *classString = NSStringFromClass(class);
        [self.table registerClass:class forCellReuseIdentifier:classString];
        [self.table registerNib:[UINib nibWithNibName:classString bundle:nil] forCellReuseIdentifier:classString];
        
        
    }
}
-(UIEdgeInsets)tableCellSepEdge:(NSIndexPath* )indexPath{
    
//    UIEdgeInsets edge = UIEdgeInsetsMake(0, 12, 0, 12);
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0 );
   
    if( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation ) ){
            edge = UIEdgeInsetsMake(0, -30, 0, -30 );
            
        }else{
            
            edge = UIEdgeInsetsMake(0, -160, 0, -160 );
            
        }
        
    }
    
    return edge;
    
}

#pragma mark tableView
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    UIEdgeInsets edge = [self tableCellSepEdge:indexPath];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:edge];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:edge];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class] )];
    
    return cell;
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

#pragma mark EmptyDataSet
//The image for the empty state:
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"icon_blankpage"];
}
//The attributed string for the title of the empty state:
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"暂无数据";
//    
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
//                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//    
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
//The attributed string for the description of the empty state:
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
//    return nil;
    NSString *text = @"这里好像什么都没有";

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: HEX_RGB(0x212121),
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
//The attributed string to be used for the specified button state:
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
//    
//    return [[NSAttributedString alloc] initWithString:@"继续" attributes:attributes];
//}
//or the image to be used for the specified button state:
//- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    return [UIImage imageNamed:@"icon_Collection.png"];
//}
//The background color for the empty state:
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}
//If you need a more complex layout, you can return a custom view instead:
//- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
//{
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [activityView startAnimating];
//    return activityView;
//}
//The image view animation
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
    
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}
//Additionally, you can also adjust the vertical alignment of the content view (ie: useful when there is tableHeaderView visible):
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.table.tableHeaderView.frame.size.height/2.0f;

    return self.table.tableHeaderView.frame.size.height/1.0f;
}
//Finally, you can separate components from each other (default separation is 11 pts):
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0.0f;
}
//Delegate Implementation
//Return the behaviours you would expect from the empty states, and receive the user events.
//Asks to know if the empty state should be rendered and displayed (Default is YES) :

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}
//Asks for interaction permission (Default is YES) :
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}
//Asks for scrolling permission (Default is NO) :
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
//Asks for image view animation permission (Default is NO) :
- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView
{
    return YES;
}
//Notifies when the dataset view was tapped:
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    // Do something
    if(scrollView.mj_header){
        [scrollView.mj_header beginRefreshing];
    }
}
//Notifies when the data set call to action button was tapped:
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    // Do something
}

#pragma mark ======= 设置导航栏属性 =====
#if TimCustomNAV
-(UIColor *)navigationBarOutColor
{
    return [self navigationBarInColor];
}
-(UIColor *)navigationBarInColor
{
//    self.navigationController.navigationBar.shadowImage = nil;
    return  NavBarMC;
    
}
-(UIImage *)navigationBarShadowImage
{
    UIColor *color = [self navigationBarInColor];
    
    if( CGColorEqualToColor(color.CGColor, NavBarMC.CGColor) ){
        return nil;
        
    }else{
        return [UIImage new];
        
    }
    
}
- (BOOL)enablePanBack
{
    return _enableNavPanBack;
}
- (NSDictionary *)navigationTitleAttributes
{
    return   @{
 
               NSForegroundColorAttributeName: HEX_RGB(0x212121) ,
               NSFontAttributeName:[UIFont systemFontOfSize:18],
               
               };
    
}

#endif



@end
