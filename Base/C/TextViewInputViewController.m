//
//  TextViewInputViewController.m
//  taoqianbao
//
//  Created by tim on 16/9/12.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "TextViewInputViewController.h"

// Controllers

// Model

// Views


//#define <#macro#> <#value#>

 

@interface TextViewInputViewController ()

@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *totalL;
@property (weak, nonatomic) IBOutlet UILabel *currectL;

@end

@implementation TextViewInputViewController


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
    
    [self initialNavigationBar];
    
    [self initViewModel];
    
    self.textView.backgroundColor = RGB(245, 245, 245);
    
    [self.textView becomeFirstResponder];
    self.textView.text = self.lastText;
    
    @weakify(self);
    
    [self showTextLength];
 
    
    {
        
        [[[[RACSignal combineLatest:@[RACObserve(self,isPhone),self.textView.rac_textSignal ]] throttle:0]distinctUntilChanged]
         subscribeNext:^(id x) {
             
             @strongify(self);
             
             ///避免中文输入法 导致的 占位符不能replace bug
             //         if(self.isPhone){
             [self showTextLength];
             
             //         }
             
             
             
         }];
        
        
        [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextViewTextDidChangeNotification object:self.textView] throttle:0]subscribeNext:^(id x) {
            
            @strongify(self);
            
            ///避免中文输入法 导致的 占位符不能replace bug
            //        if(self.isPhone){
            [self showTextLength];
            
            //        }
        }];
        
        
        [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextViewTextDidEndEditingNotification object:self.textView]subscribeNext:^(id x) {
            
            @strongify(self);
            
            ///避免中文输入法 导致的 占位符不能replace bug
            //        if(self.isPhone){
            [self showTextLength];
            
            //        }
        }];
        
        
    }
    [[[[RACSignal combineLatest:@[RACObserve(self,isPhone),self.textView.rac_textSignal ]] throttle:2]distinctUntilChanged]
     subscribeNext:^(id x) {
         
         @strongify(self);
         
         ///避免中文输入法 导致的 占位符不能replace bug
//         if(self.isPhone){
             [self dealTextLength];
         
//         }
         
         
         
     }];
    
    
    [[[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextViewTextDidChangeNotification object:self.textView] throttle:2]subscribeNext:^(id x) {
        
        @strongify(self);
        
        ///避免中文输入法 导致的 占位符不能replace bug
//        if(self.isPhone){
            [self dealTextLength];
            
//        }
    }];

    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextViewTextDidEndEditingNotification object:self.textView]subscribeNext:^(id x) {
        
        @strongify(self);
        
        ///避免中文输入法 导致的 占位符不能replace bug
//        if(self.isPhone){
            [self dealTextLength];
            
//        }
    }];
    
    
    if (!self.isPhone) {
        self.textView.keyboardType = self.keyType;
    }
}

-(void)showTextLength
{
    
    self.totalL.text = [NSString stringWithFormat:@"/%ld",(long)self.maxLength];
    self.currectL.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.textView.text.length];
    
    self.totalL.hidden = !self.maxLength;
    if(  self.maxLength >   0   ){
        if ( self.textView.text.length > self.maxLength) {
            self.currectL.textColor = [UIColor redColor];
        
        }else{
            self.currectL.textColor = [UIColor colorWithString:@"0x666666"];
            
        }
        
    }
    
   
    
}

-(void)dealTextLength
{
    if (self.isPhone && self.textView.text.length>11) {
        self.textView.text = [self.textView.text substringToIndex:11];
        
    }else if(  self.maxLength >   0   ){
        if ( self.textView.text.length > self.maxLength) {
            self.textView.text = [self.textView.text substringToIndex: self.maxLength ];
        }
        
    }
    
    self.textView.keyboardType = self.isPhone ? UIKeyboardTypeNumberPad:UIKeyboardTypeDefault;
    
    [self showTextLength];
    
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

//    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override

#pragma mark - Initial Methods

- (void)initialNavigationBar
{
//    self.navigationItem.title = <#title#>;
    
    [self showBarButton:1 title:@"保存" fontColor:HEX_RGB(0x212121)  ];
    
    
    
}


#pragma mark - Target Methods
-(void)rightButtonTouch
{
    
    [self.view endEditing:1];
    
    self.lastText = self.textView.text;
    
          
}

#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - UITableViewDelegate, UITableViewDataSource


#pragma mark - Privater Methods


#pragma mark - Setter Getter Methods


-(void)initViewModel
{}

@end
