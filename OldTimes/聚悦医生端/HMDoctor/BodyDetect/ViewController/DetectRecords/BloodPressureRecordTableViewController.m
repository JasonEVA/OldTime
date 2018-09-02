//
//  BloodPressureRecordTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureRecordTableViewController.h"
#import "BloodPressureDetectRecordTableViewCell.h"

@interface BloodPressureRecordStartViewController ()
{
    BloodPressureRecordTableViewController* tvcRecords;

}
@end

@implementation BloodPressureRecordStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"血压"];
    
    NSString* userIdStr = nil;
    if (self.paramObject && [self.paramObject isKindOfClass:[UserInfo class]])
    {
        UserInfo* userInfo = (UserInfo*)self.paramObject;
        userIdStr = [NSString stringWithFormat:@"%ld", userInfo.userId];
        
    }
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]]) {
        userIdStr = (NSString *)self.paramObject;
    }
    
    if (userIdStr)
    {
        tvcRecords = [[BloodPressureRecordTableViewController alloc]initWithUserId:userIdStr];
        [self addChildViewController:tvcRecords];
        [tvcRecords.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
        [self.view addSubview:tvcRecords.tableView];
        [self subviewLayout];
    }

}

- (void) subviewLayout
{
    [tvcRecords.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.top.and.left.equalTo(self.view);
    }];
}

@end



@interface BloodPressureRecordTableViewController ()
<TaskObserver>
{
    //NSMutableArray* recordItems;

}
@end

@implementation BloodPressureRecordTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    recordItems = [NSMutableArray array];
    //测试数据
    
    //[self  detectRecordsLoaded:items];
}

- (NSString*) chartWebUrl
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&kpiCode=%@&userId=%@&dateType=2", kZJKHealthDataBaseUrl ,@"XY", userId];
    return url;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) detectRecordTaskName
{
    return @"BloodPressureRecordsTask";
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BloodPressureDetectRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BloodPressureDetectRecordTableViewCell"];
    cell = [[BloodPressureDetectRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BloodPressureDetectRecordTableViewCell"];
    // Configure the cell...
    
    BloodPressureDetectRecord* record = recordItems[indexPath.row];
    [cell setDetectRecord:record];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BloodPressureResultContentViewController
    BloodPressureDetectRecord* record = recordItems[indexPath.row];
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:record];
}
@end
