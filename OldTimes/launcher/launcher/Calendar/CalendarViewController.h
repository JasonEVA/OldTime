//
//  CalendarViewController.h
//  Launchr
//
//  Created by Conan Ma on 15/7/23.
//  Copyright (c) 2015年 Conan Ma. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchView.h"
#import "CalendarMonthDataModel.h"
#import "CalendarMonthTableViewCell.h"
#import "CalendarWeekDataModel.h"
#import "CalendarGetEventListRequest.h"

@interface CalendarViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CalendarMonthTableViewCellDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,BaseRequestDelegate>
{
    //    UITableView *_tableView;
    
    CGFloat _topMoveOffsetGate;                 // 顶部的门限值
    CGFloat _buttomMoveOffsetGate;              // 底部的门限值
    
    // 有关 MonthData 的数组
    NSInteger _rowTotalNumber;                  // 存放多少 Month 数据
    NSInteger _rowMoveNumber;                   // 每次移动多少
    
    NSInteger _SelectedCurrent;                 //当前选中的日期
    NSInteger _TodayMonth;                       //今天的月
    NSInteger _Month;                             //周title的月
    NSInteger _DayMonth;                          //日title的月
    NSInteger _Year;                              //title的年
    NSDate *_SelectedDate;                          //从月跳转到日日期缓存
    
    NSMutableArray *_arrayMonthDataModel;       // 存放月份的 Model 数组
}
@property (nonatomic, strong) UITableView *tableView;             //月表
@property (nonatomic, strong) UITableView *tableViewEventList;    //事件表
@property (nonatomic, strong) UIScrollView *ScrollView;           //总的容器
//@property (nonatomic, strong) UIScrollView *ScrollViewWeek;       //周的容器
@property (nonatomic, strong) UICollectionView *CollectionViewWeek; //周的容器
//@property (nonatomic, strong) SearchView *searchView;             //搜索框
@property (nonatomic, strong) NSMutableArray *arrWeekModels;       //存放星期的model数组
//@property (nonatomic, strong) NSMutableArray *arrDayWeekModels;       //存放星期的model数组
@property (nonatomic, strong) NSDate *DateBefore;         //存目前获取到的之前的date
@property (nonatomic, strong) NSDate *DateAfter;          //存目前获取到的之后的date
//@property (nonatomic, strong) NSDate *DayDateBefore;         //存目前获取到的之前的date
//@property (nonatomic, strong) NSDate *DayDateAfter;          //存目前获取到的之后的date
@property (nonatomic, strong) CalendarWeekDataModel *LastWeekModels;    //存储新增加的前10个周
@property (nonatomic, strong) CalendarWeekDataModel *NextWeekModels;    //存储新增加的后10个周
@property (nonatomic, strong) NSMutableArray *arrTableViewEvent;  //事件数据
//@property (nonatomic, strong) UICollectionView *CollectionViewDays;  //日的容器
//@property (nonatomic, strong) UITableView *TableViewDayEventList;    //日的事件列表

// 新建日程
- (void)newEvent;

@end
