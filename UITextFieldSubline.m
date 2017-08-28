//
//  TQB.m
//  taoqianbao
//
//  Created by tim on 16/9/8.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "UITextFieldSubline.h"
@interface UITextFieldSubline () <UITextFieldDelegate>

@property (strong,nonatomic) UILabel *leftLabel;
@property (strong,nonatomic) UIButton *securityBtn;

@property (strong,nonatomic) UIView *lineLayer;

@end

@implementation  UITextFieldSubline
-(void)commandInitRac
{
    self.lineHeight = 0.5;
    
    self.layer.masksToBounds = 1;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    @weakify(self);
    /*
    [[[RACSignal combineLatest:@[RACObserve(self,isPhone),self.rac_textSignal ]]distinctUntilChanged]
     subscribeNext:^(id x) {
         
         @strongify(self);
         ///避免中文输入法 导致的 占位符不能replace bug
         if(self.isPhone){

         }
         [self dealTextLength];

    }];
    */
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextFieldTextDidEndEditingNotification object:self]subscribeNext:^(id x) {
        
        @strongify(self);
        [self dealTextLength];
        
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UITextFieldTextDidChangeNotification object:self]subscribeNext:^(id x) {
        
        @strongify(self);
        [self dealTextLength];
        
    }];
    
    
    self.lineLayer = [UIView new];
    
}

-(void)dealTextLength
{
    UITextRange *markedRange = [self markedTextRange];
    if (markedRange) {
        return;
    }

    if (self.isPhone && self.text.length>11) {
        self.text = [self.text substringToIndex:11];
        
    }else if(  self.maxLength >   0   ){
        if ( self.text.length > self.maxLength) {
            self.text = [self.text substringToIndex: self.maxLength ];
        }
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commandInitRac];

    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self commandInitRac];
    
}
-(void)setLeftText:(NSString*)string
{
    if (!self.leftLabel) {
        self.leftLabel = [[UILabel alloc] init];
        self.leftLabel.font = [UIFont   systemFontOfSize:14 ];
        self.leftLabel.textColor = k_color_C4 ;
        
        self.leftView = self.leftLabel;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    self.leftLabel.text = [string stringByAppendingString:@" "];
    [self.leftLabel sizeToFit];
    
}
-(void)setSecureTextEntry:(BOOL)secureTextEntry{
    [super setSecureTextEntry:secureTextEntry];
    self.clearsOnBeginEditing = secureTextEntry;
    
    if (self.showEyeForPwd) {
        
        if (!self.securityBtn) {
            self.securityBtn = [[UIButton alloc] init];
            
            UIImage *img = [UIImage imageNamed:@"icon_look"];
            UIImage *imgSelect = [UIImage imageNamed:@"icon_eyes-closed"];
            
            [self.securityBtn setImage:img forState:0];
            [self.securityBtn setImage:imgSelect forState:UIControlStateSelected];
            
            [self.securityBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
            
            self.rightView = self.securityBtn;
            self.rightViewMode = UITextFieldViewModeAlways;
            
            
            @weakify(self);
            
            [[self.securityBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            
                @strongify(self);

                self.secureTextEntry = !self.secureTextEntry;
                
            }];
    
            
            [self.securityBtn sizeToFit];

            
            
        }
        
        self.securityBtn.selected = secureTextEntry;
        
    }
    
    
    
}
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    if(!self.hideLine  ){
        
        CGRect rect2 = CGRectMake(_distanceLeading, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame)-2*_distanceLeading,  self.lineHeight );
        
        self.lineLayer.frame = rect2;
        self.lineLayer.backgroundColor = self.lineColor?:[UIColor colorWithString:@"0xcccccc"];
        //self.lineColor;
        [self addSubview:self.lineLayer];
        self.clipsToBounds = NO;
        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        
//        CGContextSetFillColorWithColor(context, self.lineColor?self.lineColor.CGColor: [UIColor fromHexValue:0xcccccc].CGColor);
//        
//        
//        CGContextFillRect(context,rect2 );
        

    }else{
        [self.lineLayer removeFromSuperview];
        
    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
