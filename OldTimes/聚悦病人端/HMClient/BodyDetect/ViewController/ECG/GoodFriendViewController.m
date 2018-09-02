//
//  GoodFriendViewController.m
//  HMClient
//
//  Created by lkl on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "GoodFriendViewController.h"
#import "BloodPressureDeviceHomePageView.h"
#import "BluetoothDeviceControl.h"

@interface GoodFriendViewController ()
{
    BloodPressureDeviceHomePageView *homePageView;
    BluetoothDeviceControl *bleControl;
    UIButton *measureButton;
    UIImageView *deviceImg;
}
@end

@implementation GoodFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWithHomePage];
}

- (void)initWithHomePage
{
    homePageView = [[BloodPressureDeviceHomePageView alloc] init];
    [self.view addSubview:homePageView];
    [homePageView setDeviceImg:@"xinlv_shenti_body_2"];
    [homePageView.useGuideBtn addTarget:self action:@selector(useGuideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [homePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}

- (void)useGuideBtnClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"DeviceDetectGuidePageViewController" ControllerObject:@"XDY_HPY"];
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
