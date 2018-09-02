//
//  HealthPlanDefaultViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthPlanDefaultViewController.h"

@interface HealthPlanDefaultViewController ()
{
    UILabel* lbDefault;
}
@end

@implementation HealthPlanDefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view  setBackgroundColor:[UIColor commonBackgroundColor]];
    lbDefault = [[UILabel alloc]init];
    [self.view addSubview:lbDefault];
    [lbDefault setTextColor:[UIColor commonGrayTextColor]];
    [lbDefault setFont:[UIFont systemFontOfSize:21]];
    
    [lbDefault mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(87);
    }];
    
    [lbDefault setText:@"建设中，敬请期待"];
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
