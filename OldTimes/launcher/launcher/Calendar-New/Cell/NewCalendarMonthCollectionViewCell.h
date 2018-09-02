//
//  NewCalendarMonthCollectionViewCell.h
//  launcher
//
//  Created by kylehe on 16/3/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  日程 － 月 － 弹出

#import <UIKit/UIKit.h>
@class NewCalendarWeeksListModel;

@protocol NewCalendarMonthCollectionViewCellDelegate <NSObject>

- (void)newCalendarMonthCollectionViewCell_SelectCalendarWithPath:(NSIndexPath *)path;
- (void)newCalendarMonthCollectionViewCell_pushCreatCalendarVCWithIsMetting:(BOOL)isMetting date:(NSDate *)date;//YES 创建会议 , NO 创建日程

@end



@interface NewCalendarMonthCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSIndexPath * indexPath;

@property (nonatomic,assign) id<NewCalendarMonthCollectionViewCellDelegate>  delegate;

- (void)setCellData:(NewCalendarWeeksListModel *)model;
- (void)setHidenBottomViewsWhileIsReadOnly:(BOOL)readOnly;
@end
