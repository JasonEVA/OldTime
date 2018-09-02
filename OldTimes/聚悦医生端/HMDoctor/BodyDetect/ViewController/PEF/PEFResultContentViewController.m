//
//  PEFResultContentViewController.m
//  HMClient
//
//  Created by lkl on 2017/6/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PEFResultContentViewController.h"
#import "PEFResultValueTableViewCell.h"
#import "PEFResultModel.h"
#import "DetectRecord.h"
#import "PEFResultValueView.h"

typedef NS_ENUM(NSInteger, PEFResultType){

    PEFResultType_PEFValueSection,
    PEFResultType_SymptomSection,
    PEFResultType_PEFHistorySection,
    PEFResultTypeMaxSection,
};

@interface PEFResultContentViewController ()<UITableViewDataSource,UITableViewDelegate,TaskObserver>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PEFResultValueView *pefHistoryView;
@property (nonatomic, strong) PEFResultSymptomView *pefSymptomView;

@property (nonatomic, strong) NSMutableArray *pefValueArray;
@property (nonatomic, strong) PEFResultModel *model;

@end

@implementation PEFResultContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"当日峰流速值"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"历史记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnItemClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    [self subViewLayout];
}

- (void)subViewLayout
{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(ScreenHeight * 0.4);
    }];
    
    _pefSymptomView = [[PEFResultSymptomView alloc] init];
    [self.view addSubview:_pefSymptomView];
    [_pefSymptomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_tableView.mas_bottom).offset(5);
        make.height.mas_equalTo(@75);
    }];
    
    _pefHistoryView = [[PEFResultValueView alloc] init];
    [self.view addSubview:_pefHistoryView];
    [_pefHistoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pefSymptomView.mas_bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (NSString*) resultTaskName
{
    return @"PEFDetectResultTask";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBtnItemClick
{
    UserInfo* targetUser = [[UserInfo alloc]init];
    if (!userId || 0 == userId) {
        return;
    }
    [targetUser setUserId:userId];
    [HMViewControllerManager createViewControllerWithControllerName:@"PEFRecordsStartViewController" ControllerObject:targetUser];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pefValueArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *bgView = [[UIView alloc] init];
    [headerView addSubview:bgView];
    [bgView setBackgroundColor:[UIColor mainThemeColor]];
    [bgView.layer setCornerRadius:12.5f];
    [bgView.layer setMasksToBounds:YES];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(12.5);
        make.bottom.equalTo(headerView).offset(-1.5);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    
    UILabel *title = [[UILabel alloc] init];
    [bgView addSubview:title];
    //[title setText:@"06-07"];
    [title setText:self.model.testDate];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont font_24]];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
    }];
    
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PEFResultValueTableViewCell *cell = [[PEFResultValueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PEFResultValueTableViewCell at_identifier]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    PEFResultdataListModel *dataList = [self.pefValueArray objectAtIndex:indexPath.row];
    [cell setDataList:dataList];
    return cell;
}

#pragma mark -- TaskObserver
- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
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
    
    if ([taskname isEqualToString:@"PEFDetectResultTask"])
    {
        self.model = (PEFResultModel *)taskResult;
        __weak typeof(self) weakSelf = self;
        [self.model.dataList enumerateObjectsUsingBlock:^(PEFResultdataListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.pefValueArray addObject:model];
        }];
        
        [self.tableView reloadData];
        [_pefSymptomView setPEFResult:self.model];
        [_pefHistoryView setPEFResult:self.model];
        
        //更新布局
        CGFloat width = kScreenWidth - 25;
        CGFloat textHeight = [self.model.symptoms heightSystemFont:[UIFont font_28] width:width];
        
        [_pefSymptomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textHeight+50);
        }];
    }
}

#pragma mark - Init
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerClass:[PEFResultValueTableViewCell class] forCellReuseIdentifier:[PEFResultValueTableViewCell at_identifier]];
    }
    return _tableView;
}

- (NSMutableArray *)pefValueArray{
    if (!_pefValueArray) {
        _pefValueArray = [[NSMutableArray alloc] init];
    }
    return _pefValueArray;
}

@end
