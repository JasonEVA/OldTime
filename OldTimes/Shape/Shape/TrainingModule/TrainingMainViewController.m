//
//  TrainingMainViewController.m
//  Shape
//
//  Created by Andrew Shen on 15/10/14.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainingMainViewController.h"
#import "TrainingTableViewCell.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "TrainingAlltrainViewController.h"
#import "TrainGetMyTrainListModel.h"
#import "TrainGetMyTrainListRequest.h"
#import "MyDefine.h"
#import "TrainingDetailPlanController.h"

@interface TrainingMainViewController ()<UITableViewDelegate,UITableViewDataSource,BaseRequestDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TrainGetMyTrainListModel *model;
@property (nonatomic, copy) NSMutableArray *dataList;
@property (nonatomic, copy)  NSString  *trainingMuscle; // 要锻炼的部位

@end

@implementation TrainingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的训练"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trainingMuscle:) name:n_pushToAddTraining object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:n_pushToStartTraining object:nil];

    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"taining_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [self.view addSubview:self.tableView];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController.navigationBar setHidden:NO];
    TrainGetMyTrainListRequest *request = [[TrainGetMyTrainListRequest alloc]init];
    [request requestWithDelegate:self];
    [self postLoading];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method
- (void)pushVCWithTrainID:(NSString *)trainID
{
    TrainingDetailPlanController *VC = [[TrainingDetailPlanController alloc]init];
    VC.trainID = trainID;
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - event Response

- (void)addClick
{
    TrainingAlltrainViewController *allVC = [[TrainingAlltrainViewController alloc]init];
    allVC.trainingMuscle = self.trainingMuscle ? self.trainingMuscle: @"";
    self.trainingMuscle = nil;
    [allVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:allVC animated:YES];
}

- (void)trainingMuscle:(NSNotification *)notification {
    self.trainingMuscle = notification.object;
    [self addClick];
}
- (void)tongzhi:(NSNotification *)text{
    [self pushVCWithTrainID:text.userInfo[@"trainID"]];
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"myCell";
    TrainingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TrainingTableViewCell alloc]initWithShowStrength:NO reuseIdentifier:ID];
    }
    [cell setModelData:self.dataList[indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.model = self.dataList[indexPath.row];
    [self pushVCWithTrainID:self.model.trainingId];

}

#pragma mark - request Delegate
- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self hideLoading];
    NSLog(@"请求失败");
}
- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求成功");
    

    TrainGetMyTrainListResponse *result = (TrainGetMyTrainListResponse *)response;
    self.dataList = [NSMutableArray arrayWithArray:result.modelArr];
    [self.tableView reloadData];
    [self hideLoading];
}

#pragma mark - updateViewConstraints

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        [_tableView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

- (TrainGetMyTrainListModel *)model
{
    if (!_model) {
        _model = [[TrainGetMyTrainListModel alloc]init];
    }
    return _model;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}
@end
