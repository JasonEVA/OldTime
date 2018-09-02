//
//  BodyTemperatureDetectsRecordsStartViewController.m
//  HMDoctor
//
//  Created by yinquan on 17/4/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "BodyTemperatureDetectsRecordsStartViewController.h"
#import "BodyTemperatureDetectRecord.h"
#import "BodyTemperatureRecordTableViewCell.h"

@interface BodyTemperatureDetectsRecordsStartViewController ()
{
    BodyTemperatureDetectsRecordsTableViewController* recordsTableViewController;
}
@end

@implementation BodyTemperatureDetectsRecordsStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"体温"];
    
    NSString* userIdStr = nil;
    NSInteger userId = 0;
    if (self.paramObject && [self.paramObject isKindOfClass:[UserInfo class]])
    {
        UserInfo* user = (UserInfo*)self.paramObject;
        userIdStr = [NSString stringWithFormat:@"%ld", user.userId];
        userId = user.userId;
    }
    
    if (userIdStr)
    {
        recordsTableViewController = [[BodyTemperatureDetectsRecordsTableViewController alloc]initWithUserId:userIdStr];
        [self addChildViewController:recordsTableViewController];
        [recordsTableViewController.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
        [self.view addSubview:recordsTableViewController.tableView];
        
    }
    
    
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [recordsTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


@end

@interface BodyTemperatureDetectsRecordsTableViewController ()

@end

@implementation BodyTemperatureDetectsRecordsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) chartWebUrl
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&kpiCode=%@&userId=%@&dateType=2", kZJKHealthDataBaseUrl ,@"TEM", userId];
    return url;
}

- (NSString*) detectRecordTaskName
{
    return @"BodyTemperatureRecordsTask";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BodyTemperatureRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BodyTemperatureRecordTableViewCell"];
    cell = [[BodyTemperatureRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BodyTemperatureRecordTableViewCell"];
    // Configure the cell...
    
    BodyTemperatureDetectRecord* record = recordItems[indexPath.row];
    [cell setDetectRecord:record];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到体温监测结果页面
    BodyTemperatureDetectRecord* record = recordItems[indexPath.row];
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyTemperatureDetectResultViewController" ControllerObject:record];
}
@end
