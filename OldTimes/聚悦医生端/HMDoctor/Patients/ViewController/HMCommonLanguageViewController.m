//
//  HMCommonLanguageViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/9/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMCommonLanguageViewController.h"
#import "HMNewCommonLaguageViewController.h"
#import "HMGetCommonLangageListRequest.h"
#import "HMCommonLangageModel.h"
#import "HMTopCommonLangageRequest.h"
#import "HMDeleteCommonLangageRequest.h"

@interface HMCommonLanguageViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, copy) cellClick block;
@end

@implementation HMCommonLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"常用语"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startGetCommonLangageListRequest];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightClick {
    HMNewCommonLaguageViewController *VC = [HMNewCommonLaguageViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}
//获取列表请求
- (void)startGetCommonLangageListRequest {
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSString stringWithFormat:@"%ld",curStaff.staffId] forKey:@"staffId"];
    [dict setValue:@(0) forKey:@"startRow"];
    [dict setValue:@(1000) forKey:@"size"];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([HMGetCommonLangageListRequest class]) taskParam:dict TaskObserver:self];

}
//删除请求
- (void)startDeleteCommonLangageListRequest:(HMCommonLangageModel *)model {
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSString stringWithFormat:@"%ld",curStaff.staffId] forKey:@"staffId"];
    [dict setValue:model.userCommonLanguageId forKey:@"commonLanguageId"];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([HMDeleteCommonLangageRequest class]) taskParam:dict TaskObserver:self];
}

//置顶请求
- (void)startTopCommonLangageListRequest:(HMCommonLangageModel *)model {
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSString stringWithFormat:@"%ld",curStaff.staffId] forKey:@"staffId"];
    [dict setValue:model.userCommonLanguageId forKey:@"commonLanguageId"];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([HMTopCommonLangageRequest class]) taskParam:dict TaskObserver:self];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMCommonLangageModel *model = self.dataList[indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defultCell"];
    [cell.textLabel setText:model.content];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HMCommonLangageModel *model = self.dataList[indexPath.row];
    if (self.block) {
        self.block(model.content);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 为兼容iOS 8上侧滑效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMCommonLangageModel *model = self.dataList[indexPath.row];
__weak typeof(self) weakSelf = self;
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除"
                                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                           [strongSelf startDeleteCommonLangageListRequest:model];
                                                                           
                                                                       }];
//    NSString *string = model._muteNotification ? @"恢复提醒" : @"免打扰";
    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:@"编辑"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                              HMNewCommonLaguageViewController *VC = [HMNewCommonLaguageViewController new];
                                                                              VC.JWTextView.text = model.content;
                                                                              VC.commonLanguageId = model.userCommonLanguageId;
                                                                              [strongSelf.navigationController pushViewController:VC animated:YES];

                                                                          }];
    UITableViewRowAction *rowActionThir = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:@"置顶"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                              [strongSelf startTopCommonLangageListRequest:model];
                                                                          }];
    rowActionSec.backgroundColor = [UIColor colorWithHexString:@"ff9c00"];
    rowActionThir.backgroundColor = [UIColor commonLightGrayColor_999999];
        return @[rowAction,rowActionSec,rowActionThir];
    
}


- (void)btnClick:(cellClick)block {
    self.block = block;
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError && errorMessage.length > 0)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}


- (void) task:(NSString *)taskId Result:(id)taskResult
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
    
    
    if ([taskname isEqualToString:@"HMGetCommonLangageListRequest"])
    {
        self.dataList = taskResult;
        [self.tableView reloadData];
    }
    else if ([taskname isEqualToString:@"HMDeleteCommonLangageRequest"]||[taskname isEqualToString:@"HMTopCommonLangageRequest"]) {
        [self startGetCommonLangageListRequest];
    }
    
}




- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defultCell"];
    }
    return _tableView;
}

@end
