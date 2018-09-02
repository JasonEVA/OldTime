//
//  TrainGetPartRequest.h
//  Shape
//
//  Created by jasonwang on 15/11/9.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"
#import "TrainPartModel.h"

@interface TrainGetPartRequest : BaseRequest

@end
@interface TrainGetPartResponse : BaseResponse
@property (nonatomic, copy) NSArray *modelArr;
@end