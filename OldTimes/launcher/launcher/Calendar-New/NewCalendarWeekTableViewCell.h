//
//  NewCalendarWeekTableViewCell.h
//  launcher
//
//  Created by TabLiu on 16/3/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCalendarWeeksListModel.h"

@protocol NewCalendarWeekTableViewCellDelegate <NSObject>

- (void)newCalendarWeekTableViewCell_SelectCalendarWithRow:(NSInteger)row num:(NSInteger)num;

@end

@interface NewCalendarWeekTableViewCell : UITableViewCell

@property (nonatomic,assign)  id<NewCalendarWeekTableViewCellDelegate>  calendarDelegate;

@property (nonatomic,strong) NSDate * startDate ;
@property (nonatomic,strong) NSDate * endDate;

- (void)setCellData:(NewCalendarWeeksListModel *)dataArray;
- (void)setCellPath:(NSIndexPath *)path;

@end
