//
//  MissionTypeListAdapter.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/3.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionTypeListAdapter.h"
#import "TaskTypeTitleAndCountModel.h"
#import "NewMissionGroupModel.h"

@implementation MissionTypeListAdapter
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return 35;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNewMissionGroupModel:(NewMissionGroupModel *)model {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableView at_identifier]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[UITableViewCell at_identifier]];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setText:model.teamName];
    [cell.textLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)model.doneCount,(long)model.allCount]];
    [cell.detailTextLabel setTextColor:[UIColor commonLightGrayColor_999999]];
    [cell.detailTextLabel setTextAlignment:NSTextAlignmentRight];
    
    return cell;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withTaskTypeTitleAndCountModel:(TaskTypeTitleAndCountModel *)model {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableView at_identifier]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[UITableViewCell at_identifier]];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    if (indexPath.section) {
        [cell.textLabel setText:@"服务群"];

    }
    else {
        [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MissionType_%ld",(long)indexPath.row]]];
        [cell.textLabel setText:model.tabName];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",(long)model.count]];
        [cell.detailTextLabel setTextColor:[UIColor commonLightGrayColor_999999]];
        [cell.detailTextLabel setTextAlignment:NSTextAlignmentRight];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section) {
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
        [head setBackgroundColor:[UIColor whiteColor]];
        UILabel *label = [UILabel new];
        [label setText:@"服务组"];
        [head addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(head);
            make.left.equalTo(head).offset(15);
        }];
        return head;
    }
    else {
        return nil;
    }
}
@end
