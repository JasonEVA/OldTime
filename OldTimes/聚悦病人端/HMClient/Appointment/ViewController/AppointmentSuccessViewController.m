//
//  AppointmentSuccessViewController.m
//  HMClient
//  约诊成功界面
//  Created by yinquan on 2017/10/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "AppointmentSuccessViewController.h"
#import "AppointStaffModel.h"

@interface AppointmentSuccessViewController ()

@property (nonatomic, readonly) AppointStaffModel* appointStaffModel;

@property (nonatomic, strong) UIImageView* successImageView;
@property (nonatomic, strong) UILabel* successLabel;
@property (nonatomic, strong) UILabel* noticeLabel;
@property (nonatomic, strong) UIButton* appointmentButton;
@end

@implementation AppointmentSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"约诊";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClicked:)];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[AppointStaffModel class]])
    {
        _appointStaffModel = (AppointStaffModel*) self.paramObject;
    }
    [self layoutElements];
    
    if (self.appointStaffModel) {
        [self.successLabel setText:[NSString stringWithFormat:@"成功约诊%@", self.appointStaffModel.staffName]];
    }
    
}

- (void) backBarButtonClicked:(id)sender
{
    [[HMViewControllerManager defaultManager] entryMainPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements{
    [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(170, 100));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
    }];
    
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.successImageView.mas_bottom).offset(18);
    }];
    
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).offset(-80);
        make.top.equalTo(self.successLabel.mas_bottom).offset(27);
        make.centerX.equalTo(self.view);
    }];
    
    [self.appointmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@46);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(-30);
        make.top.equalTo(self.noticeLabel.mas_bottom).offset(34);
    }];
}

- (void) appintmentButtonClicked:(id) sender
{
    //跳转到我的约诊列表
    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentListViewController" ControllerObject:nil];
}

#pragma mark - settingAndGetting
- (UIImageView*) successImageView
{
    if (!_successImageView) {
        _successImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pingan_paysuccess"]];
        [self.view addSubview:_successImageView];
    }
    return _successImageView;
}

- (UILabel*) successLabel{
    if (!_successLabel) {
        _successLabel = [[UILabel alloc] init];
        [self.view addSubview:_successLabel];
        [_successLabel setFont:[UIFont systemFontOfSize:19]];
        [_successLabel setTextColor:[UIColor mainThemeColor]];
    }
    return _successLabel;
}

- (UILabel*) noticeLabel{
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc] init];
        [self.view addSubview:_noticeLabel];
        [_noticeLabel setFont:[UIFont systemFontOfSize:13]];
        [_noticeLabel setTextColor:[UIColor commonDarkGrayTextColor]];
        [_noticeLabel setText:@"您好，您已成功预约，我们会即时通知您具体的问诊时间和地点，请耐心等候。"];
        [_noticeLabel setTextAlignment:NSTextAlignmentCenter];
        [_noticeLabel setNumberOfLines:2];
    }
    return _noticeLabel;
}

- (UIButton*) appointmentButton
{
    if (!_appointmentButton) {
        _appointmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_appointmentButton];
        [_appointmentButton setBackgroundImage:[UIImage rectImage:CGSizeMake(300, 49) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_appointmentButton setTitle:@"我的约诊" forState:UIControlStateNormal];
        [_appointmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_appointmentButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _appointmentButton.layer.cornerRadius = 5;
        _appointmentButton.layer.masksToBounds = YES;
        
        [_appointmentButton addTarget:self action:@selector(appintmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appointmentButton;
}
@end
