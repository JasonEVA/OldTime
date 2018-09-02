//
//  NewPopUpCalendarListView.m
//  launcher
//
//  Created by TabLiu on 16/3/14.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewPopUpCalendarListView.h"
#import "DeviceDefine.h"
#import "NewCalendarCardFlowLayout.h"
#import "NewCalendarMonthCollectionViewCell.h"
#import "NewCalendarWeeksEventRequest.h"
#import "DateTools.h"
#import "NewCalendarWeeksListModel.h"
#import "NewCalendarWeeksModel.h"
#import <Masonry/Masonry.h>
#import "NewCalendarAddMeetingViewController.h"
#import "NewCalendarAddNewEventViewController.h"
#import "BaseNavigationController.h"

#define DAY_NUM    70 // 默认 每次请求10周(10周 是指时间间隔)
//#define CELL_WIDTH 335

@interface NewPopUpCalendarListView ()<UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout,BaseRequestDelegate,NewCalendarMonthCollectionViewCellDelegate>

@property(nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic,strong) NSMutableArray * dataArray;

// 为保证不会连续请求,将其属性化
@property (nonatomic,strong) NewCalendarWeeksEventRequest * onRequest;
@property (nonatomic,strong) NewCalendarWeeksEventRequest * nextRequest ;


@property (nonatomic,assign) int locCount;// 今天所在的位置记录

@property (nonatomic,copy) NewPopUpCalendarListViewBlock block ;
@property (nonatomic, strong) jumptoadd jumptoaddevent;
@property (nonatomic,strong) NSDate * date;

@property (nonatomic,assign) CGFloat W_float;

@property (nonatomic, assign) BOOL readOnly;
@end

@implementation NewPopUpCalendarListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.5];
        
        UIButton * button  = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
        [self.collectionView setBackgroundView:button];
        
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[NewCalendarMonthCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.userInteractionEnabled = YES;
        
        //[self initRequest];

    }
    return self;
}

- (void)setDisMissBlock:(NewPopUpCalendarListViewBlock)block
{
    self.block = block;
}

- (void)setJumptoaddeventnblock:(jumptoadd)block
{
    self.jumptoaddevent = block;
}

- (void)setLookCalendarUID:(NSString *)uid IsReadOnly:(BOOL)readOnly
{
    if (uid == nil || [uid isEqualToString:@""]) {
        return;
    }
    _logName = uid;
	_readOnly = readOnly;
    [self.dataArray removeAllObjects];
    [self initRequest];
}
- (void)setNewDate:(NSDate *)date
{
    self.date = date;
}
#pragma mark -  request
// 初始化的时候获取 只执行一次
- (void)initRequest
{
    NSDate * start = [self getDayStart];
    NSDate * end = [self getDayEnd];
    NSDate * stData = [start dateBySubtractingDays:DAY_NUM];
    NSDate *dateEnd = [end dateByAddingDays:DAY_NUM];
    
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
                [self.collectionView reloadData];
                _locCount += DAY_NUM;
                [self.collectionView setContentOffset:CGPointMake((DAY_NUM) * (IOS_SCREEN_WIDTH - 40), 0)];
            }
                break;
                
            case Request_Type_NEXT:
            {
                NSMutableArray * array = [self dealData:resp.dataArray type:requ.requestType];
                [self.dataArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataArray.count, array.count)]];
                [self.collectionView reloadData];
                _nextRequest = nil;
            }
                break;
                
            case Request_Type_ON:
            {
                NSMutableArray * array = [self dealData:resp.dataArray type:requ.requestType];
                [self.dataArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                [self.collectionView reloadData];
                _onRequest = nil;
                _locCount += DAY_NUM;
                float X = self.collectionView.contentOffset.x;
                [self.collectionView setContentOffset:CGPointMake(DAY_NUM *(IOS_SCREEN_WIDTH - 40) + X, 0)];
                
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
#pragma mark - uicollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        if (self.collectionView.contentSize.width - self.collectionView.contentOffset.y - self.collectionView.frame.size.height < (IOS_SCREEN_WIDTH - 40)*7)
        {
            [self nextWeeksRequest];
        }
        // 无限上拉
        else if (self.collectionView.contentOffset.x < (IOS_SCREEN_WIDTH - 40)*7)
        {
            [self onWeeksRequest];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    NewCalendarMonthCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell.delegate) {
        cell.delegate = self;
    }
    [cell setCellData:self.dataArray[indexPath.row]];
	[cell setHidenBottomViewsWhileIsReadOnly:self.readOnly];
    cell.indexPath = indexPath;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake( IOS_SCREEN_WIDTH - 60, IOS_SCREEN_HEIGHT - 64 - 60 - 60);
}

#pragma mark - NewCalendarMonthCollectionViewCellDelegate
- (void)newCalendarMonthCollectionViewCell_SelectCalendarWithPath:(NSIndexPath *)path
{
    NewCalendarWeeksListModel * listmodel = [self.dataArray objectAtIndex:path.section];
    NewCalendarWeeksModel * model = [listmodel.calendarArray objectAtIndex:path.row];
    
    self.date = listmodel.endTime;
    if (self.block) {
        self.block(blockType_Calendar,model);
        NSLog(@"==model.isVisible==%d",model.isVisible);
        
    }
}
- (void)newCalendarMonthCollectionViewCell_pushCreatCalendarVCWithIsMetting:(BOOL)isMetting date:(NSDate *)date
{
    if (isMetting) {
        if (self.block) {
            self.block(blockType_CreatMetting,nil);
        }
    }else {
        if (self.jumptoaddevent)
        {
            self.jumptoaddevent(date);
        }
        
//        if (self.block) {
//            self.block(blockType_CreatEvent,nil);
//        }
    }
}



#pragma mark - eventRespond
- (void)popAction
{
    if (self.block) {
        self.block(blockType_pop,nil);
    }
}


// 获取 当天刚开始的时间戳
- (NSDate *)getDayStart
{
    return [NSDate dateWithYear:_date.year month:_date.month day:_date.day hour:0 minute:0 second:0];
}
// 获取当天最后的时间的时间戳
- (NSDate *)getDayEnd
{
    return [NSDate dateWithYear:_date.year month:_date.month day:_date.day hour:23 minute:59 second:59];
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

#pragma mark - setterAndGetter
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        NewCalendarCardFlowLayout *layout = [[NewCalendarCardFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource =self;
        _collectionView.decelerationRate = -20; //设置滑动速度
//        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



@end
