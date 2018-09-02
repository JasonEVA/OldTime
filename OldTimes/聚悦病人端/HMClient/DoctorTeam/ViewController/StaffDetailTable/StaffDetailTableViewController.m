//
//  StaffDetailTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "StaffDetailTableViewController.h"

@interface StaffDetailTableViewController ()

@end

@implementation StaffDetailTableViewController

- (id) initWithStaffInfo:(StaffInfo*) staffinfo
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        staff = staffinfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
