//
//  ATLoginController.m
//  Clock
//
//  Created by Dariel on 16/7/22.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATLoginController.h"
#import <Masonry.h>
#import "ATClockViewController.h"
#import <MBProgressHUD.h>

#import "UIColor+ATHex.h"

@interface ATLoginController ()

@property (nonatomic, strong) UITextField *inputField;

@end

@implementation ATLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"设置用户ID";
    titleLabel.textColor = [UIColor redColor];
    [self.view addSubview:titleLabel];
    [titleLabel sizeToFit];
    
    
    UITextField *inputField = [[UITextField alloc] init];
    self.inputField = inputField;
    inputField.placeholder = @"填写用户ID";
    [self.view addSubview:inputField];
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"提交完成后不能更改!请仔细检查!注意不能有空格!参照格式: Dariel Simon";
    [self.view addSubview:descLabel];
    descLabel.textColor = [UIColor redColor];
    descLabel.numberOfLines = 0;
    
    
    
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setTitle:@"登录" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor at_blueColor]];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 6;
    sureBtn.layer.masksToBounds = YES;
    [self.view addSubview:sureBtn];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
    }];
    
    
    [inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(titleLabel.mas_bottom).offset(40);
        make.width.equalTo(@240);

    }];
    
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(inputField.mas_bottom).offset(20);
        make.width.equalTo(@240);
        make.height.equalTo(@100);
    }];
    
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.view);
        make.top.equalTo(descLabel.mas_bottom).offset(20);

    }];
}


- (void)sureBtnClick {
    
    if (![self.inputField.text isEqual: @""]) {
        
        ATClockViewController *clockVC = [[ATClockViewController alloc] init];
        clockVC.userId = self.inputField.text;
        clockVC.orgId = @"mintcode";
        [self.navigationController pushViewController:clockVC animated:YES];
        
    }else {
    
        NSLog(@"输入不能为空");
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.inputField endEditing:YES];
}




@end
