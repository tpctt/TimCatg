
//
//  TQBJiaodandCompleteViewController.m
//  taoqianbao
//
//  Created by tim on 17/2/28.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodandCompleteViewController.h"
//#import "OnlineProduct_tabbar_ViewController.h"
//#import "TQBProductWebViewController.h"
#import "TQBJiaodanBaseViewController.h"


#import "TQBJiaodanCompleteViewModel.h"
#import "TQBJiaodanProductObj.h"

@interface TQBJiaodandCompleteViewController ()

@property (nonatomic, strong) TQBJiaodanCompleteViewModel *viewModel;
//@property (strong,nonatomic) ProductDetailGetUrlViewModel *getUrlViewModel;

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIButton *addAlertBtn;

@end

@implementation TQBJiaodandCompleteViewController

//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.viewModel = [[TQBJiaodanCompleteViewModel alloc] init];
//    self.viewModel.identify_key =   self.identify_key;
//    self.viewModel.recommadPath =   self.recommadPath;
//
//    self.getUrlViewModel = [[ProductDetailGetUrlViewModel alloc] init];
//    
//    [self initialNavigationBar];
//    [self initTable:YES];
//    [self initHeader];
//    
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    GCD_main(
//             [self.table.mj_header beginRefreshing];
//             )
//}
//
//#pragma mark - Override
//
//-(void)initTable:(BOOL)group
//{
//    
//    [super initTable:group];
//    [self regNibs:@[[TQBJiaodanRecommandCell class]]];
//    
////    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.table.estimatedRowHeight = 100;
//    self.table.backgroundColor = RGB(245, 245, 245);
//    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
//    
//    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.edges.equalTo(self.view);
//        
//    }];
//    
//    
//    
//    
//    
//    //    self.table.tableHeaderView = self.header;
//    //    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
//    //        make.width.mas_equalTo(self.table.mas_width);
//    //
//    //    }];
//    //
//    //
//    //
//    //    [[[RACSignal combineLatest:@[RACObserve(self.header, bounds)]]distinctUntilChanged]
//    //     subscribeNext:^(id x) {
//    //
//    //         self.table.tableHeaderView = self.header;
//    //
//    //     }];
//    
//    
//    
//    
//    
//    @weakify(self);
//    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        @strongify(self);
//        
//        
//        [self.viewModel loadFirstPage];
//        
//        
//    }];
//    
//    
//    
//    
////    self.table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
////        
////        @strongify(self);
////        
////        
////        [self.viewModel loadNextPage];
////        
////        
////    }];
//    
//    
//    
//    //////
//    [self.viewModel.command.executing subscribeNext:^(NSNumber *executing) {
//        
//        @strongify(self);
//        
//        [self.view endEditing:1];
//        
//    }];
//    
//    [[self.viewModel.command.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id x) {
//        
//        @strongify(self);
//        
//        [self.table.mj_header endRefreshing];
//        [self.table.mj_footer endRefreshing];
//        
//        [self.table reloadData];
//        
//    }];
//    
//    
//    [[self.viewModel.command.errors deliverOnMainThread] subscribeNext:^(NSError *error) {
//        
//        @strongify(self);
//        
//        [self.table.mj_header endRefreshing];
//        [self.table.mj_footer endRefreshing];
//        
//        self.title = self.viewModel.title;
//        
//        SHOWMSG(error.localizedDescription);
//        
//    }];
//    
//    
//    
//    
//    
//    
//    //////////
//    [self.getUrlViewModel.command.executing subscribeNext:^(NSNumber *executing) {
//        
//        @strongify(self);
//        
//        [self.view endEditing:1];
//        
//    }];
//    
//    [[self.getUrlViewModel.command.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id x) {
//        
//        @strongify(self);
//        
//        if (self.getUrlViewModel.apply_type == 0 ) {
//            TQBProductWebViewController *webVC = [[TQBProductWebViewController alloc] init];
//            
//            //        [[AppDelegate shareInstance].navVC pushViewController:vc animated:1];
//            [webVC jumpToWebFrom:[AppDelegate shareInstance].navVC vcIsNav:1 withAddress:self.getUrlViewModel.href];
//            
//            [[webVC rac_signalForSelector:@selector(webviewDidClose)]subscribeNext:^(id x) {
////                @strongify(self);
//                
//                GCD_main(
////                         SHOWMSG(@"申请产品成功后可在个人中心设置还款闹钟，方便管理您的贷款。");
////                         [self alertMoreProduct];
//                         )
//                
//            }];
//        }else   if (self.getUrlViewModel.apply_type == 1 ) {
//            
//            TQBJiaodanBaseViewController *vc = [[TQBJiaodanBaseViewController alloc] init];
//            
//            vc.identify_key = self.getUrlViewModel.identify_key;
//            
//            [[AppDelegate shareInstance].navVC pushViewController:vc animated:1];
//            
//            
//        }
//
//        
//    }];
//    
//    
//    [[self.getUrlViewModel.command.errors deliverOnMainThread] subscribeNext:^(NSError *error) {
//        
////        @strongify(self);
//        
//        
//        SHOWMSG(error.localizedDescription);
//        
//    }];
//    
//}
//
//#pragma mark - Initial Methods
//
//- (void)initialNavigationBar
//{
//    //    self.navigationItem.title = <#title#>;
//    
//    //    [self showBarButton:1 title:@"联系客服" fontColor: MTC ];
//    
//    self.title = @"推荐产品";
//    [self setBackBtnImage:[UIImage imageNamed:@"btn_close"]];
//    
//}
//
//
//#pragma mark - Target Methods
//
//#pragma mark - Notification Methods
//
//
//#pragma mark - KVO Methods
//
//
//#pragma mark - UITableViewDelegate, UITableViewDataSource
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    
//    return 1;
//    
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.viewModel.dataArray.count == 0) {
//        
//        static NSString *idenifier = @"noData";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier  ];
//        if (! cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier ];
//            
//        }
//        cell.backgroundColor = [UIColor clearColor];
//        cell.textLabel.text = @"暂无数据";
//        cell.textLabel.font = [UIFont systemFontOfSize:16];
//        
//        return cell;
//    }
//    
//    
//    ///普通产品
//    TQBJiaodanProductObj *adobj = [self.viewModel.dataArray safeObjectAtIndex:indexPath.row];
//    
//    TQBJiaodanRecommandCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TQBJiaodanRecommandCell class]) forIndexPath:indexPath ];
//    
//    @weakify(self);
//    [[[cell.quickApplyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id x) {
//        
//        @strongify(self);
//        [self quickApplyObject:adobj];
//        
//    }];
//    
//    [cell banding:adobj  ];
//    
//    return cell;
//    
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return 101;
//    
//    
//    return UITableViewAutomaticDimension;
//    
//    
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//    return self.viewModel.dataArray .count;
//    
//}
//
//
//
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:1];
//    
//    ///普通产品
//    TQBJiaodanProductObj *adobj = [self.viewModel.dataArray safeObjectAtIndex:indexPath.row];
//    
//    TQBProductDetailViewController *detailVC= [[TQBProductDetailViewController alloc] init];
//    detailVC.productObj_id = adobj.id;
//    
//    [[AppDelegate shareInstance].navVC pushViewController:detailVC animated:YES];
//    
//    
//}
//
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
////    return UITableViewAutomaticDimension;
//    return 60;
//    
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
//    
//    [button setTitle:self.viewModel.tips forState:0];
//    
//    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    
//    [button setTitleColor:HEX_RGB(0x999999) forState:0];
//    button.titleLabel.font = [UIFont systemFontOfSize:12];
//    button.titleLabel.numberOfLines = 0;
//    
//    
//    [button setBackgroundColor:RGB(245, 245, 245)];
//    
//    [button sizeToFit];
//    
//    return button;
//    
//    
//    
//}
//
//#pragma mark - Privater Methods
//
//
//#pragma mark - Setter Getter Methods
//
//
//-(void)initHeader
//{
//    
//    //    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
//    self.addAlertBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    
//    [self.addAlertBtn setTitleColor:BlueC forState:0];
//    [self.addAlertBtn setTitle:@"查看更多产品" forState:0];
////    [self.addAlertBtn setImage:[UIImage imageNamed:@"alert_icon_add"] forState:0];
//    [self.addAlertBtn  setBackgroundColor:[UIColor whiteColor]];
//    
//    
//    
//    [self.addAlertBtn  setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
//    [self.addAlertBtn  setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    
//    
//    LayerColorWidth(self.addAlertBtn, 5, BlueC, 1 );
//    
//    [self.view addSubview:self.addAlertBtn];
//    [self.addAlertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(@(-14));
//        make.leading.equalTo(@14);
//        make.bottom.equalTo(@(-14));
//        
//        make.height.equalTo(@44);
//        
//    }];
//    
//    
//    [self.addAlertBtn addTarget:self action:@selector(addAlertBtnAct:) forControlEvents:UIControlEventTouchUpInside];
//    
//}
//
//-(void)addAlertBtnAct:(id)SENDER
//{
//
//    [self gotoProductListVC];
//    
//    
//}
//
//-(void)quickApplyObject:(TQBJiaodanProductObj*)object{
//    
//    
//    self.getUrlViewModel.productID = object.id;
//    
//    
//    [self.getUrlViewModel.command execute:nil];
//    
//    
//}
//
//-(void)gotoProductListVC
//{
//    
//    OnlineProduct_tabbar_ViewController *product_list_vc ;
//    //    Tabbar1_ViewController *tabbar_vc ;
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if([vc isKindOfClass:[OnlineProduct_tabbar_ViewController class]])
//        {
//            product_list_vc = (OnlineProduct_tabbar_ViewController *)vc;
//            break;
//        }
//        
//    }
//    
//    
//    if (product_list_vc == nil) {
//        product_list_vc = [[OnlineProduct_tabbar_ViewController alloc] init];
//        
//        [self.navigationController pushViewController:product_list_vc animated:1];
//        
//    }else{
//        [self.navigationController popToViewController:product_list_vc animated:1];
//        
//    }
//    
//    [self removeFromParentViewController];
//    
//    
//    
//}
@end
