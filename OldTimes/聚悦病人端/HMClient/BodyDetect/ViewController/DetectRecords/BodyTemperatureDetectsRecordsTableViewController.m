//
//  BodyTemperatureDetectsRecordsTableViewController.m
//  HMClient
//
//  Created by yinquan on 17/4/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BodyTemperatureDetectsRecordsTableViewController.h"
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
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    if (curUser.userId != userId)
    {
        return;
    }
    
    NSString* btiTitle = @"添加数据";
    CGFloat titleWidth = [btiTitle widthSystemFont:[UIFont font_30]];
    UIButton* appendbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleWidth, 25)];
    [appendbutton setTitle:@"添加数据" forState:UIControlStateNormal];
    [appendbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appendbutton.titleLabel setFont:[UIFont font_30]];
    [appendbutton addTarget:self action:@selector(appendBbiClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiAppend = [[UIBarButtonItem alloc]initWithCustomView:appendbutton];
    [bbiAppend setTintColor:[UIColor whiteColor]];
    
    [self.navigationItem setRightBarButtonItem:bbiAppend];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [recordsTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void) appendBbiClicked:(id) sender
{
    //BodyPressureDetectStartViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyTemperatureDetectStartViewController" ControllerObject:nil];
}

@end

@interface BodyTemperatureDetectsRecordsTableViewController ()

@end

@implementation BodyTemperatureDetectsRecordsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) chartWebUrl
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YH&kpiCode=%@&userId=%@&dateType=2", kZJKHealthDataBaseUrl ,@"TEM", userId];
    return url;
}

- (NSString*) detectRecordTaskName
{
    return @"BodyTemperatureRecordsTask";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    //跳转到呼吸监测结果页面
    BodyTemperatureDetectRecord* record = recordItems[indexPath.row];
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyTemperatureDetectResultViewController" ControllerObject:record];
}




@end
