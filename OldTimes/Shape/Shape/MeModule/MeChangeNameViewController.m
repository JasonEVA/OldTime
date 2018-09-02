//
//  MeChangeNameViewController.m
//  Shape
//
//  Created by jasonwang on 15/10/21.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeChangeNameViewController.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "MeChangeUserNameRequest.h"

typedef NS_ENUM(NSInteger,buttonTag){
    cancelTag,
    saveTag
};

@interface MeChangeNameViewController ()<BaseRequestDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *leftView;


@end

@implementation MeChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"更改用户名"];
    [self.textField setText:self.nameStr];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick:)];
    [saveBtn setTag:saveTag];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick:)];
    [cancelBtn setTag:cancelTag];
    [self.navigationItem setRightBarButtonItem:saveBtn];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    [self.view addSubview:self.textField];
    
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.textField becomeFirstResponder];
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method


#pragma mark - event Response
- (void)saveBtnClick:(UIBarButtonItem *)button
{
    if (button.tag == saveTag) {
        NSLog(@"点击保存了");
        MeChangeUserNameRequest *request = [[MeChangeUserNameRequest alloc]init];
        //请求
        request.userName = self.textField.text;
        [request requestWithDelegate:self];
        
        if ([self.delegate respondsToSelector:@selector(MeChangeNameDelegateCallBack_update:)]) {
            [self.delegate MeChangeNameDelegateCallBack_update:self.textField.text];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - initComponent

#pragma mark - updateViewConstraints

#pragma mark - init UI

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        [_textField setTextColor:[UIColor whiteColor]];
        [_textField setBackgroundColor:[UIColor themeBackground_373737]];
        [_textField setLeftView:self.leftView];
        [_textField setLeftViewMode:UITextFieldViewModeAlways];

    }
    return _textField;
}




- (UIView *)leftView
{
    if (!_leftView) {
        _leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 1)];
    }
    return _leftView;
}


#pragma mark - request Delegate

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self postSuccess:response.message];
    NSLog(@"请求成功");
}

-(void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self postError:response.message];
    NSLog(@"请求失败");
}
@end
