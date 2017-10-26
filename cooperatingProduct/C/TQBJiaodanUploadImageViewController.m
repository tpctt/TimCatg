//
//  TQBJiaodanUploadImageViewController.m
//  taoqianbao
//
//  Created by tim on 17/2/22.
//  Copyright © 2017年 tim. All rights reserved.
//

#import "TQBJiaodanUploadImageViewController.h"
#import <SuggestImageSelectView.h>

#import "TQBJiaodanUploadImageViewModel.h"
#import "TQBJiaoDanInputCell.h"
#import "DialogUtil+Hud.h"
// Controllers
// Model
// Views
//#define macro value
@interface TQBJiaodanUploadImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (weak, nonatomic) IBOutlet SuggestImageSelectView *imageSelectView;
@property (strong, nonatomic)  TQBJiaodanUploadImageViewModel *viewModel;
@property (strong, nonatomic)  TQBJiaodanGetImageViewModel *getImageViewModel;
///原始的图片地址
@property (strong, nonatomic)  NSMutableArray *originImageArray;

@end

@implementation TQBJiaodanUploadImageViewController

#pragma mark - View Controller LifeCyle

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
    self.view.backgroundColor = RGB(245, 245, 245);
    
    self.imageSelectView.cameraBgIcon = [UIImage imageNamed:@"icon_camera_gray"];
    self.imageSelectView.delBtnImage = [UIImage imageNamed:@"icon_delete-"];
    
    [self setVMaction];
    [self setDefaultImage];
    [self initialNavigationBar];
    [self getData];
    
}

#pragma mark - Override

#pragma mark - Initial Methods

- (void)initialNavigationBar
{

    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    [self showBarButton:0 title:@"取消" fontColor: HEX_RGB(0x666666)];
    [self showBarButton:1 title:@"完成" fontColor: BlueC];
    
    self.title = self.model.title;
    
}

#pragma mark - Target Methods
-(void)rightButtonTouch
{
    @weakify(self);
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *pathArray = [NSMutableArray array];
    
    
    for (id image in self.imageSelectView.currectImageArray ) {
        if ([image isKindOfClass:[UIImage class]]) {
            [imageArray addObject:image];
        }else   if ([image isKindOfClass:[NSString class]]) {
            [pathArray addObject:image];
            
        }

        
    }
    
    
    NSMutableArray *original_img_ids = [NSMutableArray  array];
    for (TQBJiaodanImageObject *imageObject in self.getImageViewModel.imageObjects) {
        for (NSString *imagePath in pathArray ) {
            if ([imagePath  isEqualToString:imageObject.href]) {
                [original_img_ids addObject:imageObject.id];
            }
        }
    }
    
    
    
    self.viewModel.images = imageArray;
    self.viewModel.identify_key = self.model.identify_key;
    self.viewModel.img_type = self.model.name;
    self.viewModel.original_img_ids = original_img_ids;
    
    

    
    [[self.viewModel.command execute:nil]
     subscribeNext:^(id x) {
         
         @strongify(self);
         
         
         [self.originImageArray removeObjectsInArray:imageArray];
         [self.originImageArray addObjectsFromArray:pathArray];
         
         
         self.model.value = [[self.viewModel.imagePaths valueForKey:@"id"]componentsJoinedByString:@","];

         [[NSNotificationCenter defaultCenter]postNotificationName:ReloadSectionNotifaction object:nil];

         
         [self.navigationController popViewControllerAnimated:1];
         
         
         
    }];
    
    
    
}

#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - UITableViewDelegate, UITableViewDataSource

#pragma mark - Privater Methods

-(void)setOriginImageShow{
    @weakify(self);
    
    
    self.originImageArray = self.getImageViewModel.imageObjects.mutableCopy;
    
    
    [self.imageSelectView addImages:[self.originImageArray valueForKey:@"href"]];
    self.imageSelectView.setImageBlock = ^UIImage *(NSIndexPath *path , UIButton *imageBtn){
        
        @strongify(self);
        
        
        id image = [self.imageSelectView.currectImageArray objectAtIndex:path.row];
        
        if ([image isKindOfClass:[UIImage class]]) {
            return image;
            
        }else if ([image isKindOfClass:[NSString class]]){
            [imageBtn sd_setImageWithURL:[NSURL URLWithString:image] forState:0 placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            
        }else{
            return nil;

        }
        
        return nil;
        

    };
    
    self.imageSelectView.tapImageBlock = ^(NSIndexPath *path , UIImage *image, UIButton *btn){
        CGRect rect = [self.view convertRect:btn.frame toView:self.view];
        
        [UIActionSheet showFromRect:rect inView:self.view animated:YES withTitle:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            
            if (buttonIndex == 0) {
                [self.imageSelectView deleteImageAtIndex:path.row];
                
            }
            
        }];
        
    };
    
    
    
}
-(void)setDefaultImage{
    
    NSString *imagePath = self.getImageViewModel.default_img;
    [self.defaultImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
}
-(void)setVMaction{
    self.viewModel = [[TQBJiaodanUploadImageViewModel alloc] init];
    
    
    @weakify(self);
    
    [self.viewModel.command.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self);
        
        executing.boolValue?[[DialogUtil sharedInstance]showHud:self.view withLabel:@""]:[MBProgressHUD hideHUDForView:self.view animated:1];
        
        
        [self.view endEditing:1];
        
    }];
    
    [[self.viewModel.command.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        
        
        [self.table reloadData];
        
        
    }];
    
    [[self.viewModel.command.errors deliverOnMainThread] subscribeNext:^(NSError *error) {
        @strongify(self);
        
        [self.table.mj_header endRefreshing];
        
        SHOWMSG(error.localizedDescription);
        
    }];
    
    //////
    
    
    
    self.getImageViewModel = [[TQBJiaodanGetImageViewModel alloc] init];

    [self.getImageViewModel.command.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self);
        
        executing.boolValue?[[DialogUtil sharedInstance]showHud:self.view withLabel:@""]:[MBProgressHUD hideHUDForView:self.view animated:1];
        
        
        [self.view endEditing:1];
        
    }];
    
    [[self.getImageViewModel.command.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        
        self.title = self.getImageViewModel.title;
        [self setOriginImageShow];
        [self setDefaultImage];
        
        
    }];
    
    [[self.getImageViewModel.command.errors deliverOnMainThread] subscribeNext:^(NSError *error) {
//        @strongify(self);
        
        
        SHOWMSG(error.localizedDescription);
        
    }];
    
}

#pragma mark - Setter Getter Methods

-(void)getData{
    
    self.getImageViewModel.identify_key = self.model.identify_key;
    self.getImageViewModel.img_type = self.model.name;
    [self.getImageViewModel.command execute:nil];
    
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
