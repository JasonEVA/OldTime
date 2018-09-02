//
//  ECGDetectRecordTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ECGDetectRecordTableViewController.h"
#import "HeartRateDetectRecordTableViewCell.h"
#import "ClientHelper.h"


@interface ECGDetectRecordStartViewController ()
{
    ECGDetectRecordTableViewController* tvcRecords;
}
@end

@implementation ECGDetectRecordStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"心率"];
    
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
        tvcRecords = [[ECGDetectRecordTableViewController alloc]initWithUserId:userIdStr];
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

@interface ECGDetectRecordTableViewController ()

@end

@implementation ECGDetectRecordTableViewController

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
- (NSString*) chartWebUrl
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&kpiCode=%@&userId=%@&dateType=2", kZJKHealthDataBaseUrl ,@"XL", userId];
    return url;
}

- (NSString*) detectRecordTaskName
{
    return @"HeartRateRecordsTask";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HeartRateDetectRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeartRateDetectRecordTableViewCell"];
    cell = [[HeartRateDetectRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeartRateDetectRecordTableViewCell"];
    // Configure the cell...
    
    HeartRateDetectRecord* record = recordItems[indexPath.row];
    [cell setDetectRecord:record];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HeartRateDetectRecord* record = recordItems[indexPath.row];
    HeartRateDetectRecord* xyrecord = [[HeartRateDetectRecord alloc]init];
    
    if (!kStringIsEmpty(record.sourceKpiCode) && [record.sourceKpiCode isEqualToString:@"XY"]){
        
        [xyrecord setKpiCode:@"XY"];
        [xyrecord setTestDataId:record.sourceTestDataId];
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:xyrecord];
    }
    else if (!kStringIsEmpty(record.sourceKpiCode) && [record.sourceKpiCode isEqualToString:@"XD"]){
        [xyrecord setKpiCode:@"XD"];
        [xyrecord setTestDataId:record.sourceTestDataId];
        [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:xyrecord];
    }
    else{
        [xyrecord setKpiCode:@"XL"];
        [xyrecord setTestDataId:record.testDataId];
        [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:xyrecord];
    }
}

@end
