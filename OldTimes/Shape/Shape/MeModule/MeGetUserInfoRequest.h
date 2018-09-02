//
//  MeGetUserInfoRequest.h
//  Shape
//
//  Created by jasonwang on 15/10/23.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"
#import "MeGetUserInfoModel.h"

@interface MeGetUserInfoRequest : BaseRequest

@end


@interface MeGetUserInfoResponse : BaseResponse
@property (nonatomic, strong) MeGetUserInfoModel *userInfoMogdel;
@end
