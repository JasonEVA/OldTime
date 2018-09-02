//
//  WorkCircleDetailInfoAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "WorkCircleDetailInfoAdapter.h"
#import "BaseInputTableViewCell.h"
#import "WorkCircleMembersTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface WorkCircleDetailInfoAdapter()<WorkCircleMembersTableViewCellDelegate,InputCellDelegate>
@property (nonatomic, strong)  UISwitch  *switchView; // <##>
@property (nonatomic, copy)  MessageReminderState  messageReminderBlock; // <##>
@property (nonatomic, copy)  GroupNameEndEdit  groupNameBlock; // <##>
@property (nonatomic, strong)  UserProfileModel  *infoModel; // <##>

@end

@implementation WorkCircleDetailInfoAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30;
    }
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSInteger integral = (self.infoModel.memberList.count + 1) / 4;
        NSInteger remainder = (self.infoModel.memberList.count + 1) % 4;
        NSInteger line = integral + (remainder > 0 ? 1 : 0);
        return line * itemHeight;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WorkCircleMembersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WorkCircleMembersTableViewCell class])];
        cell.delegate = self;
        [cell configCellData:self.infoModel.memberList];
        return cell;

    }
    else if (indexPath.section== 1) {
        BaseInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BaseInputTableViewCell class])];
        cell.indexPath = indexPath;
        [cell.textLabel setFont:[UIFont font_30]];
        [cell.textLabel setTextColor:[UIColor commonBlackTextColor_333333]];
        [cell.textField setTextColor:[UIColor commonDarkGrayColor_666666]];
        [cell.textField setFont:[UIFont font_30]];
        [cell.textLabel setText:@"工作圈名称"];
        [cell configTextFieldText:self.infoModel.nickName editing:YES];
        cell.delegate = self;
        return cell;

    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"contactCell"];
            cell.accessoryView = self.switchView;
            [cell.textLabel setFont:[UIFont font_30]];
            [cell.textLabel setTextColor:[UIColor commonBlackTextColor_333333]];
        }
        [cell.textLabel setText:@"消息免打扰"];
        return cell;

    }
}

#pragma mark - Interface

- (void)addGroupNameNoti:(GroupNameEndEdit)groupNameNoti {
    self.groupNameBlock = groupNameNoti;
}
- (void)addMessageReminderNoti:(MessageReminderState)messageReminderNoti {
    self.messageReminderBlock = messageReminderNoti;
}

- (void)configUserProfileModel:(UserProfileModel *)userProfileModel {
    self.infoModel = userProfileModel;
}
- (void)configContactDetailModel:(ContactDetailModel *)contactDetailModel {
    self.switchView.on = contactDetailModel._muteNotification;
}
#pragma mark - InputCellDelegate

- (void)InputCellDelegateCallBack_endEditWithIndexPath:(NSIndexPath *)indexPath {
    BaseInputTableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.groupNameBlock(YES,currentCell.textField.text,self.infoModel.nickName);
}

// 开始输入回调
- (void)InputCellDelegateCallBack_startEditWithIndexPath:(NSIndexPath*)indexPath {
    BaseInputTableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.groupNameBlock(NO,currentCell.textField.text,self.infoModel.nickName);

}

#pragma mark - Event Response

- (void)switchStateChanged {
    self.messageReminderBlock(self.switchView.on);
}

#pragma mark - WorkCircleMembersTableViewCellDelegate

- (void)workCircleMembersTableViewCellDelegateCallBack_memberClickedWithData:(id)memberData indexPath:(NSIndexPath *)indexPath {
    if ([self.customDelegate respondsToSelector:@selector(workCircleDetailInfoAdapterDelegateCallBack_circleMemberClickedWithModel:)]) {
        [self.customDelegate workCircleDetailInfoAdapterDelegateCallBack_circleMemberClickedWithModel:memberData];
    }
}

- (void)workCircleMembersTableViewCellDelegateCallBack_addMemberClicked {
    if ([self.customDelegate respondsToSelector:@selector(workCircleDetailInfoAdapterDelegateCallBack_addMemberClicked)]) {
        [self.customDelegate workCircleDetailInfoAdapterDelegateCallBack_addMemberClicked];
    }

}

#pragma mark - Init

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [UISwitch new];
        _switchView.onTintColor = [UIColor mainThemeColor];
        [_switchView addTarget:self action:@selector(switchStateChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}
@end
