//
//  ATDailyAttendanceAdapter.h
//  Clock
//
//  Created by SimonMiao on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATTableViewAdapter.h"

@class ATPunchCardModel;
typedef void(^ATDailyAttendanceAdapterBlock)(ATPunchCardModel *model);
@interface ATDailyAttendanceAdapter : ATTableViewAdapter

@property (nonatomic, copy) ATDailyAttendanceAdapterBlock block;

- (void)goToEditingRemark:(ATDailyAttendanceAdapterBlock)block;

@end
