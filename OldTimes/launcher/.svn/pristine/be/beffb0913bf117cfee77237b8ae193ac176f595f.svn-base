//
//  ATCheckAttendanceViewAdapter.h
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATTableViewAdapter.h"

@class ATPunchCardModel;
typedef void(^ATCheckAttendanceViewAdapterBlock)(ATPunchCardModel *model);

@interface ATCheckAttendanceViewAdapter : ATTableViewAdapter

@property (nonatomic, copy) ATCheckAttendanceViewAdapterBlock block;

- (void)goToEditingRemark:(ATCheckAttendanceViewAdapterBlock)block;

@end
