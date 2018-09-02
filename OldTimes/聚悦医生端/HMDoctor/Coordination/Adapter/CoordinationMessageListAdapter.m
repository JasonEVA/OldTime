//
//  CoordinationMessageListAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationMessageListAdapter.h"
#import "SessionListTableViewCell.h"
#import "SessionListModel.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "MessageListCell.h"
#import "IMApplicationConfigure.h"
#import "ChatIMConfigure.h"

@implementation CoordinationMessageListAdapter

- (UITableViewCell *)tableView:(UITableView *)tableView cellForContactDetailModel:(ContactDetailModel *)model {
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageListCell class])];
    [cell setModel:model];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.adapterArray.count == 0) {
        return NO;
    }
    ContactDetailModel *model = self.adapterArray[indexPath.row];
    if ([model._target isEqualToString:im_task_uid]) {
        // 固定任务不可删除
        return NO;
    }
    return YES;
}

// 为兼容iOS 8上侧滑效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactDetailModel *model = self.adapterArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除"
                                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                           NSLog(@"删除");
                                                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                           id cellData;
                                                                           if ([strongSelf.adapterArray.firstObject isKindOfClass:[NSArray class]]) {
                                                                               cellData = strongSelf.adapterArray[indexPath.section][indexPath.row];
                                                                           }
                                                                           else {
                                                                               cellData = strongSelf.adapterArray[indexPath.row];
                                                                           }
                                                                           if (strongSelf.adapterDelegate) {
                                                                               if ([strongSelf.adapterDelegate respondsToSelector:@selector(deleteCellData:indexPath:)]) {
                                                                                   [strongSelf.adapterDelegate deleteCellData:cellData indexPath:indexPath];
                                                                               }
                                                                           }

                                                                       }];
    NSString *string = model._muteNotification ? @"恢复提醒" : @"免打扰";
    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:string
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                              NSLog(string);
                                                                              if (strongSelf.messageAdepterDelegate) {
                                                                                  if ([strongSelf.messageAdepterDelegate respondsToSelector:@selector(CoordinationMessageListAdapterDelegateCallBack_muteNotification:)]) {
                                                                                      [strongSelf.messageAdepterDelegate CoordinationMessageListAdapterDelegateCallBack_muteNotification:model];
                                                                                  }
                                                                              }
                                                                          }];
    rowActionSec.backgroundColor = [UIColor commonLightGrayColor_999999];
    
    NSString *stickString = model._stick ? @"取消置顶" : @"置顶";
    UITableViewRowAction *rowActionStick = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:stickString
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                              [strongSelf dealWithStick:model];
                                                                          }];
    rowActionStick.backgroundColor =  [UIColor colorWithHexString:@"ff9d00"];

    NSMutableArray *tempArr = [NSMutableArray array];
    
    if ([ContactDetailModel isGroupWithTarget:model._target]) {
        [tempArr addObjectsFromArray:@[rowAction,rowActionSec]];
    }
    else {
        [tempArr addObjectsFromArray:@[rowAction]];
    }
    // 用户添加置顶
    if ([model._tag isEqualToString:im_doctorPatientGroupTag]) {
        [tempArr insertObject:rowActionStick atIndex:1];
    }
    return tempArr;
    
}

- (void)dealWithStick:(ContactDetailModel *)model {
    [[MessageManager share] MTStickSeeionWithSessionName:model._target stickModel:!model._stick completion:^(BOOL success) {
        
    }];
}

@end
