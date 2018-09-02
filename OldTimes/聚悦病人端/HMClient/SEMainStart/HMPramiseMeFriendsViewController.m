//
//  HMPramiseMeFriendsViewController.m
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMPramiseMeFriendsViewController.h"
#import "HMPramiseMeModel.h"
#import "HMPramiseMeTableViewCell.h"


@interface HMPramiseMeFriendsViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@end

@implementation HMPramiseMeFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"赞我的朋友"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self startRequestlist];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}
// 获取列表
- (void)startRequestlist {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.userExerciseId forKey:@"userExerciseId"];
    [self at_postLoading];

    [[TaskManager shareInstance] createTaskWithTaskName:@"HMGetUserExFavourListRequest" taskParam:dict TaskObserver:self];
    
}

#pragma mark - event Response
- (void)rightClick {
    
}
#pragma mark - Delegate

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMPramiseMeModel *model = self.dataList[indexPath.row];
    HMPramiseMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMPramiseMeTableViewCell at_identifier]];
    [cell fillDataWith:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    
    if (StepError_None != taskError)
    {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self at_hideLoading];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"HMGetUserExFavourListRequest"]) {
        
        self.dataList = taskResult;
        [self.tableView reloadData];
    }
   
}
#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"还没有人点赞过哦" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"emptyImage_g"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.dataList ||self.dataList.count == 0) {
        return YES;
    }
    return NO;
}
#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setRowHeight:60];
        [_tableView registerClass:[HMPramiseMeTableViewCell class] forCellReuseIdentifier:[HMPramiseMeTableViewCell at_identifier]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
    }
    return _tableView;
}


@end
