//
//  HospitalizationHistoryTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HospitalizationHistoryTableViewController.h"

@interface HospitalizationHistoryTableViewController ()

@end

@implementation HospitalizationHistoryTableViewController

- (id) initWithUserId:(NSString*) aUserId
{
    self = [super initWithUserId:aUserId];
    if (self)
    {
        type = 2;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
