//
//  GankFeedbackController.m
//  LKGank
//
//  Created by Stephen on 2017/6/28.
//  Copyright © 2017年 wsl. All rights reserved.
//

#import "GankFeedbackController.h"
#import "PlaceholderTextView.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+MJ.h"

#define tableSuggestionName @"suggestionTab"

#define GankScreenWidth [UIScreen mainScreen].bounds.size.width
#define GankScreenHeight [UIScreen mainScreen].bounds.size.height
@interface GankFeedbackController ()<UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    int keyBoardHeight;
    
    CGRect rectOldScrllView;
    
}

@property (nonatomic,strong) PlaceholderTextView *suggestionView;
@property (nonatomic,strong) UITextField *dialView;
@property (nonatomic,strong) UITextField *nickView;
@property (nonatomic,strong) UIButton *send_bt;


@property (nonatomic,strong) UITapGestureRecognizer *tapGesTap;
@property (nonatomic,strong) UISwipeGestureRecognizer *swipeGesRe;

@property (nonatomic,strong) UIScrollView *scrollView;

@end


@implementation GankFeedbackController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBarHidden=NO;
    self.title=@"给个反馈";
    [self initViewUI];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [MobClick beginLogPageView:@"反馈我们"];//("PageOne"为页面名称，可自定义)
    [self.navigationController.navigationBar setHidden:NO];
    rectOldScrllView = self.scrollView.frame;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"反馈我们"];
}






-(void)initViewUI
{
    
    //注册键盘出现与隐藏时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowPlayCorrect:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowPlayCorrect:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    self.scrollView=[[UIScrollView alloc] init];
    self.scrollView.frame=CGRectMake(0, 0,GankScreenWidth , GankScreenHeight);
    self.scrollView.delegate=self;
    [self.view addSubview:self.scrollView];
    
    //添加手势识别
    self.swipeGesRe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cancel_Edit)];
    self.swipeGesRe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.scrollView addGestureRecognizer:self.swipeGesRe];
    
    self.tapGesTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel_Edit)];
    [self.tapGesTap setNumberOfTapsRequired:1];
    [self.scrollView addGestureRecognizer:self.tapGesTap];
    self.suggestionView=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(15, 16, GankScreenWidth-15*2, 160)];
    self.suggestionView.contentMode=UIViewContentModeTop;
    self.suggestionView.contentInset=UIEdgeInsetsMake(5, 0, 0, 0);
    self.suggestionView.placeholder=@"有什么问题或建议吗？赶快发送给我们吧!";
    self.suggestionView.font=[UIFont systemFontOfSize:13];
    self.suggestionView.placeholderFont=[UIFont systemFontOfSize:13];
    self.suggestionView.layer.borderWidth=0.5;
    self.suggestionView.layer.cornerRadius=6.0;
    self.suggestionView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.suggestionView.returnKeyType=UIReturnKeyNext;
    self.suggestionView.delegate=self;
    
    [self.scrollView addSubview:self.suggestionView];
    
    self.dialView=[[UITextField alloc] initWithFrame:CGRectMake(15, 196, GankScreenWidth-15*2,50)];
    self.dialView.font=[UIFont systemFontOfSize:13];
    self.dialView.placeholder=@"联系方式(手机号或邮箱或微信)";
    self.dialView.borderStyle=UITextBorderStyleRoundedRect;
    self.dialView.returnKeyType= UIReturnKeyDone;
    
    self.dialView.delegate=self;
    [self.scrollView addSubview:self.dialView];
    
    self.nickView=[[UITextField alloc] initWithFrame:CGRectMake(15, 270, GankScreenWidth-15*2,50)];
    self.nickView.font=[UIFont systemFontOfSize:13];
    self.nickView.placeholder=@"昵称";
    self.nickView.borderStyle=UITextBorderStyleRoundedRect;
    self.nickView.returnKeyType= UIReturnKeyDone;
    
    self.nickView.delegate=self;
    [self.scrollView addSubview:self.nickView];
    
    self.send_bt=[[UIButton alloc] initWithFrame:CGRectMake(GankScreenWidth/2-130, 341, 260,44)];
    self.send_bt.layer.borderWidth=0.0;
    self.send_bt.layer.cornerRadius=6.0;
    [self.send_bt setBackgroundColor:[UIColor orangeColor]];
    self.send_bt.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.send_bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.send_bt setTitle:@"发布" forState:UIControlStateNormal];
    [self.send_bt addTarget:self action:@selector(send_request) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.send_bt];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self cancel_Edit];
}

-(void)cancel_Edit
{
    if ([self.suggestionView isFirstResponder]) {
        [self.suggestionView endEditing:YES];
    }
    if ([self.dialView isFirstResponder]) {
        [self.dialView endEditing:YES];
        
    }
    if ([self.nickView isFirstResponder]) {
        [self.nickView endEditing:YES];
    }
}

#pragma -mark-
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self cancel_Edit];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range

 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}


//返回
-(void)aboutBtnClick
{
    [self cancel_Edit];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma -mark-  反馈
-(void)send_request
{
    
    if ([self.suggestionView.text isEqualToString:@""]||[self.dialView.text isEqualToString:@""]||[self.nickView.text isEqualToString:@""]) {
        
        return ;
    }
    [self cancel_Edit];
    [self addDataSuggesion:self.suggestionView.text LinkPhone:self.dialView.text nickName:self.nickView.text];
}


-(void)addDataSuggesion:(NSString *)suggestion LinkPhone:(NSString *)phone nickName:(NSString *)nickName
{
    //往GameScore表添加一条playerName为小明，分数为78的数据
     BmobObject *gameScore = [[BmobObject alloc] initWithClassName:tableSuggestionName];
    [gameScore setObject:suggestion forKey:@"suggestionContent"];
    [gameScore setObject:phone forKey:@"suggestionLink"];
    [gameScore setObject:nickName forKey:@"suggestionNick"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        [MobClick event:Umeng_me_feedback];
        [MBProgressHUD showSuccess:@"发送成功"];
        [self.navigationController popViewControllerAnimated:YES];
        //进行操作
    }];
}



#pragma mark - 键盘相关操作

//键盘出现
-(void)keyboardWillShowPlayCorrect:(NSNotification*)noti
{
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyBoardHeight = size.height;
    [self.scrollView setFrame:CGRectMake(0,
                                         0,
                                         GankScreenWidth,
                                         rectOldScrllView.size.height - keyBoardHeight)];
    [self.scrollView setContentSize:rectOldScrllView.size];
}

//键盘消失
- (void)keyboardWillHide:(NSNotification*)noti{
    keyBoardHeight = 0;
    CGSize size=rectOldScrllView.size;
    size.height-=100;
    
    [self.scrollView setContentSize:size];
    [self.scrollView setFrame:rectOldScrllView];
}

//    -(void)dealloc //移除通知
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
}


@end
