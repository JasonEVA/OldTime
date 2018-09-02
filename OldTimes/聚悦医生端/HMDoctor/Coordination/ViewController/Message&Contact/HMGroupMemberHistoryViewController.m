//
//  HMGroupMemberHistoryViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/4/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMGroupMemberHistoryViewController.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "HMSomeOneMessageHistoryTableViewCell.h"
#import "ChatSearchResultViewController.h"

#define PAGECOUNT      20
@interface HMGroupMemberHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UserProfileModel *memberModel;   // 群成员信息
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, copy)  NSString  *groupUid; // <##>

@end

@implementation HMGroupMemberHistoryViewController

- (instancetype)initWithUserProfileModel:(UserProfileModel *)model groupId:(NSString *)groupId{
    if (self = [super init]) {
        self.memberModel = model;
        self.groupUid = groupId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@历史记录",self.memberModel.nickName]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self acquireMessage];
    // Do any additional setup after loading the view.
}

- (void)acquireMessage {
    self.dataList = [[MessageManager share] querySomeOneAllMessageWithTarget:self.groupUid userName:self.memberModel.userName];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method
- (void)configElements {
}
#pragma mark - event Response

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
    return 0.000001;
}

- (HMSomeOneMessageHistoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageBaseModel *model = self.dataList[indexPath.row];
    HMSomeOneMessageHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMSomeOneMessageHistoryTableViewCell at_identifier]];
    [cell fillDataWithMessageModel:model profileModel:self.memberModel];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageBaseModel *model = self.dataList[indexPath.row];

    ChatSearchResultViewController *searchResultVC = [[ChatSearchResultViewController alloc] init];
    searchResultVC.IsGroup = [ContactDetailModel isGroupWithTarget:model._target];
    [searchResultVC setStrUid:model._target];
    UserProfileModel *userModel = [[MessageManager share] queryContactProfileWithUid:model._target];
    [searchResultVC setStrName:userModel.nickName];
    searchResultVC.sqlId = model._sqlId;
    searchResultVC.msgid = model._msgId;
    [self.navigationController pushViewController:searchResultVC animated:YES];
}
#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView registerClass:[HMSomeOneMessageHistoryTableViewCell class] forCellReuseIdentifier:[HMSomeOneMessageHistoryTableViewCell at_identifier]];
        [_tableView setRowHeight:60];
    }
    return _tableView;
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
