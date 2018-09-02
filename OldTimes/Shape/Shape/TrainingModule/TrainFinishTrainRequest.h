//
//  TrainFinishTrainRequest.h
//  Shape
//
//  Created by jasonwang on 15/11/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"

@interface TrainFinishTrainRequest : BaseRequest
@property (nonatomic, copy) NSString *identifier;
@end

@interface TrainFinishTrainResponse : BaseResponse

@end