//
//  MMlistView.m
//  Wedai
//
//  Created by 中联信 on 15/11/3.
//  Copyright © 2015年 Tim.rabbit. All rights reserved.
//

#import "MMlistView.h"
//#import <IQKeyboardManager/IQUIView+Hierarchy.h>

//extern NSString * const MMbackgroundColor;
//extern NSString * const MMtextColor;
//extern NSString * const MMtoolbarColor;
//extern NSString * const MMbuttonColor;
//extern NSString * const MMfont;
//extern NSString * const MMvalueY;
//extern NSString * const MMselectedObject;
//extern NSString * const MMtoolbarBackgroundImage;
//
//
//NSString * const MMbackgroundColor = @"backgroundColor";
//NSString * const MMtextColor = @"textColor";
//NSString * const MMtoolbarColor = @"toolbarColor";
//NSString * const MMbuttonColor = @"buttonColor";
//NSString * const MMfont = @"font";
//NSString * const MMvalueY = @"yValueFromTop";
//NSString * const MMselectedObject = @"selectedObject";
//NSString * const MMtoolbarBackgroundImage = @"toolbarBackgroundImage";


//#import <EasyIOS/MMPickerView.h>


@interface MMlistView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *pickerViewLabel;
@property (nonatomic, strong) UIView *pickerViewLabelView;
@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) UIView *pickerViewContainerView;
//@property (nonatomic, strong) UIView *pickerTopBarView;
//@property (nonatomic, strong) UIImageView *pickerTopBarImageView;
//@property (nonatomic, strong) UIToolbar *pickerViewToolBar;
//@property (nonatomic, strong) UIBarButtonItem *pickerViewBarButtonItem;
//@property (nonatomic, strong) UIButton *pickerDoneButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) NSMutableArray *selectIndexPathArray;


@property (nonatomic, strong) NSMutableArray *pickerViewArray;
@property (nonatomic, strong) UIColor *pickerViewTextColor;
@property (nonatomic, strong) UIFont *pickerViewFont;
@property (nonatomic, assign) CGFloat yValueFromTop;
@property (copy) void (^onDismissCompletion)(NSArray *);
@property (copy) void (^onSelectedCompletion)(MMlistView *mmPickView,NSInteger row,NSInteger component);
@property (nonatomic, assign) BOOL isTapCancel;
@property (nonatomic, strong) NSString* withQuest;

@property (nonatomic, assign) BOOL isMulit;


@end


@implementation MMlistView

#pragma mark - Singleton

+ (MMlistView*)sharedView {
    static dispatch_once_t once;
    static MMlistView *sharedView;
    dispatch_once(&once, ^ { sharedView = [[self alloc] init]; });
    return sharedView;
}

#pragma mark - Show Methods
-(void)reloadAllComponentWithPickViewArray:(NSArray *)array{
    _pickerViewArray = [NSMutableArray arrayWithArray:array];
    //    [_pickerView reloadAllComponents];
    [_tableView reloadData  ];
    
    [self modifyTableViewH];
    
}

-(void)modifyTableViewH
{
    NSInteger number = 44 * ([(NSArray *)[_pickerViewArray safeObjectAtIndex:0] count] + 1 )+ 35;
    if(number > self.pickerViewContainerView.height - 60){
        number = self.pickerViewContainerView.height - 60;
    }
    NSInteger top = self. pickerViewContainerView.height-number;
    
    
    self.pickerContainerView.frame =  CGRectMake(0, top, self.pickerViewContainerView.frame.size.width, number);
    self.tableView.frame = self.pickerContainerView.bounds;
    
    
}
-(void)reloadComponent:(NSInteger)component withPickViewArray:(NSArray *)array{
    [_pickerViewArray replaceObjectAtIndex:component withObject:array];
    //    [_pickerView reloadComponent:component];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:component] withRowAnimation:UITableViewRowAnimationAutomatic  ];
    
    [self modifyTableViewH];
    
}
+(void)showPickerViewInView: (UIView *)view
                withStrings: (NSArray *)strings
                withOptions: (NSDictionary *)options
                   selected: (void(^)(MMlistView *mmPickView,NSInteger row,NSInteger component))selected
                 completion: (void(^)(NSArray *selectedString))completion
                  withQuest:(NSString*)withQuest
{
    
    [[self class]showPickerViewInView:view withStrings:strings withOptions:options selected:selected  completion:completion  withQuest:withQuest isMulit:NO];
    
    
}
+(void)showPickerViewInView: (UIView *)view
                withStrings: (NSArray *)strings
                withOptions: (NSDictionary *)options
                   selected: (void(^)(MMlistView *mmPickView,NSInteger row,NSInteger component))selected
                 completion: (void(^)(NSArray *selectedString))completion
                  withQuest:(NSString*)withQuest isMulit:(BOOL)isMulit
{
    [self sharedView].withQuest = withQuest;
    
    [self showPickerViewInView:view withStrings:strings withOptions:options completion:completion];
    [self sharedView].onSelectedCompletion = selected;
    [self sharedView].isMulit = isMulit;
    
    
}

+(void)showPickerViewInView:(UIView *)view
                withStrings:(NSArray *)strings
                withOptions:(NSDictionary *)options
                 completion:(void (^)(NSArray *))completion{
    
    [self sharedView].onDismissCompletion = nil;
    [self sharedView].onSelectedCompletion = nil;
    [[self sharedView] initializePickerViewInView:view
                                        withArray:strings
                                      withOptions:options];
    
    [[self sharedView] setPickerHidden:NO callBack:nil];
    [self sharedView].onDismissCompletion = completion;
    [view addSubview:[self sharedView]];
    
    [[self sharedView] modifyTableViewH];
    
    
}
#pragma mark - Dismiss Methods

+(void)dismissWithCompletion:(void (^)(NSArray *))completion{
    [[self sharedView] setPickerHidden:YES callBack:completion];
}

-(void)dismiss{
    [MMlistView dismissWithCompletion:self.onDismissCompletion];
}

+(void)removePickerView{
    [[self sharedView] removeFromSuperview];
}

#pragma mark - Show/hide PickerView methods

-(void)setPickerHidden: (BOOL)hidden
              callBack: (void(^)(NSArray *))callBack; {
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         if (hidden) {
                             [_pickerViewContainerView setAlpha:0.0];
                             [_pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(_pickerContainerView.frame))];
                         } else {
                             [_pickerViewContainerView setAlpha:1.0];
                             [_pickerContainerView setTransform:CGAffineTransformIdentity];
                         }
                     } completion:^(BOOL completed) {
                         if(completed && hidden && callBack){
                             [MMlistView removePickerView];
                             if (_isTapCancel) {
                                 
                                 callBack(nil);
                                 
                             }else{
                                 callBack([self selectedObject]);
                                 
                             }
                         }
                     }];
    
}

#pragma mark - Initialize PickerView

-(void)initializePickerViewInView: (UIView *)view
                        withArray: (NSArray *)array
                      withOptions: (NSDictionary *)options {
    
    _pickerViewArray = [NSMutableArray arrayWithArray:array];
    _selectIndexPathArray = [NSMutableArray array ];
    
    //    UIColor *pickerViewBackgroundColor = [[UIColor alloc] initWithCGColor:[options[MMbackgroundColor] CGColor]];
    //    UIColor *pickerViewTextColor = [[UIColor alloc] initWithCGColor:[options[MMtextColor] CGColor]];
    //    UIColor *toolbarBackgroundColor = [[UIColor alloc] initWithCGColor:[options[MMtoolbarColor] CGColor]];
    //    UIColor *buttonTextColor = [[UIColor alloc] initWithCGColor:[options[MMbuttonColor] CGColor]];
    //    UIFont *pickerViewFont = [[UIFont alloc] init];
    //    pickerViewFont = options[MMfont];
    //    _yValueFromTop = [options[MMvalueY] floatValue];
    
    UIColor *pickerViewBackgroundColor = [ UIColor whiteColor];
    UIColor *pickerViewTextColor = [ UIColor blackColor];
//    UIColor *toolbarBackgroundColor = [ UIColor whiteColor];
//    UIColor *buttonTextColor = [ UIColor blueColor];
    UIFont *pickerViewFont = nil;
    pickerViewFont = [UIFont systemFontOfSize:15];
    //    _yValueFromTop = [options[MMvalueY] floatValue];
    
    [self setFrame: view.bounds];
    [self setBackgroundColor:[UIColor clearColor]];
    
    //    UIImage * toolbarImage = options[MMtoolbarBackgroundImage];
    
    //Whole screen with PickerView and a dimmed background
    _pickerViewContainerView = [[UIView alloc] initWithFrame:view.bounds];
    [_pickerViewContainerView setBackgroundColor: [UIColor colorWithRed:0.412 green:0.412 blue:0.412 alpha:0.7]];
    [self addSubview:_pickerViewContainerView];
    
    //PickerView Container with top bar
    _pickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, _pickerViewContainerView.bounds.size.height - 260.0, _pickerViewContainerView.bounds.size.width, 260.0)];
    
    //Default Color Values (if colors == nil)
    
    //PickerViewBackgroundColor - White
    if (pickerViewBackgroundColor==nil) {
        pickerViewBackgroundColor = [UIColor whiteColor];
    }
    
    //PickerViewTextColor - Black
    if (pickerViewTextColor==nil) {
        pickerViewTextColor = [UIColor blackColor];
    }
    _pickerViewTextColor = pickerViewTextColor;
    
    //ToolbarBackgroundColor - Black
//    if (toolbarBackgroundColor==nil) {
//        toolbarBackgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:0.8];
//    }
//    
//    //ButtonTextColor - Blue
//    if (buttonTextColor==nil) {
//        buttonTextColor = [UIColor colorWithRed:0.000 green:0.486 blue:0.976 alpha:1];
//    }
    
    if (pickerViewFont==nil) {
        _pickerViewFont = [UIFont systemFontOfSize:22];
    }
    _pickerViewFont = pickerViewFont;
    
    /*
     //ToolbackBackgroundImage - Clear Color
     if (toolbarBackgroundImage!=nil) {
     //Top bar imageView
     _pickerTopBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, _pickerContainerView.frame.size.width, 44.0)];
     //[_pickerContainerView addSubview:_pickerTopBarImageView];
     _pickerTopBarImageView.image = toolbarBackgroundImage;
     [_pickerViewToolBar setHidden:YES];
     
     }
     */
    
    _pickerContainerView.backgroundColor = pickerViewBackgroundColor;
    [_pickerViewContainerView addSubview:_pickerContainerView];
    
    
    //Content of pickerContainerView
    
    //Top bar view
    //    _pickerTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, _pickerContainerView.frame.size.width, 44.0)];
    //    [_pickerContainerView addSubview:_pickerTopBarView];
    //    [_pickerTopBarView setBackgroundColor:[UIColor whiteColor]];
    
    
    //    _pickerViewToolBar = [[UIToolbar alloc] initWithFrame:_pickerTopBarView.frame];
    //    [_pickerContainerView addSubview:_pickerViewToolBar];
    
    CGFloat iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    //NSLog(@"%f",iOSVersion);
    
    if (iOSVersion < 7.0) {
        //        _pickerViewToolBar.tintColor = toolbarBackgroundColor;
        //[_pickerViewToolBar setBackgroundColor:toolbarBackgroundColor];
    }else{
        //        [_pickerViewToolBar setBackgroundColor:toolbarBackgroundColor];
        
        //_pickerViewToolBar.tintColor = toolbarBackgroundColor;
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        //        _pickerViewToolBar.barTintColor = toolbarBackgroundColor;
#endif
    }
    
    //    if (toolbarImage!=nil) {
    ////        [_pickerViewToolBar setBackgroundImage:toolbarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    //    }
    
//    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //    _pickerViewBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    //    _pickerViewToolBar.items = @[flexibleSpace, _pickerViewBarButtonItem];
    //    [_pickerViewBarButtonItem setTintColor:buttonTextColor];
    
    //[_pickerViewBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica-Neue" size:23.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
    /*
     _pickerDoneButton = [[UIButton alloc] initWithFrame:CGRectMake(_pickerContainerView.frame.size.width - 80.0, 10.0, 60.0, 24.0)];
     [_pickerDoneButton setTitle:@"Done" forState:UIControlStateNormal];
     [_pickerContainerView addSubview:_pickerDoneButton];
     [_pickerDoneButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
     */
    
    //Add pickerView
    //    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, _pickerContainerView.frame.size.width, 216.0)];
    //    [_pickerView setDelegate:self];
    //    [_pickerView setDataSource:self];
    //    [_pickerView setShowsSelectionIndicator:YES];
    //    [_pickerContainerView addSubview:_pickerView];
    
    _tableView = [[UITableView  alloc] initWithFrame:CGRectMake(0.0, 0.0, _pickerContainerView.frame.size.width, 260.0)];
    _tableView.tableFooterView = [[UIView alloc]init ];
    _tableView.separatorColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5 ];
    
    [_tableView setDelegate:self ];
    [_tableView setDataSource:self ];
    //    [_tableView setShowsSelectionIndicator:YES];
    [_pickerContainerView addSubview:_tableView ];
    
    
    //[self.pickerViewContainerView setAlpha:0.0];
    [_pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(_pickerContainerView.frame))];
    
    //Set selected row
    
    NSArray * chosenObject = nil;
    
    if (chosenObject!=nil) {
        for (int i=0;i<[chosenObject count];i++) {
//            NSNumber* num = [chosenObject objectAtIndex:i];
            //            [_pickerView selectRow:[num intValue] inComponent:i animated:YES];
            
            self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0   ];
            
            
        }
    }
    
}

#pragma cell btn
-(void)cancelBtn
{
    ///点击取消按钮
    _isTapCancel = YES;
    [self dismiss];
    
}
-(void)finishBtn
{
    if (self.isMulit) {
        
        _isTapCancel = NO;
        
        [self dismiss];
        
        
    }else{
        _isTapCancel = NO;
        
        [self dismiss];
        
    }
}

#pragma mark - UItablViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_pickerViewArray count]+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == [_pickerViewArray count] ){
        return 1;
    }
    
    
    if (section && _pickerViewArray.count >section) {
        return [(NSArray *)[_pickerViewArray safeObjectAtIndex:section] count];
    }else{
        return [(NSArray *)[_pickerViewArray safeObjectAtIndex:0] count];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == [_pickerViewArray count] ){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"11Q234"];
        if (cell==nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"11Q234"];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
            
            if (_isMulit) {
                
                UIButton *finishBtn = [[UIButton alloc] init];
                UIButton *cancelBtn = [[UIButton alloc] init];
                
                [finishBtn setTitle:@"完成" forState:0];
                [cancelBtn setTitle:@"取消" forState:0];
                
                [finishBtn setTitleColor:[UIColor blueColor] forState:0];
                [cancelBtn setTitleColor:[UIColor redColor] forState:0];
                
                
                [cell addSubview:finishBtn];
                [cell addSubview:cancelBtn];
                
//                UIView *superView = cell;
                
                
                
//                [finishBtn alignTop:@"0" bottom:@"0" toView:superView];
//                [finishBtn alignTrailingEdgeWithView:superView predicate:@"0"];
//                
//                [cancelBtn alignTop:@"0" bottom:@"0" toView:superView];
//                [cancelBtn alignLeadingEdgeWithView:superView predicate:@"0"];
//                
//                //            [cancelBtn alignTrailingEdgeWithView:finishBtn predicate:@"130"];
//                
//                [finishBtn constrainLeadingSpaceToView:cancelBtn predicate:@"8"];
//                [UIView equalWidthForViews:@[finishBtn,cancelBtn]];
//                //            [finishBtn equalWidthForViews:@[cancelBtn ] ];
                
                
                [finishBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchUpInside];
                [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
                
                
            }else{
                cell.textLabel.text = @"取消" ;
                cell.textLabel.textColor = [UIColor redColor];
                
                
            }
            
        }
        
//        cell.textLabel.text = @"取消" ;
//        cell.textLabel.textColor = [UIColor redColor];
        
        
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1Q234"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1Q234"];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
        }
        
        if(indexPath.section == [_pickerViewArray count] ){
            cell.textLabel.text = @"取消" ;
            
        }else{
            NSString *str = [[_pickerViewArray safeObjectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.textLabel.text = str ;
            
//            id obj = [[_pickerViewArray firstObject]safeObjectAtIndex:indexPath.row];
            if ([_selectIndexPathArray containsObject:indexPath]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
        }
        return cell;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == [_pickerViewArray count] ){
        return 5;
    }
    return 30;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, [self tableView:tableView heightForHeaderInSection:section])];
        //        label.mj_x = 0;
        //        label.mj_w -= 5+ 50;
        label.backgroundColor = RGB(248, 248, 248);
        
        label.text = self.withQuest;
        label.textAlignment = NSTextAlignmentCenter;
        
        return label;
        
    }else{
        return nil;
    }
}
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        return self.withQuest;
//    }else{
//        return nil;
//    }
//}

#pragma mark - UItableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:1];
    
    if(indexPath.section == [_pickerViewArray count] ){
        
        //        self.selectIndexPath = indexPath;
        ///点击取消按钮
        _isTapCancel = YES;
        [self dismiss];
        
    }else{
        if (self.isMulit) {
            
            id obj = [[_pickerViewArray firstObject]safeObjectAtIndex:indexPath.row];
            if (obj) {
                
                if ([_selectIndexPathArray containsObject:indexPath]) {
                    [_selectIndexPathArray removeObject:indexPath];
                }else{
                    [_selectIndexPathArray addObject:indexPath];
                }
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else{
            _isTapCancel = NO;
        
            self.selectIndexPath = indexPath;
            [self dismiss];
        }
    }
    
    //    if (self.onSelectedCompletion) {
    //        self.onSelectedCompletion(self,indexPath.row,indexPath.section);
    //    }
    
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView {
    return [_pickerViewArray count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    if (component && _pickerViewArray.count >component) {
        return [(NSArray *)[_pickerViewArray safeObjectAtIndex:component] count];
    }else{
        return [(NSArray *)[_pickerViewArray safeObjectAtIndex:0] count];
    }
}

- (NSString *)pickerView: (UIPickerView *)pickerView
             titleForRow: (NSInteger)row
            forComponent: (NSInteger)component {
    return [[_pickerViewArray safeObjectAtIndex:component] objectAtIndex:row];
    
}



#pragma mark - UIPickerViewDelegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.onSelectedCompletion) {
        self.onSelectedCompletion(self,row,component);
    }
}

- (id)selectedObject {
    
    
    NSMutableArray *picked = [NSMutableArray array];
    if(self.isMulit){
        for (int i=0; i<[_selectIndexPathArray count]; i++) {
            NSIndexPath *indexPath = [self.selectIndexPathArray objectAtIndex:i];

            [picked addObject:[NSNumber numberWithInteger:indexPath.row]];

        }
    }
    else{
        [picked addObject:[NSNumber numberWithInteger:self.selectIndexPath.row]];

    }
    
    
    return picked;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    UIView *customPickerView = view;
    
    UILabel *pickerViewLabel;
    
    if (customPickerView==nil) {
        
        CGRect frame = CGRectMake(0.0, 0.0, _pickerContainerView.frame.size.width -28.0f, 44.0);
        customPickerView = [[UIView alloc] initWithFrame: frame];
        
        //   UIImageView *patternImageView = [[UIImageView alloc] initWithFrame:frame];
        //   patternImageView.image = [[UIImage imageNamed:@"texture"] resizableImageWithCapInsets:UIEdgeInsetsZero];
        //    [customPickerView addSubview:patternImageView];
        
        if (_yValueFromTop == 0.0f) {
            _yValueFromTop = 3.0;
        }
        
        CGRect labelFrame = CGRectMake(0.0, _yValueFromTop, _pickerContainerView.frame.size.width -28.0f, 35); // 35 or 44
        pickerViewLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [pickerViewLabel setTag:1];
        [pickerViewLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerViewLabel setBackgroundColor:[UIColor clearColor]];
        [pickerViewLabel setTextColor:_pickerViewTextColor];
        [pickerViewLabel setFont:_pickerViewFont];
        [customPickerView addSubview:pickerViewLabel];
    } else{
        
        for (UIView *view in customPickerView.subviews) {
            if (view.tag == 1) {
                pickerViewLabel = (UILabel *)view;
                break;
            }
        }
    }
    
    [pickerViewLabel setText: [[[_pickerViewArray safeObjectAtIndex:component] objectAtIndex:row] description]];
    
    return customPickerView;
    
}


@end
