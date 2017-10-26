//
//  MMDatePickerView.m
//  Wedai
//
//  Created by 中联信 on 15/11/12.
//  Copyright © 2015年 Tim.rabbit. All rights reserved.
//

#import "MMDatePickerView.h"
#import <UIKit/UIDatePicker.h>
#import <EasyIOS/MMPickerView.h>
#import "MMPickerView+add.h"

@interface MMDatePickerView ()


@property (nonatomic, strong) UILabel *pickerViewLabel;
@property (nonatomic, strong) UIView *pickerViewLabelView;
@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) UIView *pickerViewContainerView;
@property (nonatomic, strong) UIView *pickerTopBarView;
@property (nonatomic, strong) UIImageView *pickerTopBarImageView;
@property (nonatomic, strong) UIToolbar *pickerViewToolBar;
@property (nonatomic, strong) UIBarButtonItem *pickerViewBarButtonItem;
@property (nonatomic, strong) UIButton *pickerDoneButton;
@property (nonatomic, strong) UIDatePicker *pickerView;

@property (nonatomic, strong) NSMutableArray *pickerViewArray;
@property (nonatomic, strong) UIColor *pickerViewTextColor;
@property (nonatomic, strong) UIFont *pickerViewFont;
@property (nonatomic, assign) CGFloat yValueFromTop;
@property (copy) void (^onDismissCompletion) (MMDatePickerView *mmPickView,NSDate *date);
@property (copy) void (^onSelectedCompletion)(MMDatePickerView *mmPickView,NSDate *date);
@property (nonatomic, strong) NSString* withQuest;

@end


@implementation MMDatePickerView

#pragma mark - Singleton

+ (MMDatePickerView*)sharedView {
    static dispatch_once_t once;
    static MMDatePickerView *sharedView;
    dispatch_once(&once, ^ { sharedView = [[self alloc] init]; });
    return sharedView;
}

#pragma mark - Show Methods


+(void)showPickerViewInView: (UIView *)view
                    maxDate: (NSDate *)maxDate
                    minDate:(NSDate*)minDate
                withOptions: (NSDictionary *)options
                   selected: (void(^)(MMDatePickerView *mmPickView,NSDate*date ))selected
                 completion: (void(^)(MMDatePickerView *mmPickView,NSDate*date))completion
                  withQuest:(NSString *)withQuest
{
    [self sharedView].withQuest = withQuest;
    
    [self sharedView].onDismissCompletion = nil;
    [self sharedView].onSelectedCompletion = nil;
    [[self sharedView] initializePickerViewInView:view
                                             date:nil
                                      withOptions:options];
    
    [[self sharedView] setPickerHidden:NO callBack:nil];
    [self sharedView].onDismissCompletion = completion;
    [view addSubview:[self sharedView]];
    
    [self sharedView].pickerView.date = [NSDate date];
    [self sharedView].pickerView.maximumDate = maxDate;
    [self sharedView].pickerView.minimumDate = minDate;
    [self sharedView].pickerView.datePickerMode = UIDatePickerModeDate;
    
    
    
}



#pragma mark - Dismiss Methods

+(void)dismissWithCompletion:(void (^)(MMDatePickerView *mmPickView,NSDate *date))completion{
    [[self sharedView] setPickerHidden:YES callBack:completion];
}

-(void)dismiss{
    [MMDatePickerView dismissWithCompletion:self.onDismissCompletion];
}

+(void)removePickerView{
    [[self sharedView] removeFromSuperview];
}

#pragma mark - Show/hide PickerView methods

-(void)setPickerHidden: (BOOL)hidden
              callBack: (void(^)(MMDatePickerView *mmPickView,NSDate *date))callBack; {
    
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
                             [MMDatePickerView removePickerView];
                             callBack(self,self.pickerView.date);
                             
                         }
                     }];
    
}

#pragma mark - Initialize PickerView

-(void)initializePickerViewInView: (UIView *)view
                             date: (NSDate *)date
                      withOptions: (NSDictionary *)options {
    
    //    _pickerViewArray = [NSMutableArray arrayWithArray:array];
    
    UIColor *pickerViewBackgroundColor = [[UIColor alloc] initWithCGColor:[options[MMbackgroundColor] CGColor]];
    UIColor *pickerViewTextColor = [[UIColor alloc] initWithCGColor:[options[MMtextColor] CGColor]];
    UIColor *toolbarBackgroundColor = [[UIColor alloc] initWithCGColor:[options[MMtoolbarColor] CGColor]];
    UIColor *buttonTextColor = [[UIColor alloc] initWithCGColor:[options[MMbuttonColor] CGColor]];
    UIFont *pickerViewFont = nil;
    pickerViewFont = options[MMfont];
    _yValueFromTop = [options[MMvalueY] floatValue];
    
    [self setFrame: view.bounds];
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIImage * toolbarImage = options[MMtoolbarBackgroundImage];
    
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
    if (toolbarBackgroundColor==nil) {
        toolbarBackgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:0.8];
    }
    
    //ButtonTextColor - Blue
    if (buttonTextColor==nil) {
        buttonTextColor = [UIColor colorWithRed:0.000 green:0.486 blue:0.976 alpha:1];
    }
    
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
    _pickerTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, _pickerContainerView.frame.size.width, 44.0)];
    [_pickerContainerView addSubview:_pickerTopBarView];
    [_pickerTopBarView setBackgroundColor:[UIColor whiteColor]];
    
    
    _pickerViewToolBar = [[UIToolbar alloc] initWithFrame:_pickerTopBarView.frame];
    [_pickerContainerView addSubview:_pickerViewToolBar];
    
    CGFloat iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    //NSLog(@"%f",iOSVersion);
    
    if (iOSVersion < 7.0) {
        _pickerViewToolBar.tintColor = toolbarBackgroundColor;
        //[_pickerViewToolBar setBackgroundColor:toolbarBackgroundColor];
    }else{
        [_pickerViewToolBar setBackgroundColor:toolbarBackgroundColor];
        
        //_pickerViewToolBar.tintColor = toolbarBackgroundColor;
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        _pickerViewToolBar.barTintColor = toolbarBackgroundColor;
#endif
    }
    
    if (toolbarImage!=nil) {
        [_pickerViewToolBar setBackgroundImage:toolbarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    _pickerViewBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
        _pickerViewToolBar.items = @[flexibleSpace, _pickerViewBarButtonItem];
    
    
    [MMPickerView addTitle:self.withQuest toolbar:_pickerViewToolBar withOtherItems:@[flexibleSpace, _pickerViewBarButtonItem]];
    
    [_pickerViewBarButtonItem setTintColor:buttonTextColor];
    
    //[_pickerViewBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica-Neue" size:23.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
    /*
     _pickerDoneButton = [[UIButton alloc] initWithFrame:CGRectMake(_pickerContainerView.frame.size.width - 80.0, 10.0, 60.0, 24.0)];
     [_pickerDoneButton setTitle:@"Done" forState:UIControlStateNormal];
     [_pickerContainerView addSubview:_pickerDoneButton];
     [_pickerDoneButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
     */
    
    //Add pickerView
    _pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, _pickerContainerView.frame.size.width, 216.0)];
    //    [_pickerView setDelegate:self];
    //    [_pickerView setDataSource:self];
    //    [_pickerView setShowsSelectionIndicator:YES];
    [_pickerContainerView addSubview:_pickerView];
    
    //[self.pickerViewContainerView setAlpha:0.0];
    [_pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(_pickerContainerView.frame))];
    
    //Set selected row
    
    //    id chosenObject = options[MMselectedObject];
    //
    //    if (chosenObject!=nil) {
    //        for (int i=0;i<[chosenObject count];i++) {
    //            NSNumber* num = [chosenObject objectAtIndex:i];
    //            [_pickerView selectRow:[num intValue] inComponent:i animated:YES];
    //        }
    //    }
    
}




@end
