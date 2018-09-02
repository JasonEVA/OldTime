//
//  HMOnlineArchivesMedictionsViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/3/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMOnlineArchivesMedictionsViewController.h"
#import "HMRecentMedicalTableViewCell.h"
#import "HMRecentMedicalModel.h"

@interface HMOnlineArchivesMedictionsViewController ()<TaskObserver,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *admissionId;
@property (nonatomic, strong) NSArray *medicalList;

@end

@implementation HMOnlineArchivesMedictionsViewController

- (instancetype)initWithUserID:(NSString *)userID admissionId:(NSString *)admissionId
{
    self = [super init];
    if (self) {
        _userId = userID;
        _admissionId = admissionId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(5);
    }];
    
    [self startRecentMedicalInfoRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createDateChanged:) name:@"OnlineArchivesDateChangedNotification" object:nil];
}

- (void)createDateChanged:(NSNotification *)notification
{
    _admissionId = [notification object];
    [self startRecentMedicalInfoRequest];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startRecentMedicalInfoRequest {

    //获取患者的信息
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setObject:_admissionId forKey:@"admissionId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMRecentMedicalTask" taskParam:dicPost TaskObserver:self];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.medicalList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMRecentMedicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMRecentMedicalTableViewCell"];
    if (!cell)
    {
        cell = [[HMRecentMedicalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMRecentMedicalTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    HMRecentMedicalModel *model = [self.medicalList objectAtIndex:indexPath.row];
    [cell setRecentMedicalInfo:model];
    
    return cell;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
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
    
    if ([taskname isEqualToString:@"HMRecentMedicalTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]]) {
            self.medicalList = taskResult;
            [self.tableView reloadData];
        }
    }
}


#pragma mark - init UI

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setBackgroundColor:[UIColor commonBackgroundColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"img_blank_list"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.medicalList || self.medicalList.count == 0) {
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
@end
