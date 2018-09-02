//
//  RoundsRecordsTableViewController.m
//  HMClient
//
//  Created by lkl on 16/9/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "RoundsRecordsTableViewController.h"
#import "RoundsRecordTableViewCell.h"
#import "RoundsRecord.h"

@interface RoundsRecordTableHeaderView : UIView
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

@implementation RoundsRecordTableHeaderView

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
            make.size.mas_equalTo(CGSizeMake(94 * kScreenScale, 30));
            make.centerY.equalTo(self);
        }];
        
        lbMonth = [[UILabel alloc]init];
        [lbMonth setBackgroundColor:[UIColor clearColor]];
        [lbMonth setTextColor:[UIColor whiteColor]];
        [lbMonth setFont:[UIFont font_24]];
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


@interface RoundsRecordsTableViewController ()
<TaskObserver>
{
    NSArray* months;
    NSInteger selectedMonthIndex;
    NSMutableArray* recordList;
}
@end

@implementation RoundsRecordsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRoundsListMonths)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadRoundsListMonths
{
    selectedMonthIndex = 0;
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"RoundsMonthsListTask" taskParam:nil TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    RoundsRecordTableHeaderView* headerview = [[RoundsRecordTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 47)];
    [headerview setMonth:[months objectAtIndex:section]];
    [headerview setIsExtended:(section == selectedMonthIndex)];
    [headerview setMonthIndex:section];
    [headerview setSelectSelectedBlock:^(NSInteger selSection) {
        if (selSection == selectedMonthIndex)
        {
            selectedMonthIndex = NSNotFound;
            [self.tableView reloadData];
            return ;
        }
        [self selectSection:selSection];
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
    return 130 - 24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundsRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoundsRecordTableViewCell"];
    if (!cell)
    {
        cell = [[RoundsRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoundsRecordTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    RoundsRecord *record = [recordList objectAtIndex:indexPath.row];
    [cell setRoundsRecord:record];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundsRecord *record = [recordList objectAtIndex:indexPath.row];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"RoundsDetailViewController" ControllerObject:record.itemId];

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

    [dicPost setValue:months[section] forKey:@"month"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"RoundsRecordListTask" taskParam:dicPost TaskObserver:self];
}

- (void)RoundsMonthlistLoaded:(NSArray*) items
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
    
    if ([taskname isEqualToString:@"RoundsMonthsListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* items = (NSArray*) taskResult;
            [self RoundsMonthlistLoaded:items];
        }
    }
    
    if ([taskname isEqualToString:@"RoundsRecordListTask"])
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
