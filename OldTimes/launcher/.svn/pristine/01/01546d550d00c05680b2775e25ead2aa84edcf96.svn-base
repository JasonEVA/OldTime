//
//  NewMissionChangeMissionStatusRequest.h
//  launcher
//
//  Created by jasonwang on 16/2/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//   切换任务状态

#import "BaseRequest.h"

@interface NewMissionChangeMissionStatusRequest : BaseRequest

- (void)requestWithShowID:(NSString *)ShowID status:(NSString *)status;

@property (nonatomic,strong) NSIndexPath * path;
@property (nonatomic,strong) NSString * status ;
@end

@interface NewMissionChangeMissionStatusResponse : BaseResponse

@property (nonatomic) BOOL isSuccess;
@property (nonatomic,strong) NSIndexPath * path;
@property (nonatomic,strong) NSString * type ;

@end