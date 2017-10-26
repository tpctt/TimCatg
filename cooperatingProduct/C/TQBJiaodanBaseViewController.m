//
//  TQBJiaodanBaseViewController.m
//  taoqianbao
//
//  Created by tim on 17/2/16.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodanBaseViewController.h"
#import "TQBJiaodanStepHeader.h"

#import "TQBJiaodanDynamicInputObjectListViewModel.h"
#import "TQBJiaodanverifyViewModel.h"
#import "TQBJiaodanDynamicInputObject.h"
#import "TQBJiaodanVerifyModel.h"

#import "TQBJiaoDanInputCell.h"
#import "TQBSectionTableViewCell.h"
#import "TQBJiaodanCellManager.h"
#import "TQBJiaodanRadioCell.h"
#import "TQBJiaodanBigInputCell.h"

#import <UIViewController+HUD.h>
#import <UINavigationBar+Color.h>
#import <TalkingData.h>
#import <CustomIOSAlertView.h>
#import <TTTAttributedLabel.h>
#import "DialogUtil+Hud.h"

@interface TQBJiaodanBaseViewController ()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) TQBScrollAdView *adScroll;


@property (strong,nonatomic) TQBJiaodanDynamicInputObjectListViewModel *viewModel;
@property (strong,nonatomic) TQBJiaodanVerifyViewModel *verifyDataViewModel;
@property (strong,nonatomic) TQBJiaodanVerifyViewModel *verifyCodeViewModel;
@property (strong,nonatomic) TQBJiaodanVerifyModel *verifyCodeModel;

@property (strong,nonatomic) TQBJiaodanStepHeader *header;
@property (strong,nonatomic) UIView *footer;
@property (strong,nonatomic) UIButton *footerBtn;
@property (strong,nonatomic) TTTAttributedLabel *footerLabel;
@property (strong, nonatomic)  UIButton *agreeBtn;

@property (strong, nonatomic)   TQBJiaodanCellManager *cellManager;

@end

@implementation TQBJiaodanBaseViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initVM];
    [self initAD_view];
    [self initTable:NO];
    
    self.cellManager = [[TQBJiaodanCellManager alloc ] init];
    self.cellManager.identify_key = self.identify_key;
    self.cellManager.table = self.table;
    
    self.table.delegate = self.cellManager;
    self.table.dataSource = self.cellManager;
    
    if (self.dataArray != nil) {
        
        self.viewModel.dataArray = self.dataArray;
        self.viewModel.theme = [TQBJiaodanDynamicTheme defaultTheme];

        [self didReceivedData];
        
        self.table.mj_header = nil;
        
    }else{
        [self.viewModel loadFirstPage];
        [self.adScroll.scrollAD_command.command execute:nil];

    }
    
//    [self resetCustomUI];
    [self enableNavPanBack:NO];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

//    [self resetCustomUI];

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self resetCustomUI];
//    
//    [self enableNavPanBack:YES];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self setCustomUI];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[TQBSuspendButton sharedSingleton] showSuspendButtonAddedTo:self.view  scrollView:self.table animated:YES];
//    [self enableNavPanBack:NO];    
}





-(void)initVM{
    
    self.viewModel = [[TQBJiaodanDynamicInputObjectListViewModel alloc] init];
    self.viewModel.identify_key = self.identify_key;
    self.viewModel.next_step = self.first_step;
    
    
    self.verifyDataViewModel = [[TQBJiaodanVerifyViewModel alloc] init];
//    self.verifyDataViewModel.identify_key = self.identify_key;

    
    
}




///重置自定义页面
-(void)resetCustomUI{
    
#if TimCustomNAV
    [(GJW_NavigationBar *)self.navigationController.navigationBar gjw_setBackgroundColor:NavBarMC];
#endif
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: HEX_RGB(0x666666) ,NSFontAttributeName:[UIFont systemFontOfSize:18]    }];
    [UIApplication sharedApplication].statusBarStyle =  [super preferredStatusBarStyle];

}
///自定义页面
-(void)setCustomUI{

    if (self.viewModel.theme == nil) {
        return;
    }
    
    ///状态栏
    if (self.viewModel.theme) {
        if(self.viewModel.theme.back_button_highlight){
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }else{
            [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
        }
    }else{
        [UIApplication sharedApplication].statusBarStyle =  [super preferredStatusBarStyle];
        
    }
    
#if TimCustomNAV
    [(GJW_NavigationBar *)self.navigationController.navigationBar gjw_reset];
#endif
    
    
    
    self.title = self.viewModel.theme.title;
    [self.footerBtn setTitle:self.viewModel.theme.button_title forState:0];
    
    UIColor *navBarcolor = [UIColor colorWithString:self.viewModel.theme.title_background_color];
    UIColor *navBarTextcolor = [UIColor colorWithString:self.viewModel.theme.tile_color];
    
    UIColor *footerBtnBgColor = [UIColor colorWithString:self.viewModel.theme.button_background_color];
    UIColor *footerBtnTextColor = [UIColor colorWithString:self.viewModel.theme.button_color];
    
    BOOL back_button_highlight = self.viewModel.theme.back_button_highlight ;
    BOOL show_save_button = self.viewModel.theme.show_save_button;

    if (self.viewModel.theme.previous_step.length) {
        [self setBackAsWhite:back_button_highlight ];
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
        
    }else{
        if (show_save_button) {
            [self showBarButton:0 title:show_save_button?@"保存并退出":@"" fontColor:navBarTextcolor];

        }else{
            [self setBackAsWhite:back_button_highlight ];
            self.navigationItem.leftBarButtonItem = [self backBarButtonItem];

        }
        
        
    }
    
    
    
#if TimCustomNAV
    
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:navBarcolor size:CGSizeMake(1, 128)] forBarMetrics:UIBarMetricsDefault];
    
    
    [ self.navigationController.navigationBar  setTitleTextAttributes:@{NSForegroundColorAttributeName:navBarTextcolor,NSFontAttributeName:[UIFont systemFontOfSize:18]    }];
    
    [(GJW_NavigationBar *)self.navigationController.navigationBar gjw_setBackgroundColor:navBarcolor];
#else
    [(GJW_NavigationBar *)self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:navBarcolor size:CGSizeMake(1, 128)] forBarMetrics:UIBarMetricsDefault];
    [(GJW_NavigationBar *) self.navigationController.navigationBar  setTitleTextAttributes:@{NSForegroundColorAttributeName:navBarTextcolor,NSFontAttributeName:[UIFont systemFontOfSize:18]    }];
    
#endif
    
    [self.footerBtn setBackgroundImage:[UIImage imageWithColor:footerBtnBgColor] forState:0];
    [self.footerBtn setTitleColor:footerBtnTextColor forState:0];
    
    
    
    
    self.footerBtn.hidden = NO;
    
    
    if(nil == self.viewModel.theme.button_agreement){
        
        self.footerLabel.hidden = 1;
        self.agreeBtn.hidden = 1;
        
//        return;
        
    }else{
        
        self.footerLabel.hidden = 0;
        self.agreeBtn.hidden = 0;


        TTTAttributedLabel *label  = self.footerLabel;
        label.linkAttributes = @{ NSUnderlineStyleAttributeName : @(NO) ,
                                  NSForegroundColorAttributeName :  HEX_RGB(0xff8309),
                                  
                                  };
        
        
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = HEX_RGB(0xff8309);
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        
        //    《%@》《%@》
        
        NSString *text = [NSString stringWithFormat:@"%@",self.viewModel.theme.button_agreement.label];
        NSString *temp = [text mutableCopy];
        
        for (TQBJiaodanLinkObject *linkObj in self.viewModel.theme.button_agreement.link ) {
            NSString *string = [NSString stringWithFormat:@"%@", linkObj.title];
            text = [text stringByAppendingString:string];
        }
        
        label.text = text;
        
        NSMutableAttributedString *att = [label.attributedText mutableCopy];
        for (TQBJiaodanLinkObject *linkObj in self.viewModel.theme.button_agreement.link ) {
            NSString *string = [NSString stringWithFormat:@"%@", linkObj.title];
            NSRange rang = NSMakeRange(temp.length, string.length);
            temp = [temp stringByAppendingString:string];
            
            
            [label addLinkToURL:[NSURL URLWithString:linkObj.href] withRange:rang];
            [att addAttributes:@{NSForegroundColorAttributeName :  HEX_RGB(0x225599)} range:rang];
            
        }
        
        
    }
    
   
    
    
}


#pragma mark 点击协议
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    BaseToWebViewController *web = [[BaseToWebViewController alloc] init];
    [web jumpToWebFrom:self.navigationController vcIsNav:YES withAddress:url.absoluteString];
    
}



//#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return [self.cellManager numberOfSectionsInTableView:tableView];
//    
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return [self.cellManager tableView:tableView numberOfRowsInSection:section];
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return [self.cellManager tableView:tableView heightForRowAtIndexPath:indexPath];
//    
//    
//}
//
/////不使用reusable
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.cellManager tableView:tableView cellForRowAtIndexPath:indexPath];
//}
//
//#pragma mark - Table view delegate source
//
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 50;
//}
//


#pragma mark - Target
-(void)saveTempData
{
    [self.cellManager cleanOtherInfoFromDataModel];
    
    
    [self.view endEditing:1];
    
    
    
    NSString *msg = nil;
    if ([self.cellManager checkDataModel:&msg checkAll:YES] == NO) {
//        SHOWMSG(msg);
//        return;
    }
    
    
    
    
    self.verifyDataViewModel.inputInfo  = self.cellManager.dataModel;
//    self.verifyDataViewModel.step = self.viewModel.next_step ;
//    self.verifyDataViewModel.verify_step = self.viewModel.verify_step ;
//    self.verifyDataViewModel.save_order = YES;///保存订单
    
    
    [self.verifyDataViewModel.command execute:nil];
    
    
    
}
-(void)footerBtnAct:(UIButton *)sender{
    
    @try {
        [[TQBStatistialFunction sharedSingleton] recordEvent:faqixunjiaye segmentationKey:dongtaibiaodan_fqxj segmentation:nil];

    } @catch (NSException *exception) {
        [[Countly sharedInstance]recordHandledException:exception];
    } @finally {
        
    }
    
    
    if (self.agreeBtn.selected == NO) {
        [UIAlertView showWithTitle:@"请阅读并同意 询价服务协议 " message:@"是否同意?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            self.agreeBtn.selected = YES;
            
        }];
        return;
    }
    
    [self.cellManager cleanOtherInfoFromDataModel];
//
//    
    [self.view endEditing:1];
    
    
    
    NSString *msg = nil;
    if ([self.cellManager checkDataModel:&msg checkAll:NO] == NO) {
        SHOWMSG(msg);
        return;
    }

    KHConfirmInfoViewController * vc = [[KHConfirmInfoViewController alloc] init];
    vc.inputInfo =  self.cellManager.dataModel;
    vc.itemsArray =  self.viewModel.dataArray;

    [[AppDelegate shareInstance].navVC pushViewController:vc animated:YES];
    
//    self.verifyDataViewModel.inputInfo  = self.cellManager.dataModel;
    
//    self.verifyDataViewModel.step = self.viewModel.next_step ;
//    self.verifyDataViewModel.verify_step = self.viewModel.verify_step ;
//    self.verifyDataViewModel.save_order = NO;///不是保存订单
//    [self.verifyDataViewModel.command execute:nil];
    
}

#pragma mark - setter-getter
//-(void)setStep:(NSInteger)step
//{
//    _step = step;
//    [self.header setSelectIndex:step - 1 ];
//    
//    
////    self.title = [NSString stringWithFormat:@"%ld",self.step];
//    
//}


- (IBAction)agreeBtnAct:(id)sender {
    @try {
        [[TQBStatistialFunction sharedSingleton] recordEvent:faqixunjiaye segmentationKey:dongtaibiaodan_xjfwxy segmentation:nil];

    } @catch (NSException *exception) {
        [[Countly sharedInstance]recordHandledException:exception];
    } @finally {
        
    }
    self.agreeBtn.selected = !self.agreeBtn.selected ;
    
    
}
-(void)initFooter{
    
    self.footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 120)];
    self.table.tableFooterView = self.footer;
    
    
    self.footerBtn = [[UIButton alloc] init];
    [self.footerBtn setBackgroundImage:[UIImage imageNamed:@"blue_button"] forState:0];
//    [self.footerBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];

    [self.footerBtn addTarget:self action:@selector(footerBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerBtn setTitle:@"下一步" forState:0];
    [self.footerBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.footerBtn setTitleColor:HEX_RGB(0xBA5C00) forState:UIControlStateDisabled];
    
    Layer(self.footerBtn, 22);
    
    
    [self.footer addSubview:self.footerBtn];
    
    
    
    [self.footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.centerX.equalTo(self.footer.mas_centerX);
//        make.centerY.equalTo(self.footer.mas_centerY);
        make.left.equalTo(@16);
        make.top.equalTo(@16);
        
    }];
    
    
    
    
    self.footerLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0) ];
    self.footerLabel.delegate = self;
    [self.footer addSubview:self.footerLabel];

    
    [self.footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.footer.mas_centerX);
//        make.left.equalTo(@16);

        make.top.equalTo(self.footerBtn.mas_bottom).with.offset(16);
//        make.bottom.equalTo(@26);
        
    }];
    
    
    
    
    
    self.agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0) ];
    self.agreeBtn.titleLabel.font = MYFONT(14);
    [self.agreeBtn setTitleColor:HEX_RGB(0X212121) forState:0];
    [self.agreeBtn setTitle:@"已阅读并同意" forState:0];
    
    
    [self.agreeBtn setImage:[UIImage imageNamed:@"jiaodan_icon_unselected"] forState:0];
    [self.agreeBtn setImage:[UIImage imageNamed:@"jiaodan_icon_selected"] forState:UIControlStateSelected];
    [self.agreeBtn addTarget:self action:@selector(agreeBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.agreeBtn sizeToFit];
//    self.agreeBtn.mj_h += 40;
    
    self.agreeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    
    self.agreeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    self.agreeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    
    [self.footer addSubview:self.agreeBtn];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.footerLabel.mas_centerY);
        make.right.equalTo(self.footerLabel.mas_left);
        
        make.height.equalTo(@54);
        make.width.equalTo(@120);
        
    }];
    
    
    
    self.footerLabel.hidden = 1;
    self.agreeBtn.hidden = 1;
    self.footerBtn.hidden = 1;
    
    
//    RAC(self.footerBtn,enabled) =
//    [[RACSignal combineLatest:@[
//                                
//                                RACObserve(self.agreeBtn, selected),
//                                RACObserve(self.agreeBtn, hidden)
//                                ]
//                       reduce:^(NSNumber *selected ,NSNumber *hidden ) {
//                           if (self.agreeBtn.hidden) {
//                               
//                               return @(YES);
//                           }else{
//                               return @( self.agreeBtn.selected    );
//                               
//                           }
//                           
//                       }]
//     
//     distinctUntilChanged];
    
    
}
#pragma mark - Override
-(void)rightButtonTouch
{
    BOOL show_save_button = self.viewModel.theme.show_save_button;
    if (show_save_button) {
        
        [UIAlertView showWithTitle:@"退出申请后，您的申请进度将被保存，可在订单中找到进度并继续填写。" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self saveTempData];
                
            }
        }];
        
    }
}
-(void)leftButtonTouch
{
    [self rightButtonTouch];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.viewModel.theme) {
        if(self.viewModel.theme.back_button_highlight){
            return UIStatusBarStyleLightContent;
        }else{
            return UIStatusBarStyleDefault;
        }
    }else{
        return [super preferredStatusBarStyle];
        
    }
}

-(void)backItemAct:(id)sender
{
    if (self.viewModel.theme.previous_step.length) {
        
        self.viewModel.next_step = self.viewModel.theme.previous_step;
        [[GCDQueue mainQueue]queueBlock:^{
            
            [self.viewModel.command execute:nil];
            
        } afterDelay:1];
        
        return;
    }
    
    
//    [UIAlertView showWithTitle:@"请问您是否要退出精准推荐流程？" message: nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//        if (buttonIndex == 1)
        {
            
#if TimCustomNAV
            //            [self setNavBarShowWithAlpha: 0 ];
            [self resetCustomUI];
            [self enableNavPanBack:YES];
            
            [super backItemAct:sender];
            
#else
            [self setNavBarShowWithAlpha: 0 ];
            [super backItemAct:sender];
#endif

        }
//    }];
}
//-(UIEdgeInsets)tableCellSepEdge:(NSIndexPath* )indexPath{
//    
//    TQBJiaodanDynamicInputObjectGroup *group = [TQBJiaodanDynamicInputObjectGroup new];
//    group.objects = self.viewModel.dataArray;
//    
//    TQBJiaodanDynamicInputObject *object = [group.allShowItems objectAtIndex:indexPath.row];
//    
//    
//    if (object.type_enum == InputObjectType_label) {
//        return UIEdgeInsetsMake(0, 100000, 0, 0);
//
//    }else{
//        return UIEdgeInsetsMake(0, 22, 0, 16);
//
//    }
//   
//    
//}

-(void)initTable:(BOOL)group
{
    [super initTable:group];
    
    [self initFooter ];
    
    self.table.tableHeaderView = self.adScroll;
    
    
    
    [self regNibs:@[[TQBJiaodanRadioCell class],[TQBJiaodanBigInputCell class]]];
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.table registerClass:[TQBSectionTableViewCell class] forCellReuseIdentifier:@"TQBSectionTableViewCell"];
//    [self.table registerNib:[UINib nibWithNibName:@"ProductDetailRecommandHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ProductDetailRecommandHeader"];
    
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

    
    
    self.table.estimatedRowHeight = 160;
    self.table.backgroundColor = RGB(245, 245, 245);
    
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
    TQBJiaodanStepHeader *header = [[TQBJiaodanStepHeader alloc] initWithFrame:CGRectMake(0, 0, 300, 100) ];
//    header.frame = CGRectMake(0, 0, 300, 100);
//    self.table.tableHeaderView = header;
    self.header = header;
    
    
    
    
    @weakify(self);
    
//    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        @strongify(self);
//
//        [self.viewModel loadFirstPage];
//        [self.adScroll.scrollAD_command.command execute:nil];
//
//    }];
    
    
    
    
    
    [self setVMaction];
    
    
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:ReloadSectionNotifaction object:nil] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        
        [self.cellManager resetAllShowItems];
        
        CGPoint offset = self.table.contentOffset ;
        
        [self.table reloadData];
        
        self.table.contentOffset = offset ;
        

    }];
    
    
    
}
-(void)didReceivedData
{
    self.cellManager.itemsArray = self.viewModel.dataArray;
    self.cellManager.theme = self.viewModel.theme;
    
    
    [self setCustomUI];
    
    
    [self.table reloadData];
    
    
    if (self.viewModel.dataArray.count) {
        GCD_main(
                 [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                 )
        
    }

}
-(void)setVMaction{
    @weakify(self);

    [self.viewModel.command.executing  subscribeNext:^(NSNumber *executing) {
        @strongify(self);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        executing.boolValue?[[DialogUtil sharedInstance]showHud:self.view withLabel:@""]:[MBProgressHUD hideAllHUDsForView:self.view animated:1];
#pragma clang diagnostic pop
        
        
        [self.view endEditing:1];
        
    }];
    
    [[self.viewModel.command.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        
        
        [self.table.mj_header endRefreshing];
        
        [self didReceivedData];
        
    }];
    
    [[self.viewModel.command.errors deliverOnMainThread] subscribeNext:^(NSError *error) {
        @strongify(self);
        
        [self.table.mj_header endRefreshing];
        
//        SHOWMSG(error.localizedDescription);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
#pragma clang diagnostic pop
        
        
        [self showFailWithText:error.localizedDescription yOffset:0];
        
    }];
    
    //////
    
    
    
    
    
    
    
    /////
    [[self.verifyDataViewModel.command.executing deliverOnMainThread]subscribeNext:^(NSNumber *executing) {
        @strongify(self);
        
//        executing.boolValue?[[DialogUtil sharedInstance]showHud:self.view withLabel:@""]:[MBProgressHUD hideAllHUDsForView:self.view animated:1];
        executing.boolValue?[[DialogUtil sharedInstance]showHud:self.view withLabel:@""]:nil;
        
        
        [self.view endEditing:1];
        
    }];
    
    [[self.verifyDataViewModel.command.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        
        if (x == nil
//            && self.verifyDataViewModel.save_order == NO
            ) {
            return ;
        }
        
      
        [self dealDataVerifyVM:self.verifyDataViewModel];
        
        
        
    }];
    
    [[self.verifyDataViewModel.command.errors deliverOnMainThread] subscribeNext:^(NSError *error) {
        @strongify(self);
        
        [self.table.mj_header endRefreshing];
        
        if (error.code == 2 ) {
            ////
            
            [self dealDataVerifyVM:self.verifyDataViewModel withErrr:error];
            
            
        }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
#pragma clang diagnostic pop
//            SHOWMSG(error.localizedDescription);
            [self showFailWithText:error.localizedDescription yOffset:0];
            
        }
        
    }];
    

}

///数据验证模块,失败的流程
-(void)dealDataVerifyVM:(TQBJiaodanVerifyViewModel *)viewModel withErrr:(NSError *)error
{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
#pragma clang diagnostic pop
    [self showFailWithText:error.localizedDescription yOffset:0];
    
    
    self.verifyCodeModel = [TQBJiaodanVerifyModel mj_objectWithKeyValues:viewModel.output[@"data"]];
    
    if ([[self.verifyCodeModel.verify_type lowercaseString] isEqualToString:@"sms"]) {
        [self showMobileSmsCodeAlert];
        
    }else{
        
        [self showImageCodeAlert];

    }
    
    
    
}

///数据验证模块,成功的流程
-(void)dealDataVerifyVM:(TQBJiaodanVerifyViewModel *)viewModel
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
#pragma clang diagnostic pop
    ///成功的提示
    if (viewModel.msg.length && ![viewModel.msg isEqualToString:@"success"]) {
        [self showSuccessWithText:viewModel.msg yOffset:0];

    }
    
    
    //        if([self.viewModel.next_step isEqualToString:@"step-mobile"]){
    //            //上一步是运营商验证
    //
    //            [self showMobileSmsCodeAlert];
    //
    //        }
    //        else
    
//    if (viewModel.save_order) {
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//        
//    }else
    
    if([viewModel.next_step hasSuffix:@"end"] ||
              [viewModel.next_step hasSuffix:@"done"] ){
        
        ///完成的 block
        void (^GotoCompleteVC_block)(BOOL) = ^(BOOL alert){
            
            UIViewController<JiaodanCompleteVC_Protocal> *vc = self.completeVC;
            if ([vc conformsToProtocol:@protocol(JiaodanCompleteVC_Protocal )]) {
                vc.identify_key =   self.identify_key;
                vc.recommadPath =   viewModel.next_step;
                
                [self.navigationController pushViewController:vc animated:1];
                
            }
            
            
            [self resetCustomUI];
            [self enableNavPanBack:YES];
            
            
            ///移除
            [self removeVCfromNav:self];
            
        };
        
        GotoCompleteVC_block(0);

//            ///判断下一步是完成?  是的话,跳转到推荐列表
//        if(viewModel.msg.length){
//            [UIAlertView showWithTitle:nil message:viewModel.msg cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//                
//                GotoCompleteVC_block(1);
//               
//            }];
//            
//            
//        }else{
//            GotoCompleteVC_block(0);
//            
//        }
        
    }
    else{
        
        //            self.step = self.step + 1;
        
        self.viewModel.next_step = viewModel.next_step;
        [self.viewModel.command execute:nil];

//        [[GCDQueue mainQueue]queueBlock:^{
//            
//            [self.viewModel.command execute:nil];
//            
//        } afterDelay:1];
        
        
        
    }
}

///请输入图像验证码
-(void)showImageCodeAlert{
    
    CGFloat w  = 200;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 200)];
    
    UILabel *titleT = [[UILabel alloc] init];
    titleT.frame = CGRectMake(0, 0, w, 44);
    titleT.text= self.verifyCodeModel.verify_title;
    titleT.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:titleT];
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.verifyCodeModel.image];
    imageView.frame = CGRectMake(0, CGRectGetMaxY(titleT.frame), w, 50);
    [view addSubview:imageView];
    
    
    UITextField *textF = [[UITextField alloc] init];
    textF.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame), w, 50);
    textF.placeholder= @"请输入验证码";
    textF.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:textF];
    
    view.frame = CGRectMake(0, 0, w, CGRectGetMaxY(textF.frame) + 5 );

    
    @weakify(textF);
    @weakify(self);
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    [alertView setContainerView:view];

    [alertView setButtonTitles:[NSArray arrayWithObjects://@"取消",
                                @"确定", nil]];


//    [alertView setButton:self.verifyCodeModel.verify_title];
    
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        
        @strongify(textF);
        @strongify(self);
        
//        if(buttonIndex == 0){
//            [alertView close];
//
//        }else   if(buttonIndex == 0){
//            
//        }

        if (textF.text.length == 0){
//            [self showImageCodeAlert];

            return ;
            
        }else{
            
            [self sendVerifyCodeToServer:textF.text];
            
            [alertView close];
            
        }

        
        
    }];
    [alertView show];
    alertView.delegate = NULL;
    
    [textF becomeFirstResponder];
    
    
    
}
///请输入手机验证码
-(void)showMobileSmsCodeAlert{
    @weakify(self);
    UIAlertView *alert =  [UIAlertView showWithTitle:self.verifyCodeModel.verify_title message:nil style:UIAlertViewStylePlainTextInput cancelButtonTitle:nil otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        
        @strongify(self);
        
        UITextField *input = [alertView textFieldAtIndex:0];
        if (input.text.length == 0) {
            [self showMobileSmsCodeAlert];
        }else{
            [self sendVerifyCodeToServer:input.text];
        }
        
        
    }];
    
    
    UITextField *input = [alert textFieldAtIndex:0];
    input.placeholder = @"请输入手机验证码";
    

}
///发送验证码
-(void)sendVerifyCodeToServer:(NSString *)code
{
    if (code.length==0) {
        return;
    }
    
    TQBJiaodanVerifyViewModel *codeVM = [[TQBJiaodanVerifyViewModel alloc] init];
//    codeVM.identify_key = self.identify_key;
//    codeVM.verify_step = self.verifyCodeModel.verify_step;
    
    codeVM.inputInfo = @{self.verifyCodeModel.verify_key:code};
    
    
    @weakify(self);
    @weakify(codeVM);
    /////
    [[codeVM.command.executing deliverOnMainThread] subscribeNext:^(NSNumber *executing) {
        @strongify(self);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        executing.boolValue?[[DialogUtil sharedInstance]showHud:self.view withLabel:@""]:[MBProgressHUD hideAllHUDsForView:self.view animated:1];
#pragma clang diagnostic pop
        
        
        [self.view endEditing:1];
        
    }];
    
    [[codeVM.command.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        @strongify(codeVM);
        
        if (x == nil) {
            return ;
        }
        
        [self dealDataVerifyVM:codeVM];
        
        
    }];
    
    [[codeVM.command.errors deliverOnMainThread] subscribeNext:^(NSError *error) {
        @strongify(self);
        
        [self.table.mj_header endRefreshing];
        
        if (error.code == 2 ) {
            
            ////
            [self dealDataVerifyVM:codeVM withErrr:error];
            
            
        }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
#pragma clang diagnostic pop
            
//            SHOWMSG(error.localizedDescription);
            [self showFailWithText:error.localizedDescription yOffset:0];
            
        }
        
    }];

    
    [codeVM.command execute:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark EmptyDataSet
//The image for the empty state:
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}


#if TimCustomNAV
-(UIColor *)navigationBarInColor
{
    UIColor *navBarcolor = nil;
    
    if (self.viewModel.theme) {
        
        navBarcolor = [UIColor colorWithString:self.viewModel.theme.title_background_color];
        
        if(navBarcolor){
            return navBarcolor;
            
        }
        
    }
    
    
    navBarcolor = [super navigationBarInColor];
    
    return navBarcolor;
    
    
}
#endif
-(void)initAD_view
{
    if ( !self.adScroll) {
        self.adScroll = [TQBScrollAdView cycleScrollViewWithFrame:CGRectMake(0, 0, 300, 0) delegate:self placeholderImage:nil];
        self.adScroll.scrollAdType = ScrollAdType_kh_inquiry_top_add;
    }
    
    @weakify(self);
    [[RACObserve(self.adScroll.scrollAD_command ,obj ) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        self.adScroll.height = self.adScroll.scrollAD_command.obj.ad.count == 0?0:320/750. * self.adScroll.width;

    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
