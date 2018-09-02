//
//  NewMissionMainListAdapter.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/3.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewMissionMainListAdapter.h"
#import "MissionDetailModel.h"
#import "NewMissionMainListTableViewCell.h"
#import "MissionMainListHeadView.h"
@implementation NewMissionMainListAdapter
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.headViewTitelArr.count == 0) {
        return 0.01;
    }
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForTaskTypeTitleAndCountModel:(TaskTypeTitleAndCountModel *)model {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//    [cell.textLabel setText:model.tabName];
//    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",(long)model.count]];
//    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
//    [cell.detailTextLabel setTextAlignment:NSTextAlignmentRight];
//    // 测试数据
//    return cell;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withMissionDetailModel:(MissionDetailModel *)model {
    NewMissionMainListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewMissionMainListTableViewCell class])];
    [cell setCellDataWithModel:model];
        // 测试数据
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (!section && self.adapterArray.count > 1) {
        if ([self.adapterArray[0] count] > 0) {
            if (self.arrayButtons.count > 0) {
                if (![self.arrayButtons[0] selectButton].isSelected) {
                    return 1;
                }
            } else{
                return 1;
            }
        }
    }
    return [super tableView:tableView numberOfRowsInSection:section];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.headViewTitelArr.count == 0) {
        return nil;
    }
    
    if (self.arrayButtons.count < self.headViewTitelArr.count) {
        MissionMainListHeadView *headView = [MissionMainListHeadView new];
        [headView.selectButton setHidden:section];
        [headView.selectButton setTag:section];
        [self.arrayButtons insertObject:headView atIndex:section];
        __weak typeof(self) weakSelf = self;
        [self.arrayButtons[0] selectClickBlock:^(BOOL selected, NSInteger tag) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!tag && [strongSelf.adapterArray[0] count] > 1) {
                [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        
    }
    
    if (self.headViewTitelArr && self.headViewTitelArr.count > 0) {
        [[self.arrayButtons[section] titelLb] setText:[NSString stringWithFormat:@"%@(%ld)", self.headViewTitelArr.count > 0 ? self.headViewTitelArr[section] : @"", self.adapterArray.count > 0 ? [self.adapterArray[section] count] : 0]];
    }
    if (self.adapterArray.count > 0 && section < 1) {
        [self.arrayButtons[section] selectButton].hidden = [self.adapterArray[section] count] < 2 || self.adapterArray.count == 1;
    }
    return self.arrayButtons[section];
    
}

- (NSMutableArray *)arrayButtons {
    if (!_arrayButtons) {
        _arrayButtons = [NSMutableArray array];
    }
    return _arrayButtons;
}
@end
