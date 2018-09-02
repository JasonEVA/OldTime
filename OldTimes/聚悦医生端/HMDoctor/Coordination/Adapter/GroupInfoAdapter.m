//
//  GroupInfoAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GroupInfoAdapter.h"
#import "GroupInfoHeaderTableViewCell.h"
#import "RowButtonGroup.h"
#import "CoordinationPatientInfoCell.h"
#import "GroupInfoPatientInfoModel.h"
#import "GroupInfoHeaderModel.h"
#import "PatientModel.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
@interface GroupInfoAdapter()<RowButtonGroupDelegate,GroupInfoHeaderTableViewCellDelegate>
@property (nonatomic, strong)  RowButtonGroup  *buttonGroup; // <##>

@property (nonatomic, copy) titleSelectIndexBlock myblock;

@end

@implementation GroupInfoAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        [self.buttonGroup setFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        return self.buttonGroup;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 175;
    }
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForUserProfileModel:(UserProfileModel *)model {
    GroupInfoHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupInfoHeaderTableViewCell class])];
    [cell setSeviceModel:self.serviceInfoModel];
    cell.delegate = self;
    [cell configDataWith:model];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForPatientModel:(PatientModel *)model {
    CoordinationPatientInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CoordinationPatientInfoCell class])];
    [cell setDataWithModel:model];
    return cell;
}

#pragma mark - rowBtnGroupDelegate

// 正反面点击委托
- (void)RowButtonGroupDelegateCallBack_btnClickedWithTag:(NSInteger)tag {
    if (self.myblock)
    {
        self.myblock(tag);
    }
}

#pragma mark - GroupInfoHeaderTableViewCellDelegate

- (void)groupInfoHeaderTableViewCellDelegateCallBack_doctorClickedWithIndex:(NSInteger)index {
    if ([self.doctorClickedDelegate respondsToSelector:@selector(groupInfoAdapterDelegateCallBack_doctorClickedWithIndex:)]) {
        [self.doctorClickedDelegate groupInfoAdapterDelegateCallBack_doctorClickedWithIndex:index];
    }
}

#pragma mark - interfaceMethod
- (void)getTitleSelectIndexWithBlock:(titleSelectIndexBlock)block
{
    self.myblock = block;
}


#pragma mark - Event Response

- (void)headerClicked:(UIButton *)sender {
    
}

#pragma mark - Init

- (RowButtonGroup *)buttonGroup {
    if (!_buttonGroup) {
        _buttonGroup = [[RowButtonGroup alloc] initWithTitles:@[@"在诊用户",@"所有用户"] tags:@[@(0),@(1)] normalTitleColor:[UIColor commonDarkGrayColor_666666] selectedTitleColor:[UIColor mainThemeColor] font:[UIFont font_30] lineColor:[UIColor mainThemeColor]];
        [_buttonGroup setBackgroundColor:[UIColor whiteColor]];
        [_buttonGroup setDelegate:self];

    }
    return _buttonGroup;
}

@end
