//
//  BodyWeightRecordsTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyWeightRecordsTableViewController.h"
#import "BodyWeightDetectRecordTableViewCell.h"

@interface BodyWeightRecordsStartViewController ()
{
    BodyWeightRecordsTableViewController* tvcRecords;
}
@end

@implementation BodyWeightRecordsStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"体重"];
    
    NSString* userIdStr = nil;
    if (self.paramObject && [self.paramObject isKindOfClass:[UserInfo class]])
    {
        UserInfo* userInfo = (UserInfo*)self.paramObject;
        userIdStr = [NSString stringWithFormat:@"%ld", userInfo.userId];
        
    }
    
    if (userIdStr)
    {
        tvcRecords = [[BodyWeightRecordsTableViewController alloc]initWithUserId:userIdStr];
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

@interface BodyWeightRecordsTableViewController ()
{
    NSInteger subType;
}
@end


@implementation BodyWeightRecordsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    recordItems = [NSMutableArray array];
    //TODO:体重、BMI选择器 webview
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"体重",@"BMI", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    [self.view addSubview:segmentedControl];
    segmentedControl.tintColor = [UIColor mainThemeColor];
    [segmentedControl.layer setCornerRadius:12.0f];
    [segmentedControl.layer setMasksToBounds:YES];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl.layer setBorderColor:[[UIColor mainThemeColor] CGColor]];
    [segmentedControl.layer setBorderWidth:1.0f];
    [segmentedControl addTarget:self action:@selector(reloadChart:) forControlEvents:UIControlEventValueChanged];
    
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(webview).with.offset(-20);
        make.top.equalTo(webview).with.offset(4);
        make.size.mas_equalTo(CGSizeMake(65, 25));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadChart:(UISegmentedControl *)seg
{
    subType = seg.selectedSegmentIndex;
    
    NSString* chartUrl = [self chartWebUrl];
    if (chartUrl)
    {
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:chartUrl]]];
    }
}

- (NSString*) chartWebUrl
{
//    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&kpiCode=%@&userId=%@&dateType=%ld&islegend=1", kZJKHealthDataBaseUrl ,@"TZ", userId, _timetype];
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&userId=%@&dateType=2&kpiCode=TZ&islegend=1", kZJKHealthDataBaseUrl , userId];
    switch (subType)
    {
        case 0:
        {
            url = [url stringByAppendingString:@"&childKpiCode=TZ_SUB"];
        }
            break;
        case 1:
        {
            url = [url stringByAppendingString:@"&childKpiCode=TZ_BMI"];
        }
            break;
        default:
            break;
    }
    return url;
}

- (NSString*) detectRecordTaskName
{
    return @"BodyWeightRecordsTask";
}

#pragma mark - Table view data source



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BodyWeightDetectRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BodyWeightDetectRecordTableViewCell"];
    cell = [[BodyWeightDetectRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BodyWeightDetectRecordTableViewCell"];
    // Configure the cell...
    
    BodyWeightDetectRecord* record = recordItems[indexPath.row];
    [cell setDetectRecord:record];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BodyWeightResultContentViewController
    BodyWeightDetectRecord* record = recordItems[indexPath.row];
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyWeightResultContentViewController" ControllerObject:record];
}

@end
