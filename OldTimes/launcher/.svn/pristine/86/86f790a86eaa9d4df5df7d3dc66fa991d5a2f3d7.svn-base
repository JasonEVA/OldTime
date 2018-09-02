//
//  MeetingActionSheetView.h
//  launcher
//
//  Created by Conan Ma on 15/8/13.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingSelectedMeetingRoomView.h"

@interface MeetingActionSheetView : UIView
@property (nonatomic, strong) MeetingSelectedMeetingRoomView *PickView;
- (instancetype)initWithRoomList:(NSArray *)arr;

/** 更新数据时用 */
@property (nonatomic, strong) NSArray *arrRoomList;

- (void)show;
- (void)dismiss;
@end
