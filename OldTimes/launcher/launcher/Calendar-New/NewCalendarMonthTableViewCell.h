//
//  NewCalendarMouthTableViewCell.h
//  launcher
//
//  Created by kylehe on 16/3/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CellType)
{
    k_cell_First = 0,  //第一行
    k_cell_Middle,     //中间的行
    k_cell_Last        //最后的一行
};

@class NewCalendarMonthDataModel;
@protocol NewCalenarMonthTableViewCellDelegate <NSObject>

- (void)getDateWithDelegate:(NSDate *)date;

@end
@interface NewCalendarMonthTableViewCell : UITableViewCell

@property(nonatomic, weak) id delegate;

@property(nonatomic, assign) CellType  cellType;
/**
 *  一周时间的数据的array
 */
@property(nonatomic, strong) NSArray  *array;
/**
 *  储存事件数据的数组
 */
@property(nonatomic, strong) NSMutableArray  *eventArray;
/**
 *  记录一下model，方便进行时间切换
 */
@property(nonatomic, strong) NewCalendarMonthDataModel   *currentModel;
/**
 *  获取标签
 */
+ (NSString *)identifier;

/**
 *  设置日期数组
 *
 *  @param array      时间模型数组
 *  @param eventArray 事件模型数组
 */
- (void)setDataWithArray:(NSArray *)array eventArray:(NSMutableArray *)eventArray;


@end
