//
//  ECGDetectStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ECGDetectStartViewController.h"

@interface ECGDetectStartViewController ()

@end

@implementation ECGDetectStartViewController

- (void)viewDidLoad {
    self.allowInputType = DetectInput_Device;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"心电"];
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"历史记录" style:UIBarButtonItemStylePlain target:self action:@selector(entryRecordHistoryViewController:)];
//    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (NSString *)deviceInputClassName
{
    return @"HellofitECGViewController";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)entryRecordHistoryViewController:(id)sender
//{
//    [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectRecordStartViewController" ControllerObject:self.userId];
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
