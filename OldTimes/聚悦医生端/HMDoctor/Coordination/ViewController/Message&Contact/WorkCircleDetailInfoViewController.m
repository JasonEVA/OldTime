//
//  WorkCircleDetailInfoViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "WorkCircleDetailInfoViewController.h"
#import "WorkCircleDetailInfoAdapter.h"
#import "BaseInputTableViewCell.h"
#import "WorkCircleMembersTableViewCell.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "ChatIMConfigure.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ContactInfoModel.h"
#import "IMMessageHandlingCenter.h"

@interface WorkCircleDetailInfoViewController ()<ATTableViewAdapterDelegate,WorkCircleDetailInfoAdapterDelegate,MessageManagerDelegate>

@property (nonatomic, strong)  WorkCircleDetailInfoAdapter  *adapter; // <##>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  UIView *footerView; // <##>
@property (nonatomic, strong)  UserProfileModel  *infoModel; // <##>
@property (nonatomic, strong)  NSMutableArray  *arrayNonSelectableContacts; // <##>
@end

@implementation WorkCircleDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"工作圈"];
    [self configElements];

    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 注册委托
    [[IMMessageHandlingCenter sharedInstance] registerDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    // 移除委托
    [[IMMessageHandlingCenter sharedInstance] deregisterDelegate:self];
}
#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
    
    // 监听群信息改变
    [self groupInfoChangedNoti];
}

// 设置约束
- (void)configConstraints {
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

// 设置数据
- (void)configData {
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] querySessionDataWithUid:self.workCircleID completion:^(ContactDetailModel *contactModel) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.adapter configContactDetailModel:contactModel];
    }];
    
    [self at_postLoading];
    [[MessageManager share] MTRequestGroupInfoWirhGroupId:self.workCircleID completion:^(UserProfileModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf at_hideLoading];
        if (model) {
            strongSelf.infoModel = model;
            [strongSelf.adapter configUserProfileModel:strongSelf.infoModel];
            [strongSelf.tableView reloadData];
        }
    }];

   
}


#pragma mark - Event Response


- (void)groupInfoChangedNoti {
    __weak typeof(self) weakSelf = self;
    [self.adapter addGroupNameNoti:^(BOOL end, NSString *newName, NSString *oldName) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [[MessageManager share] groupSessionUid:strongSelf.infoModel.userName changeName:newName];
    }];
    [self.adapter addMessageReminderNoti:^(BOOL switchState) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [[MessageManager share] groupSessionUid:strongSelf.infoModel.userName receiveMode:(!switchState ? kUserProfileReceiveNormal : kUserProfileReceiveAccept) completion:^(BOOL success) {
            if (!success) {
                return ;
            }
            [strongSelf at_hideLoading];
        }];
        [strongSelf at_postLoading];

    }];
    
}

- (void)quitWorkCircle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"删除工作圈后您将不再接收到该工作圈的消息" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *actionQuit = [UIAlertAction actionWithTitle:@"删除并退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [[MessageManager share] groupSessionUid:strongSelf.infoModel.userName deleteMemberId:[MessageManager getUserID] completion:^(BOOL success) {
            if (!success) {
                return;
            }
            // 删除并退出
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 取消
    }];
    
    [alertController addAction:actionQuit];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - Delegate

#pragma mark - MessageManagerDelegate

/**
 *  联系人、群信息改变刷新回调
 *
 *  联系人姓名、群成员增删等
 *
 *  @param userProfile
 */
- (void)MessageManagerDelegateCallBack_refreshContactProfileRefresh:(UserProfileModel *)userProfile {
    if (![userProfile.userName isEqualToString:self.workCircleID]) {
        return;
    }
    self.infoModel = [[MessageManager share] queryContactProfileWithUid:self.workCircleID];
    [self.adapter configUserProfileModel:self.infoModel];
    [self.tableView reloadData];
}

#pragma mark - WorkCircleDetailInfoAdapterDelegate

- (void)workCircleDetailInfoAdapterDelegateCallBack_addMemberClicked {

    [[ATModuleInteractor sharedInstance] goCreateWorkCircleIsCreate:NO nonSelectableContacts:self.arrayNonSelectableContacts workCircleID:self.infoModel.userName];
}

- (void)workCircleDetailInfoAdapterDelegateCallBack_circleMemberClickedWithModel:(UserProfileModel *)model {
    [[ATModuleInteractor sharedInstance] goDoctorDetailInfoWithRelationType:ContactRelationshipType_stranger model:model];
}

#pragma mark - Override

#pragma mark - Init

- (WorkCircleDetailInfoAdapter *)adapter {
    if (!_adapter) {
        _adapter = [WorkCircleDetailInfoAdapter new];
        _adapter.adapterArray = [@[@[@""],@[@""],@[@""]] mutableCopy];
        _adapter.adapterDelegate = self;
        _adapter.customDelegate = self;
        _adapter.tableView = self.tableView;
    }
    return _adapter;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        [_tableView registerClass:[BaseInputTableViewCell class] forCellReuseIdentifier:[BaseInputTableViewCell at_identifier]];
        [_tableView registerClass:[WorkCircleMembersTableViewCell class] forCellReuseIdentifier:[WorkCircleMembersTableViewCell at_identifier]];

        [_tableView setTableFooterView:self.footerView];
    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 125)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 2.5;
        btn.clipsToBounds = YES;
        [btn setBackgroundImage:[UIImage at_imageWithColor:[UIColor commonRedColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont font_30]];
        [btn setTitle:@"删除并退出" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(quitWorkCircle) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_footerView);
            make.left.right.equalTo(_footerView).insets(UIEdgeInsetsMake(0, 12.5, 0, 12.5));
            make.height.mas_equalTo(45);
        }];
        
    }
    return _footerView;
}

- (NSMutableArray *)arrayNonSelectableContacts {
    if (!_arrayNonSelectableContacts) {
        _arrayNonSelectableContacts = [NSMutableArray arrayWithCapacity:self.infoModel.memberList.count];
        for (UserProfileModel *profile in self.infoModel.memberList) {
            ContactInfoModel *model = [[ContactInfoModel alloc] initWithUserProfileModel:profile];
            [_arrayNonSelectableContacts addObject:model];
        }
    }
    return _arrayNonSelectableContacts;
}
@end
