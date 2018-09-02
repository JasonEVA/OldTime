//
//  DepartmentAdapter.m
//  HMDoctor
//
//  Created by jasonwang on 16/5/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DepartmentAdapter.h"
#import "ContactDoctorInfoTableViewCell.h"
#import "DoctorContactDetailModel.h"
#import "ContactInfoModel.h"
#import "DoctorCompletionInfoModel.h"

@implementation DepartmentAdapter
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.015;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForDoctorCompletionInfoModel:(DoctorCompletionInfoModel *)model {
    ContactDoctorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ContactDoctorInfoTableViewCell at_identifier]];
    // 测试数据
    [cell configDoctorCompletionInfoModel:model];
    return cell;
}


@end
