//
//  CoordinationContactsAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationContactsAdapter.h"
#import "ContactSelectButton.h"
#import "ContactInfoModel.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "CoordinationContactsManager.h"
#import "CoordinationContactTableViewCell.h"

@interface CoordinationContactsAdapter()<ContactSelectButtonDelegate>
@property (nonatomic, strong)  NSMutableArray<ContactSelectButton *>  *arrayButtons; // <##>
@property (nonatomic, strong)  NSMutableDictionary<NSNumber * , NSNumber *>  *dictHeight; // <##>
@property (nonatomic, strong)  NSMutableArray  *addedContacts; // <##>
@property (nonatomic, strong)  NSMutableArray  *deletedContacts; // <##>
@property (nonatomic)  ContactsSelectType  selectType; // <##>
@property (nonatomic, copy)  NSArray  *nonSelectable; // 不可选择人员列表
@property (nonatomic, copy)  NSArray  *arraySelectedContacts; // <##>

@end

@implementation CoordinationContactsAdapter

- (instancetype)initWithSelectType:(ContactsSelectType)selectType selectedContacts:(NSArray *)selectedContacts nonSelectableContacts:(NSArray *)nonSelectableContacts {
    self = [super init];
    if (self) {
        self.selectType = selectType;
        self.arraySelectedContacts = selectedContacts;
        self.nonSelectable = nonSelectableContacts ? : @[];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithSelectType:ContactsSelectTypeNone selectedContacts:nil nonSelectableContacts:nil];
}

- (void)configSelectContacts:(NSArray *)selectContacts reload:(BOOL)reload {
    if (reload) {
        [self reloadSelectedContactsStateWithOldSelectContacs:self.arraySelectedContacts newSelectContacts:selectContacts];
    }
    self.arraySelectedContacts = selectContacts;
}

#pragma mark - TableView Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.adapterArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.adapterArray.count == 0) {
        return 0;
    }
    MessageRelationGroupModel *groupModel = self.adapterArray[section];
    return groupModel.relationList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1 && !self.onlyRelations) {
        return 15;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.adapterArray.count == 0) {
        return nil;
    }
    if (self.arrayButtons.count < section + 1) {
        BOOL isShowTopLine = NO;
        if (section == 2 && !self.onlyRelations) {
            isShowTopLine = YES;
        }
        ContactSelectButton *btn = [self createHeaderButton:isShowTopLine];
        btn.tag = section;
        [self.arrayButtons insertObject:btn atIndex:section];
    }
    MessageRelationGroupModel *model = self.adapterArray[section];
    [[self.arrayButtons[section] button] setTitle:model.relationGroupName forState:UIControlStateNormal];
    [self configSelectAllStateWithSection:section];
    return self.arrayButtons[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.dictHeight[@(indexPath.section)].floatValue;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CoordinationContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CoordinationContactTableViewCell class])];
    MessageRelationGroupModel *relationModel = self.adapterArray[indexPath.section];
    ContactInfoModel *model = relationModel.relationList[indexPath.row];
    // 配置数据
    [cell configCellData:model selectable:self.selectType > ContactsSelectTypeNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
     MessageRelationGroupModel *groupModel = self.adapterArray[indexPath.section];
    ContactInfoModel *cellData = groupModel.relationList[indexPath.row];
    cellData.selected = !cellData.selected;
    if (self.selectType > ContactsSelectTypeNone) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self configSelectedContacts:cellData section:indexPath.section];
    }

    
    if ([self.customeDelegate respondsToSelector:@selector(coordinationContactsAdapterDelegateCallBack_clickedWithCellData:)]) {
        [self.customeDelegate coordinationContactsAdapterDelegateCallBack_clickedWithCellData:cellData];
    }

    if (self.adapterDelegate) {
        if ([self.adapterDelegate respondsToSelector:@selector(didSelectCellData:index:)]) {
            [self.adapterDelegate didSelectCellData:cellData index:indexPath];
        }
    }

}
#pragma mark - Event Response
- (void)headerClicked:(UIButton *)sender {
    CGFloat height = self.dictHeight[@(sender.tag)].floatValue;
    if (sender.selected) {
        height = 0;
        [UIView animateWithDuration:0.24 animations:^{
            [sender.imageView setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
        }];
    }
    else {
        height = 60;
        [UIView animateWithDuration:0.24 animations:^{
            [sender.imageView setTransform:CGAffineTransformMakeRotation(0)];
        }];
    }
    self.dictHeight[@(sender.tag)] = @(height);
    sender.selected ^= 1;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)headerLongPressed {
    if ([self.customeDelegate respondsToSelector:@selector(coordinationContactsAdapterDelegateCallBack_headerLongPressed)]) {
        [self.customeDelegate coordinationContactsAdapterDelegateCallBack_headerLongPressed];
    }
}


#pragma mark - Private Method
- (ContactSelectButton *)createHeaderButton:(BOOL)isShowTopLine {
    ContactSelectButton *buttonView = [[ContactSelectButton alloc] initWithEdit:self.selectType == ContactsSelectTypeMutableSelect isShowTopLine:isShowTopLine];
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

// 配置选择的人
- (void)configSelectedContacts:(ContactInfoModel *)model section:(NSInteger)section {
    if (self.selectType == ContactsSelectTypeNone) {
        return;
    }
    [self resetSelectedContacts];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationInfoModel.relationName == %@", model.relationInfoModel.relationName];

    BOOL contain = [self.arraySelectedContacts filteredArrayUsingPredicate:predicate].count > 0;
    if (model.selected) {
        if (!contain) {
            [self.addedContacts addObject:model];
        }
    }
    else {
        if (contain) {
            [self.deletedContacts addObject:model];
        }
    }
    // 配置是否全选
    [self configSelectAllStateWithSection:section];
    // 发送委托
    [self sendSelectContactsDelegate:model.selected];
}

- (void)sendSelectContactsDelegate:(BOOL)selected {
    if (self.selectType == ContactsSelectTypeNone) {
        return;
    }
    if ([self.customeDelegate respondsToSelector:@selector(coordinationContactsAdapterDelegateCallBack_selectContact:selectState:)]) {
        [self.customeDelegate coordinationContactsAdapterDelegateCallBack_selectContact:selected ? self.addedContacts : self.deletedContacts selectState:selected];
    }
}

- (void)resetSelectedContacts {
    if (self.selectType == ContactsSelectTypeNone) {
        return;
    }
    [self.addedContacts removeAllObjects];
    [self.deletedContacts removeAllObjects];
}

// 配置全选状态
- (void)configSelectAllStateWithSection:(NSInteger)section {
    if (self.selectType == ContactsSelectTypeNone) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected == NO && nonSelectable == NO"];
    MessageRelationGroupModel *model = self.adapterArray[section];
    NSArray *array = [model.relationList filteredArrayUsingPredicate:predicate];
    self.arrayButtons[section].selected = array.count > 0 || model.relationList.count == 0  ? NO : YES;
}

// 配置选人状态
- (void)reloadSelectedContactsStateWithOldSelectContacs:(NSArray *)oldContacts newSelectContacts:(NSArray *)newContacts {
    if (self.selectType == ContactsSelectTypeNone) {
        return;
    }
    for (ContactInfoModel *model in oldContacts) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationInfoModel.relationName == %@",model.relationInfoModel.relationName];
        [self.adapterArray enumerateObjectsUsingBlock:^(MessageRelationGroupModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *temp = [obj.relationList filteredArrayUsingPredicate:predicate];
            if (temp.count > 0) {
                ContactInfoModel *model = temp.firstObject;
                model.selected = NO;
                *stop = YES;
            }
        }];
    }


    for (ContactInfoModel *model in newContacts) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationInfoModel.relationName == %@",model.relationInfoModel.relationName];
        [self.adapterArray enumerateObjectsUsingBlock:^(MessageRelationGroupModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *temp = [obj.relationList filteredArrayUsingPredicate:predicate];
            if (temp.count > 0) {
                ContactInfoModel *model = temp.firstObject;
                model.selected = YES;
                *stop = YES;
            }
        }];
    }
    [self.tableView reloadData];
}

#pragma mark - ContactSelectButtonDelegate

- (void)contactSelectButtonDelegateCallBack_selectedStateChangedWithView:(ContactSelectButton *)buttonView selected:(BOOL)selected {
    [self resetSelectedContacts];
    MessageRelationGroupModel  *groupModel = self.adapterArray[buttonView.tag];
    for (ContactInfoModel *model in groupModel.relationList) {
        if (model.nonSelectable) {
            continue;
        }
        if (selected) {
            if (!model.selected) {
                [self.addedContacts addObject:model];
            }
        }
        else {
            if (model.selected) {
                [self.deletedContacts addObject:model];
            }
        }
        model.selected = selected;
    }
    [self sendSelectContactsDelegate:selected];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:buttonView.tag] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Init

- (NSMutableDictionary *)dictHeight {
    if (!_dictHeight) {
        _dictHeight = [NSMutableDictionary dictionary];
        if (_dictHeight.allKeys.count != self.adapterArray.count) {
            for (NSInteger i = 0; i < self.adapterArray.count; i++) {
                _dictHeight[@(i)] = @(0);
            }
        }
    }
    return _dictHeight;
}

- (NSMutableArray<ContactSelectButton *> *)arrayButtons {
    if (!_arrayButtons) {
        _arrayButtons = [NSMutableArray array];
    }
    return _arrayButtons;
}


- (NSMutableArray *)addedContacts {
    if (!_addedContacts) {
        _addedContacts = [NSMutableArray array];
    }
    return _addedContacts;
}

- (NSMutableArray *)deletedContacts {
    if (!_deletedContacts) {
        _deletedContacts = [NSMutableArray array];
    }
    return _deletedContacts;
}

@end
