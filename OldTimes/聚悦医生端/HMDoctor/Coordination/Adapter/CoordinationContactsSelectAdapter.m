//
//  CoordinationContactsSelectAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationContactsSelectAdapter.h"
#import "ContactSelectButton.h"
#import "CoordinationContactTableViewCell.h"
#import "ServiceGroupMemberModel.h"
#import "PatientInfo.h"
#import "PatientInfo+SelectEX.h"

@interface CoordinationContactsSelectAdapter ()<ContactSelectButtonDelegate>

@property (nonatomic)  ContactsSelectType  selectType; // <##>

//@property (nonatomic, strong)  NSMutableArray  *arraySelectedContacts; // 已选的人，可以修改
@property (nonatomic, copy)  NSArray  *nonSelectable; // 不可选择人员列表，不可修改
@property (nonatomic, strong)  NSMutableArray<ContactSelectButton *>  *arrayButtons; // <##>

@property (nonatomic, strong)  NSMutableDictionary<NSNumber * , NSNumber *>  *dictNumberRow; // <##>
@property (nonatomic, strong)  NSMutableArray<NSIndexPath *>  *arraySelectedIndexPath; // <##>
@end

@implementation CoordinationContactsSelectAdapter

- (instancetype)initWithSelectType:(ContactsSelectType)selectType selectedContacts:(NSArray *)selectedContacts nonSelectableContacts:(NSArray *)nonSelectableContacts {
    self = [super init];
    if (self) {
        self.selectType = selectType;
        [self.arraySelectedContacts addObjectsFromArray:selectedContacts];
        self.nonSelectable = nonSelectableContacts ? : @[];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithSelectType:ContactsSelectTypeNone selectedContacts:nil nonSelectableContacts:nil];
}

- (void)configDataSource:(NSArray *)dataSource {
    [self.adapterArray removeAllObjects];
    [self.adapterArray addObjectsFromArray:dataSource];
    if (self.arraySelectedContacts.count == 0 || !self.arraySelectedContacts) {
        return;
    }
    Class dataClass;
    id data = self.arraySelectedContacts.firstObject;
    dataClass = [data class];
    
    __block NSMutableArray *selectedContactsTemp = [NSMutableArray arrayWithCapacity:self.arraySelectedContacts.count];
    NSArray *arrayTemp = [self.arraySelectedContacts valueForKey:@"userId"];
    __weak typeof(self) weakSelf = self;
    [self.adapterArray enumerateObjectsUsingBlock:^(NSArray  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
         NSLog(@"-------------->%@",[NSThread currentThread]);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (id model in obj) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@",arrayTemp];
            if ([predicate evaluateWithObject:@([model userId])]) {
                if ([model isKindOfClass:[ServiceGroupMemberModel class]]) {
                    ServiceGroupMemberModel *newModel = (ServiceGroupMemberModel *)model;
                    newModel.selected = YES;
                }
                else if ([model isKindOfClass:[PatientInfo class]]) {
                    PatientInfo *newModel = (PatientInfo *)model;
                    newModel.at_selected = YES;
                }
                [selectedContactsTemp addObject:model];
            }
            if (strongSelf.arraySelectedContacts.count == selectedContactsTemp.count) {
                strongSelf.arraySelectedContacts = selectedContactsTemp;
                *stop = YES;
                [strongSelf configSelectedAllStateWithCellClass:dataClass section:idx];
                return;
            }

        }
        [strongSelf configSelectedAllStateWithCellClass:dataClass section:idx];
    }];
}

// 取消选中对象
- (void)deselectDataObject:(id)model {
    if ([model isKindOfClass:[PatientInfo class]]) {
        ((PatientInfo *)model).at_selected = NO;
        [self.arraySelectedContacts removeObject:model];
        for (NSInteger i = 0; i < self.arrayButtons.count; i ++ ) {
            if (self.arrayButtons[i].selected) {
                [self configSelectedAllStateWithCellClass:[PatientInfo class] section:i];
            }
        }
        [self.tableView reloadData];
    }

}

#pragma mark - Event Response

- (void)headerClicked:(UIButton *)sender {
    NSInteger row = self.dictNumberRow[@(sender.tag)].integerValue;
    if (sender.selected) {
        row = 0;
        [UIView animateWithDuration:0.24 animations:^{
            [sender.imageView setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
        }];
    }
    else {
        row = [self.adapterArray[sender.tag] count];
        [UIView animateWithDuration:0.24 animations:^{
            [sender.imageView setTransform:CGAffineTransformMakeRotation(0)];
        }];
    }
    self.dictNumberRow[@(sender.tag)] = @(row);
    sender.selected ^= 1;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)headerLongPressed {
//    if ([self.customeDelegate respondsToSelector:@selector(coordinationContactsAdapterDelegateCallBack_headerLongPressed)]) {
//        [self.customeDelegate coordinationContactsAdapterDelegateCallBack_headerLongPressed];
//    }
}

#pragma mark - Private Method

- (ContactSelectButton *)createHeaderButton {
    ContactSelectButton *buttonView = [[ContactSelectButton alloc] initWithEdit:self.selectType == ContactsSelectTypeMutableSelect isShowTopLine:NO];
    buttonView.delegate = self;
    buttonView.button.backgroundColor = [UIColor whiteColor];
    [buttonView.button setImage:[UIImage imageNamed:@"c_grayArrow"] forState:UIControlStateNormal];
    buttonView.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [buttonView.button setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [buttonView.button.imageView setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
    [buttonView.button addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerLongPressed)];
    [buttonView.button addGestureRecognizer:gesture];
    return buttonView;
}

// 配置选中的indexPath
- (void)configSelectCellIndexPath:(NSIndexPath *)indexPath {
    BOOL reloadAll = NO;
    
    id cellData;
    NSPredicate *predicate;
    if ([self.adapterArray.firstObject isKindOfClass:[NSArray class]]) {
        cellData = self.adapterArray[indexPath.section][indexPath.row];
    }
    else {
        cellData = self.adapterArray[indexPath.row];
    }
    if ([cellData isKindOfClass:[ServiceGroupMemberModel class]]) {
        
        ServiceGroupMemberModel *model = (ServiceGroupMemberModel *)cellData;
        model.selected = !model.selected;
        predicate = [NSPredicate predicateWithFormat:@"selected == NO"];

        if (self.selectType == ContactsSelectTypeSingleSelect) {
            if (self.arraySelectedContacts.count > 0) {
                ServiceGroupMemberModel *oldModel = self.arraySelectedContacts.firstObject;
                if (oldModel.userId != model.userId) {
                    oldModel.selected = NO;
                    [self.arraySelectedContacts removeAllObjects];
                    reloadAll = YES;
                }
            }
        }
        if (model.selected) {
            [self.arraySelectedContacts addObject:model];
        }
        else {
            [self.arraySelectedContacts removeObject:model];
        }
    }
    else if ([cellData isKindOfClass:[PatientInfo class]]) {
        PatientInfo *model = (PatientInfo *)cellData;
        model.at_selected = !model.at_selected;
        predicate = [NSPredicate predicateWithFormat:@"at_selected == NO"];
        
        if (self.selectType == ContactsSelectTypeSingleSelect) {
            if (self.arraySelectedContacts.count > 0) {
                PatientInfo *oldModel = self.arraySelectedContacts.firstObject;
                if (oldModel.userId != model.userId) {
                    oldModel.at_selected = NO;
                    [self.arraySelectedContacts removeAllObjects];
                    reloadAll = YES;
                }
            }
        }
        if (model.at_selected) {
            [self.arraySelectedContacts addObject:model];
        }
        else {
            [self.arraySelectedContacts removeObject:model];
        }

    }
    
    if (reloadAll) {
        [self.tableView reloadData];
    }
    else {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    NSArray *arrayTemp = [self.adapterArray[indexPath.section] filteredArrayUsingPredicate:predicate];
    self.arrayButtons[indexPath.section].selected = arrayTemp.count == 0;
}

// 配置section选择状态
- (void)configSectionSelectState:(BOOL)selected section:(NSInteger)section {
    NSArray *arrayTemp = self.adapterArray[section];
    for (id sourceModel in arrayTemp) {
        if ([sourceModel isKindOfClass:[PatientInfo class]]) {
            PatientInfo *model = (PatientInfo *)sourceModel;
            model.at_selected = selected;
            if (selected) {
                if (![self.arraySelectedContacts containsObject:model]) {
                    [self.arraySelectedContacts addObject:model];
                }
            }
            else {
                [self.arraySelectedContacts removeObject:model];
            }
        }
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];

    if ([self.customDelegate respondsToSelector:@selector(coordinationContactsSelectAdapterDelegateCallBack_sectionSelectStateChangedWithChangedContacts:)]) {
        [self.customDelegate coordinationContactsSelectAdapterDelegateCallBack_sectionSelectStateChangedWithChangedContacts:self.arraySelectedContacts];
    }
    
}

- (void)configSelectedAllStateWithCellClass:(Class)class section:(NSInteger)section {
    NSPredicate *predicate;
    if (class == [ServiceGroupMemberModel class]) {
        predicate = [NSPredicate predicateWithFormat:@"selected == NO"];
    }
    else if (class == [PatientInfo class]) {
        predicate = [NSPredicate predicateWithFormat:@"at_selected == NO"];

    }
    NSArray *arrayTemp = [self.adapterArray[section] filteredArrayUsingPredicate:predicate];
    self.arrayButtons[section].selected = arrayTemp.count == 0;

}

#pragma mark - ContactSelectButtonDelegate

- (void)contactSelectButtonDelegateCallBack_selectedStateChangedWithView:(ContactSelectButton *)buttonView selected:(BOOL)selected {
    [self configSectionSelectState:buttonView.selected section:buttonView.tag];
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.sectionData.count > 0) {
        return self.sectionData.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.sectionData.count > 0) {
//        NSArray *array = self.adapterArray[section];
//        return array.count;
//    }
    return self.dictNumberRow[@(section)].integerValue;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.sectionData.count > 0) {
        return 45;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.sectionData.count == 0) {
        return nil;
    }
    return self.arrayButtons[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sectionData.count == 0) {
        return 60;
    }
    return 60;
}

// 医生信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForServiceGroupMemberModel:(ServiceGroupMemberModel *)model {
    CoordinationContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CoordinationContactTableViewCell class])];
    
    // 配置数据
    [cell configCellData:model selectable:self.selectType != ContactsSelectTypeNone ];
    return cell;
}

// 病人信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForPatientInfo:(PatientInfo *)model {
    CoordinationContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CoordinationContactTableViewCell class])];
    
    // 配置数据
    [cell configCellData:model selectable:self.selectType != ContactsSelectTypeNone ];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configSelectCellIndexPath:indexPath];

    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Init

- (NSMutableDictionary *)dictNumberRow {
    if (!_dictNumberRow) {
        _dictNumberRow = [NSMutableDictionary dictionary];
        for (NSInteger i = 0; i < self.sectionData.count; i++) {
            _dictNumberRow[@(i)] = @(0);
        }
    }
    return _dictNumberRow;
}

- (NSMutableArray *)sectionData {
    if (!_sectionData) {
        _sectionData = [NSMutableArray array];
    }
    return _sectionData;
}

- (NSMutableArray<ContactSelectButton *> *)arrayButtons {
    if (!_arrayButtons) {
        _arrayButtons = [NSMutableArray array];
        for (NSString *title in self.sectionData) {
            ContactSelectButton *btn = [self createHeaderButton];
            btn.tag = _arrayButtons.count;
            [_arrayButtons addObject:btn];
            [btn.button setTitle:title forState:UIControlStateNormal];
        }
    }
    return _arrayButtons;
}

- (NSMutableArray<NSIndexPath *> *)arraySelectedIndexPath {
    if (!_arraySelectedIndexPath) {
        _arraySelectedIndexPath = [NSMutableArray array];
    }
    return _arraySelectedIndexPath;
}

- (NSMutableArray *)arraySelectedContacts {
    if (!_arraySelectedContacts) {
        _arraySelectedContacts = [NSMutableArray array];
    }
    return _arraySelectedContacts;
}
@end
