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
#import "InitializationHelper.h"
#import "UITableViewController+WithoutService.h"
#import "PersonCommitIDCardViewController.h"

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

@interface HealthHistoryIDCardInvalidView : UIView

@property (nonatomic, strong) UILabel* IDCardInvalidLabel;
@property (nonatomic, strong) UIButton* identificeButton;   //认证按钮
@end

@implementation HealthHistoryIDCardInvalidView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.IDCardInvalidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(98);
    }];
    
    [self.identificeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(160, 45));
        make.top.equalTo(self.IDCardInvalidLabel.mas_bottom).offset(35);
    }];
}



#pragma mark - settingAndGetting
- (UILabel*) IDCardInvalidLabel
{
    if (!_IDCardInvalidLabel) {
        _IDCardInvalidLabel = [[UILabel alloc] init];
        [self addSubview:_IDCardInvalidLabel];
        
        [_IDCardInvalidLabel setText:@"实名认证后才能查看医院病历哦！"];
        [_IDCardInvalidLabel setTextColor:[UIColor commonTextColor]];
        [_IDCardInvalidLabel setFont:[UIFont font_34]];
    }
    
    return _IDCardInvalidLabel;
}

- (UIButton*) identificeButton
{
    if (!_identificeButton) {
        _identificeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_identificeButton];
        
        [_identificeButton setTitle:@"立即认证" forState:UIControlStateNormal];
        [_identificeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_identificeButton setBackgroundImage:[UIImage rectImage:CGSizeMake(200, 49) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        _identificeButton.layer.cornerRadius = 4;
        _identificeButton.layer.masksToBounds = YES;
    }
    return _identificeButton;
}
@end

@interface HealthHistoryTableViewController ()
<TaskObserver, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSMutableDictionary* dicSections;
    
}
@property (nonatomic, assign) BOOL isAuthentication;   //是否进行（查看住院）认证
@end

static const NSInteger kIDCardInvalidViewTag = 0x2521;

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
    
    [self.tableView setEmptyDataSetSource:self];
    [self.tableView setEmptyDataSetDelegate:self];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    if (curUser.userId == userId.integerValue)
    {
        if (!curUser.idCard || curUser.idCard.length == 0) {
//        if (YES) {
            //用户还没有进行身份证认证
//            [self showIDCardInvalidView];
            [self performSelector:@selector(showIDCardInvalidView) withObject:nil afterDelay:0.1];
            return;
        }
    }

    if (kStringIsEmpty(curUser.authenticationType) || [curUser.authenticationType isEqualToString:@"1"]) {
        // 已进行身份证认证，正在审核
        self.isAuthentication = YES;
        return;
    }
    
    [self loadHealthHistoiry];
}

- (BOOL) userHasService
{
    [self showBlankView];
    InitializationHelper* helper = [InitializationHelper defaultHelper];
    if (helper.userHasService) {
        return YES;
    }
    return NO;
}

- (void) showIDCardInvalidView
{
    HealthHistoryIDCardInvalidView* IDCardInvalidView = [self.tableView viewWithTag:kIDCardInvalidViewTag];
    if (!IDCardInvalidView) {
        IDCardInvalidView = [[HealthHistoryIDCardInvalidView alloc] init];
        [self.tableView addSubview:IDCardInvalidView];
        [IDCardInvalidView setTag:kIDCardInvalidViewTag];
        [IDCardInvalidView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.tableView.superview);
        }];
        
        [IDCardInvalidView.identificeButton addTarget:self action:@selector(identificeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tableView setScrollEnabled:NO];
    }
    return;
}

- (void) closeIDCardInvalidView
{
    HealthHistoryIDCardInvalidView* IDCardInvalidView = [self.tableView viewWithTag:kIDCardInvalidViewTag];
    if (IDCardInvalidView) {
        [IDCardInvalidView removeFromSuperview];
        IDCardInvalidView = nil;
    }
    [self.tableView setScrollEnabled:YES];
}

- (void) identificeButtonClicked:(id) sender
{
    __weak typeof(self) weakSelf = self;
    [PersonCommitIDCardViewController showWithHandleBlock:^{
        [weakSelf closeIDCardInvalidView];
        
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        if (kStringIsEmpty(curUser.authenticationType) || [curUser.authenticationType isEqualToString:@"1"]) {
            // 已进行身份证认证，正在审核
            self.isAuthentication = YES;
            return;
        }
        
        [weakSelf loadHealthHistoiry];
    }];
}

- (void) loadHealthHistoiry
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:userId forKey:@"userId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", type] forKey:@"type"];
    
    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthHistoryListTask" taskParam:dicPost TaskObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) historyItemsLoaded:(NSArray*) items
{
    dicSections = [NSMutableDictionary dictionary];
    if (!items || 0 == items.count)
    {
        [self.tableView reloadData];
        return;
    }
    
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
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
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
//#warning Incomplete implementation, return the number of sections
    if (dicSections)
    {
        NSArray* keys = [dicSections allKeys];
        return keys.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
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
    [headerview setIsExtended:historySection.isExpended];
    [headerview addTarget:self action:@selector(yearSectionHeaderViewClicked:) forControlEvents:UIControlEventTouchUpInside];
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
#pragma mark - DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isAuthentication) {
        return [[NSAttributedString alloc] initWithString:@"正在实名审核中，\n您可以联系健康顾问咨询审核进度" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]}];
    }
    return nil;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isAuthentication) {
        return [UIImage imageNamed:@"emptyImage_i"];
    }
    return [UIImage imageNamed:@"img_blank_list"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if (!dicSections ||dicSections.count == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -68;
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
        
    }
    
}
@end
