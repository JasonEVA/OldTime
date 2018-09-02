//
//  PersonComplainHistoryListViewController.m
//  HMClient
//
//  Created by Dee on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonComplainHistoryListViewController.h"
#import "PersonServiceComplainHistoryTableViewCell.h"
#import "GetPersonServiceComplainListTask.h"
#import "UserInfo.h"

@interface PersonComplainHistoryListViewController ()<UITableViewDelegate, UITableViewDataSource, TaskObserver>

@property(nonatomic, strong) UITableView  *tableview;

@property(nonatomic, strong) NSMutableArray  *modelArray;

@end

@implementation PersonComplainHistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投诉记录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createFrame];
    //直接获取所有的数据
    [self getDataWithCompType:0 compObjectId:nil startRow:0 Rows:0];
    
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 10, 40);
    [btn.titleLabel setFont:[UIFont font_32]];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popToRootVc) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}



#pragma mark privateMathod
/**
 *  获取投诉历史纪录 (所有参数不传，默认获取所有的)
 *
 *  @param type     投诉类系ing
 *  @param objectid 投诉对象ID
 *  @param startrow 开始行
 *  @param rows     行数
 */

- (void)getDataWithCompType:(NSInteger)type compObjectId:(NSString *)objectid startRow:(NSInteger)startrow Rows:(NSInteger)rows
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dict setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"userId"];
    [dict setValue:@"ALL" forKey:@"orgGroupCode"];
//    [dict setValue:type?[NSString stringWithFormat:@"%ld",type]:@"" forKey:@"compType"];
//    [dict setValue:objectid?:@"" forKey:@"compObjectId"];
//    [dict setValue:startrow?[NSString stringWithFormat:@"%ld",startrow]:@"" forKey:@"startRow"];
//    [dict setValue:rows?[NSString stringWithFormat:@"%ld",rows]:@"" forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetPersonServiceComplainListTask class]) taskParam:dict TaskObserver:self];
}

- (void)createFrame
{
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -- uitableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonServiceComplainHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PersonServiceComplainHistoryTableViewCell identifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataWithModel:self.modelArray[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark - eventResponde
- (void)popToRootVc
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - taskDelegate
- (void)task:(NSString *)taskId Result:(id)taskResult
{
    self.modelArray = taskResult;
    [self.tableview reloadData];
}

- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (taskError == StepError_None) return;
    
}

#pragma mark -- setterAndAGetter

- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 280;
        _tableview.separatorColor = [UIColor clearColor];
        [_tableview registerClass:[PersonServiceComplainHistoryTableViewCell class] forCellReuseIdentifier:[PersonServiceComplainHistoryTableViewCell identifier]];
    }
    return _tableview;
}

- (NSMutableArray *)modelArray
{
    if (!_modelArray)
    {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

@end
