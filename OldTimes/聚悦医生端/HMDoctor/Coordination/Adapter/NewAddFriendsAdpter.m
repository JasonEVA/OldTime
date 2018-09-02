//
//  NewAddFriendsAdpter.m
//  HMDoctor
//
//  Created by jasonwang on 16/5/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewAddFriendsAdpter.h"
#import "CoordinationDepartmentModel.h"

@implementation NewAddFriendsAdpter

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForCoordinationDepartmentModel:(CoordinationDepartmentModel *)model
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell at_identifier]];
        // 测试数据
    [cell.textLabel setText:model.depName];
    return cell;
}

@end
