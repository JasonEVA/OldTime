//
//  NewCalendarWeekView.m
//  launcher
//
//  Created by williamzhang on 16/3/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarWeekView.h"
#import "NewCalendarWeekTableViewCell.h"
#import <Masonry/Masonry.h>
#import "DateTools.h"
#import "NewCalendarWeeksEventRequest.h"
#import "UnifiedUserInfoManager.h"
#import "NewCalendarWeeksListModel.h"
#import "NewCalendarWeeksModel.h"

#define CELLHEIGHT 80 // cell 的固定高度
#define DAY_NUM    70 // 默认 每次请求10周(10周 是指时间间隔)

@interface  NewCalendarWeekView ()<UITableViewDataSource,UITableViewDelegate,BaseRequestDelegate,NewCalendarWeekTableViewCellDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) CGFloat  topMoveOffsetGate;   // 天花板 默认 0
@property (nonatomic,assign) CGFloat  buttomMoveOffsetGate;// 婴儿底 无默认值

@property (nonatomic,strong) NSMutableArray * onPathArray; //向上插入数据的索引

@property (nonatomic,strong) NSDate * startDate;
@property (nonatomic,strong) NSDate * endDate;

@property (nonatomic, copy, readwrite) NSString *currentMonthTitle;

@property (nonatomic, copy, readwrite) NSString *currentYearTitle;

// 为保证不会连续请求,将其属性化
@property (nonatomic,strong) NewCalendarWeeksEventRequest * onRequest;
@property (nonatomic,strong) NewCalendarWeeksEventRequest * nextRequest ;

@property (nonatomic,assign) int locCount;// 今天所在的位置记录

@end

@implementation NewCalendarWeekView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        //[self initRequest];
    }
    return self;
}

- (void)setLookCalendarUID:(NSString*)uid
{
    if (uid == nil || [uid isEqualToString:@""]) {
        return;
    }
    self.logName = uid;
    [self.dataArray removeAllObjects];
    [self initRequest];
}

- (void)locationWithToday
{
    if ((_locCount+3) > self.dataArray.count) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_locCount+2 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark Private Method
// 初始化的时候获取 只执行一次
- (void)initRequest
{
    NSDate * start = [self getDayStart];
    NSDate * end = [self getDayEnd];
    NSDate * stData = [start dateBySubtractingDays:DAY_NUM];
    NSDate *dateEnd = [end dateByAddingDays:DAY_NUM];
    self.startDate = [start copy];
    self.endDate = [end copy];
    
    NewCalendarWeeksEventRequest * request = [[NewCalendarWeeksEventRequest alloc] initWithDelegate:self];
    request.requestType = Request_Type_INIT;
    [request eventListWithStartDate:stData endDate:dateEnd userLoginName:self.logName];
}
// 获取上一周的日程 (最早的一天的上一周)
- (void)onWeeksRequest
{
    if (_onRequest) {
        return;
    }
    NewCalendarWeeksListModel * model = [self.dataArray firstObject];
    NSDate * stData = [model.srartTime dateBySubtractingDays:DAY_NUM];
    NSDate *dateEnd = [model.endTime dateBySubtractingDays:1];
    _onRequest = [[NewCalendarWeeksEventRequest alloc] initWithDelegate:self];
    _onRequest.requestType = Request_Type_ON;
    [_onRequest eventListWithStartDate:stData endDate:dateEnd userLoginName:self.logName];
}
// 获取下一周的日程 (最晚的一天的下一周)
- (void)nextWeeksRequest
{
    if (_nextRequest) {
        return;
    }
    NewCalendarWeeksListModel * model = [self.dataArray lastObject];
    NSDate * stData = [model.srartTime dateByAddingDays:1];
    NSDate *dateEnd = [model.endTime dateByAddingDays:DAY_NUM];
    _nextRequest = [[NewCalendarWeeksEventRequest alloc] initWithDelegate:self];
    _nextRequest.requestType = Request_Type_NEXT;
    [_nextRequest eventListWithStartDate:stData endDate:dateEnd userLoginName:self.logName];
}

/// 获得当前时间段的月标题内容(考虑跨年情况)
- (NSString *)getCurrentMonthTitleWithStartDay:(NSDate *)start EndDay:(NSDate *)end {
	NSString *result = @"";
	if (start.year != end.year) {
		result = [NSString stringWithFormat:@"%ld年%ld月%ld日-%ld年%ld月%ld日", (long)start.year,(long)start.month,(long)start.day, (long)end.year, (long)end.month,(long)end.day];
	} else {
		result = [NSString stringWithFormat:@"%ld月%ld日-%ld月%ld日",(long)start.month,(long)self.startDate.day,(long)end.month,(long)end.day];
	}
	
	return result;
}

/// 获当前时间的年标题内容
- (NSString *)getCurrentYearTitleWithStartDay:(NSDate *)start {
	return [NSString stringWithFormat:@"%ld年",(long)start.year];
}

#pragma mark - BaseRequestDelegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[NewCalendarWeeksEventRequest class]]) {
        NewCalendarWeeksEventRequest * requ = (NewCalendarWeeksEventRequest *)request;
        NewCalendarWeeksEventResponse * resp = (NewCalendarWeeksEventResponse *)response;
        switch (requ.requestType) {
            case Request_Type_INIT:
            {
                NSMutableArray * array = [self dealData:resp.dataArray type:requ.requestType];
                self.dataArray = [array mutableCopy];
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:DAY_NUM+3 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
				if ([self isMyself]) {
					_locCount += DAY_NUM;
				} else {
					_locCount = DAY_NUM;
				}
            }
                break;
                
            case Request_Type_NEXT:
            {
                NSMutableArray * array = [self dealData:resp.dataArray type:requ.requestType];
                [self.dataArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataArray.count, array.count)]];
                [self.tableView reloadData];
                _nextRequest = nil;
            }
                break;
                
            case Request_Type_ON:
            {
                NSMutableArray * array = [self dealData:resp.dataArray type:requ.requestType];
                [self.dataArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                float y = self.tableView.contentOffset.y;
                [self.tableView reloadData];
                [self.tableView setContentOffset:CGPointMake(0, DAY_NUM *CELLHEIGHT + y)];
                _onRequest = nil;
                _locCount += DAY_NUM;
            }
                break;
                
            default:
                break;
        }
    }
    
}
- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    if ([request isKindOfClass:[NewCalendarWeeksEventRequest class]]) {
        _onRequest = nil;
        _nextRequest = nil;
    }
}

#pragma mark - NewCalendarWeekTableViewCellDelegate

- (void)newCalendarWeekTableViewCell_SelectCalendarWithRow:(NSInteger)row num:(NSInteger)num
{
    NewCalendarWeeksListModel * model = [self.dataArray objectAtIndex:row];
    NewCalendarWeeksModel * model1 = [model.calendarArray objectAtIndex:num];
    
    if ([self.delegate respondsToSelector:@selector(NewCalendarWeekViewDidSelectModel:)]) {
        [self.delegate NewCalendarWeekViewDidSelectModel:model1];
    }
}

#pragma mark -  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL isToday = NO;
    NSDate * todayDate = [NSDate date];
    self.startDate = nil;
    self.endDate = nil;
    for (NewCalendarWeekTableViewCell *cell in self.tableView.visibleCells)
    {
        if (self.startDate == nil)
        {
            self.startDate = [cell.startDate copy];
        }
        if ([cell.startDate isEarlierThan:self.startDate]) {
            self.startDate = [cell.startDate copy];
        }
        if ([cell.endDate isLaterThan:self.endDate]) {
            self.endDate = [cell.endDate copy];
        }
        if (cell.endDate.day == todayDate.day && cell.endDate.month == todayDate.month && cell.endDate.year == todayDate.year) {
            isToday = YES;
        }
    }
	
	NSString *yearTitile = [self getCurrentYearTitleWithStartDay:self.startDate];
	NSString *monthTitle = [self getCurrentMonthTitleWithStartDay:self.startDate EndDay:self.endDate];

    self.currentMonthTitle = monthTitle;
    self.currentYearTitle = yearTitile;
    
    if (_delegate && [_delegate respondsToSelector:@selector(NewCalendarWeekView_ChangeStartDate:endDate:)]) {
        [_delegate NewCalendarWeekView_ChangeStartDate:yearTitile endDate:monthTitle];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(setIsToday:)]) {
        [_delegate setIsToday:isToday];
    }
    
    
    if (scrollView == self.tableView) {
        if (self.tableView.contentSize.height - self.tableView.contentOffset.y - self.tableView.frame.size.height < CELLHEIGHT*7)
        {
            [self nextWeeksRequest];
        }
        // 无限上拉
        else if (self.tableView.contentOffset.y < CELLHEIGHT*7)
        {
            [self onWeeksRequest];
        }
    }
    
    if (scrollView == self.tableView)
    {
        
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"cell";
    NewCalendarWeekTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[NewCalendarWeekTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        [cell setCalendarDelegate:self];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setCellData:self.dataArray[indexPath.row]];
    [cell setCellPath:indexPath];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; };
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01; };
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return CELLHEIGHT; };


#pragma mark - tool
// 获取 当天刚开始的时间戳
- (NSDate *)getDayStart
{
    NSDate * date = [NSDate date];
    return [NSDate dateWithYear:date.year month:date.month day:date.day hour:0 minute:0 second:0];
}
// 获取当天最后的时间的时间戳
- (NSDate *)getDayEnd
{
    NSDate * date = [NSDate date];
    return [NSDate dateWithYear:date.year month:date.month day:date.day hour:23 minute:59 second:59];
}

- (NSMutableArray * )dealData:(NSMutableArray *)DataArray  type:(Request_Type)type
{
    NSMutableArray * mutArray;
    switch (type) {
        case Request_Type_INIT:
        {
            NSMutableArray * listArray = [NSMutableArray array];
            NewCalendarWeeksListModel * model = [[NewCalendarWeeksListModel alloc] init];
            model.srartTime = [self getDayStart];
            model.endTime = [self getDayEnd];
            [model setDayAndWeek];
            
            [listArray addObject:model];
            
            {
                NSMutableArray * array = [self get_NEXT_ListModelWithNum:DAY_NUM model:model];
                [listArray addObjectsFromArray:array];
            }
            {
                NSMutableArray * array = [self get_ON_ListModelWithNum:DAY_NUM model:model];
                [listArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
            }
            
            mutArray = [self dataMarryList:listArray data:DataArray];
            
        }
            break;
            
        case Request_Type_NEXT:
        {
            NewCalendarWeeksListModel * model = [self.dataArray lastObject];
            NSMutableArray * array = [self get_NEXT_ListModelWithNum:DAY_NUM model:model];
            mutArray = [self dataMarryList:array data:DataArray];
        }
            break;
            
        case Request_Type_ON:
        {
            NewCalendarWeeksListModel * model = [self.dataArray firstObject];
            NSMutableArray * array = [self get_ON_ListModelWithNum:DAY_NUM model:model];
            mutArray = [self dataMarryList:array data:DataArray];
            
        }
            break;
            
        default:
            break;
    }
    
    return mutArray;
}

- (NSMutableArray *)get_ON_ListModelWithNum:(NSUInteger)num  model:(NewCalendarWeeksListModel *)model
{
    NSMutableArray * array= [NSMutableArray array];
    int count = (int)num;
    for (int i = 0; i < num; i ++) {
        NewCalendarWeeksListModel * newModel = [[NewCalendarWeeksListModel alloc] init];
        newModel.srartTime = [model.srartTime dateBySubtractingDays:count];
        newModel.endTime = [model.endTime dateBySubtractingDays:count];
        [newModel setDayAndWeek]; // 设置好时间区间后计算日期和周几
        [array addObject:newModel];
        count --;
        if (count == 0) {
            break;
        }
    }
    return array;
}
- (NSMutableArray *)get_NEXT_ListModelWithNum:(NSUInteger)num  model:(NewCalendarWeeksListModel *)model
{
    NSMutableArray * array= [NSMutableArray array];
    for (int i = 0; i < num; i ++) {
        NewCalendarWeeksListModel * newModel = [[NewCalendarWeeksListModel alloc] init];
        newModel.srartTime = [model.srartTime dateByAddingDays:i+1];
        newModel.endTime = [model.endTime dateByAddingDays:i+1];
        [newModel setDayAndWeek]; // 设置好时间区间后计算日期和周几
        [array addObject:newModel];
    }
    return array;
}

- (NSMutableArray *)dataMarryList:(NSMutableArray *)listArray data:(NSMutableArray *)data
{
    for (NewCalendarWeeksModel * model in data) {
        for (NewCalendarWeeksListModel * listModel in listArray) {
            NSDate * stDate = [NSDate dateWithTimeIntervalSince1970:model.startTime/1000];
            NSDate * endDate = [NSDate dateWithTimeIntervalSince1970:model.endTime/1000];
            
            if ([stDate isEarlierThan:listModel.endTime] && [endDate isLaterThan:listModel.srartTime]) {
                [listModel addModel:model];
            }
        }
    }
    for (NewCalendarWeeksListModel * listModel in listArray) {
        [listModel calendarRank];// 排序
    }
    return listArray;
}

- (BOOL)isMyself {
    return [self.logName isEqualToString:[UnifiedUserInfoManager share].userShowID];
}

/**
 *  判断today的Cell是否出现在界面上
 */
- (BOOL)isTodayVisible {
	if (!self.tableView.visibleCells) {
		return NO;
	}
	
	NSDate *todayDate = [NSDate date];
	
	for (NewCalendarWeekTableViewCell *cell in self.tableView.visibleCells)
	{
		if (cell.endDate.day == todayDate.day && cell.endDate.month == todayDate.month && cell.endDate.year == todayDate.year) {
			return YES;
		}
	}
	
	return NO;
}

#pragma mark - init
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)onPathArray
{
    if (!_onPathArray) {
        _onPathArray = [NSMutableArray array];
        for (int i = 0; i < DAY_NUM; i ++) {
            NSIndexPath * path = [NSIndexPath indexPathForRow:i inSection:0];
            [_onPathArray addObject:path];
        }
    }
    return _onPathArray;
}

@end
