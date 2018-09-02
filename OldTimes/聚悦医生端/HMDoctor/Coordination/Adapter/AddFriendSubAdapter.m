//
//  AddFriendSubAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AddFriendSubAdapter.h"
#import "ContactDoctorInfoTableViewCell.h"

@implementation AddFriendSubAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ContactDoctorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ContactDoctorInfoTableViewCell at_identifier]];
        // 测试数据
        [cell configDoctorCompletionInfoModel:self.adapterArray[indexPath.section][indexPath.row]];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setFont:[UIFont font_30]];
        [cell.textLabel setTextColor:[UIColor commonDarkGrayColor_666666]];
        [cell.detailTextLabel setFont:[UIFont font_30]];
        [cell.detailTextLabel setTextColor:[UIColor commonBlackTextColor_333333]];
    }
    [cell.textLabel setText:@"分组"];
    MessageRelationGroupModel *model = [self.adapterArray.lastObject firstObject];
    [cell.detailTextLabel setText:model.relationGroupName];
    // 测试数据
    return cell;
}

@end
