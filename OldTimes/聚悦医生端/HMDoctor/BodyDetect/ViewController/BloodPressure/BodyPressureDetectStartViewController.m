//
//  BodyPressureDetectStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyPressureDetectStartViewController.h"

@interface BodyPressureDetectStartViewController ()

@end

@implementation BodyPressureDetectStartViewController

- (void)viewDidLoad {
    [self setAllowInputType:(DetectInput_Device|DetectInput_Manual)];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"血压"];
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"历史记录" style:UIBarButtonItemStylePlain target:self action:@selector(entryRecordHistoryViewController:)];
//    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (NSString*) deviceInputClassName
{
    return @"BloodPressureDetectViewController";
}

- (NSString*) manualInputClassName
{
    return @"BloodPressureManualInputViewController";
}

//- (void)entryRecordHistoryViewController:(id) sender
//{
//    [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureRecordStartViewController" ControllerObject:self.userId];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end



