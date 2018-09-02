//
//  MeGetTrainHistoryRequest.h
//  Shape
//
//  Created by jasonwang on 15/11/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"
#import "MeTrainHistoryListModel.h"

@interface MeGetTrainHistoryRequest : BaseRequest
@property (nonatomic) NSInteger pageSize;	//页容量	Int	非必填	默认为10
@property (nonatomic) NSInteger pageIndex;	//页编号	Int	非必填	默认为1
@end

@interface MeGetTrainHistoryResponse : BaseResponse
@property (nonatomic, strong) MeTrainHistoryListModel *model;
@end