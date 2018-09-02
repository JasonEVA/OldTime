//
//  BreathingRecordsTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BreathingRecordsTableViewController.h"
#import "BreathingRecordTableViewCell.h"

@interface BreathingRecordsStartViewController ()
{
    BreathingRecordsTableViewController* tvcRecords;
}
@end

@implementation BreathingRecordsStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"呼吸"];
    
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
        tvcRecords = [[BreathingRecordsTableViewController alloc]initWithUserId:userIdStr];
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
    [HMViewControllerManager createViewControllerWithControllerName:@"BreathingDetectStartViewController" ControllerObject:nil];
}

@end


@interface BreathingRecordsTableViewController ()

@end

@implementation BreathingRecordsTableViewController

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
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YH&kpiCode=%@&userId=%@&dateType=2", kZJKHealthDataBaseUrl ,@"HX", userId];
    return url;
}

- (NSString*) detectRecordTaskName
{
    return @"BreathingRecordsTask";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BreathingRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BreathingRecordTableViewCell"];
    cell = [[BreathingRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BreathingRecordTableViewCell"];
    // Configure the cell...
    
    BreathingDetctRecord* record = recordItems[indexPath.row];
    [cell setDetectRecord:record];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到呼吸监测结果页面
    BreathingDetctRecord* record = recordItems[indexPath.row];
    [HMViewControllerManager createViewControllerWithControllerName:@"BreathingDetectResultViewController" ControllerObject:record];
}

@end
