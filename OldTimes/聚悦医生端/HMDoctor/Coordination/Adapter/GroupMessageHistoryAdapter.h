//
//  GroupMessageHistoryAdapter.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/27.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ATTableViewAdapter.h"
#import "HMHistoryCollectImageTableViewCell.h"
#import "HMHistoryCollectTextTableViewCell.h"
#import "HMHistoryCollectVoiceTableViewCell.h"
#import "HMGroupMemberHistoryTableViewCell.h"

typedef NS_ENUM(NSInteger, UISegmentedControlSelectedButtonType) {
    GroupMember, //群成员
    AtUser,      //@我
    Image,       //图片
    Collect      //收藏
};

@protocol GroupMessageHistoryAdapterDelegate <NSObject>

- (void)GroupMessageHistoryAdapterDelegateCallBack_deleteCell:(NSIndexPath *)indexPath;

@end

@interface GroupMessageHistoryAdapter : ATTableViewAdapter
@property (nonatomic) UISegmentedControlSelectedButtonType  segmentedControlSelectedButtonType ;
@property (nonatomic, assign) long long currentPlayingVoiceMsgId; // 当前播放语音Model的msgID
@property (nonatomic, weak) id <GroupMessageHistoryAdapterDelegate> groupMessageHistoryAdapterDelegate;
@property (nonatomic, strong)  UserProfileModel  *patientInfo; // <##>

@end
