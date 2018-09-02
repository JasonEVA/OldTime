//
//  BloodOxygenationRecordTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodOxygenationRecordTableViewController.h"
#import "BloodOxygenationRecordTableViewCell.h"
#import "ClientHelper.h"

@interface BloodOxygenationRecordStartViewController ()
{
    BloodOxygenationRecordTableViewController* tvcRecords;
}
@end

@implementation BloodOxygenationRecordStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"血氧"];
    
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
        tvcRecords = [[BloodOxygenationRecordTableViewController alloc]initWithUserId:userIdStr];
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

@interface BloodOxygenationRecordTableViewController ()

@end

@implementation BloodOxygenationRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) chartWebUrl
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&kpiCode=%@&userId=%@&dateType=2", kZJKHealthDataBaseUrl ,@"OXY", userId];
    return url;
}

- (NSString*) detectRecordTaskName
{
    return @"BloodOxygenationRecordsTask";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BloodOxygenationRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BloodOxygenationRecordTableViewCell"];
    cell = [[BloodOxygenationRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BloodOxygenationRecordTableViewCell"];
    // Configure the cell...
    
    BloodOxygenationRecord* record = recordItems[indexPath.row];
    [cell setDetectRecord:record];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BodyWeightResultContentViewController
    BloodOxygenationRecord* record = recordItems[indexPath.row];
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenResultContentViewController" ControllerObject:record];
}

@end
