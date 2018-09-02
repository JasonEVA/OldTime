//
//  MeetingTimeandAddressSelectView.h
//  launcher
//
//  Created by 马晓波 on 15/8/9.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingActionSheetView.h"
#import "DatePickView.h"

@class NewMeetingModel;

@protocol MeetingTimeandAddressSelectViewDelegate <NSObject>

/** 选择成功后，返回时间 */
- (void)MeetingTimeandAddressSelectViewDelegateCallBack_SelectTimes:(NSArray *)timeArray address:(MeetingRoomListModel *)model;
- (void)MeetingTimeandAddressSelectViewDelegateCallBack_ShowDetailTimeArrange:(NSDate *)date;
- (void)delegateposterror:(NSString *)string;

@end
@interface MeetingTimeandAddressSelectView : UIView
@property (nonatomic, weak) id<MeetingTimeandAddressSelectViewDelegate> delegate;
@property (nonatomic, strong) UIButton *btnDetailEvent;
@property (nonatomic, strong) UILabel *lblArrangedEvent;
@property (nonatomic, strong) UIButton *btnJumpToMap;
@property (nonatomic, strong) UILabel *lblbtnJumpToMap;
@property (nonatomic, strong) UILabel *lblWithNoMeetingRoom;
@property (nonatomic, strong) UILabel *lblSelectOutside;
@property (nonatomic) BOOL isInnerMeeting;

@property (nonatomic, strong) MeetingActionSheetView *MeetingActionSheetView;
@property (nonatomic, strong) NSString *strAddress;

- (instancetype)initWithMeetingModel:(NewMeetingModel *)meetingModel timeList:(NSArray *)timeList;
- (void)showWithMeetingRoom:(BOOL)HaveMeetingRoom;
- (void)dismiss;

@end
