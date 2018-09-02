//
//  AddFriendSubViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AddFriendSubViewController.h"
#import "AddFriendSubAdapter.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "ContactDoctorInfoTableViewCell.h"
#import "CoordinationContactsManager.h"
#import "ContactGroupingManagementViewController.h"
#import "DoctorCompletionInfoModel.h"

@interface AddFriendSubViewController ()<ATTableViewAdapterDelegate,ContactGroupingManagementViewControllerDelegate>

@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  AddFriendSubAdapter  *adapter; // <##>
@end

@implementation AddFriendSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"添加好友"];
    [self configElements];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendRequest)];
    [self.navigationItem setRightBarButtonItem:item];
    
    [self.view addSubview:self.tableView];
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)popVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
// 设置数据
- (void)configData {
}

- (void)sendRequest {
    MessageRelationGroupModel *model = [self.adapter.adapterArray.lastObject firstObject];
    NSString *uid = [NSString stringWithFormat:@"%ld",self.doctorInfo.userId];
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] addRelationValidateToUser:uid remark:@"这里填备注" content:@"验证信息" relationGroupId:model.relationGroupId completion:^(BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!success) {
            return;
        }
        [strongSelf at_postSuccess:@"发送成功"];
        [strongSelf performSelector:@selector(popVC) withObject:nil afterDelay:1.0f];
        }];
}

#pragma mark - Event Response

#pragma mark - ContactGroupingManagementViewControllerDelegate

- (void)ContactGroupingManagementViewControllerDelegateCallBack_selectModel:(MessageRelationGroupModel *)model
{
    [self.adapter.adapterArray replaceObjectAtIndex:self.adapter.adapterArray.count - 1 withObject:@[model]];
    [self.tableView reloadData];
}

#pragma mark - Adapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [[ATModuleInteractor sharedInstance] goToSelsctfriendsGroupWithDataList:[[CoordinationContactsManager sharedManager] getContatsGroupingNamesIncludeChatGroup:NO] Edit:NO delegate:self selectModel:[self.adapter.adapterArray.lastObject firstObject]];
    }
    else if (indexPath.section == 0 && indexPath.row == 0) {
        [[ATModuleInteractor sharedInstance] goDoctorDetailInfoWithRelationType:ContactRelationshipType_none model:cellData];
    }
}

#pragma mark - Override

#pragma mark - Init


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        [_tableView registerClass:[ContactDoctorInfoTableViewCell class] forCellReuseIdentifier:[ContactDoctorInfoTableViewCell at_identifier]];
    }
    return _tableView;
}

- (AddFriendSubAdapter *)adapter {
    if (!_adapter) {
        _adapter = [AddFriendSubAdapter new];
        NSArray *arr = [[CoordinationContactsManager sharedManager] getContatsGroupingNamesIncludeChatGroup:NO];
        if (arr.count > 0) {
            _adapter.adapterArray = [@[@[self.doctorInfo],@[arr.firstObject]] mutableCopy];
        }
        _adapter.adapterDelegate = self;
        _adapter.tableView = self.tableView;
    }
    return _adapter;
}

@end
