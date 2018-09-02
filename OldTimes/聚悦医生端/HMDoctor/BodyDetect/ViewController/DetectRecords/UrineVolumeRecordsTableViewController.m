//
//  UrineVolumeRecordsTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UrineVolumeRecordsTableViewController.h"
#import "UrineVolumeRecordTableViewCell.h"

@interface UrineVolumeRecordsStartViewController ()
{
    UrineVolumeRecordsTableViewController* tvcRecords;
}
@end

@implementation UrineVolumeRecordsStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"尿量"];
    
    NSString* userIdStr = nil;
    if (self.paramObject && [self.paramObject isKindOfClass:[UserInfo class]])
    {
        UserInfo* userInfo = (UserInfo*)self.paramObject;
        userIdStr = [NSString stringWithFormat:@"%ld", userInfo.userId];
        
    }
    
    if (userIdStr)
    {
        tvcRecords = [[UrineVolumeRecordsTableViewController alloc]initWithUserId:userIdStr];
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

@interface UrineVolumeRecordsTableViewController ()

@end

@implementation UrineVolumeRecordsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (NSString*) chartWebUrl
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&kpiCode=%@&userId=%@&dateType=2", kZJKHealthDataBaseUrl ,@"NL", userId];
    return url;
}

- (NSString*) detectRecordTaskName
{
    return @"UrineVolumeRecordsTask";
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UrineVolumeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UrineVolumeRecordTableViewCell"];
    cell = [[UrineVolumeRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UrineVolumeRecordTableViewCell"];
    // Configure the cell...
    
    UrineVolumeRecord* record = recordItems[indexPath.row];
    [cell setDetectRecord:record];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}




@end
