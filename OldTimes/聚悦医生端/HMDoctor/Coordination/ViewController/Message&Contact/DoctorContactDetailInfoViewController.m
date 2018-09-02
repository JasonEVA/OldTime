//
//  DoctorContactDetailInfoViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DoctorContactDetailInfoViewController.h"
#import "DoctorDetailInfoHeaderView.h"
#import "CoordinationFilterView.h"
#import "ContactGroupingManagementViewController.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "ChatIMConfigure.h"
#import "ContactInfoModel.h"
#import "DoctorCompletionInfoModel.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "LoadStaffInfoTask.h"
#import "CoordinationContactsManager.h"
#import "ServiceGroupMemberModel.h"
#import "ChatMemberCache.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

typedef NS_ENUM(NSUInteger, DoctorDetailMoreType) {
    DoctorDetailManageGroup,
    DoctorDetailDeleteFriend,
};

typedef NS_ENUM(NSUInteger, DoctorDetailButtonType) {
    DoctorDetailButtonAdd,
    DoctorDetailButtonMSG,
    DoctorDetailButtonChat,
};


@interface DoctorDetailVCModel : NSObject

@property (nonatomic, copy)  NSString  *avatarPath; // <##>
@property (nonatomic, copy)  NSString  *name; // <##>
@property (nonatomic)  NSInteger  doctorID; // <##>
@property (nonatomic, copy)  NSString  *hospital; // <##>
@property (nonatomic, copy)  NSString  *position; // <##>
@property (nonatomic, copy)  NSString  *phoneNum; // <##>
@property (nonatomic, copy)  NSString  *groupName; // <##>
@property (nonatomic)  BOOL  relation; // <##>

- (instancetype)initWithModel:(id)model;
@end

@implementation DoctorDetailVCModel

- (instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {
        if ([model isKindOfClass:[ContactInfoModel class]]) {
            self.avatarPath = ((ContactInfoModel *)model).relationInfoModel.relationAvatar ?: @""; // <##>
            self.name = ((ContactInfoModel *)model).relationInfoModel.nickName ?: @""; // <##>
            self.doctorID = ((ContactInfoModel *)model).relationInfoModel.relationName.integerValue; // <##>
            self.hospital = @""; // <##>
            self.position = @""; // <##>
            self.phoneNum = ((ContactInfoModel *)model).relationInfoModel.mobile ?: @""; // <##>
            self.groupName = @""; // <##>

        }
        else if ([model isKindOfClass:[DoctorCompletionInfoModel class]]) {
            self.avatarPath = ((DoctorCompletionInfoModel *)model).imgUrl; // <##>
            self.name = ((DoctorCompletionInfoModel *)model).staffName; // <##>
            self.doctorID = ((DoctorCompletionInfoModel *)model).userId; // <##>
            self.hospital = ((DoctorCompletionInfoModel *)model).orgName; // <##>
            self.position = ((DoctorCompletionInfoModel *)model).staffTypeName; // <##>
            self.phoneNum = @""; // <##>
            self.groupName = @""; // <##>
        }
        else if ([model isKindOfClass:[UserProfileModel class]]) {
            UserProfileModel *newModel = [[MessageManager share] queryContactProfileWithUid:((UserProfileModel *)model).userName];
            self.avatarPath = newModel.avatar ?: @""; // <##>
            self.name = ((UserProfileModel *)model).nickName; // <##>
            self.doctorID = ((UserProfileModel *)model).userName.integerValue; // <##>
            self.hospital = @""; // <##>
            self.position = @""; // <##>
            self.phoneNum = @""; // <##>
            self.groupName = @""; // <##>
        }
        else if ([model isKindOfClass:[ServiceGroupMemberModel class]]) {
            self.avatarPath = ((ServiceGroupMemberModel *)model).imgUrl; // <##>
            self.name = ((ServiceGroupMemberModel *)model).staffName; // <##>
            self.doctorID = ((ServiceGroupMemberModel *)model).userId; // <##>
            self.hospital = ((ServiceGroupMemberModel *)model).orgName; // <##>
            self.position = ((ServiceGroupMemberModel *)model).staffTypeName; // <##>
            self.phoneNum = @""; // <##>
            self.groupName = @""; // <##>

        }
        
    }
    return self;
}

- (DoctorCompletionInfoModel *)convertToDoctorCompletionInfoModel {
    DoctorCompletionInfoModel *model = [DoctorCompletionInfoModel new];
    model.imgUrl = self.avatarPath;
    model.staffName = self.name;
    model.userId = self.doctorID;
    model.orgName = self.hospital;
    model.staffTypeName = self.position;
    return model;
}

- (instancetype)convertFromStaffInfo:(StaffInfo *)model {
    self.avatarPath = model.staffIcon ?: @""; // <##>
    self.name = model.staffName ?: @""; // <##>
    self.doctorID = model.userId; // <##>
    self.hospital = model.orgName ?: @""; // <##>
    self.position = model.staffTypeName ?: @""; // <##>
    self.phoneNum = model.depPhone ?: @""; // <##>
    return self;
}

@end


@interface DoctorContactDetailInfoViewController ()<UITableViewDataSource, UITableViewDelegate,CoordinationFilterViewDelegate,TaskObserver,ContactGroupingManagementViewControllerDelegate>
@property (nonatomic, strong)  CoordinationFilterView  *filterView; // <##>

@property (nonatomic, strong)  DoctorDetailInfoHeaderView  *headerView; // <##>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy)  NSArray  *arrayTitles; // <##>
@property (nonatomic, strong)  NSMutableArray  *arrayValue; // <##>
@property (nonatomic, strong)  UIView  *footerView; // <##>

@property (nonatomic)  ContactRelationshipType  relationshipType; // <##>
@property (nonatomic, strong)  DoctorDetailVCModel  *model; // <##>
@property (nonatomic, strong)  MessageRelationGroupModel  *currentGroupInfo; // <##>
@end

@implementation DoctorContactDetailInfoViewController


- (instancetype)initWithRelationType:(ContactRelationshipType)type infoModel:(id)model
{
    self = [super init];
    if (self) {
        self.relationshipType = type;
        self.model = [[DoctorDetailVCModel alloc] initWithModel:model];
        MessageRelationInfoModel *relationModel = [[MessageManager share] queryRelationInfoWithUserID:[NSString stringWithFormat:@"%ld",self.model.doctorID]];
        if (relationModel) {
            self.model.relation = YES;
            self.relationshipType = ContactRelationshipType_friend;
            
            self.currentGroupInfo = [[CoordinationContactsManager sharedManager] getGroupInfoWithGroupID:relationModel.relationGroupId];
            self.model.groupName = self.currentGroupInfo.relationGroupName ?: @"";
        }
        if (self.model.doctorID == [MessageManager getUserID].integerValue) {
            self.relationshipType = ContactRelationshipType_none;
        }
        [self requestUserDetailData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.definesPresentationContext = YES;
    NSString *uid = [NSString stringWithFormat:@"%ld",self.model.doctorID];
    [self p_removeCache:uid];
    [self configElements];
    [self setFd_prefersNavigationBarHidden:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        if (!vc.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    });
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark - Interface Method

#pragma mark - Private Method

- (void)p_removeCache:(NSString *)uid {
    avatarRemoveCache(uid);
    removeChatMember(uid);
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] MTRequestGroupInfoWirhGroupId:uid completion:^(UserProfileModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.model = [[DoctorDetailVCModel alloc] initWithModel:model];
        [strongSelf.headerView configAvatarPath:[NSString stringWithFormat:@"%ld",(long)strongSelf.model.doctorID] name:strongSelf.model.name];
    }];
}

// 设置元素控件
- (void)configElements {
    
    if (self.relationshipType == ContactRelationshipType_friend) {
        self.arrayTitles = @[@"所属医院",@"职务",@"科室电话",@"所属分组"];
    }
    else {
        self.arrayTitles = @[@"所属医院",@"职务",@"科室电话"];
    }
    [self configTableViewData];
    [self.headerView configAvatarPath:[NSString stringWithFormat:@"%ld",(long)self.model.doctorID] name:self.model.name];
    // 设置约束
    [self configConstraints];
    

}

// 设置约束
- (void)configConstraints {
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.tableView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(15);
        make.left.right.equalTo(self.view);
    }];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.mas_equalTo(85);
    }];
}

- (void)requestUserDetailData {
    
    NSDictionary *dictParam = @{
                                @"staffUserId" : [NSString stringWithFormat:@"%ld",self.model.doctorID]
                                };
    
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([LoadStaffInfoTask class]) taskParam:dictParam TaskObserver:self];

}


- (void)configTableViewData {
    [self.arrayValue removeAllObjects];
    [self.arrayValue addObjectsFromArray:@[self.model.hospital,self.model.position,self.model.phoneNum,self.model.groupName]];

}
#pragma mark - Event Response

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMore {
    if (![self.view.subviews containsObject:self.filterView]) {
        [self.view addSubview:self.filterView];
        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else {
        [self.filterView removeFromSuperview];
        _filterView = nil;
    }
    
}

- (void)bottomButtonAction:(UIButton *)sender {
    DoctorDetailButtonType tag = (DoctorDetailButtonType)sender.tag;
    switch (tag) {
        case DoctorDetailButtonAdd: {
            [[ATModuleInteractor sharedInstance] goAddFriendsSubVCWith:[self.model convertToDoctorCompletionInfoModel]];
            break;
        }
        case DoctorDetailButtonChat: {
            // 实时语音聊天

            break;
        }
        case DoctorDetailButtonMSG: {
            
            ContactDetailModel *tempModel = [[ContactDetailModel alloc]init];
                tempModel._target = [NSString stringWithFormat:@"%ld",self.model.doctorID];
                tempModel._nickName = self.model.name;

            [[ATModuleInteractor sharedInstance] goSingleChatVCWith:tempModel chatType:IMChatTypeWorkGroup];
            break;
        }
    }
}

#pragma mark - Delegate

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
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
    
    if ([taskname isEqualToString:NSStringFromClass([LoadStaffInfoTask class])])
    {
        if ([taskResult isKindOfClass:[StaffInfo class]]) {
            
            [self.model convertFromStaffInfo:(StaffInfo *)taskResult];
            [self configTableViewData];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayTitles.count;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [UIView performWithoutAnimation:^{
        [cell layoutIfNeeded];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont font_30]];
        [cell.textLabel setTextColor:[UIColor commonBlackTextColor_333333]];
        [cell.detailTextLabel setFont:[UIFont font_30]];
        [cell.detailTextLabel setTextColor:[UIColor commonLightGrayColor_999999]];
    }
    [cell.textLabel setText:self.arrayTitles[indexPath.row]];
    [cell.detailTextLabel setText:self.arrayValue[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ContactGroupingManagementViewControllerDelegate

- (void)ContactGroupingManagementViewControllerDelegateCallBack_selectModel:(MessageRelationGroupModel *)model
{
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] transferRelationWithRelationName:[NSString stringWithFormat:@"%ld",self.model.doctorID] RelationGroupID:@(model.relationGroupId) completion:^(BOOL isSuccess) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!isSuccess) {
            [strongSelf at_postError:@"编辑分组失败"];
        }
        else {
            [strongSelf at_postSuccess:@"编辑分组成功"];
            strongSelf.model.groupName = model.relationGroupName;
            [strongSelf configTableViewData];
            [strongSelf.tableView reloadData];
        }
    }];
}

#pragma mark - filterView Delegate

- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag
{
    DoctorDetailMoreType type = (DoctorDetailMoreType)tag;
    switch (type) {
        case DoctorDetailManageGroup: {
            // 分组管理
            [[ATModuleInteractor sharedInstance] goToSelsctfriendsGroupWithDataList:[[CoordinationContactsManager sharedManager] getContatsGroupingNamesIncludeChatGroup:NO] Edit:NO delegate:self selectModel:self.currentGroupInfo];
            break;
        }
        case DoctorDetailDeleteFriend: {
            // 删除好友
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"同时会将我从对方的好友列表中删除，且不再接收此人消息" preferredStyle:UIAlertControllerStyleActionSheet];
            __weak typeof(self) weakSelf = self;

            UIAlertAction *actionDel = [UIAlertAction actionWithTitle:@"删除好友" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakSelf) strongSelf = weakSelf;

                // 删除并退出
                [[MessageManager share] deleteRelationWithUid:[NSString stringWithFormat:@"%ld",strongSelf.model.doctorID] completion:^(BOOL success) {
                    [strongSelf.navigationController setNavigationBarHidden:NO animated:NO];
                    [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                }];

            }];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // 取消
            }];
            [alertController addAction:actionDel];
            [alertController addAction:actionCancel];
            
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
    }
    
}


#pragma mark - Override

#pragma mark - Init

- (DoctorDetailInfoHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DoctorDetailInfoHeaderView alloc] init];
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:btnBack];
        [btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView);
            make.top.equalTo(_headerView).offset(20);
            make.width.equalTo(@43);
            make.height.equalTo(@29);
        }];
        
        if (self.relationshipType == ContactRelationshipType_friend) {
            UIButton *btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnMore setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
            [btnMore addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:btnMore];
            [btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_headerView);
                make.centerY.equalTo(btnBack);
                make.width.equalTo(@43);
                make.height.equalTo(@29);
            }];
        }
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        _tableView.bounces = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (CoordinationFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[CoordinationFilterView alloc] initWithImageNames:@[@"c_manageGroup",@"c_delFriend"] titles:@[@"分组管理",@"删除好友"] tags:@[@(DoctorDetailManageGroup),@(DoctorDetailDeleteFriend)] topOffset:40];
        _filterView.delegate = self;
    }
    return _filterView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [UIView new];
        _footerView.backgroundColor = [UIColor whiteColor];
        NSArray *arrayTitle = @[@"加好友",@"发消息",@"通话"];
        NSArray<NSNumber *> *arrayTag;
        
        // 隐藏通话
        switch (self.relationshipType) {
            case ContactRelationshipType_friend: {
//                arrayTag = @[@(DoctorDetailButtonChat),@(DoctorDetailButtonMSG)];
                arrayTag = @[@(DoctorDetailButtonMSG)];

                break;
            }
            case ContactRelationshipType_groupMember: {
//                arrayTag = @[@(DoctorDetailButtonAdd),@(DoctorDetailButtonChat),@(DoctorDetailButtonMSG)];
                arrayTag = @[@(DoctorDetailButtonAdd),@(DoctorDetailButtonMSG)];

                break;
            }
            case ContactRelationshipType_stranger: {
                arrayTag = @[@(DoctorDetailButtonAdd)];
                break;
            }
            case ContactRelationshipType_none: {
                
                break;
            }
        }
        UIButton *lastBtn;
        for (NSInteger i = 0; i < arrayTag.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
            [btn setTitle:arrayTitle[arrayTag[i].integerValue] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont font_30]];
            btn.tag = (DoctorDetailButtonType)arrayTag[i].unsignedIntegerValue;
            btn.layer.borderColor = [UIColor mainThemeColor].CGColor;
            btn.layer.borderWidth = 1.0;
            btn.layer.cornerRadius = 2.5;
            btn.clipsToBounds = YES;
            [btn addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_footerView addSubview:btn];
            if (i == 0) {
                if (arrayTag.count == 1) {
                    [btn setBackgroundImage:[UIImage at_imageWithColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_footerView).offset(12.5);
                    make.bottom.equalTo(_footerView).offset(-20);
                    make.right.equalTo(_footerView).offset(-12.5).priorityMedium();
                    make.height.mas_equalTo(45).priorityMedium();

                }];
            }
            else if (i == arrayTag.count - 1) {
                [btn setBackgroundImage:[UIImage at_imageWithColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastBtn.mas_right).offset(10);
                    make.right.equalTo(_footerView).offset(-13);
                    make.bottom.equalTo(_footerView).offset(-20);
                    make.width.equalTo(lastBtn);
                    make.height.equalTo(lastBtn);
                    make.height.mas_equalTo(45);
                }];
            } else {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastBtn.mas_right).offset(10);
                    make.bottom.equalTo(_footerView).offset(-20);
                    make.width.equalTo(lastBtn);
                    make.height.equalTo(lastBtn);
                }];
 
            }
            
            lastBtn = btn;

        }
    }
    return _footerView;
}

- (NSMutableArray *)arrayValue {
    if (!_arrayValue) {
        _arrayValue = [NSMutableArray array];
    }
    return _arrayValue;
}
@end
