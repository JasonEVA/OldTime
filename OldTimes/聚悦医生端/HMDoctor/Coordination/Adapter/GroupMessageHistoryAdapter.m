//
//  GroupMessageHistoryAdapter.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/27.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GroupMessageHistoryAdapter.h"
#import "MessageHistoryMissionCell.h"
#import "AtMeMessageTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@implementation GroupMessageHistoryAdapter
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.segmentedControlSelectedButtonType == GroupMember && self.patientInfo) {
        return 30;
    }
    else {
        return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.segmentedControlSelectedButtonType == GroupMember) {
        return 0.001;
    }
    else {
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForUserProfileModel:(UserProfileModel *)model {
    HMGroupMemberHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMGroupMemberHistoryTableViewCell at_identifier]];
    [cell fillDataWithProfileModel:model];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForMessageBaseModel:(MessageBaseModel *)model {
    id cell;
    if (self.segmentedControlSelectedButtonType == Collect) {
        //收藏
        switch (model._type) {
            case msg_personal_text:
            {
                //文本
                cell = [tableView dequeueReusableCellWithIdentifier:[HMHistoryCollectTextTableViewCell at_identifier]];
                [cell setDataWithModel:model];
                break;
            }
            case msg_personal_image:
            {
                //图片
                cell = [tableView dequeueReusableCellWithIdentifier:[HMHistoryCollectImageTableViewCell at_identifier]];
                [cell setDataWithModel:model];
                

                break;
            }
            case msg_personal_voice:
            {
                //语音
                cell = [tableView dequeueReusableCellWithIdentifier:[HMHistoryCollectVoiceTableViewCell at_identifier]];
                [cell setDataWithModel:model];
                // 判断是否需要播放动画
                if (self.currentPlayingVoiceMsgId == model._msgId) {
                    NSDictionary *dict = model._content.mj_JSONObject;

                    [cell startPlayVoiceWithTime:[dict[@"audioLength"] floatValue]];
                }
                else {
                    [cell stopPlayVoice];
                }

                return cell;
                break;
            }
            default:
                break;
        }
        
    }
    else {
        //@我
        cell = [tableView dequeueReusableCellWithIdentifier:[AtMeMessageTableViewCell at_identifier]];
        [cell setDataWithModel:model];
    }
    return cell;
}

- (void)setCurrentPlayingVoiceMsgId:(long long)currentPlayingVoiceMsgId {
//    long long playingMsgID = _currentPlayingVoiceMsgId;
    _currentPlayingVoiceMsgId = currentPlayingVoiceMsgId;
    // 刷新原来的播放的cell和现在要播放的cell
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF._msgId == %lld OR SELF._msgId == %lld",playingMsgID,currentPlayingVoiceMsgId];
//    __block NSMutableArray *tempArr = [NSMutableArray array];
//    [self.adapterArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [tempArr addObject:obj[0]];
//    }];
//    NSArray<MessageBaseModel *> *modelArray = [tempArr filteredArrayUsingPredicate:predicate];
//    NSMutableArray *relodArray = [NSMutableArray arrayWithCapacity:modelArray.count];
//    [modelArray enumerateObjectsUsingBlock:^(MessageBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSUInteger row = [tempArr indexOfObject:obj];
//        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:row];
//        [relodArray addObject:indexpath];
//    }];
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
   if(self.segmentedControlSelectedButtonType == Collect) {
       return YES;
   }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.segmentedControlSelectedButtonType == GroupMember && self.patientInfo) {
        if (section) {
            NSArray *groupList = self.adapterArray[section];
            return [NSString stringWithFormat:@"医生团队(%lu)", (unsigned long)groupList.count];
        }
        else {
            return @"用户";
        }
    }
    else {
        return nil;
    }
}
// 为兼容iOS 8上侧滑效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除"
                                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                           if (strongSelf.groupMessageHistoryAdapterDelegate) {
                                                                               [strongSelf.groupMessageHistoryAdapterDelegate GroupMessageHistoryAdapterDelegateCallBack_deleteCell:indexPath];
                                                                           }
                                                                           
                                                                       }];
    
        return @[rowAction];
}
@end
