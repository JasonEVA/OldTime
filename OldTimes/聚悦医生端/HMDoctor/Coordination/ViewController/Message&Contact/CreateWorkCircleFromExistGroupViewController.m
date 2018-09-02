//
//  CreateWorkCircleFromExistGroupViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CreateWorkCircleFromExistGroupViewController.h"
#import "RowButtonGroup.h"
#import "SelectContactTabbarView.h"
#import "ContactsMainTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ContactInfoModel.h"
#import "CoordinationContactsManager.h"
#import "CreateWorkCircleFromGroupAdapter.h"
#import "CoordinationContactsManager.h"
#import "ATModuleInteractor+CoordinationInteractor.h"

typedef NS_ENUM(NSUInteger, CreateWorkCircleCategory) {
    CategoryServiceGroup,
    CategoryWorkCircle,
};


@interface CreateWorkCircleFromExistGroupViewController ()<RowButtonGroupDelegate,ATTableViewAdapterDelegate>

@property (nonatomic, strong)  RowButtonGroup  *buttonGroup; // <##>
@property (nonatomic, strong)  UIBarButtonItem  *createItem; // <##>
@property (nonatomic, strong)  CreateWorkCircleFromGroupAdapter  *groupAdapter; // <##>
@property (nonatomic, strong)  SelectContactTabbarView  *selectView; // <##>

@property (nonatomic, strong)  UITableView  *tableView; // <##>

@property (nonatomic, copy)  NSArray  *arrayNonSelectableContacts; // <##>
@property (nonatomic, copy)  NSArray  *arraySuperGroups; // <##>
@property (nonatomic, copy)  NSArray  *arrayWorkCircle; // <##>
@end

@implementation CreateWorkCircleFromExistGroupViewController

- (instancetype)initWithSelectView:(SelectContactTabbarView *)selectView nonSelectableContacts:(NSArray *)array {
    self = [super init];
    if (self) {
        self.selectView = selectView;
        self.arrayNonSelectableContacts = array;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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
    [self.view addSubview:self.buttonGroup];
    [self.view addSubview:self.tableView];

    [self.buttonGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonGroup.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

// 设置数据
- (void)configData {
    [self configSuperGroupData];
    [self configWorkCircleData];
}

- (void)configSuperGroupData {
    __weak typeof(self) weakSelf = self;
    [[CoordinationContactsManager sharedManager] getSuperGroupsDataWithCompletion:^(long groupID, NSArray *contacts) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.arraySuperGroups = contacts;
        if (strongSelf.buttonGroup.selectedBtn.tag == CategoryServiceGroup) {
            strongSelf.groupAdapter.adapterArray = [strongSelf.arraySuperGroups mutableCopy];
            [strongSelf.tableView reloadData];
        }
    }];
}

- (void)configWorkCircleData {
    __weak typeof(self) weakSelf = self;
    [[CoordinationContactsManager sharedManager] getNormalGroupsDataWithCompletion:^(long groupID, NSArray *contacts) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.arrayWorkCircle = contacts;
        if (strongSelf.buttonGroup.selectedBtn.tag == CategoryWorkCircle) {
            strongSelf.groupAdapter.adapterArray = [strongSelf.arrayWorkCircle mutableCopy];
            [strongSelf.tableView reloadData];
        }

    }];
}
#pragma mark - Event Response


#pragma mark - Delegate

#pragma mark - rowBtnGroupDelegate

// 正反面点击委托
- (void)RowButtonGroupDelegateCallBack_btnClickedWithTag:(NSInteger)tag {
    CreateWorkCircleCategory index = (CreateWorkCircleCategory)tag;
    switch (index) {
        case CategoryServiceGroup: {
            // 群
            self.groupAdapter.adapterArray = [self.arraySuperGroups mutableCopy];
            [self.tableView reloadData];
            break;
        }
        case CategoryWorkCircle: {
            // 工作圈
            self.groupAdapter.adapterArray = [self.arrayWorkCircle mutableCopy];
            [self.tableView reloadData];
            break;
        }
    }
}

#pragma mark - ATTableViewAdapterDelegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    NSString *groupTarget = @"";
    if ([cellData isKindOfClass:[UserProfileModel class]]) {
        groupTarget = ((UserProfileModel *)cellData).userName;
    }
    else if ([cellData isKindOfClass:[SuperGroupListModel class]]) {
        groupTarget = ((SuperGroupListModel *)cellData).userName;
    }
    [[ATModuleInteractor sharedInstance] goGroupContactMemberListWithGroupID:groupTarget selectView:self.selectView nonSelectableContacts:self.arrayNonSelectableContacts singleSelect:NO];
}


#pragma mark - Override

#pragma mark - Init

- (RowButtonGroup *)buttonGroup {
    if (!_buttonGroup) {
        _buttonGroup = [[RowButtonGroup alloc] initWithTitles:@[@"我的服务群",@"工作圈"] tags:@[@(CategoryServiceGroup),@(CategoryWorkCircle)] normalTitleColor:[UIColor commonDarkGrayColor_666666] selectedTitleColor:[UIColor mainThemeColor] font:[UIFont font_30] lineColor:[UIColor mainThemeColor]];
        [_buttonGroup setBackgroundColor:[UIColor whiteColor]];
        [_buttonGroup setDelegate:self];
        
    }
    return _buttonGroup;
}

- (CreateWorkCircleFromGroupAdapter *)groupAdapter {
    if (!_groupAdapter) {
        _groupAdapter = [CreateWorkCircleFromGroupAdapter new];
        _groupAdapter.adapterDelegate = self;
    }
    return _groupAdapter;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.groupAdapter;
        _tableView.dataSource = self.groupAdapter;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell at_identifier]];
    }
    return _tableView;
}

@end
