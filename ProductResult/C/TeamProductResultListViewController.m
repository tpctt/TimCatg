//
//  GoldListViewController.m
//  KehuFox
//
//  Created by tim on 16/11/15.
//  Copyright © 2016年 timRabbit. All rights reserved.
//

#import "TeamProductResultListViewController.h"
//#import "TeamProductResultListHeader.h"
#import "TeamProductResultListViewModel.h"

#import "TeamProductResultListTableViewCell.h"
#import "TeamProductResultListTableViewSubCell.h"

///订单详情
#import "OrderDetailViewController.h"


///产品业绩详情/
@interface TeamProductResultListViewController ()
//@property (strong,nonatomic) TeamProductResultListHeader *header;
//@property (strong,nonatomic) FunImageDetailFooterView *footer;


@property (strong,nonatomic) TeamProductResultListViewModel *viewModel;


@end

@implementation TeamProductResultListViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewModel = [[TeamProductResultListViewModel alloc] init];
    self.viewModel.id = self.id;
    self.viewModel.user_id = self.user_id;
    
    [self initialNavigationBar];
    [self initHeader];
    [self initFooter];
    
    [self initTable:NO];
    
    
    
    
    
    
    GCD_main(
             [self.table.mj_header beginRefreshing];
             )
    /*
     [[self.adScroll.scrollAD_command.command execute:nil]
     merge:[self.viewModel.productList_command.command execute:nil]];
     */
    
    [self scrollViewDidScroll:self.table];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setBackAsWhite:NO];


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override
-(void)initTable:(BOOL)group
{
    [super initTable:group];
//    [self.view bringSubviewToFront:self.footer];
    
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.estimatedRowHeight = 160;
    
//    self.table.backgroundColor = RGB(255, 255, 255);
    self.table.backgroundColor = RGB(245, 245, 245);
    
    ///
    
    
    
    [self regNibs:@[[TeamProductResultListTableViewCell class],[TeamProductResultListTableViewSubCell class]]];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
                make.bottom.equalTo(@(0));
//        make.bottom.equalTo(self.footer.mas_top);
        
    }];
 
    
    
    self.table.tableFooterView = [UIView new];

//    self.table.tableHeaderView = self.header;
//    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(self.table.mas_width);
//        make.height.equalTo(@88);
//        make.top.equalTo(@0);
//        
////        make.right.equalTo(@0);
////        make.left.equalTo(@0);
//        
//        
//    }];
//    
//    
    @weakify(self);
//    [[[RACSignal combineLatest:@[RACObserve(self.header, bounds)]]distinctUntilChanged]
//     subscribeNext:^(id x) {
//         @strongify(self);
//         
//         self.table.tableHeaderView = self.header;
//         
//     }];
//    
    
    
    
    
    
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        @strongify(self);
        
        
        [self.viewModel loadFirstPage];

        
        
    }];
    
    
    
    
    self.table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        @strongify(self);
        
        
        [self.viewModel loadNextPage];
        
        
    }];
    
    
    
    
    
    [[self.viewModel.command.executing deliverOnMainThread] subscribeNext:^(NSNumber *executing) {
        
        @strongify(self);
        
        [self.view endEditing:1];
        
    }];
    
    [[self.viewModel.command.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id x) {
        
        @strongify(self);
        
//        [self.header.goldBtn setTitle:self.viewModel.goldNumber forState:0];
        
        self.title = self.viewModel.title;
        
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
        
        [self.table reloadData];
        
    }];
    
    [[self.viewModel.command.errors deliverOnMainThread] subscribeNext:^(NSError *error) {
        
        @strongify(self);
        
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
        
        SHOWMSG(error.localizedDescription);
        
        [self.table reloadData];
        
    }];
    
    
}

#pragma mark - Initial Methods

- (void)initialNavigationBar
{
//    self.navigationItem.title = @"产品详情";
    
//    self.navigationItem.title = self.productName?:@"我的团队的某个人的业绩详情";
    
    
//    [self showBarButton:1 title:@"如何晋升" fontColor:  OrangeC ];
    
    
}


#pragma mark - Target Methods
-(void)rightButtonTouch
{
//    [[Config sharedInstance]gotoKehu:YES];
    
    
}

#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.dataArray .count;

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    TeamProductResultObject *arrayObj = [self.viewModel.dataArray safeObjectAtIndex:section];
    
    return 1 + arrayObj.stateArray.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    TeamProductResultObject *arrayObj = [self.viewModel.dataArray safeObjectAtIndex:indexPath.section];
    
    
    if (indexPath.row == 0 ) {
        
        TeamProductResultObject *adobj = arrayObj;
        adobj.isMyOrder = [self.viewModel.user_id isEqualToString:arrayObj.proxy_id];
        
        
        static NSString *idenifier = @"TeamProductResultListTableViewCell";
        TeamProductResultListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier forIndexPath:indexPath ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell banding:adobj];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        
        
        return cell;
        
    }else {
        
        TeamProductResultStateObject *adobj = [arrayObj.stateArray safeObjectAtIndex:indexPath.row - 1 ];
        
        
        static NSString *idenifier = @"TeamProductResultListTableViewSubCell";
        TeamProductResultListTableViewSubCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier forIndexPath:indexPath ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell banding:adobj];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        
        
        return cell;
        
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    TeamProductResultObject *arrayObj = [self.viewModel.dataArray safeObjectAtIndex:indexPath.section];
    
    
    if (indexPath.row == 0 ) {
        return 102;
        
    }else {
        return 30;
        
    }
    
    return 44;
    
    return UITableViewAutomaticDimension;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 16;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *label = [UILabel new];
    
    label.backgroundColor = RGB(245,245,245);
    label.font = MYFONT(16);
    label.textColor = HEX_RGB(0x999999);
    
    return label;
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

#pragma mark - Privater Methods


#pragma mark - Setter Getter Methods

-(void)initHeader
{
   
}

-(void)initFooter
{

}


#pragma mark EmptyData
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty_income_p_message"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    //    return nil;
    NSString *text = @"这位队友还未开单,快去帮帮他吧!";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: HEX_RGB(0x212121),
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
#if TimCustomNAV

- (NSDictionary *)navigationTitleAttributes
{
    return   @{
               NSForegroundColorAttributeName: HEX_RGB(0x212121) ,
               NSFontAttributeName:[UIFont systemFontOfSize:18],
               
               };
    
}

#endif


@end
