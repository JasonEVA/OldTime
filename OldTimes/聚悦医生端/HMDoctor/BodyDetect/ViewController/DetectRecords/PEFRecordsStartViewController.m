//
//  PEFRecordsStartViewController.m
//  HMClient
//
//  Created by lkl on 2017/6/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PEFRecordsStartViewController.h"
#import "PEFDetectRecordTableViewCell.h"
#import "PEFDetectRecord.h"

@interface PEFRecordsStartViewController ()
{
    PEFDetectsRecordsTableViewController* recordsTableViewController;
}
@end

@implementation PEFRecordsStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"峰流速值"];
    
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
        recordsTableViewController = [[PEFDetectsRecordsTableViewController alloc]initWithUserId:userIdStr];
        [self addChildViewController:recordsTableViewController];
        [recordsTableViewController.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
        [self.view addSubview:recordsTableViewController.tableView];
        
    }
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    if (curUser.userId != userId)
    {
        return;
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


@interface PEFDetectsRecordsTableViewController ()

@end

@implementation PEFDetectsRecordsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSString*) detectRecordTaskName
{
    return @"PEFRecordsTask";
}

- (NSString*) chartWebUrl
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&kpiCode=%@&userId=%@&dateType=2", kZJKHealthDataBaseUrl ,@"FLSZ", userId];
    return url;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PEFDetectRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PEFDetectRecordTableViewCell"];
    
    if (!cell) {
        cell = [[PEFDetectRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PEFDetectRecordTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    PEFDetectRecord *record = recordItems[indexPath.row];
    [cell setDetectRecord:record];
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PEFDetectRecord *record = recordItems[indexPath.row];
    [HMViewControllerManager createViewControllerWithControllerName:@"PEFResultContentViewController" ControllerObject:record];
}


@end
