//
//  MeGetCityListRequest.h
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"
#import "MeCityListModel.h"

@interface MeGetCityListRequest : BaseRequest
@property (nonatomic) NSInteger areaType;
@property (nonatomic, copy) NSString *areaCode;
@end

@interface MeGetCityListResponse : BaseResponse
@property (nonatomic, copy) NSArray *modelArr;
@end