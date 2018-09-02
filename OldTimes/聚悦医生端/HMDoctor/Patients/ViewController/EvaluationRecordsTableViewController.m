//
//  EvaluationRecordsTableViewController.m
//  HMClient
//
//  Created by lkl on 16/8/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "EvaluationRecordsTableViewController.h"
#import "EvaluationRecordTableViewCell.h"
#import "EvaluationListRecord.h"

@interface EvaluationRecordTableHeaderView : UIView
{
    UIControl* headerControl;
    UILabel* lbMonth;
    UIImageView* ivArrow;
    UIView* lineview;
}

@property (nonatomic, retain) NSString* month;
@property (nonatomic, assign) BOOL isExtended;


@property (nonatomic, copy) void(^selectSelectedBlock)(NSInteger selSection);

- (void)setMonthIndex:(NSInteger) index;
@end

@implementation EvaluationRecordTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lineview = [[UIView alloc]init];
        [lineview setBackgroundColor:[UIColor mainThemeColor]];
        [self addSubview:lineview];
        
        headerControl = [[UIControl alloc]init];
        [self addSubview:headerControl];
        [headerControl setBackgroundColor:[UIColor mainThemeColor]];
        headerControl.layer.cornerRadius = 15;
        headerControl.layer.masksToBounds = YES;
        [headerControl addTarget:self action:@selector(headerControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.size.mas_equalTo(CGSizeMake(94, 30));
            make.centerY.equalTo(self);
        }];
        
        lbMonth = [[UILabel alloc]init];
        [lbMonth setBackgroundColor:[UIColor clearColor]];
        [lbMonth setTextColor:[UIColor whiteColor]];
        [lbMonth setFont:[UIFont systemFontOfSize:12]];
        [headerControl addSubview:lbMonth];
        
        [lbMonth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerControl).with.offset(7);
            make.centerY.equalTo(headerControl);
        }];
        
        ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_disexpended"]];
        [headerControl addSubview:ivArrow];
        
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@8);
            make.width.mas_equalTo(@8);
            make.centerY.equalTo(headerControl);
            make.right.equalTo(headerControl).with.offset(-8);
        }];
        
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.width.mas_equalTo(@1);
            make.top.equalTo(self);
            make.left.equalTo(self).with.offset(51);
        }];
        
    }
    return self;
}

- (void)setMonth:(NSString *)month
{
    _month = month;
    NSDate* dateMonth = [NSDate dateWithString:month formatString:@"yyyy-MM"];
    NSString* monthStr = [dateMonth formattedDateWithFormat:@"yyyy年MM月"];
    [lbMonth setText:monthStr];
}

- (void) setIsExtended:(BOOL)isExtended
{
    _isExtended = isExtended;
    
    if (isExtended){
        
        [ivArrow setImage:[UIImage imageNamed:@"history_expended"]];
    }
    else{
        [ivArrow setImage:[UIImage imageNamed:@"history_disexpended"]];
    }
}

- (void) setMonthIndex:(NSInteger) index
{
    [headerControl setTag:(0x100 + index)];
}

- (void) headerControlClicked:(id) sender
{
    NSInteger section = headerControl.tag - 0x100;
    if (_selectSelectedBlock)
    {
        _selectSelectedBlock(section);
    }
}


@end

@interface EvaluationRecordsTableViewController ()
<TaskObserver>
{
    NSString *userId;
    NSArray* months;
    NSInteger selectedMonthIndex;
    NSMutableArray* recordList;
}
@end

@implementation EvaluationRecordsTableViewController

- (id) initWithUserId:(NSString*) aUserId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        userId = aUserId;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadEvaluationListMonths)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    
    [self.tableView.mj_header beginRefreshing];
    
    
    /*recordList = [NSMutableArray array];
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    
    [dicPost setValue:@"2016-08" forKey:@"month"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"EvaluationRecordListTask" taskParam:dicPost TaskObserver:self];*/
}

- (void) loadEvaluationListMonths
{
    selectedMonthIndex = 0;

    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:userId forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"EvaluationMonthsListTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDataWithUserID:(NSString *)userID {
    userId = userID;
    [self loadEvaluationListMonths];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (months)
    {
        return months.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == selectedMonthIndex)
    {
        if (recordList)
        {
            return recordList.count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EvaluationRecordTableHeaderView* headerview = [[EvaluationRecordTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 47)];
    [headerview setMonth:[months objectAtIndex:section]];
    [headerview setIsExtended:(section == selectedMonthIndex)];
    [headerview setMonthIndex:section];
    __weak typeof(self) weakSelf = self;
    [headerview setSelectSelectedBlock:^(NSInteger selSection) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (selSection == selectedMonthIndex)
        {
            selectedMonthIndex = NSNotFound;
            [strongSelf.tableView reloadData];
            return ;
        }
        [strongSelf selectSection:selSection];
    }];
    return headerview;
}

- (void)selectSection:(NSInteger) section
{
    selectedMonthIndex = section;
    [self loadMonthRecords:selectedMonthIndex];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluationRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluationRecordTableViewCell"];
    if (!cell)
    {
        cell = [[EvaluationRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EvaluationRecordTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    EvaluationListRecord *record = [recordList objectAtIndex:indexPath.row];
    [cell setEvaluationRecord:record];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluationListRecord *record = [recordList objectAtIndex:indexPath.row];
   
    //if ([record.itemType isEqualToString:@"3"])
    //{
    //建档评估
    [HMViewControllerManager createViewControllerWithControllerName:@"EvaluationDetailViewController" ControllerObject:record];
    //}
}

- (void)loadMonthRecords:(NSInteger) section
{
    
    if (!months || months.count == 0)
    {
        [self showBlankView];
        return;
    }
    
    recordList = [NSMutableArray array];
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:userId forKey:@"userId"];
    [dicPost setValue:months[section] forKey:@"month"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"EvaluationRecordListTask" taskParam:dicPost TaskObserver:self];
}

- (void)EvaluationMonthlistLoaded:(NSArray*) items
{
    selectedMonthIndex = 0;
    months = [NSMutableArray arrayWithArray:items];
    [self loadMonthRecords:selectedMonthIndex];
    [self.tableView reloadData];
}

#pragma mark -- TaskObserver

- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.mj_header endRefreshing];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    [self.tableView reloadData];
}

- (void)task:(NSString *)taskId Result:(id)taskResult
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
    
    if ([taskname isEqualToString:@"EvaluationMonthsListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* items = (NSArray*) taskResult;
            [self EvaluationMonthlistLoaded:items];
        }
    }
    
    if ([taskname isEqualToString:@"EvaluationRecordListTask"])
    {
        NSDictionary* dicResult = (NSDictionary*)taskResult;
        NSNumber* numCount = [dicResult valueForKey:@"count"];
        NSArray* list = [dicResult valueForKey:@"list"];
        
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            //
        }
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            recordList = [NSMutableArray arrayWithArray:list];
        }
        
    }
}


@end
