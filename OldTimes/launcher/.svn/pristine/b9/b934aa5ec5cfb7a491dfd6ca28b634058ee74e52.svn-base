//
//  ATGoOutAttendanceAdapter.h
//  Clock
//
//  Created by SimonMiao on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATTableViewAdapter.h"

@class ATPunchCardModel;
typedef void(^ATGoOutAttendanceAdapterBlock)(ATPunchCardModel *model);

@interface ATGoOutAttendanceAdapter : ATTableViewAdapter

@property (nonatomic, copy) ATGoOutAttendanceAdapterBlock block;

- (void)goToEditingRemark:(ATGoOutAttendanceAdapterBlock)block;

@end
