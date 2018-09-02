//
//  CreateWorkCircleFromGroupAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CreateWorkCircleFromGroupAdapter.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
@implementation CreateWorkCircleFromGroupAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSuperGroupListModel:(SuperGroupListModel *)model {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 配置数据
    [cell.textLabel setText:model.nickName];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForUserProfileModel:(UserProfileModel *)model {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 配置数据
    [cell.textLabel setText:model.nickName];
    return cell;
}
@end
