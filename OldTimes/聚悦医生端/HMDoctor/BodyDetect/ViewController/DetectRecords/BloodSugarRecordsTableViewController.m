//
//  BloodSugarRecordsTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodSugarRecordsTableViewController.h"
#import "BloodSugarDetectRecordTableViewCell.h"

@interface BloodSugarRecordsStartViewController ()
{
    BloodSugarRecordsTableViewController* tvcRecords;
}
@end

@implementation BloodSugarRecordsStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"血糖"];
    
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
        tvcRecords = [[BloodSugarRecordsTableViewController alloc]initWithUserId:userIdStr];
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

@interface BloodSugarRecordsTableViewController ()

@end

@implementation BloodSugarRecordsTableViewController

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
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&kpiCode=%@&userId=%@&dateType=2", kZJKHealthDataBaseUrl ,@"XT", userId];
    return url;
}

- (NSString*) detectRecordTaskName
{
    return @"BloodSugarRecordsTask";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BloodSugarDetectRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BloodSugarDetectRecordTableViewCell"];
    cell = [[BloodSugarDetectRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BloodSugarDetectRecordTableViewCell"];
    // Configure the cell...
    
    BloodSugarDetectRecord* record = recordItems[indexPath.row];
    [cell setDetectRecord:record];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BloodSugarDetectRecord* record = recordItems[indexPath.row];
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarDetectResultViewController" ControllerObject:record];
}
@end
