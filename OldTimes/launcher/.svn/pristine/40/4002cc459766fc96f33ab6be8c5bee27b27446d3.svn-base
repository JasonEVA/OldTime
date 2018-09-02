//
//  ATGetClockListRequest.h
//  Clock
//
//  Created by SimonMiao on 16/7/20.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATHttpBaseRequest.h"

@class ATPunchCardModel;
@interface ATGetClockListResponse : ATHttpBaseResponse

@property (nonatomic, strong) NSArray <ATPunchCardModel *> *dataSource;

@end

@interface ATGetClockListRequest : ATHttpBaseRequest

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, copy) NSString *startTime; //!< 开始时间(yyyy-MM-dd HH:mm:ss),不传返回所有考勤记录
@property (nonatomic, copy) NSString *endTime; //!< 结束时间(yyyy-MM-dd HH:mm:ss),不传返回所有考勤记录
@property (nonatomic, strong) NSNumber *signType; //!< 考勤类型,不传返回全部,【0-未标记;1-上班;2-下班;3-外勤】

@end
