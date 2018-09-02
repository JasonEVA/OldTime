//
//  NewCalendarMouthTableViewCell.m
//  launcher
//
//  Created by kylehe on 16/3/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarMonthTableViewCell.h"
#import <Masonry/Masonry.h>
#import "NewCalendarMonthADayCollectionViewCell.h"
#import "DeviceDefine.h"
#import "UIColor+Hex.h"
#import "DeviceDefine.h"
#import "NewCalendarMonthDataModel.h"
#import "UIImage+Manager.h"
#import "NSDate+CalendarTool.h"
#import "NewCalendarWeeksModel.h"
#import "DateTools.h"
#import "NewCalendarStripVIew.h"

@interface NewCalendarMonthTableViewCell ()

@property(nonatomic, strong) UICollectionView  *collectionView;
@property(nonatomic, strong) UIView  *headView; //头部分割线
@property(nonatomic, strong) NSMutableArray  *timeBtnArray;
@property (nonatomic,strong) NSMutableDictionary * sortingDict; // 记录每个日程 所处的位置  K: showID V: 序号 number

@property (nonatomic,strong) NSMutableArray * numUIArray;
@property (nonatomic,strong) NSMutableArray * bgBtnArray;

@property (nonatomic,assign) NSInteger locCount ;

@end

@implementation NewCalendarMonthTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
     
        [self createFrame];
        [self initNumsLabel];
    }
    return self;
}

#pragma mark - interfaceMethod

- (void)setDataWithArray:(NSArray *)array eventArray:(NSMutableArray *)eventArray
{
    //时间数组
    self.array = array;
    
    //事件数组
    self.eventArray = eventArray;
    
    //移除所有的时间按钮
    for (UIView *view in self.timeBtnArray)
    {
        [view removeFromSuperview];
    }
    
    for (UIView *view in self.contentView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    //抽取一个model
    NewCalendarMonthDataModel *model = [array lastObject];
    self.currentModel = model;

    if (model.day < 7 && array.count <7)          //第一行
    {
        _locCount = 7;
        for (int i = 0; i < array.count; i++)
        {
            NewCalendarMonthDataModel *currentmodel = array[i];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((currentmodel.firstWeekDay + i) * (IOS_SCREEN_WIDTH)/7.0, 0.5, (IOS_SCREEN_WIDTH)/7.0, 20)];
            [btn setTag:i+1000];
            [btn setTitle:[NSString stringWithFormat:@"%ld",(long)currentmodel.day] forState:UIControlStateNormal];
            [self setupBtn:btn];
            if (currentmodel.firstWeekDay + i == 0 || currentmodel.firstWeekDay + i == 6)
            {
                [btn setTitleColor:[UIColor minorFontColor] forState:UIControlStateNormal];
            }
            
            
            
            
            btn.selected = (currentmodel.day == [NSDate mtc_day:[NSDate date]])
                         &&(currentmodel.month == [NSDate mtc_month:[NSDate date]])
                         &&(currentmodel.year == [NSDate mtc_year:[NSDate date]]);
            
            [self.contentView addSubview:btn];
            [self.timeBtnArray addObject:btn];
            [self addPopBtn:btn];
        }
    }
    else
    {
        if (model.day > 7 && array.count <7) {
            _locCount = (int)self.array.count;
        }else {
            _locCount = 7;
        }
        
        for (int i = 0; i < array.count; i++)
        {
            NewCalendarMonthDataModel *currentmodel = array[i];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * (IOS_SCREEN_WIDTH)/7.0, 0.5, (IOS_SCREEN_WIDTH)/7.0, 20)];
            [btn setTag:i+1000];

            [btn setTitle:[NSString stringWithFormat:@"%ld",currentmodel.day] forState:UIControlStateNormal];
            btn.selected = [model.date isEqualToDate:[NSDate date]];
            [self setupBtn:btn];
            
            if (i == 0 || i == 6)
            {
                [btn setTitleColor:[UIColor minorFontColor] forState:UIControlStateNormal];
            }

            btn.selected = (currentmodel.day == [NSDate mtc_day:[NSDate date]])
                         &&(currentmodel.month == [NSDate mtc_month:[NSDate date]])
                         &&(currentmodel.year == [NSDate mtc_year:[NSDate date]]);
            [self.contentView addSubview:btn];
            [self.timeBtnArray addObject:btn];
            [self addPopBtn:btn];
         
        }
    }
    [self rank];
}

- (void)cleanView
{
    for (int i = 0; i < self.array.count; i ++) {
        NewCalendarMonthDataModel * dayModel = [self.array objectAtIndex:i];
        [dayModel removeCalendarArray];
    }
    
    NewCalendarMonthDataModel *model = [self.array lastObject];
    
    if (model.day < 7 && self.array.count <7)  {        //第一行
        for (int i = 0; i < self.array.count; i ++) {
            NewCalendarMonthDataModel *model1 = [self.array objectAtIndex:i];
            model1.serialNumber = i + (int)model1.firstWeekDay;
        }
    }else {
        for (int i = 0; i < self.array.count; i ++) {
            NewCalendarMonthDataModel *model1 = [self.array objectAtIndex:i];
            model1.serialNumber = i ;
        }
    }
    
    NSArray * array = self.contentView.subviews;
    for (UIView * view in array) {
        if ([view isKindOfClass:[NewCalendarStripVIew class]])
        {
            [view removeFromSuperview];
        }
    }
    _sortingDict = nil;
}

- (void)rank
{
    [self cleanView];
    for (NewCalendarWeeksModel * CalendarModel in self.eventArray) {
        for (int i = 0; i < self.array.count; i ++) {
            NewCalendarMonthDataModel * dayModel = [self.array objectAtIndex:i];
            NSDate * stDate = [NSDate dateWithTimeIntervalSince1970:CalendarModel.startTime/1000];
            NSDate * endDate = [NSDate dateWithTimeIntervalSince1970:CalendarModel.endTime/1000];
            if ([stDate isEarlierThan:dayModel.endDate] && [endDate isLaterThan:dayModel.startDate]) {
                [dayModel addModel:CalendarModel];
            }
        }
    }
    for (int i = 0; i < self.array.count; i ++) {
        NewCalendarMonthDataModel * dayModel = [self.array objectAtIndex:i];
        [dayModel calendarRank];
    }
    [self calendarLayout];
}

- (void)calendarLayout
{
    for (int i = 0; i < self.array.count; i ++) {
        //遍历时间model －－ 时间日期标志
        NewCalendarMonthDataModel * dayModel = [self.array objectAtIndex:i];
        //遍历每一天的事件model
        for (int j = 0; j < dayModel.calendarArray.count; j ++) {
            //事件model
            NewCalendarWeeksModel * calendarModel = dayModel.calendarArray[j];
            // 判断是否可以显示获取所有所有数据的showID
            NSArray * allKey = [self.sortingDict allKeys];
            //如果不存在show ID
            if (![allKey containsObject:calendarModel.showId]) {
                
                //事件model的开始时间
                long long start;
                NSDate * startDate = [NSDate dateWithTimeIntervalSince1970:calendarModel.startTime/1000];// 时间戳转date
                
                //事件的开始时间早于日期model的开始时间
                if ([startDate isEarlierThan:dayModel.startDate]) {
                    //设置开始时间为日期model的开始时间
                    start = [dayModel.startDate timeIntervalSince1970] * 1000 ;
                }else {
                    //设置开始时间为事件model的开始时间
                    start = calendarModel.startTime;
                }
                
                //时间间隔
                long long  interval = calendarModel.endTime - start;             // 获取时间间隔
                interval = interval /1000;                                       // 转化成秒
                float day = interval/ (24*60*60.0);                              // 转化为天
               
            
                if (calendarModel.isAllDay && day >1) {
                    [self.sortingDict setValue:@(j) forKey:calendarModel.showId];
                        //非全天但是跨天
                }else if (calendarModel.pretendIsAllDay) {
                    [self.sortingDict setValue:@(j) forKey:calendarModel.showId];
                }
                
                //
                /**
                 *  法定节假日特殊处理
                 */
                
                //日历数据类型
                if ([calendarModel.type isEqualToString:@"company_festival"] || [calendarModel.type isEqualToString:@"statutory_festival"]) {
                    
                    NewCalendarMonthDataModel *model = [self.array firstObject];
                    if (model.day < 7 && self.array.count <7)  {        //第一行
                        NSInteger tag = dayModel.serialNumber - model.firstWeekDay;
                        UIButton * button = [self.contentView viewWithTag:tag +1000];
                        if (button) {
                            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        }
                    }else {
                        UIButton * button = [self.contentView viewWithTag:dayModel.serialNumber +1000];
                        if (button) {
                            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        }
                    }
                }
                
                //处理当前的前三天的事件
                if (j< 3) { // 0 , 1 , 2
                    
                    NewCalendarStripVIew * view = [[NewCalendarStripVIew alloc] init];
                    float X;
                    float Y;
                    float width;
                    float height;
                    X = dayModel.serialNumber * (IOS_SCREEN_WIDTH /7);
				
					/// 处理3.5寸屏幕下stripView高度不一致的问题
					NSInteger divider = (IOS_DEVICE_4 && dayModel.lines == 6)? dayModel.lines -1 : dayModel.lines;
                    CGFloat needheight = ((IOS_SCREEN_HEIGHT - 50 - 30 - 64)/divider - 20.5 - 15 - 4)/3.0;
                    
					height = needheight;
					
                    Y = 20 + j * height + 3; //+ j + 1 ;

                    NSInteger surplusDay = _locCount - dayModel.serialNumber;
                    if (day > surplusDay) {
                        day = surplusDay;
                    }else {
                        int a = day;
                        if (day > a) {
                            day = a+1;
                        }else {
                            day = a;
                        }
                    }
                    
                    width = (IOS_SCREEN_WIDTH /7)*day;
                   
                    CGRect stripViewFrame = CGRectMake(X, Y, width, height);
                    
                    [view setFrame:stripViewFrame];
                    [view setData:calendarModel];
                    [self.contentView addSubview:view];
                    dayModel.showCount += 1;
                }
            }
            else {
                if ([[self.sortingDict objectForKey:calendarModel.showId] intValue] < 3) {
                    dayModel.showCount += 1;
                }
            }
        }
    }
	
	[self configureMonthViewCellBottomLabelContent];
	
}

/**
 *  月视图Cell上单天的事件超过3个时,剩下事件个数在对应底部Label上展示
 */
- (void)configureMonthViewCellBottomLabelContent {
	NewCalendarMonthDataModel *model = [self.array firstObject];
	if (model.day < 7 && self.array.count <7)  {        //第一行
		[self changeNumWithState:model.serialNumber];
	} else if (model.day >7  && self.array.count <7) {
		
	}else {
		[self changeNumWithState:model.serialNumber];
	}
	
	[self.array enumerateObjectsUsingBlock:^(NewCalendarMonthDataModel*  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
		
		 if (model.day >7  && self.array.count <7) { // 最后一行
			for (int i = 0; i < self.numUIArray.count; i ++ ) {
				UILabel * label = self.numUIArray[i];
				if (i <= model.serialNumber) {
					NewCalendarMonthDataModel *  model = self.array[i];
					if (model.calendarArray.count > 0) {
						NSInteger num = model.calendarArray.count - model.showCount;
						if (num > 0) {
							label.text = [NSString stringWithFormat:@"+%lu",model.calendarArray.count - model.showCount];
						}else {
							label.text = @"";
						}
					}else {
						label.text = @"";
					}
					
				}else {
					label.text = @"";
				}
			}
		}
		
	}];
}

- (void)changeNumWithState:(NSInteger)state
{
    NSString * str;
    for (int i = 0; i < self.numUIArray.count; i ++ ) {
        UILabel * label = self.numUIArray[i];
        if (i >= state) {
            NewCalendarMonthDataModel *  model = self.array[i - state];
            if (model.calendarArray.count > 0) {
                NSInteger num = model.calendarArray.count - model.showCount;
                if (num > 0) {
                    str = [NSString stringWithFormat:@"+%lu",model.calendarArray.count - model.showCount];
                }else {
                    str = @"";
                }

            }else {
                str = @"";
            }
            
        }else {
            str = @"";
        }
        label.text = str;
    }
}

#pragma mark - privateMethod
- (void)createFrame
{
    UIView *headline = [[UIView alloc] init];
    headline.backgroundColor = [UIColor colorWithRed:0.89 green:0.88 blue:0.89 alpha:1];
    headline.frame = CGRectMake(0, 0, IOS_SCREEN_WIDTH, 0.5);
    self.headView = headline;
    [self.contentView addSubview:headline];
    
}
- (void)initNumsLabel
{
    float width = IOS_SCREEN_WIDTH/7;
    for (int i = 0; i < 7; i ++) {
        UILabel * label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor themeBlue];
        [self.contentView addSubview:label];
        [self.numUIArray addObject:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(i * width);
            make.bottom.equalTo(self.contentView);
            make.width.equalTo(@(width));
            make.height.equalTo(@15);
        }];
    }
    
}

//设置时间标签
- (UIButton *)setupBtn:(UIButton *)btn
{
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateSelected];
    btn.userInteractionEnabled = NO;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    return btn;
}

- (void)addPopBtn:(UIButton*)numBtn
{
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = numBtn.tag;
    [self.contentView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(numBtn);
        make.width.equalTo(numBtn);
        make.height.equalTo(self);
    }];
    
    [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - evetRespond
- (void)selectAction:(UIButton *)btn
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(getDateWithDelegate:)])
    {
        NewCalendarMonthDataModel *model = self.array[btn.tag - 1000];
        [self.delegate getDateWithDelegate:model.date];
    }
}

#pragma mark - SetterAndGetter


- (NSMutableArray *)timeBtnArray
{
    if (!_timeBtnArray)
    {
        _timeBtnArray = [NSMutableArray array];
    }
    return _timeBtnArray;
}
- (NSMutableArray *)eventArray
{
    if (!_eventArray)
    {
        _eventArray = [NSMutableArray array];
    }
    return _eventArray;
}

- (NSMutableDictionary *)sortingDict
{
    if (!_sortingDict) {
        _sortingDict = [NSMutableDictionary dictionary];
    }
    return _sortingDict;
}

- (NSMutableArray *)numUIArray
{
    if (!_numUIArray) {
        _numUIArray = [NSMutableArray array];
    }
    return _numUIArray;
}

@end
