//
//  ATStaticOutsideDetailRequest.h
//  Clock
//
//  Created by Dariel on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATHttpBaseRequest.h"

@class ATStaticOutsideModel;
@interface ATStaticOutsideDetailResponse : ATHttpBaseResponse

@property (nonatomic, strong) NSArray<ATStaticOutsideModel *> *dataSource;

@end

@interface ATStaticOutsideDetailRequest : ATHttpBaseRequest

@property (nonatomic, copy) NSString *userId; //!< 用户标识
@property (nonatomic, copy) NSString *startTime; //!< 开始时间
@property (nonatomic, copy) NSString *endTime; //!< 结束时间
@property (nonatomic, copy) NSString *orgId; //!< 企业标识
@property (nonatomic, assign) NSInteger signType; // !< 考勤类型,不传返回全部

@end
