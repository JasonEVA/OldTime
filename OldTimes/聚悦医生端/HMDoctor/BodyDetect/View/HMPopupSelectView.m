//
//  HMPopupSelectView.m
//  HMDoctor
//
//  Created by lkl on 2017/6/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMPopupSelectView.h"

@interface HMPopupSelectView ()<TaskObserver,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation HMPopupSelectView

- (instancetype)initWithKpiCode:(NSString *)kpiCode dateList:(NSArray *)dataList{
    self = [super init];
    if (self) {
        
        //请求数据
        [self requestDataList:kpiCode];

        UIControl* closeControl = [[UIControl alloc]init];
        [self addSubview:closeControl];
        [closeControl setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
        [closeControl addTarget:self action:@selector(popupCloseControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [closeControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)requestDataList:(NSString *)kpiCode
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:kpiCode forKey:@"kpiCode"];
    
    [self showWaitView];
    //以前调用的接口 PostUserTestPeriodTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"BloodPressureThriceDetectPeriodTask" taskParam:dicPost TaskObserver:self];
}

- (void)createTableView
{
    if (!_dataList)
    {
        return;
    }
    float tableheight = _dataList.count * 45;
    if (tableheight > self.height - 50)
    {
        tableheight = self.height- 50;
    }

    [self addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((self.height - tableheight)/2);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.height.mas_equalTo(tableheight);
    }];
}

- (void)popupCloseControlClicked:(UIControl *)sender
{
    [self removeFromSuperview];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont font_28]];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"535353"]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    NSString *testPeriod = [[_dataList objectAtIndex:indexPath.row] valueForKey:@"name"];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",testPeriod]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *tempDic = [_dataList objectAtIndex:indexPath.row];
    if (self.dataSelectBlock) {
        self.dataSelectBlock(tempDic);
    }
    [self removeFromSuperview];
}

#pragma mark - init UI

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView.layer setCornerRadius:10.0f];
        [_tableView.layer setMasksToBounds:YES];
    }
    return _tableView;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self closeWaitView];
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

    if ([taskname isEqualToString:@"BloodPressureThriceDetectPeriodTask"])
    {
        if ([taskResult isKindOfClass:[NSArray class]]) {
            _dataList = (NSArray *)taskResult;
            [self createTableView];
        }
    }
}

@end
