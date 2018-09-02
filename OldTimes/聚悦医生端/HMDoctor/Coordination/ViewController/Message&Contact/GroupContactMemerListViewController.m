//
//  GroupContactMemerListViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GroupContactMemerListViewController.h"
#import "SelectContactTabbarView.h"
#import "ContactCellAdapter.h"
#import "CoordinationContactTableViewCell.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "ContactInfoModel.h"
#import "CreateWorkCircleBaseViewController.h"
@interface GroupContactMemerListViewController ()<ATTableViewAdapterDelegate>
@property (nonatomic, strong)  SelectContactTabbarView  *selectView; //
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  ContactCellAdapter  *adapter; // <##>

@property (nonatomic, copy)  NSString  *groupID; // 群组ID
@property (nonatomic, copy)  NSArray  *arrayNonSelectableContacts; // <##>
@property (nonatomic)  BOOL  singleSelect; // <##>

@property (nonatomic, strong)  UserProfileModel  *infoModel; // <##>
@property (nonatomic, strong)  NSMutableArray  *dataSource; // <##>
@end

@implementation GroupContactMemerListViewController

- (instancetype)initWithGroupID:(NSString *)groupID selectView:(SelectContactTabbarView *)selectView nonSelectableContacts:(NSArray *)array singleSelect:(BOOL)singleSelect {
    
    self = [super init];
    if (self) {
        self.groupID = groupID;
        self.selectView = selectView;
        self.arrayNonSelectableContacts = array;
        self.singleSelect = singleSelect;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
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
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
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
    // 获取人员列表
    [self at_postLoading];
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] MTRequestGroupInfoWirhGroupId:self.groupID completion:^(UserProfileModel *model) {
        [self at_hideLoading];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.infoModel = model;
        
        for (UserProfileModel *sourceModel in strongSelf.infoModel.memberList) {
            ContactInfoModel *model = [[ContactInfoModel alloc] initWithUserProfileModel:sourceModel];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationInfoModel.relationName == %@",model.relationInfoModel.relationName];
            NSArray *nonArray = [strongSelf.arrayNonSelectableContacts filteredArrayUsingPredicate:predicate];
            NSArray *selectedArray = [strongSelf.selectView.arraySelect filteredArrayUsingPredicate:predicate];
            if (nonArray.count > 0) {
                model.nonSelectable = YES;
            }
            if (selectedArray.count > 0) {
                model.selected = YES;
            }
            
            [strongSelf.dataSource addObject:model];
        }
        [strongSelf.tableView reloadData];


        // 监听tabbarView删除事件
        [self.selectView addTabbarViewDeleteContactNoti:^(ContactInfoModel *deleteModel) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationInfoModel.relationName == %@",deleteModel.relationInfoModel.relationName];
            NSArray *temp = [strongSelf.adapter.adapterArray filteredArrayUsingPredicate:predicate];
            if (temp.count > 0) {
                ContactInfoModel *model = temp.firstObject;
                model.selected = NO;
                [strongSelf.tableView reloadData];
            }
        }];

    }];
    
    
}

#pragma mark - Event Response
- (void)rightClick {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[CreateWorkCircleBaseViewController class]]) {
            CreateWorkCircleBaseViewController *revise =(CreateWorkCircleBaseViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
}

#pragma mark - Delegate

#pragma mark - adapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    ContactInfoModel *model = (ContactInfoModel *)cellData;
    if (model.selected) {
        [self.selectView addPeople:@[model]];
    }
    else {
        [self.selectView deletePeople:@[model]];
    }
}

#pragma mark - Override

#pragma mark - Init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[CoordinationContactTableViewCell class] forCellReuseIdentifier:[CoordinationContactTableViewCell at_identifier]];
    }
    return _tableView;
}

- (ContactCellAdapter *)adapter {
    if (!_adapter) {
        _adapter = [ContactCellAdapter new];
        _adapter.adapterDelegate = self;
        _adapter.selectable = YES;
        _adapter.adapterArray = self.dataSource;
    }
    return _adapter;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
