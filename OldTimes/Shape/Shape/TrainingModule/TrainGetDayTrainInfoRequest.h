//
//  TrainGetDayTrainInfoRequest.h
//  Shape
//
//  Created by jasonwang on 15/11/12.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"
#import "TrainGetDayTrainInfoModel.h"
#import "TrainActionListModel.h"
#import "TrainAddMarksModel.h"

@interface TrainGetDayTrainInfoRequest : BaseRequest
@property (nonatomic, copy) NSString *trainID;
@end

@interface TrainGetDayTrainInfoResponse : BaseResponse
@property (nonatomic, strong) TrainGetDayTrainInfoModel *model;
//@property (nonatomic, copy) NSArray <TrainActionListModel *>*actionListArr;
//@property (nonatomic, copy) NSArray <TrainAddMarksModel *>*addMarkArr;
@end