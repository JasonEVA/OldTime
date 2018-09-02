//
//  NewMeetingConfirmViewController.h
//  launcher
//
//  Created by 马晓波 on 16/3/9.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ApplicationCommentBaseViewController.h"
#import "NewMeetingModel.h"

@class PlaceModel;

@interface NewMeetingConfirmViewController : ApplicationCommentBaseViewController
@property (nonatomic, strong) NewMeetingModel *meetingModel;
//从快速创建入口进入
@property(nonatomic, assign) BOOL  isFromQuickStart;
- (instancetype)initWithModel:(NewMeetingModel *)model;
- (instancetype)initWithModel:(NewMeetingModel *)model WithRepeatType:(calendar_repeatType)type;
- (instancetype)initWithModel:(NewMeetingModel *)model WithRepeatType:(calendar_repeatType)type justSee:(BOOL)justSee;
@end
