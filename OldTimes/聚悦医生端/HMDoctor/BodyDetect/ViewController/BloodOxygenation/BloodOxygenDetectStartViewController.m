//
//  BloodOxygenDetectStartViewController.m
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodOxygenDetectStartViewController.h"

@interface BloodOxygenDetectStartViewController ()

@end

@implementation BloodOxygenDetectStartViewController

- (void)viewDidLoad {
    [self setAllowInputType:DetectInput_Device|DetectInput_Manual];
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationItem setTitle:@"血氧"];
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"历史记录" style:UIBarButtonItemStylePlain target:self action:@selector(entryRecordHistoryViewController:)];
//    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (NSString*) deviceInputClassName
{
    return @"BloodOxgenDetectViewController";
}

- (NSString*) manualInputClassName
{
    return @"BloodOxgenManualInputViewController";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)entryRecordHistoryViewController:(id) sender
//{
//    [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenationRecordStartViewController" ControllerObject:self.userId];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
