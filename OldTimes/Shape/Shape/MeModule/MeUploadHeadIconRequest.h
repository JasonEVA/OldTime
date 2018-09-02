//
//  MeUplloadHeadIconRequest.h
//  Shape
//
//  Created by jasonwang on 15/10/26.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"
#import "MeUploadIconModel.h"

@interface MeUploadHeadIconRequest : BaseRequest

@end

@interface MeUploadHeadIconResponse : BaseResponse
@property (nonatomic, strong) MeUploadIconModel *model;
@end