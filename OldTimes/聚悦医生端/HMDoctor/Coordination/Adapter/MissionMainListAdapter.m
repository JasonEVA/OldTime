//
//  MissionMainListAdapter.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionMainListAdapter.h"
#import "MissionMainListCell.h"
#import "MissionDetailModel.h"
#import "MissionMainListSentFromMeCell.h"

@interface MissionMainListAdapter()<SWTableViewCellDelegate>
@property(nonatomic, copy) showAlterViewCallBackBlock  myBlock;

@end

@implementation MissionMainListAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForMissionDetailModel:(MissionDetailModel *)model
{
    if (self.selectType == MissionType_SendFromMe) {
        MissionMainListSentFromMeCell *cell = [tableView dequeueReusableCellWithIdentifier:[MissionMainListSentFromMeCell at_identifier]];
        if (!cell) {
            cell = [[MissionMainListSentFromMeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionMainListSentFromMeCell at_identifier]];
            [cell setDelegate:self];
        }
        [cell setCellDataWithModel:model];
        return cell;

    } else {
        MissionMainListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[MissionMainListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            [cell setDelegate:self];
            __weak typeof(self) weakSelf = self;
            [cell finishedCallBlock:^(BOOL isFinished, UITableViewCell *cell) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf.myBlock) {
                    strongSelf.myBlock(isFinished ,cell);
                }
            }];
        }
        [cell setCellDataWithModel:model withType:self.selectType];
        return cell;
    }
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    if (index == 0) {
        // 新建草稿
        if ([self.customDelegate respondsToSelector:@selector(missionMainListAdapterDelegateCallBack_newDraftWithCellData:)]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            id cellData;
            if ([self.adapterArray.firstObject isKindOfClass:[NSArray class]]) {
                cellData = self.adapterArray[indexPath.section][indexPath.row];
            }
            else {
                cellData = self.adapterArray[indexPath.row];
            }
            [self.customDelegate missionMainListAdapterDelegateCallBack_newDraftWithCellData:cellData];
        }
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

#pragma mark - interFaceMethod
- (void)showAlterViewWithBlock:(showAlterViewCallBackBlock)block
{
    self.myBlock = block;
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithHexString:@"2ecc71"] title:@"新建草稿"];
    return rightUtilityButtons;
}

- (NSMutableArray *)arrayButtons {
    if (!_arrayButtons) {
        _arrayButtons = [NSMutableArray array];
    }
    return _arrayButtons;
}
@end
