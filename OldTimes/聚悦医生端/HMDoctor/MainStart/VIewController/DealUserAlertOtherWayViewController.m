//
//  DealUserAlertOtherWayViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "DealUserAlertOtherWayViewController.h"
#import "HMKeyboardShowHiddenNotificationCenter.h"

@interface DealUserAlertOtherWayViewController ()<UITextViewDelegate,HMKeyboardShowHiddenNotificationCenterDelegate>

@property (nonatomic, strong) UIView *dealView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, copy) DealUserAlertOtherWayVCDisMiss block;
@end

@implementation DealUserAlertOtherWayViewController

- (void)dealloc{
    [[HMKeyboardShowHiddenNotificationCenter defineCenter] closeCurrentNotification];
}

- (instancetype)initWithjumpToOtherWayVC:(DealUserAlertOtherWayVCDisMiss)disMisssBlock{
    if (self = [super init]) {
        self.block = disMisssBlock;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 设置代理
    [HMKeyboardShowHiddenNotificationCenter defineCenter].delegate = self;
    
    // 设置元素控件
    [self configElements];
}

#pragma mark - Interface Method

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    
    [self.view addSubview:self.dealView];
    [self.dealView addSubview:self.cancelBtn];
    [self.dealView addSubview:self.promptLabel];
    [self.dealView addSubview:self.txtView];
    [self.dealView addSubview:self.submitBtn];
    
    [self.dealView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(@240);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.dealView).offset(12);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dealView.mas_right).offset(-12);
        make.center.equalTo(self.promptLabel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dealView).offset(12);
        make.right.equalTo(self.dealView).offset(-12);
        make.top.equalTo(self.promptLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.dealView).offset(-65);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.txtView);
        make.top.equalTo(self.txtView.mas_bottom).offset(10);
        make.height.mas_equalTo(@45);
    }];
}

#pragma mark - Event Response

- (void)cancelBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitBtnClick{
    if(![_txtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        [self at_postError:@"请输入处理意见"];
        return;
    }
    if (self.block) {
        self.block(_txtView.text);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegate
#pragma mark -- textViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    //字数限制操作
    if (textView.text.length > 20) {
        textView.text = [textView.text substringToIndex:20];
        [self at_postError:@"最多输入20个字"];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - LMJKeyboardShowHiddenNotificationCenter Delegate

- (void)showOrHiddenKeyboardWithHeight:(CGFloat)height withDuration:(CGFloat)animationDuration isShow:(BOOL)isShow{
    
    if (isShow) {
        [UIView animateWithDuration:animationDuration animations:^{
            
            
            CGFloat offsetHeight = self.view.height - 32 - (height + self.dealView.bottom);
            
            if (offsetHeight > 0) {
                
                offsetHeight = 0;
            }
            //将视图的Y坐标向上移动
            self.view.frame = CGRectMake(0, offsetHeight, self.view.width, self.view.height);
        }];
    }
    else{
        [UIView animateWithDuration:animationDuration animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        }];
        
    }
}
#pragma mark - Override

#pragma mark - Action

#pragma mark - Init
- (UIView *)dealView{
    if (!_dealView) {
        _dealView = [UIView new];
        [_dealView setBackgroundColor:[UIColor whiteColor]];
        [_dealView.layer setCornerRadius:5.0f];
        [_dealView.layer setMasksToBounds:YES];
    }
    return _dealView;
}

- (UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [UILabel new];
        _promptLabel.text = @"预警处理：其他方式";
        _promptLabel.textColor = [UIColor commonTextColor];
    }
    return _promptLabel;
}

- (PlaceholderTextView *)txtView{
    if (!_txtView) {
        _txtView = [[PlaceholderTextView alloc] init];
        [_txtView setPlaceholder:@"请输入处理意见（20字以内）"];
        [_txtView.layer setBorderWidth:1.0f];
        [_txtView.layer setBorderColor:[UIColor commonControlBorderColor].CGColor];
        [_txtView setReturnKeyType:UIReturnKeyDone];
        [_txtView setDelegate:self];
    }
    return _txtView;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:[UIColor mainThemeColor]];
        [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setImage:[UIImage imageNamed:@"X_gray"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
