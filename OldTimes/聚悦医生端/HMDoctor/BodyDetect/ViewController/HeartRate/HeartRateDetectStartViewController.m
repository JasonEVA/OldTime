//
//  HeartRateDetectStartViewController.m
//  HMClient
//
//  Created by lkl on 2017/7/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HeartRateDetectStartViewController.h"

@interface HeartRateDetectStartViewController ()

@end

@implementation HeartRateDetectStartViewController

- (void)viewDidLoad {
    [self setAllowInputType:DetectInput_Manual];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"测心率"];
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"历史记录" style:UIBarButtonItemStylePlain target:self action:@selector(entryRecordHistoryViewController:)];
//    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (NSString*) manualInputClassName
{
    return @"HeartRateManualInputViewController";
}

//- (void)entryRecordHistoryViewController:(id) sender
//{
//    [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenationRecordStartViewController" ControllerObject:self.userId];
//}

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
