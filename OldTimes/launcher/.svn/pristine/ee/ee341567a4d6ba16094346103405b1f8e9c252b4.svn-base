//
//  ATCheckAttendanceHeaderView.h
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ATCheckAttendanceHeaderViewBlock)(NSNumber *timestamp);

@interface ATCheckAttendanceHeaderView : UIView

@property (nonatomic, strong) NSNumber *currentTimestamp;
@property (nonatomic, assign) BOOL isDesignatedArea;
@property (nonatomic, copy) ATCheckAttendanceHeaderViewBlock block;

- (void)headerViewOfPunchCardBtnClicked:(ATCheckAttendanceHeaderViewBlock)block;

@end
