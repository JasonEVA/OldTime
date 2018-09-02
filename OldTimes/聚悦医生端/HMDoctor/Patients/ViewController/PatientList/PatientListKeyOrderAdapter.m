//
//  PatientListKeyOrderAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientListKeyOrderAdapter.h"
#import "PatientListTableViewCell.h"
#import "NewPatientListInfoModel.h"
#import "DAOFactory.h"

@implementation PatientListKeyOrderAdapter

- (void)reloadTableViewWithOriginData:(NSArray<NewPatientListInfoModel *> *)originData {
    [self.adapterArray removeAllObjects];
    [self.adapterArray addObjectsFromArray:originData];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientListTableViewCell class]) forIndexPath:indexPath];
    
    // Configure the cell...
    [cell configCellDataWithNewPatientListInfoModel:self.adapterArray[indexPath.row]];
    return cell;
}

// 为兼容iOS 8上侧滑效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewPatientListInfoModel *model = self.adapterArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *follow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 关注
        [_DAO.patientInfoListDAO updatePatientFollowStatus:YES patientID:model.userId completion:^(BOOL requestSuccess, NSString *errorMsg) {
            if (requestSuccess) {
                [strongSelf p_postFollowDelegate:YES];

                model.attentionStatus = 1;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }];
    follow.backgroundColor = [UIColor commonOrangeColor_ff8636];
    UITableViewRowAction *cancelFollow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 取消关注
        [_DAO.patientInfoListDAO updatePatientFollowStatus:NO patientID:model.userId completion:^(BOOL requestSuccess, NSString *errorMsg) {
            if (requestSuccess) {

                model.attentionStatus = 2;
                if (strongSelf.filterFollow) {
                    [strongSelf.adapterArray removeObject:model];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                else {
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                [strongSelf p_postFollowDelegate:NO];

            }
        }];
    }];
    cancelFollow.backgroundColor = [UIColor commonLightGrayColor_999999];
    return model.attentionStatus == 1 ? @[cancelFollow] : @[follow];
}

- (void)p_postFollowDelegate:(BOOL)follow {
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(patientListKeyOrderAdapterDelegateCallBack_followStatus:)]) {
        [self.customDelegate patientListKeyOrderAdapterDelegateCallBack_followStatus:follow];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat tableViewOffsetY = scrollView.contentOffset.y;
    if ([self.customDelegate respondsToSelector:@selector(patientListKeyOrderAdapterDelegateCallBack_scrollViewDidScroll:)]) {
        [self.customDelegate patientListKeyOrderAdapterDelegateCallBack_scrollViewDidScroll:tableViewOffsetY];
    }
}
@end
