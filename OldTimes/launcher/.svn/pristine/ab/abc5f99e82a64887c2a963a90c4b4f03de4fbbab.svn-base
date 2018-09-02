//
//  ATGoOutAttendanceHeadView.h
//  Clock
//
//  Created by SimonMiao on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ATGoOutAttendanceHeadViewBlock)(NSNumber *timestamp);

@interface ATGoOutAttendanceHeadView : UIView

@property (nonatomic, strong) NSNumber *currentTimestamp;
@property (nonatomic, copy) ATGoOutAttendanceHeadViewBlock block;

- (void)goOutClock:(ATGoOutAttendanceHeadViewBlock)block;

@end
