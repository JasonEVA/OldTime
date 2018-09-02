//
//  ATGetClockRuleModel.h
//  Clock
//
//  Created by SimonMiao on 16/7/22.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATGetClockLocationListModel : NSObject

@property (nonatomic, copy) NSString *Lat;
@property (nonatomic, copy) NSString *Location;
@property (nonatomic, copy) NSString *Lon;
@property (nonatomic, strong) NSNumber *Offset; //!< 允许偏移量

@end

@interface ATGetClockRuleModel : NSObject

@property (nonatomic, strong) NSArray *LocationList;
@property (nonatomic, strong) NSNumber *OffWorkTime;
@property (nonatomic, strong) NSNumber *OnWorkTime;
@property (nonatomic, copy) NSString *OrgId;
@property (nonatomic, copy) NSString *UserId;

+ (ATGetClockRuleModel *)decodeClockRuleModelFromUserDefault;

@end
