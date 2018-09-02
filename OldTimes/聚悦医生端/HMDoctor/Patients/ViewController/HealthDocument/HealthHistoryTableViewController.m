//
//  HealthHistoryTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthHistoryTableViewController.h"
#import "HealthHistoryItem.h"
#import "HealthHistoryHeaderView.h"
#import "HealthHistoryRecordTableViewCell.h"

@interface HealthHistorySection : NSObject
{
    
}
@property (nonatomic, readonly) NSMutableArray* historyItems;
@property (nonatomic, assign) BOOL isExpended;
@end

@implementation HealthHistorySection

- (id) init
{
    self = [super init];
    if (self)
    {
        _historyItems = [NSMutableArray array];
    }
    return self;
}

@end

@interface HealthHistoryTableViewController ()
<TaskObserver>
{
    NSMutableDictionary* dicSections;
}
@end

@implementation HealthHistoryTableViewController

- (id) initWithUserId:(NSString*) aUserId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        userId = aUserId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self p_requestData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDataWithUserID:(NSString *)userID {
    userId = userID;
    [self p_requestData];
}

- (void)p_requestData {
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:userId forKey:@"userId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", type] forKey:@"type"];
    
    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthHistoryListTask" taskParam:dicPost TaskObserver:self];
}

- (void) historyItemsLoaded:(NSArray*) items
{
    dicSections = [NSMutableDictionary dictionary];
    if (!items || 0 == items.count)
    {
        [self showBlankView];
        return;
    }
    
    [self closeBlankView];
    for (HealthHistoryItem* item in items)
    {
        NSString* yearStr = [item yearStr];
        if (!yearStr) {
            continue;
        }
        HealthHistorySection* historySection = [dicSections valueForKey:yearStr];
        if (!historySection)
        {
            historySection = [[HealthHistorySection alloc]init];
            [dicSections setValue:historySection forKey:yearStr];
        }
    
        [historySection.historyItems addObject:item];
    }
    
    NSArray* sectons = [self sectionList];
    if (sectons && 0 < sectons.count)
    {
        NSString* yearStr = [sectons firstObject];
        HealthHistorySection* historySection = [dicSections valueForKey:yearStr];
        [historySection setIsExpended:YES];
    }
    
    [self.tableView reloadData];
}

- (NSArray*) sectionList
{
    if (!dicSections)
    {
        return nil;
    }
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray* keys = [dicSections allKeys];
    NSArray* sections = [keys sortedArrayUsingComparator:cmptr];
    
    return sections;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (dicSections)
    {
        NSArray* keys = [dicSections allKeys];
        return keys.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dicSections)
    {
        NSArray* sections = [self sectionList];
        NSString* yearStr = sections[section];
        
        HealthHistorySection* historySection = [dicSections valueForKey:yearStr];
        if (!historySection.isExpended) {
            return 0;
        }
        
        if (historySection.historyItems)
        {
            return historySection.historyItems.count;
        }
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray* sections = [self sectionList];
    NSString* sectionname = sections[section];
    
    HealthHistorySection* historySection = [dicSections valueForKey:sectionname];
    
    HealthHistoryHeaderView* headerview = [[HealthHistoryHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 37)];
    [headerview setYearStr:sectionname];
    [headerview setTag:section + 0x1400];
    
    [headerview addTarget:self action:@selector(yearSectionHeaderViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerview setIsExtended:historySection.isExpended];
    
    return headerview;
}

- (void) yearSectionHeaderViewClicked:(id) sender
{
    if (![sender isKindOfClass:[HealthHistoryHeaderView class]])
    {
        return;
    }
    HealthHistoryHeaderView* headerview = (HealthHistoryHeaderView*)sender;
    NSInteger section = headerview.tag - 0x1400;
    NSArray* sections = [self sectionList];
    if (0 > section || section >= sections.count)
    {
        return;
    }
    NSString* sectionname = sections[section];
    
    HealthHistorySection* historySection = [dicSections valueForKey:sectionname];
    historySection.isExpended = !historySection.isExpended;
    
    [self.tableView reloadData];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (NSString*) cellClassName
{
    return @"HealthHistoryRecordTableViewCell";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellName = [self cellClassName];
    HealthHistoryRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[NSClassFromString(cellName) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    // Configure the cell...
    NSArray* sections = [self sectionList];
    NSString* sectionname = sections[indexPath.section];
    
    HealthHistorySection* historySection = [dicSections valueForKey:sectionname];
    HealthHistoryItem* history = historySection.historyItems[indexPath.row];

    [cell setHistoryItem:history];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //HealthHistoryDetailViewController
    NSArray* sections = [self sectionList];
    NSString* sectionname = sections[indexPath.section];
    HealthHistorySection* historySection = [dicSections valueForKey:sectionname];
    HealthHistoryItem* history = historySection.historyItems[indexPath.row];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthHistoryDetailViewController" ControllerObject:history];
}


#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [[self.tableView superview] closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"HealthHistoryListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* items = (NSArray*) taskResult;
            [self historyItemsLoaded:items];
        }
        else
        {
            [self showBlankView];
        }
    }
}
@end
