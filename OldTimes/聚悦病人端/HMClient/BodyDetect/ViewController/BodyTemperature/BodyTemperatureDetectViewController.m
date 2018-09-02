//
//  BodyTemperatureDetectViewController.m
//  HMClient
//
//  Created by yinquan on 17/4/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BodyTemperatureDetectViewController.h"
#import "FSRKTemperatureDetectViewController.h"

@interface BodyTemperatureDetectViewController ()
{
    UIViewController* deviceDetectViewController;
}
@end

@implementation BodyTemperatureDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self getDeviceObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getDeviceObject
{
    if (YES)
    {
        deviceDetectViewController = [[FSRKTemperatureDetectViewController alloc] init];
        [self addChildViewController:deviceDetectViewController];
        [self.view addSubview:deviceDetectViewController.view];
        [deviceDetectViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
            
        }];
    }
}



@end
