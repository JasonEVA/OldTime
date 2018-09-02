//
//  MeTrainHistoryViewController.m
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  训练历史页面

#import "MeTrainHistoryViewController.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
#import "MeTrainHistoryCell.h"
#import "MeTableView.h"
#import "MeHeadView.h"
#import "MeGetTrainHistoryRequest.h"
#import "MeTrainHistoryListModel.h"
#import "MeFooterView.h"

#define ROWHIGHT      80

@interface MeTrainHistoryViewController()<UITableViewDelegate,UITableViewDataSource,BaseRequestDelegate>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) MeHeadView *headView;
@property (nonatomic, strong) MeFooterView *footView;
@property (nonatomic, strong) MeTrainHistoryListModel *model;
@property (nonatomic, copy) NSArray<MeTrainHistoryDetailModel *> *trainHistoryList;

@property (nonatomic, strong) UILabel *noDataLb;

@end
@implementation MeTrainHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"训练历史"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noDataLb];
    [self.tableView addSubview:self.headView];
    [self.tableView addSubview:self.footView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.noDataLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
    }];
    [self startRequest];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trainHistoryList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"myCell";
    MeTrainHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MeTrainHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    [cell setMyContent:self.trainHistoryList[indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROWHIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.view.frame.size.height - self.trainHistoryList.count * ROWHIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footView;
}
#pragma mark -private method

- (void)startRequest
{
    MeGetTrainHistoryRequest *request = [[MeGetTrainHistoryRequest alloc]init];
    request.pageIndex = 1;
    request.pageSize = 3;
    [request requestWithDelegate:self];
    [self postLoading];
}

#pragma mark - event Response


#pragma mark - request Delegate
-(void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求失败");
    [self hideLoading];
}

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求成功");
    [self hideLoading];
    MeGetTrainHistoryResponse *result = (MeGetTrainHistoryResponse *)response;
    self.model = result .model;
    self.trainHistoryList = result.model.pageItems;
    if (self.trainHistoryList.count > 0) {
        [self.tableView setHidden:NO];
        [self.noDataLb setHidden:YES];
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView setHidden:YES];
        [self.noDataLb setHidden:NO];
    }
    
}

#pragma mark - updateViewConstraints
#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
                [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setTableHeaderView:self.headView];
    }
    return _tableView;
}

- (MeHeadView *)headView
{
    if (!_headView) {
        _headView = [[MeHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    }
    return _headView;
}

- (MeFooterView *)footView
{
    if (!_footView) {
        _footView = [[MeFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _footView;
}

- (MeTrainHistoryListModel *)model
{
    if (!_model) {
        _model = [[MeTrainHistoryListModel alloc]init];
    }
    return _model;
}
- (UILabel *)noDataLb
{
    if (!_noDataLb) {
        _noDataLb = [[UILabel alloc] init];
        [_noDataLb setText:@"暂无训练记录"];
        _noDataLb.font = [UIFont systemFontOfSize:30];
        [_noDataLb setTextColor:[UIColor colorLightGray_898888]];
        [_noDataLb setHidden:YES];
    }
    return _noDataLb;
}
@end

