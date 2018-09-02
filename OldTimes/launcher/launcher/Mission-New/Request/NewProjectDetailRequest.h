//
//  NewProjectDetailRequest.h
//  launcher
//
//  Created by jasonwang on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
// 获取项目详情请求

#import "BaseRequest.h"
#import "ProjectDetailModel.h"


@interface NewProjectDetailResponse : BaseResponse

@property (nonatomic, strong) ProjectDetailModel *model;

@end

@interface NewProjectDetailRequest : BaseRequest

- (void)detailShowId:(NSString *)showId;

@end