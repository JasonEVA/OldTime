//
//  PersonCommentViewController.m
//  HMClient
//
//  Created by Dee on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonCommentViewController.h"
#import "PersonCommentTableViewCell.h"
#import "PersonServiceComPlainContentTableViewCell.h"
#import "UserServiceEvaluateTask.h"
@interface PersonCommentViewController ()<UITableViewDelegate, UITableViewDataSource, TaskObserver>

@property(nonatomic, strong) UITableView  *tableview;

@property(nonatomic, strong) UIButton  *submitBtn;
//用户服务ID
@property(nonatomic, copy) NSString  *serviceId;
//服务评价等级
@property(nonatomic, assign) NSInteger  grade;
//评价内容
@property(nonatomic, copy) NSString  *evaluateContent;

@end

@implementation PersonCommentViewController


- (instancetype)initWithServiceID:(NSString *)serviceID
{
    if (self = [super init])
    {
        self.serviceId = serviceID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createFrame];
    self.view.backgroundColor = self.tableview.backgroundColor;
    self.title = @"评价";
}

#pragma mark - privateMethod
- (void)createFrame
{
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - tableViewDelegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{return 2;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return 1;}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return indexPath.section?120:45;}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{return 5;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        return  section?80:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    if (!indexPath.section)
    {
        
        cell =  [tableView dequeueReusableCellWithIdentifier:[PersonCommentTableViewCell identifier]];
        [cell getStarCountWithBlock:^(NSInteger starCount) {
            self.grade = starCount;
        }];
    }else
    {
       cell = [tableView dequeueReusableCellWithIdentifier:[PersonServiceComPlainContentTableViewCell identifier]];
        [cell getContentWithBlock:^(NSString *content) {
            self.evaluateContent = content;
        }];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section) {
        UIView *contentView =[[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 80)];
        contentView.backgroundColor =  tableView.backgroundColor;
        [contentView addSubview:self.submitBtn];
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(20);
            make.right.left.equalTo(contentView);
            make.height.equalTo(@44);
        }];
        return contentView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - taskdelegate
- (void)task:(NSString *)taskId Result:(id)taskResult
{
    [self.view closeWaitView];
    //TODO:评价完成，后续处理
    NSLog(@"评价完成");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (taskId  == StepError_None) {return;}
    if (errorMessage.length > 0) {
        [self.view showAlertMessage:errorMessage];
    }
}

#pragma mark - eventrespond
- (void)submitAction
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.serviceId?:@"" forKey:@"userServiceId"];
    [dict setValue:@(self.grade) forKey:@"grade"];
    [dict setValue:self.evaluateContent?:@"" forKey:@"evaluateContent"];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([UserServiceEvaluateTask class]) taskParam:dict TaskObserver:self];
    [self.view showWaitView];
}

#pragma mark - setterAndGetter
- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[PersonCommentTableViewCell class] forCellReuseIdentifier:[PersonCommentTableViewCell identifier]];
        [_tableview registerClass:[PersonServiceComPlainContentTableViewCell class] forCellReuseIdentifier:[PersonServiceComPlainContentTableViewCell identifier]];
    }
    return _tableview;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:[UIColor mainThemeColor]];
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}




@end
