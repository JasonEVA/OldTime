//
//  CreateWorkCircleViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CreateWorkCircleViewController.h"
#import "CoordinationContactsAdapter.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "CoordinationContactsManager.h"
#import "SelectContactTabbarView.h"
#import "CoordinationContactTableViewCell.h"

@interface CreateWorkCircleViewController ()<CoordinationContactsAdapterDelegate>

@property (nonatomic, strong)  CoordinationContactsAdapter  *contactAdapter; // <##>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  UIButton  *selectFromGroup; // <##>
@property (nonatomic, strong)  SelectContactTabbarView  *selectView; //

@property (nonatomic, copy)  NSArray  *arrayNonSelectableContacts; // <##>

@end

@implementation CreateWorkCircleViewController

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
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.contactAdapter configSelectContacts:self.selectView.arraySelect reload:YES];
    [self configSelectData];
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
    
    [self.view addSubview:self.selectFromGroup];
    [self.view addSubview:self.tableView];

    [self.selectFromGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectFromGroup.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(self.view);
    }];

}

// 设置内容数据
- (void)configData {
    [self at_postLoading];
    NSArray<MessageRelationGroupModel *> *sectionData = [[CoordinationContactsManager sharedManager] getContatsGroupingNamesIncludeChatGroup:NO];
    __block NSInteger dataCount = 0;
    __weak typeof(self) weakSelf = self;
    [sectionData enumerateObjectsUsingBlock:^(MessageRelationGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[CoordinationContactsManager sharedManager] getContactsWithWithRelationGroup:obj.relationGroupId completion:^(long groupID, NSArray *contacts) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            ++dataCount;

            NSMutableArray *arrayContacts = [NSMutableArray arrayWithCapacity:contacts.count];
            for (id cellData in contacts) {
                ContactInfoModel *model;
                if ([cellData isKindOfClass:[ContactInfoModel class]]) {
                    model = (ContactInfoModel *)cellData;
                }
                else if ([cellData isKindOfClass:[UserProfileModel class]]) {
                    model = [[ContactInfoModel alloc] initWithUserProfileModel:cellData];
                }
                else if ([cellData isKindOfClass:[ContactDetailModel class]]) {
                    model = [[ContactInfoModel alloc] initWithContactDetailModel:cellData];
                }
                else if ([cellData isKindOfClass:[MessageRelationInfoModel class]]) {
                    model = [[ContactInfoModel alloc] initWithMessageRelationInfoModel:cellData];
                }
                else if ([cellData isKindOfClass:[SuperGroupListModel class]]) {
                    model = [[ContactInfoModel alloc] initWithSuperGroupListModel:cellData];
                }
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationInfoModel.relationName == %@", model.relationInfoModel.relationName];
                NSArray *arrayTemp = [strongSelf.arrayNonSelectableContacts filteredArrayUsingPredicate:predicate];
                NSArray *arrayTemp2 = [strongSelf.selectView.arraySelect filteredArrayUsingPredicate:predicate];
                if (arrayTemp.count > 0) {
                    model.nonSelectable = YES;
                }
                if (arrayTemp2.count > 0) {
                    model.selected = YES;
                }
                if (model) {
                    [arrayContacts addObject:model];
                }
            }
            
            if (obj.relationGroupId == groupID) {
                obj.relationList = arrayContacts;
            }
            else {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationGroupId == %ld",groupID];
                NSArray<MessageRelationGroupModel *> *temp = [sectionData filteredArrayUsingPredicate:predicate];
                if (temp.count > 0) {
                    temp.firstObject.relationList = arrayContacts;
                }
            }
            if (dataCount == sectionData.count) {
                strongSelf.contactAdapter.adapterArray = [sectionData mutableCopy];
                [strongSelf.tableView reloadData];
                [strongSelf at_hideLoading];
            }
        }];
    }];
}

// 配置选择数据
- (void)configSelectData {
    // 监听tabbarView删除事件
    __weak typeof(self) weakSelf = self;
    [self.selectView addTabbarViewDeleteContactNoti:^(ContactInfoModel *deleteModel) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationInfoModel.relationName == %@",deleteModel.relationInfoModel.relationName];
        [strongSelf.contactAdapter.adapterArray enumerateObjectsUsingBlock:^(MessageRelationGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *temp = [obj.relationList filteredArrayUsingPredicate:predicate];
            if (temp.count > 0) {
                ContactInfoModel *model = temp.firstObject;
                model.selected = NO;
                [strongSelf.tableView reloadData];
                
                *stop = YES;
            }
        }];
        [strongSelf.contactAdapter configSelectContacts:strongSelf.selectView.arraySelect reload:NO];
    }];

}
#pragma mark - Event Response

// 从群/工作圈中选择
- (void)createFromGroupOrWorkCircle {
    [[ATModuleInteractor sharedInstance] goCreateWorkCircleFromGroupWithSelectView:self.selectView nonSelectableContacts:self.arrayNonSelectableContacts];
}

#pragma mark - Delegate

#pragma mark - CoordinationContactsAdapterDelegate

- (void)coordinationContactsAdapterDelegateCallBack_selectContact:(NSArray *)selectedContacts selectState:(BOOL)selectState {
    if (selectState) {
        [self.selectView addPeople:selectedContacts];
    }
    else {
        [self.selectView deletePeople:selectedContacts];
    }
    [self.contactAdapter configSelectContacts:self.selectView.arraySelect reload:NO];
}

#pragma mark - Override

#pragma mark - Init


- (CoordinationContactsAdapter *)contactAdapter {
    if (!_contactAdapter) {
        _contactAdapter = [[CoordinationContactsAdapter alloc] initWithSelectType:ContactsSelectTypeMutableSelect selectedContacts:nil nonSelectableContacts:self.arrayNonSelectableContacts];
        _contactAdapter.tableView = self.tableView;
        _contactAdapter.customeDelegate = self;
        _contactAdapter.onlyRelations = YES;
        [_contactAdapter configSelectContacts:self.selectView.arraySelect reload:YES];
    }
    return _contactAdapter;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.contactAdapter;
        _tableView.dataSource = self.contactAdapter;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[CoordinationContactTableViewCell class] forCellReuseIdentifier:[CoordinationContactTableViewCell at_identifier]];
    }
    return _tableView;
}

- (UIButton *)selectFromGroup {
    if (!_selectFromGroup) {
        _selectFromGroup = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectFromGroup setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_selectFromGroup setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        [_selectFromGroup.titleLabel setFont:[UIFont font_30]];
        [_selectFromGroup setTitleColor:[UIColor commonBlackTextColor_333333] forState:UIControlStateNormal];
        [_selectFromGroup setBackgroundImage:[UIImage at_imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_selectFromGroup setTitle:@"从群/工作圈中选择" forState:UIControlStateNormal];
        [_selectFromGroup addTarget:self action:@selector(createFromGroupOrWorkCircle) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"c_rightArrow"]];
        [_selectFromGroup addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_selectFromGroup);
            make.right.equalTo(_selectFromGroup).offset(-13);
        }];

    }
    return _selectFromGroup;
}

@end
