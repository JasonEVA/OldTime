//
//  BrithdayIntegralViewController.m
//  HMClient
//
//  Created by yinquan on 2017/7/20.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BrithdayIntegralViewController.h"
#import "AppDelegate.h"

@interface BrithdayIntegralViewController ()

@property (nonatomic, strong) UIView* hubView;
@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) UIImageView* integralcakeImageView;// integral_cake;

@property (nonatomic, strong) UILabel* companyLabel; //聚悦健康祝您
@property (nonatomic, strong) UILabel* happyLabel;  //生日快乐
@property (nonatomic, strong) UILabel* integralLabel;

@end

@implementation BrithdayIntegralViewController

+ (void) show
{
    BrithdayIntegralViewController* integralViewController = [[BrithdayIntegralViewController alloc] init];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [app.window addSubview:integralViewController.view];
    [integralViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];
    UIViewController* topmostViewController = [HMViewControllerManager topMostController] ;
    [topmostViewController addChildViewController:integralViewController];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self layoutElements];
    
    [self.closeButton addTarget:self action:@selector(closeController) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements
{
    [self.hubView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth -30, 200));
        make.center.equalTo(self.view);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self.hubView).offset(20);
        make.right.equalTo(self.hubView).offset(-20);
    }];
    
    [self.integralcakeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(217, 110));
        make.centerX.equalTo(self.hubView);
        make.centerY.equalTo(self.hubView.mas_top);
    }];
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hubView);
        make.top.equalTo(self.hubView).offset(73);
    }];
    
    [self.happyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hubView);
        make.top.equalTo(self.companyLabel.mas_bottom).offset(7.5);
    }];
    
    [self.integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hubView);
        make.top.equalTo(self.happyLabel.mas_bottom).offset(7.5);
    }];
}

- (void) closeController
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - settingAndGeting
- (UIView*) hubView
{
    if (!_hubView) {
        _hubView = [[UIView alloc] init];
        [self.view addSubview:_hubView];
        
        NSArray* colors = @[[UIColor colorWithHexString:@"FFD672"], [UIColor colorWithHexString:@"FC5F5F"]];
        UIImage* patternImage = [UIImage gradientColorImageFromColors:colors gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(400, 400)];
        UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:patternImage];
        [_hubView addSubview:backgroundImageView];
        
        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_hubView);
        }];
        
        
    }
    return _hubView;
}

- (UIButton*) closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.hubView addSubview:_closeButton];
        [_closeButton setImage:[UIImage imageNamed:@"close_button_icon"] forState:UIControlStateNormal];
        [_closeButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    }
    return _closeButton;
}

- (UIImageView*) integralcakeImageView
{
    if (!_integralcakeImageView) {
        _integralcakeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"integral_cake"]];
        [self.hubView addSubview:_integralcakeImageView];
    }
    return _integralcakeImageView;
    
}

- (UILabel*) companyLabel
{
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        [self.hubView addSubview:_companyLabel];
        
        [_companyLabel setFont:[UIFont systemFontOfSize:18]];
        [_companyLabel setTextColor:[UIColor whiteColor]];
        [_companyLabel setText:@"聚悦健康祝您"];
    }
    return _companyLabel;
}

- (UILabel*) happyLabel
{
    if (!_happyLabel) {
        _happyLabel = [[UILabel alloc] init];
        [self.hubView addSubview:_happyLabel];
        
        [_happyLabel setFont:[UIFont systemFontOfSize:32]];
        [_happyLabel setTextColor:[UIColor whiteColor]];
        [_happyLabel setText:@"生日快乐！"];
    }
    return _happyLabel;
}

- (UILabel*) integralLabel
{
    if (!_integralLabel) {
        _integralLabel = [[UILabel alloc] init];
        [self.hubView addSubview:_integralLabel];
        
        [_integralLabel setFont:[UIFont systemFontOfSize:18]];
        [_integralLabel setTextColor:[UIColor whiteColor]];
        [_integralLabel setText:@"+20积分"];
    }
    return _integralLabel;
}

@end
