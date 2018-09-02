//
//  NewFriendAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewFriendAdapter.h"
#import "ContactDoctorInfoTableViewCell.h"
#import "DoctorContactDetailModel.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "CoordinationContactsManager.h"

@implementation NewFriendAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForMessageRelationValidateModel:(MessageRelationValidateModel *)model {
    ContactDoctorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ContactDoctorInfoTableViewCell at_identifier]];
    [[cell btnAccept] setEnabled:!model.validateState];
    cell.acceptState = YES;
    [cell setDataWithModel:model];
    
    [cell clickBlock:^{
        NSArray *arrayGroups = [[CoordinationContactsManager sharedManager] getContatsGroupingNamesIncludeChatGroup:NO];
        MessageRelationGroupModel *groupModel;
        if (arrayGroups.count > 0) {
            // TODO: 默认为我的好友
            groupModel = arrayGroups[0];
        }
        [[MessageManager share] dealRelationWithModel:model validateState:2 relationGroupId:groupModel ? groupModel.relationGroupId : 0 remark:@"备注" content:@"我同意了" completion:^(BOOL success) {
            [[cell btnAccept] setEnabled:!success];
        }];
    }];
    // 测试数据
    return cell;
}


@end
