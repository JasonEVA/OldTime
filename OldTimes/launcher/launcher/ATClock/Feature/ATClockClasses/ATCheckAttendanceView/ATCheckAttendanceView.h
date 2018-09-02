//
//  ATCheckAttendanceView.h
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATTableView.h"

typedef void(^ATCheckAttendanceViewBlock)(NSNumber *timestamp);

@interface ATCheckAttendanceView : ATTableView

@property (nonatomic, strong) NSNumber *currentTimestamp;
@property (nonatomic, assign) BOOL isDesignatedArea;
@property (nonatomic, copy) ATCheckAttendanceViewBlock block;

- (void)attendanceViewOfGoToPunchCard:(ATCheckAttendanceViewBlock)block;

- (void)showFooterView;
- (void)hideFooterView;


- (void)showNoInfoView;
- (void)hideNoInfoView;

@end
