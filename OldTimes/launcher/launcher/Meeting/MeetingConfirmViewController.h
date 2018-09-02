//
//  MeetingConfirmViewController.h
//  launcher
//
//  Created by Conan Ma on 15/8/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplicationCommentBaseViewController.h"
#import "NewMeetingModel.h"

@class PlaceModel;

@interface MeetingConfirmViewController :ApplicationCommentBaseViewController
@property (nonatomic, strong) NewMeetingModel *meetingModel;
@property(nonatomic, assign) BOOL  isFromQuickStart;
- (instancetype)initWithModel:(NewMeetingModel *)model;
- (instancetype)initWithModel:(NewMeetingModel *)model WithRepeatType:(calendar_repeatType)type;
- (instancetype)initWithModel:(NewMeetingModel *)model WithRepeatType:(calendar_repeatType)type justSee:(BOOL)justSee;

@end
