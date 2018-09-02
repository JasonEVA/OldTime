//
//  ContactGroupingManagementViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ContactGroupingManagementViewController.h"
#import "ContactGroupingmanagementAdapter.h"
#import "CoordinationModalViewController.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "CoordinationContactsManager.h"
@interface ContactGroupingManagementViewController ()<ATTableViewAdapterDelegate,CoordinationModalViewControllerDelegate>
@property (nonatomic, strong)  UIButton  *btnAddGroup; // <##>
@property (nonatomic, strong)  ContactGroupingmanagementAdapter  *adapter; // <##>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  UITextField  *myInputView;
@property (nonatomic) BOOL isAdd;
@end

@implementation ContactGroupingManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"分组管理"];
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
    if (self.managementStatus) {
        UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction)];
        [self.navigationItem setRightBarButtonItem:finishItem];
    }
    
    [self.view addSubview:self.btnAddGroup];
    [self.view addSubview:self.tableView];
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.btnAddGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view).insets(UIEdgeInsetsMake(15, 0, 0, 0));
        make.height.mas_equalTo(60);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.btnAddGroup.mas_bottom);
    }];
}

// 设置数据
- (void)configData {
    
}

- (void)showAlertViewWithAddGroup:(BOOL)add {
    self.isAdd = add;
    CoordinationModalViewController *VC = [[CoordinationModalViewController alloc] initWithTitle:add ? @"添加分组" : @"编辑分组" message:@"请输入分组名称" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];

    if (!add) {
        self.myInputView.text = self.selectModel.relationGroupName;
    }
    [VC addInputView:self.myInputView height:37.5];

    [self presentViewController:VC animated:YES completion:nil];
    
    
}

#pragma mark - Event Response

- (void)finishAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addGroupAction {
    [self showAlertViewWithAddGroup:YES];
}


#pragma mark - Delegate

#pragma mark - Adapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    if (self.managementStatus) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.relationGroupName IN {'专家组','工作圈','我的好友','黑名单'}"];
        if ([predicate evaluateWithObject:cellData]) {
            return;
        }
        self.selectModel = self.adapter.adapterArray[indexPath.row];
        [self showAlertViewWithAddGroup:NO];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(ContactGroupingManagementViewControllerDelegateCallBack_selectModel:)]) {
            [self.delegate ContactGroupingManagementViewControllerDelegateCallBack_selectModel:cellData];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)deleteCellData:(id)cellData indexPath:(NSIndexPath *)indexPath {
    MessageRelationGroupModel *model = (MessageRelationGroupModel *)cellData;
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] deleteRelationGroupWithRelationGroupId:model.relationGroupId completion:^(BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!success) {
            [strongSelf at_postError:@"删除分组失败"];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
        [strongSelf.adapter.adapterArray removeObjectAtIndex:indexPath.row];
        [strongSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];

}

#pragma mark - CoordinationModalViewControllerDelegate

- (void)coordinationModalViewControllerDelegateCallBack_clickedButtonAtIndex:(NSInteger)buttonIndex Tag:(NSInteger)tag {
    if (buttonIndex) {
        //确定
        if (self.myInputView.text.length > 0) {
            if (self.isAdd) {
                //添加分组
                __weak typeof(self) weakSelf = self;
                [[MessageManager share] createRelationGroupWithName:self.myInputView.text completion:^(MessageRelationGroupModel *model, BOOL success) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (!success) {
                        [strongSelf at_postError:@"新增分组失败"];
                        return;
                    }

                    [[MessageManager share] loadRelationGroupInfoWithTotalFlag:NO Completion:^(BOOL success) {
                        if (!success) {
                            [strongSelf at_postError:@"更新联系人失败"];
                            return;
                        }
                        strongSelf.adapter.adapterArray = [[[CoordinationContactsManager sharedManager] getContatsGroupingNamesIncludeChatGroup:YES] mutableCopy];
                        [strongSelf.tableView reloadData];
                    }];
                }];
            } else {
                //编辑分组
                self.selectModel.relationGroupName = self.myInputView.text;
                __weak typeof(self) weakSelf = self;
                [[MessageManager share] modifyRelationGroupInfoGroupModel:self.selectModel comletion:^(BOOL success) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (!success) {
                        [strongSelf at_postError:@"编辑分组失败"];
                        return;
                    }

                    //刷新本地数据库中好友数据
                    [[MessageManager share] loadRelationGroupInfoWithTotalFlag:NO Completion:^(BOOL success) {
                        if (!success) {
                            [strongSelf at_postError:@"更新联系人失败"];
                            return;
                        }
                        strongSelf.adapter.adapterArray = [[[CoordinationContactsManager sharedManager] getContatsGroupingNamesIncludeChatGroup:YES] mutableCopy];
                        [strongSelf.tableView reloadData];
                    }];
                }];
            }
            
            
        } else {
            [self at_postError:@"分组名不能为空"];
        }
    }
}

#pragma mark - Override

#pragma mark - Init

- (UIButton *)btnAddGroup {
    if (!_btnAddGroup) {
        _btnAddGroup = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAddGroup.backgroundColor = [UIColor whiteColor];
        _btnAddGroup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btnAddGroup setImageEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
        [_btnAddGroup setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];

        [_btnAddGroup setImage:[UIImage imageNamed:@"c_addGroup"] forState:UIControlStateNormal];
        [_btnAddGroup setTitle:@"添加分组" forState:UIControlStateNormal];
        [_btnAddGroup setTitleColor:[UIColor commonBlackTextColor_333333] forState:UIControlStateNormal];
        [_btnAddGroup.titleLabel setFont:[UIFont font_30]];
        [_btnAddGroup addTarget:self action:@selector(addGroupAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAddGroup;
}

- (ContactGroupingmanagementAdapter *)adapter {
    if (!_adapter) {
        _adapter = [ContactGroupingmanagementAdapter new];
        _adapter.adapterDelegate = self;
        _adapter.tableView = self.tableView;
        _adapter.selectModel = self.selectModel;
        _adapter.adapterArray = [self.arrayData mutableCopy];
        _adapter.managementStatus = self.managementStatus;
    }
    return _adapter;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.rowHeight = 45;
        _tableView.editing = self.managementStatus;
        _tableView.bounces = NO;
        _tableView.allowsSelectionDuringEditing = YES;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell at_identifier]];
    }
    return _tableView;
}

- (UITextField *)myInputView
{
    if (!_myInputView) {
        _myInputView = [[UITextField alloc] init];
        _myInputView.placeholder = @"请输入分组名";
        _myInputView.layer.borderColor = [UIColor commonLightGrayColor_ebebeb].CGColor;
        _myInputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _myInputView.leftViewMode = UITextFieldViewModeAlways;
        _myInputView.layer.borderWidth = 0.5;
        _myInputView.layer.cornerRadius = 2.5;
        [_myInputView setTextColor:[UIColor commonBlackTextColor_333333]];
        [_myInputView setFont:[UIFont font_30]];
        _myInputView.clipsToBounds = YES;
    }
    return _myInputView;
}

- (MessageRelationGroupModel *)selectModel
{
    if (!_selectModel) {
        _selectModel = [MessageRelationGroupModel new];
    }
    return _selectModel;
}
@end
