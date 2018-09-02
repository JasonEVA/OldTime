//
//  MissionAddNewMissionAdapter.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//  新建任务Adapter

#import "ATTableViewAdapter.h"

@class MissionDetailModel;

@protocol MissionAddNewMissionAdapterDelegate <NSObject>

- (void)MissionAddNewMissionAdapterDelegateCallBack_insterRow;
- (void)MissionAddNewMissionAdapterDelegateCallBack_accessoryClickImageIndex:(NSUInteger)clickedIndex;
- (void)MissionAddNewMissionAdapterDelegateCallBack_startTimeSelectHideAtIndexPath:(NSIndexPath *)indexPath date:(NSDate *)date isWholeDay:(BOOL)isWholeDay isNone:(BOOL)isNone;  //收起时间选择回调

// 标题，备注输入回调
- (void)MissionAddNewMissionAdapterDelegateCallBack_textFieldEndEditWithText:(NSString *)text cellType:(Cell_Type)cellType;

@end
@interface MissionAddNewMissionAdapter : ATTableViewAdapter
@property (nonatomic, weak) UIViewController *baseVC;
@property (nonatomic, weak) id <MissionAddNewMissionAdapterDelegate> delegate;
@property (nonatomic) BOOL startTimeCellIsopen;
@property (nonatomic) BOOL endTimeCellIsopen;
@property (nonatomic, strong) MissionDetailModel *detailModel;
@property (nonatomic, copy)  NSArray<UIImage *>  *uploadOriImages; // <##>

- (id)getComponentFromDictionaryOrModel:(Cell_Type)requestStyle;
@end
