//
//  TrainGetMyTrainListRequest.h
//  Shape
//
//  Created by jasonwang on 15/11/9.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"
#import "TrainGetMyTrainListModel.h"

@interface TrainGetMyTrainListRequest : BaseRequest

@end

@interface TrainGetMyTrainListResponse : BaseResponse
@property (nonatomic, copy) NSArray *modelArr;

@end