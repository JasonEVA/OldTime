//
//  SelectHospitalDeptAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SelectHospitalDeptAdapter.h"

@implementation SelectHospitalDeptAdapter

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell at_identifier]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setTextColor:[UIColor commonBlackTextColor_333333]];
    [cell.textLabel setFont:[UIFont font_30]];
    [cell.textLabel setText:self.adapterArray[indexPath.row]];
    // 测试数据
    return cell;
}
@end
