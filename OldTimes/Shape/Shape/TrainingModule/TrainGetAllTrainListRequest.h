//
//  TrainGetAllTrainListRequest.h
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"
#import "TrainGetTrainListResultModel.h"

@interface TrainGetAllTrainListRequest : BaseRequest
@property (nonatomic) NSInteger pageSize;	//页容量	Int	非必填	默认为10
@property (nonatomic) NSInteger pageIndex;	//页编号	Int	非必填	默认为1
@property (nonatomic, copy) NSString *difficulty;	//难度	String	非必填	1~5
@property (nonatomic, copy) NSString *equipmentId;	//器械ID	String	非必填
@property (nonatomic, copy) NSString *bodyPort;	//锻炼部位（部位ID）	String	非必填	@property 
@end
@interface TrainGetAllTrainListResponse : BaseResponse
@property (nonatomic, strong) TrainGetTrainListResultModel *model;
@property (nonatomic, copy) NSArray *modelArr;
@end