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
    NSInteger userId;
    if (self.paramObject && [self.paramObject isKindOfClass:[UserInfo class]])
    {
        UserInfo* user = (UserInfo*)self.paramObject;
        userIdStr = [NSString stringWithFormat:@"%ld", user.userId];
        userId = user.userId;
    }
    if (userIdStr)
    {
        tvcRecords = [[BloodSugarRecordsTableViewController alloc]initWithUserId:userIdStr];
        [self addChildViewController:tvcRecords];
        [tvcRecords.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
        [self.view addSubview:tvcRecords.tableView];
        [self subviewLayout];
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

- (void) subviewLayout
{
    [tvcRecords.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.top.and.left.equalTo(self.view);
    }];
}

- (void) appendBbiClicked:(id) sender
{
    //BodyPressureDetectStartViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarDetectStartViewController" ControllerObject:nil];
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
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YH&kpiCode=%@&userId=%@&dateType=2", kZJKHealthDataBaseUrl ,@"XT", userId];
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
