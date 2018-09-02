//
//  ATCheckAttendanceViewCell.h
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATTableViewCell.h"

@class ATPunchCardModel;

typedef void(^ATCheckAttendanceViewCellBlock)(ATPunchCardModel *model);

@interface ATCheckAttendanceViewCell : ATTableViewCell

@property (nonatomic, copy) ATCheckAttendanceViewCellBlock block;

- (void)cellOfEditingBtnClicked:(ATCheckAttendanceViewCellBlock)block;

@end
