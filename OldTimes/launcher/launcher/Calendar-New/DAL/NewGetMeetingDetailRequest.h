//
//  NewGetMeetingDetailRequest.h
//  launcher
//
//  Created by TabLiu on 16/3/9.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"
#import "NewMeetingModel.h"

@interface NewGetMeetingDetailRequest : BaseRequest

- (void)getMeetingDetailWithShowID:(NSString *)showID startTime:(long long)startTime;

- (void)getMeetingDetailWithShowID:(NSString *)showID startTime:(long long)startTime needCheckAttend:(BOOL)needCheck;
@end

@interface NewGetMeetingDetailResponse : BaseResponse

@property (nonatomic,strong) NewMeetingModel * model;

@end