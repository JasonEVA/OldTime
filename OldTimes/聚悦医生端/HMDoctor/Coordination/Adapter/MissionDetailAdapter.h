//
//  MissionDetailAdapter.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ATTableViewAdapter.h"

@class MissionCommentsModel,MissionDetailModel;

@protocol MissionDetailAdapterDelegate <NSObject>

- (void)MissionDetailAdapterDelegateCallBack_isAccept:(BOOL)isAccept;
- (void)missionDetailAdapterDelegateCallBack_commentTypeClicked:(TaskCommentType)commentType; // 评论类型点击
- (void)missionDetailAdapterDelegateCallBack_accessoryClickImageIndex:(NSInteger)index;

// 写评论点击
- (void)missionDetailAdapterDelegateCallBack_writeCommentClicked;
@end

@interface MissionDetailAdapter : ATTableViewAdapter
@property (nonatomic, weak) id<MissionDetailAdapterDelegate> customDelegate;
@property (nonatomic, weak) UIViewController *baseVC;
@property (nonatomic, strong) MissionDetailModel *model;
@property (nonatomic, strong)  NSArray<MissionCommentsModel *>  *arrayCommentsList; // <##>
@end
