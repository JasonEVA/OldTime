//
//  NewCalendarMonthView.m
//  launcher
//
//  Created by williamzhang on 16/3/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarMonthView.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "Category.h"
#import "NSDate+CalendarTool.h"
#import "NewCalendarMonthTableViewCell.h"
#import "NewCalendarMonthDataModel.h"
#import "NewCalendarDataHelper.h"
#import "NewCalendarYearAndMonthNumberView.h"
#import "NewCalendarWeeksModel.h"
#import <NSDate+DateTools.h>
static NSString *const idetifier = @"identifier";
//static NSInteger const TopDistace = 100;
static NSInteger const BottomDistace = 100;
static CGFloat const kMonthViewHeadViewHeight = 30;
static CGFloat const kMonthViewHeadViewBottomLineHeight = 0.5;


@interface NewCalendarMonthView ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,NewCalenarMonthTableViewCellDelegate>

@property (nonatomic, strong) UIView *headerView;

// Data
@property (nonatomic, strong) NSMutableArray *dateList;

/**
 *  二维数组
 */
@property(nonatomic, strong) NSMutableArray  *monthModelArray;

/**
 *  时间数据模型数组
 */
@property(nonatomic, strong) NSMutableArray  *eventDataModelArray;

@property (nonatomic, copy, readwrite) NSString *currentMonthTitle;

@property (nonatomic, copy, readwrite) NSString *currentYearTitle;

@end

@implementation NewCalendarMonthView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@(kMonthViewHeadViewHeight));
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.right.bottom.equalTo(self);
        }];
        
        [self bottomLineSetup];
        //首先今年的月份数据
        [self prepareFirstData];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[NSDate mtc_month:[NSDate date]] -1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }
    return self;
}

#pragma mark - uitableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.monthModelArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NewCalendarMonthDataModel *model = self.monthModelArray[section][0];
    NSInteger totalCount = model.lines;
    return  totalCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewCalendarMonthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewCalendarMonthTableViewCell identifier]];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *array = self.monthModelArray[indexPath.section];
    
    NewCalendarMonthDataModel *model = array[0];
    NSInteger firstWeelDay = model.firstWeekDay;
    NSIndexSet *indexset = nil;
    
    if (indexPath.row == 0) {                    //第一行
        indexset = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 7 - firstWeelDay )];
     
        cell.cellType = k_cell_First;
        
    }else if (indexPath.row != model.lines - 1 ) //中间的行
    {
        indexset = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange( 7 - firstWeelDay + (indexPath.row - 1) * 7 , 7)];
        cell.cellType = k_cell_Middle;
        
//        self.titleView.yearLbl.text = [NSString stringWithFormat:@"%ld年",model.year];
//        self.titleView.monthLbl.text = [NSString stringWithFormat:@"%ld月",model.month];
		self.currentYearTitle = [NSString stringWithFormat:@"%ld年",(long)model.year];
		self.currentMonthTitle = [NSString stringWithFormat:@"%ld月",(long)model.month];
//		self.titleView.yearLbl.text = self.currentYearTitle;
//		self.titleView.monthLbl.text = self.currentMonthTitle;
		
		if (cell.delegate && [cell.delegate respondsToSelector:@selector(newCalendarMonthViewDelegateDidTitleViewChangeWithYearsText:MonthsText:)]) {
			[cell.delegate newCalendarMonthViewDelegateDidTitleViewChangeWithYearsText:self.currentYearTitle MonthsText:self.currentMonthTitle];
		}
		
    }else                                        //最后一行
    {
        indexset = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange( 7 - firstWeelDay + (indexPath.row - 1) * 7 , array.count - (model.lines - 2) * 7 - (7 - firstWeelDay))];
        cell.cellType = k_cell_Last;
        
    }
    //======== 以上为时间标签处理
    //======== 以下为事件数据处理
    self.eventDataModelArray = [self.eventDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)model.year]];
    
    //获取一周内的
    NSArray *currnetArray = [array objectsAtIndexes:indexset];
    
    ///*********事件过滤**********/
    
    //储存时间model
    NSMutableArray *tempArray = [NSMutableArray array];
    //用一周的时间model与所有的事件model进行对比
    //这一周的每天时间
    NewCalendarMonthDataModel *startDayModel = currnetArray[0];
    //用于记录这个月的第一天
    if (indexPath.row != model.lines - 1){ self.currentDateModel = startDayModel;}
    //这周结束的时间
    NewCalendarMonthDataModel *endDayModel   = [currnetArray lastObject];
    //所有事件的数组
    for (NewCalendarWeeksModel *model in self.eventDataModelArray)
    {
        //转换为NSDate
        NSDate *eventStartDate = [NSDate dateWithTimeIntervalSince1970:model.startTime/1000];
        NSDate *eventEndDate   = [NSDate dateWithTimeIntervalSince1970:model.endTime/1000];
        
        if ([eventStartDate isEarlierThan:endDayModel.endDate]&&[eventEndDate isLaterThan:startDayModel.startDate])
        {
            [tempArray addObject:model];
        }
    }
    
    //去重
    NSMutableArray *tpArray = [self arrayWithMember:tempArray];
    
    if (cell.eventArray) [cell.eventArray removeAllObjects];
    [cell.eventArray addObjectsFromArray:tpArray];

    //currentArray:时间数据 tpArray:事件数据
    [cell setDataWithArray:currnetArray eventArray:tpArray];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = self.monthModelArray[indexPath.section];
    NewCalendarMonthDataModel *model = array[0];
    return (IOS_SCREEN_HEIGHT - 49 - 64 - 30)/model.lines;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - uiscrollviewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.tableView.visibleCells)
    {
        NewCalendarMonthTableViewCell *cell = self.tableView.visibleCells[1];
		self.currentYearTitle = [NSString stringWithFormat:@"%ld年",(long)cell.currentModel.year];
		self.currentMonthTitle = [NSString stringWithFormat:@"%ld月",(long)cell.currentModel.month];
		
		if (self.delegate && [self.delegate respondsToSelector:@selector(newCalendarMonthViewDelegateDidTitleViewChangeWithYearsText:MonthsText:)]) {
			[self.delegate newCalendarMonthViewDelegateDidTitleViewChangeWithYearsText:self.currentYearTitle MonthsText:self.currentMonthTitle];
			
		}
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        //处理无限拉动
        //上拉
        if (self.tableView.contentOffset.y <  0) {
            self.monthModelArray = [[NewCalendarDataHelper shareInstace] getLastYearDataModelArray];
            [self.tableView reloadData];
            [self refreshHeight];
        }
        else //下拉
            if(self.tableView.contentSize.height - self.tableView.contentOffset.y - self.tableView.frame.size.height < BottomDistace)
            {
                self.monthModelArray = [[NewCalendarDataHelper shareInstace] getNextYearDataModelArray];
                [self.tableView reloadData];
            }
    }
    
    //设置title的文字
    CGFloat persent = (CGFloat)(self.tableView.contentOffset.y + self.frame.size.height/4) / (CGFloat)self.tableView.contentSize.height;
    NSInteger index = (NSInteger)(persent * self.monthModelArray.count);
    NewCalendarMonthDataModel *model = self.monthModelArray[index][0];
    
    NSDate *datetoday = [NSDate date];
    if (model.year == datetoday.year && datetoday.month == model.month)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(SetTodayColor:)])
        {
            [self.delegate SetTodayColor:YES];
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(SetTodayColor:)])
        {
            [self.delegate SetTodayColor:NO];
        }
    }
    
    //加载事件数据
    NSArray *dateArray = [self.eventDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)model.year]];
    if (!dateArray)
    {
        if (model.year > [NSDate date].year && model.month == 1)
        {
            [self getEventDataWithType:k_getNextYearEventData];
            
        }else if (model.year < [NSDate date].year && model.month == 12)
        {
            [self getEventDataWithType:k_getLastYearEventData];
        }
    }
}

#pragma mark - newCalendarMonthViewDelegate
- (void)getDateWithDelegate:(NSDate *)date
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(presentVCWithDate:)])
    {
        [self.delegate presentVCWithDate:date];
    }
}

- (void)getEventDataWithType:(RequestType)type
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(getMoreEventDataWithType:)])
    {
        [self.delegate getMoreEventDataWithType:type];
    }
}

#pragma mark - privateMethod

- (NSMutableArray *)arrayWithMember:(NSArray *)array
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < [array count]; i++)
    {
        if ([tempArray containsObject:[array objectAtIndex:i]] == NO)
        {
            [tempArray addObject:[array objectAtIndex:i]];
        }
    }
    return tempArray;
}

/**
 *  准备第一个月的数据
 */
- (void)prepareFirstData
{
    NewCalendarDataHelper *helper = [NewCalendarDataHelper shareInstace];
    self.monthModelArray =  [helper getCurrentDateModel];
}
/**
 *  准备上一年的数据
 */
- (void)prepareLastYearData
{
    NewCalendarDataHelper *helper = [NewCalendarDataHelper shareInstace];
    self.monthModelArray = [helper getLastYearDataModelArray];
}
/**
 *  准备下一年的数据
 */
- (void)prepareNextYearData
{
    NewCalendarDataHelper *helper = [NewCalendarDataHelper shareInstace];
    self.monthModelArray = [helper getNextYearDataModelArray];
}

- (void)refreshHeight
{
    NewCalendarDataHelper *helper = [NewCalendarDataHelper shareInstace];
    NSInteger height = 0;
    for (int i = 0; i <12 ; i ++)
    {
        NSArray *modelArray = helper.modelArray[i];
        NewCalendarMonthDataModel *model = modelArray[0];
        height += model.lines*((IOS_SCREEN_HEIGHT - 49 - 64 - 30)/model.lines);
    }
    
    self.tableView.contentOffset = CGPointMake(0, height + self.tableView.contentOffset.y);
}

/**
 *  判断当前模型展示的界面是否包含今天
 */
- (BOOL)isTodayVisible {
	return (self.currentDateModel.year == [NSDate date].year) && (self.currentDateModel.month == [NSDate date].month);
	
}

#pragma mark - Setup
- (void)bottomLineSetup {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor borderColor];
    [self.headerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.headerView);
        make.height.equalTo(@(kMonthViewHeadViewBottomLineHeight));
    }];
}

#pragma mark - Initializer
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        
        NSArray *weekDays = @[LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY),
                              LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY),
                              LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY),
                              LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY),
                              LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY),
                              LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY),
                              LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY)];
        UIView *lastView;
        for (NSInteger i = 0; i < [weekDays count]; i ++) {
            NSString *weekDay = weekDays[i];
            
            UILabel *label = [UILabel new];
            label.text = weekDay;
            if (i == 0 || i == 6)
            {
                label.textColor = [UIColor mediumFontColor];
            }
            else
            {
                label.textColor = [UIColor blackColor];
            }
            
            label.font = [UIFont mtc_font_26];
            label.textAlignment = NSTextAlignmentCenter;
            
            [_headerView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(_headerView);
                if (lastView) {
                    make.left.equalTo(lastView.mas_right);
                    make.width.equalTo(lastView);
                } else {
                    make.left.equalTo(_headerView);
                }
                
                if (i == [weekDays count] - 1) {
                    make.right.equalTo(_headerView);
                }
            }];
            
            lastView = label;
        }
    }
    return _headerView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor whiteColor];
        _tableView.pagingEnabled = YES;
        [_tableView registerClass:[NewCalendarMonthTableViewCell class] forCellReuseIdentifier:[NewCalendarMonthTableViewCell identifier]];
    }
    return _tableView;
}


@end
