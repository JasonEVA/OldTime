//
//  AddFriendAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AddFriendAdapter.h"
#import "ContactDoctorInfoTableViewCell.h"
#import "DoctorContactDetailModel.h"

@implementation AddFriendAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForDoctorContactDetailModel:(DoctorContactDetailModel *)model {
    ContactDoctorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ContactDoctorInfoTableViewCell at_identifier]];
    // 测试数据
    return cell;
}

@end
