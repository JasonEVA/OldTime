//
//  SiteMessageViewController.m
//  HMClient
//
//  Created by Dee on 16/6/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SiteMessageViewController.h"
#import "SiteMessageTableViewCell.h"
#import "GetSiteMessageListTask.h"
#import "UserInfo.h"
#import "DeleteMessageTask.h"
#import "SiteMessageModel.h"
#import "SiteDetailViewController.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface SiteMessageViewController ()<UITableViewDelegate, UITableViewDataSource, TaskObserver>

@property(nonatomic, strong) UITableView  *tableView;

@property(nonatomic, strong) NSMutableArray  *modelArray;

@property(nonatomic, assign) NSInteger  currentIndex;

@property(nonatomic, assign) BOOL  isDeleteAllMsg;
@end

@implementation SiteMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的消息";
    self.isDeleteAllMsg = NO;
    [self createFrame];
    [self configNacvigationItem];
    
    //将推送消息session标记已读，去除外面红点
    [[MessageManager share] sendReadedRequestWithUid:@"PUSH@SYS" messages:nil];

    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getMessageListAction];
}
#pragma mark - tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SiteMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SiteMessageTableViewCell identifier]];
    [cell setDataWithModel:self.modelArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    SiteMessageModel *model = self.modelArray[indexPath.row];
    [self deleteMsgActionWithID:[model.msgId stringValue]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { return YES; }

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    SiteMessageModel *model = self.modelArray[indexPath.row];
    
    SiteDetailViewController *vc = [[SiteDetailViewController alloc]init];
    vc.model = model;
    
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
#pragma mark - TaskDelegate
- (void)task:(NSString *)taskId Result:(id)taskResult
{
    [self.view closeWaitView];
      NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if ([taskname isEqualToString:NSStringFromClass([GetSiteMessageListTask class])]) {
        if (taskResult){
            if ([taskResult isKindOfClass:[NSArray class]]) {
                self.modelArray = taskResult;
                [self.tableView reloadData];
            }
        }
    }else if ([taskname isEqualToString:NSStringFromClass([DeleteMessageTask class])]) {
        if (self.isDeleteAllMsg){
            [self.modelArray removeAllObjects];
            
        }else{
            [self.modelArray removeObjectAtIndex:self.currentIndex];
        }
        self.isDeleteAllMsg = NO;
        [self.tableView reloadData];
        [self.view closeWaitView];
    }
    
}

- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (taskError == StepError_None) {return;}
    
}


#pragma mark - privateMethod
/**
 *  发送msgID 删除单条
 *  传nil删除全部
 */
- (void)deleteMsgActionWithID:(NSString *)msgID
{
    UserInfo *currentUserinfo = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (msgID != nil && msgID.length) {
        [dict setValue:msgID forKey:@"msgId"];
    }else{
        [dict setValue:[NSString stringWithFormat:@"%ld",currentUserinfo.userId] forKey:@"userId"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([DeleteMessageTask class]) taskParam:dict TaskObserver:self];
    [self.view showWaitView];
}


- (void)configNacvigationItem
{
    UIButton *btn = [[UIButton alloc ]init];
    [btn setFrame:CGRectMake(0, 0, 80, 30)];
    [btn setTitle:@"一键删除" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont font_28];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteAllMesageAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)deleteAllMesageAction
{
    UIAlertController *alterView = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除全部" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAct = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //传空删除全部
        self.isDeleteAllMsg = YES;
        [self deleteMsgActionWithID:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alterView addAction:deleteAct];
    [alterView addAction:cancelAction];
    [self presentViewController:alterView animated:YES completion:nil];

    
}

- (void)createFrame
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)getMessageListAction
{
    [self.view showWaitView];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"userId"];
    /**
     *  user_push_msg: 推送消息 XTXX：系统信息  YYGG: 医院公告 YZXX：医嘱消息
     */
    [dict setValue:@[@"user_push_msg",@"XTXX",@"YYGG",@"YZXX"] forKey:@"msgTypeCode"];
    [dict setValue:@(0) forKey:@"startRow"];
    [dict setValue:@(100) forKey:@"rows"];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetSiteMessageListTask class]) taskParam:dict TaskObserver:self];
}

#pragma mark - setterAndGetter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setRowHeight:60];
        [_tableView registerClass:[SiteMessageTableViewCell class] forCellReuseIdentifier:[SiteMessageTableViewCell identifier]];
    }
    return _tableView;
}

@end
