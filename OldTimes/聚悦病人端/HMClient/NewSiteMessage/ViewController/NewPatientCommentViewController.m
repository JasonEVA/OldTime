//
//  NewPatientCommentViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/3/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewPatientCommentViewController.h"
#import "NewCommentStarPartTableViewCell.h"
#import "PersonServiceComPlainContentTableViewCell.h"
#import "NewCommentCollectionTableViewCell.h"
#import "NewCommentEvaluateTagModel.h"
#import "NewCommentSelectLabelModel.h"
#import "NewCommentDetailModel.h"
#import "NewCommentDetailTableViewCell.h"
#import "IntegralModel.h"

@interface NewPatientCommentViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton  *submitBtn;
@property (nonatomic, copy) NSArray <NewCommentEvaluateTagModel *>*evaluateTagArray;         //服务评价项目列表
@property (nonatomic, copy) NSArray <NewCommentSelectLabelModel *>*evaluateLabelArray;       //服务评价内容标签列表
@property (nonatomic, copy) NSString *evaluateContent;                                       //输入评价信息
@property (nonatomic, strong) NewCommentDetailModel *commentDetailModel;                     //评价详情model  存在即已评价 不存在即未评价
@end

@implementation NewPatientCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"评价"];
    
    [self startGetCommentDetailRequest];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}
// 获取服务评价详情

- (void)startGetCommentDetailRequest {
    [self.view showWaitView];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.masgId?:@"" forKey:@"msgId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"NewCommentGetUserServiceEvaluateRequest" taskParam:dict TaskObserver:self];

    
}
// 获取服务评价项目列表请求
- (void)startGetListEvaluateScoreTargetRequest {
    [self.view showWaitView];

    [[TaskManager shareInstance] createTaskWithTaskName:@"NewCommentGetListEvaluateScoreTargetRequest" taskParam:nil TaskObserver:self];
}

// 获取服务评价内容标签列表
- (void)startGetListEvaluateTagRequest {
    [self.view showWaitView];

    [[TaskManager shareInstance] createTaskWithTaskName:@"NewCommentGetListEvaluateTagRequest" taskParam:nil TaskObserver:self];
}

// 提交评价请求
- (void)startAddCommentRequest {
    [self.view showWaitView];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.userServiceId?:@"" forKey:@"userServiceId"];
    [dict setValue:[self toGetEvaluateTarget] forKey:@"evaluateTarget"];
    [dict setValue:[self toGetEvaluateContent]?:@"" forKey:@"evaluateContent"];
    [dict setValue:self.masgId?:@"" forKey:@"msgId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"NewCommentAddUserServiceEvaluateRequest" taskParam:dict TaskObserver:self];
}

// 拼装评价信息
- (NSString *)toGetEvaluateContent {
    NSString *evaluateContent;
    __block NSString *tempString = @"";
    [self.evaluateLabelArray enumerateObjectsUsingBlock:^(NewCommentSelectLabelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            if (!tempString.length) {
                tempString = obj.tag;
            }
            else {
                tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"，%@",obj.tag]];
            }
        }
    }];
    if (self.evaluateContent && self.evaluateContent.length) {
        if (tempString && tempString.length) {
            evaluateContent = [self.evaluateContent stringByAppendingString:[NSString stringWithFormat:@"，%@",tempString]];
        }
        else {
            evaluateContent = self.evaluateContent;
        }
    }
    else {
        evaluateContent = tempString;
    }
    return evaluateContent;
}

// 拼装评星数据
- (NSDictionary *)toGetEvaluateTarget {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self.evaluateTagArray enumerateObjectsUsingBlock:^(NewCommentEvaluateTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dict setObject:[NSString stringWithFormat:@"%ld",obj.score] forKey:obj.targetId];
    }];
    return dict;
}

#pragma mark - event Response
- (void)submitAction
{
    if (![self toGetEvaluateContent] || ![self toGetEvaluateContent].length) {
        [self.view showAlertMessage:@"评价信息不完整"];
        return;
    }

    __block BOOL isShouldReturn = NO;
    [self.evaluateTagArray enumerateObjectsUsingBlock:^(NewCommentEvaluateTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.score) {
            [self.view showAlertMessage:@"评价信息不完整"];
            *stop = YES;
            isShouldReturn = YES;
        }
    }];
    
    if (isShouldReturn) {
        return;
    }
    
    [self startAddCommentRequest];
}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentDetailModel ? 2 : 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    switch (indexPath.row) {
        case 0:
        {   // 3个5星选择部分
            cell = [tableView dequeueReusableCellWithIdentifier:[NewCommentStarPartTableViewCell at_identifier]];
            [cell fillDataWithArray:self.evaluateTagArray];
            break;
        }
        case 1:
        {
            if (self.commentDetailModel) {  //评价详情
                cell = [tableView dequeueReusableCellWithIdentifier:[NewCommentDetailTableViewCell at_identifier]];
                [cell fillDataWithModel:self.commentDetailModel];
            }
            else {
                // 输入框部分
                cell = [tableView dequeueReusableCellWithIdentifier:[PersonServiceComPlainContentTableViewCell at_identifier]];
                [cell getContentWithBlock:^(NSString *content) {
                    self.evaluateContent = content;
                }];
            }
            break;
        }
        case 2:
        {   // 标签选择
            cell = [tableView dequeueReusableCellWithIdentifier:[NewCommentCollectionTableViewCell at_identifier]];
            [cell fillDataWithArray:self.evaluateLabelArray];
            break;
        }
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *contentView =[[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 80)];
    contentView.backgroundColor =  tableView.backgroundColor;
    [contentView addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(20);
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-15);
        make.height.equalTo(@50);
    }];
    return self.commentDetailModel ? nil : contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  80;
}
#pragma mark - request Delegate
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self.view closeWaitView];
    
    if (!taskId || 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"NewCommentGetListEvaluateScoreTargetRequest"]) {
        self.evaluateTagArray = (NSArray *)taskResult;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([taskname isEqualToString:@"NewCommentGetListEvaluateTagRequest"]) {
        self.evaluateLabelArray = (NSArray *)taskResult;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

    }
    else if ([taskname isEqualToString:@"NewCommentAddUserServiceEvaluateRequest"]) {
//        [self showAlertMessage:@"评价成功" clicked:^{
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
        //获取评价所得积分
        [self gainIntergal];
        return;
    }
    else if ([taskname isEqualToString:@"IntegralChangeTask"])
    {
        NSString* alertMessage = nil;
        if (taskResult && [taskResult isKindOfClass:[IntegralModel class]])
        {
            IntegralModel* model = (IntegralModel*) taskResult;
            if (model.addScore > 0) {
                //有积分获取
                alertMessage = [NSString stringWithFormat:@"积分奖励：本次您已获取%ld积分", model.addScore];
            }
        }
        [self showAlertMessage:alertMessage title:@"评价成功" clicked:^{
//            [self.navigationController popViewControllerAnimated:YES];
            [self startGetCommentDetailRequest];
        }];
        return;
//        [self showAlertMessage:@"评价成功" clicked:^{
//                        [self.navigationController popViewControllerAnimated:YES];
//                    }];
    }
    else if ([taskname isEqualToString:@"NewCommentGetUserServiceEvaluateRequest"]) {
        self.commentDetailModel = (NewCommentDetailModel *)taskResult;
        if (self.commentDetailModel) {
            self.evaluateTagArray = self.commentDetailModel.evaluateTarget;
            [self.tableView reloadData];
        }
        else {
            [self startGetListEvaluateScoreTargetRequest];
            [self startGetListEvaluateTagRequest];
        }
        
        

    }
}

#pragma mark - PointRedemption  获取积分
- (void) gainIntergal
{
    //获取服务评价的积分奖励
    
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    UserInfo* currentUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [postDictionary setValue:@2 forKey:@"type"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", currentUser.userId] forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"IntegralChangeTask" taskParam:postDictionary TaskObserver:self];
}

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.estimatedRowHeight = 60;
        [_tableView registerClass:[NewCommentStarPartTableViewCell class] forCellReuseIdentifier:[NewCommentStarPartTableViewCell at_identifier]];
        [_tableView registerClass:[PersonServiceComPlainContentTableViewCell class] forCellReuseIdentifier:[PersonServiceComPlainContentTableViewCell at_identifier]];
        [_tableView registerClass:[NewCommentCollectionTableViewCell class] forCellReuseIdentifier:[NewCommentCollectionTableViewCell at_identifier]];
        [_tableView registerClass:[NewCommentDetailTableViewCell class] forCellReuseIdentifier:[NewCommentDetailTableViewCell at_identifier]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
    }
    return _tableView;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:[UIColor mainThemeColor]];
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn.layer setCornerRadius:5];
    }
    return _submitBtn;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
