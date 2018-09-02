//
//  NewCalendarMonthEventListViewController.m
//  launcher
//
//  Created by kylehe on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarMonthEventListViewController.h"
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

@interface NewCalendarMonthEventListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout,BaseRequestDelegate,NewCalendarMonthCollectionViewCellDelegate>

@property(nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic,strong) NSMutableArray * dataArray;

// 为保证不会连续请求,将其属性化
@property (nonatomic,strong) NewCalendarWeeksEventRequest * onRequest;
@property (nonatomic,strong) NewCalendarWeeksEventRequest * nextRequest ;

@property (nonatomic,strong) NSString * logName;

@property (nonatomic,assign) int locCount;// 今天所在的位置记录

@end

@implementation NewCalendarMonthEventListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.view.bounds;
    [button addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionView setBackgroundView:button];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[NewCalendarMonthCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.userInteractionEnabled = YES;
    
    [self initRequest];
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
                [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentSize.width/2, 0)];
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
                //[self.tableView setContentOffset:CGPointMake(0, DAY_NUM *CELLHEIGHT + y)];
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
    [self postError:errorMessage];
    
}
#pragma mark - uicollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        if (self.collectionView.contentSize.height - self.collectionView.contentOffset.y - self.collectionView.frame.size.height < self.collectionView.bounds.size.width*7)
        {
            [self nextWeeksRequest];
        }
        // 无限上拉
        else if (self.collectionView.contentOffset.y < self.collectionView.bounds.size.width*7)
        {
            [self onWeeksRequest];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"count==%lu",(unsigned long)self.dataArray.count);
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
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake( IOS_SCREEN_WIDTH - 60, IOS_SCREEN_HEIGHT - 64 - 60 - 60);
}

#pragma mark - NewCalendarMonthCollectionViewCellDelegate
- (void)newCalendarMonthCollectionViewCell_SelectCalendarWithPath:(NSIndexPath *)path
{
          
}
- (void)newCalendarMonthCollectionViewCell_pushCreatCalendarVCWithIsMetting:(BOOL)isMetting date:(NSDate *)date
{
    if (isMetting) {
        
    }else {
    }
}
- (void)presentedByViewController:(UIViewController *)viewController
{
    CGRect sourceFrame = self.view.frame;
    sourceFrame.origin.x = -sourceFrame.size.width;
    
    CGRect destFrame = viewController.view.frame;
    destFrame.origin.x = viewController.view.frame.size.width;
    viewController.view.frame = destFrame;
    
    destFrame.origin.x = 0;
    [self.view.superview addSubview:viewController.view];
    [UIView animateWithDuration:.25
                     animations:^{
                         self.view.frame = sourceFrame;
                         viewController.view.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         [self presentViewController:viewController animated:NO completion:nil];
                     }];
}


#pragma mark - eventRespond
- (void)popAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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


#pragma mark - setterAndGetter
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        NewCalendarCardFlowLayout *layout = [[NewCalendarCardFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource =self;
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
