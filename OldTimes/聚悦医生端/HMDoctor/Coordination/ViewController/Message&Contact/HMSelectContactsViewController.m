//
//  HMSelectContactsViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/7/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSelectContactsViewController.h"
#import "CoordinationContactsAdapter.h"
#import "CoordinationContactsManager.h"
#import "ContactInfoModel.h"
#import "CoordinationContactTableViewCell.h"
@interface HMSelectContactsViewController ()<ATTableViewAdapterDelegate,CoordinationContactsAdapterDelegate>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  CoordinationContactsAdapter  *contactAdapter; // <##>
@property (nonatomic, copy)  selectFromAllContactsCompletion  selectCompletion; // <##>
@end

@implementation HMSelectContactsViewController


- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople completion:(selectFromAllContactsCompletion)completion {
    self = [super init];
    if (self) {
        [self.selectedPeople addObjectsFromArray:selectedPeople];
        self.selectCompletion = completion;
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
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

// 设置数据
- (void)configData {
    [self at_postLoading];
    NSArray<MessageRelationGroupModel *> *sectionData = [[CoordinationContactsManager sharedManager] getContatsGroupingNamesIncludeChatGroup:YES];
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
                NSArray *arrayTemp2 = [strongSelf.selectedPeople filteredArrayUsingPredicate:predicate];
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
#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - CoordinationContactsAdapterDelegate

- (void)coordinationContactsAdapterDelegateCallBack_selectContact:(NSArray *)selectedContacts selectState:(BOOL)selectState {
    if (selectState) {
        [self.selectedPeople addObjectsFromArray:selectedContacts];
    }
    else {
        for (ContactInfoModel *model in selectedContacts) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationInfoModel.relationName == %@", model.relationInfoModel.relationName];
            NSArray *temp = [self.selectedPeople filteredArrayUsingPredicate:predicate];
            if (temp.count > 0) {
                [self.selectedPeople removeObject:temp.firstObject];
            }
        }
    }
    
    if (self.selectCompletion) {
        self.selectCompletion(self.selectedPeople);
    }
}
#pragma mark - Override

#pragma mark - Init

- (NSMutableArray *)selectedPeople {
    if (!_selectedPeople) {
        _selectedPeople = [NSMutableArray array];
    }
    return _selectedPeople;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.contactAdapter;
        _tableView.dataSource = self.contactAdapter;
        _tableView.rowHeight = 60;
        [_tableView setTableFooterView:[UIView new]];
        [_tableView registerClass:[CoordinationContactTableViewCell class] forCellReuseIdentifier:[CoordinationContactTableViewCell at_identifier]];
    }
    return _tableView;
}

- (CoordinationContactsAdapter *)contactAdapter {
    if (!_contactAdapter) {
        _contactAdapter = [[CoordinationContactsAdapter alloc] initWithSelectType:ContactsSelectTypeMutableSelect selectedContacts:self.selectedPeople nonSelectableContacts:nil];
        _contactAdapter.tableView = self.tableView;
        _contactAdapter.customeDelegate = self;
    }
    return _contactAdapter;
}

@end
