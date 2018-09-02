//
//  BloodFatDetectRecordsViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodFatDetectRecordsTableViewController.h"
#import "BloodFatRecordHeaderView.h"
#import "BloodFatRecordTableViewCell.h"

@interface BloodFatDetectRecordsStartViewController ()
{
    BloodFatDetectRecordsTableViewController* tvcRecords;
}
@end

@implementation BloodFatDetectRecordsStartViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"血脂"];
    
    NSString* userIdStr = nil;
    if (self.paramObject && [self.paramObject isKindOfClass:[UserInfo class]])
    {
        UserInfo* userInfo = (UserInfo*)self.paramObject;
        userIdStr = [NSString stringWithFormat:@"%ld", userInfo.userId];
        
    }
    
    if (userIdStr)
    {
        tvcRecords = [[BloodFatDetectRecordsTableViewController alloc]initWithUserId:userIdStr];
        [self addChildViewController:tvcRecords];
        [tvcRecords.tableView setBackgroundColor:[UIColor whiteColor]];
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

@interface BloodFatDetectRecordsTableViewController ()

@end

@implementation BloodFatDetectRecordsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) chartWebUrl
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&kpiCode=%@&userId=%@&dateType=2", kZJKHealthDataBaseUrl ,@"XZ", userId];
    return url;
}

- (NSString*) detectRecordTaskName
{
    return @"BloodFatRecordsTask";
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 30)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    
    UIView* headercontentview = [[BloodFatRecordHeaderView alloc]initWithFrame:CGRectMake(12.5, 0, headerview.width - 25, 30)];
    [headerview addSubview:headercontentview];
        
    return headerview;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
    [footerview setBackgroundColor:[UIColor whiteColor]];
    return footerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BloodFatRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BloodFatRecordTableViewCell"];
    cell = [[BloodFatRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BloodFatRecordTableViewCell"];
    // Configure the cell...
    
    BloodFatRecord* record = recordItems[indexPath.row];
    [cell setDetectRecord:record];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BloodFatRecord* record = recordItems[indexPath.row];
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodFatDetectResultViewController" ControllerObject:record];
}

@end
