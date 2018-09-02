//
//  TrainGetTrainInfoRequest.h
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"
#import "TrainGetTrainInfoModel.h"

@interface TrainGetTrainInfoRequest : BaseRequest
@property (nonatomic, copy) NSString *myId;	//训练ID	String	必填
@end

@interface TrainGetTrainInfoResponse : BaseResponse
@property (nonatomic, strong) TrainGetTrainInfoModel *model;
@property (nonatomic, copy) NSArray *modelArr;
@end