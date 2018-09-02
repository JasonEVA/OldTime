//
//  CalendarNewEventTimeSelectView.m
//  launcher
//
//  Created by William Zhang on 15/7/31.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarNewEventTimeSelectView.h"
#import "CalendarNewTimeDateSelectTableViewCell.h"
#import "CalendarNewTimeDaySelectTableViewCell.h"
#import "CalendarNewTimeSelectFoldTableViewCell.h"
#import <DateTools/DateTools.h>
#import <Masonry/Masonry.h>
#import "UIView+Util.h"
#import "Category.h"
#import "MyDefine.h"

static NSString *timeAddCellIdentifier = @"timeAddCellIdentifier";
/** 候补时间最多数量 */
static NSInteger maxNewTiem = 3;

@interface CalendarNewEventTimeSelectView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnDone;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UILabel *lblTitle;

@property (nonatomic, strong) UISwitch *wholeDaySwitch;

/** 候补时间状态 */
@property (nonatomic, assign) CalendarNewEventTimeSelectMode timeMode;

// Data
@property (nonatomic, strong) NSMutableArray *arrTimes;
/** 当前显示的index（默认为0） */
@property (nonatomic, assign) NSInteger selectedIndex;

/** 一个cell中是否选择了开始时间(默认都是YES) */
@property (nonatomic, strong) NSMutableDictionary *dictSelectedStart;

@end

@implementation CalendarNewEventTimeSelectView

- (instancetype)initWithMode:(CalendarNewEventTimeSelectMode)mode timeList:(NSArray *)timeList {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.timeMode = mode;
        self.wholeDaySwitch.on = (self.timeMode == CalendarNewEventTimeSelectModeWholeDay);
        UIView *dismissView = [UIView new];
        dismissView.backgroundColor = [UIColor clearColor];
        [self addSubview:dismissView];
        [dismissView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [dismissView addGestureRecognizer:tapGesture];
        
        [self addSubview:self.contentView];

        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
			if (IOS_DEVICE_4) {
				make.top.equalTo(self).offset(10);
			} else {
				make.bottom.equalTo(self).offset(-10);
			}
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);

            make.height.equalTo(@(450));
        }];
        
        [self.arrTimes addObjectsFromArray:timeList];
        if (!self.arrTimes.count) {
            [self addDate];
        }
        [self initComponents];
    }
    return self;
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)initComponents {
    self.dictSelectedStart = [NSMutableDictionary dictionaryWithDictionary:@{@0:@YES, @1:@YES, @2:@YES}];
    
    [self.contentView addSubview:self.btnDone];
    [self.btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.contentView addSubview:self.btnCancel];
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.contentView addSubview:self.lblTitle];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
//        make.top.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.btnCancel);
    }];
    
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.btnDone.mas_bottom).offset(2);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

#pragma mark - Button Click
- (void)clickToDone {
    //按钮暴力点击防御
    [self.btnDone mtc_deterClickedRepeatedly];
    
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(CalendarNewEventTimeSelectViewDelegateCallBack_SelectTimes:selectMode:)]) {
        [self.delegate CalendarNewEventTimeSelectViewDelegateCallBack_SelectTimes:self.arrTimes selectMode:self.timeMode];
    }
}

- (void)clickToCancel
{
    [self removeFromSuperview];
}

- (void)clickToCopy {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"";
    
    NSString *strComponents = @"";
    for (NSInteger i = 0; i < self.arrTimes.count; i += 2) {
        NSDate *startDate = self.arrTimes[i];
        NSDate *endDate = self.arrTimes[i + 1];
        
        NSString *string = [startDate mtc_startToEndDate:endDate wholeDay:self.timeMode];
        string = [NSString stringWithFormat:@". %@", string];
        
        strComponents = [strComponents stringByAppendingFormat:@"%@%@",([strComponents length] ? @"\n":@""), string];
    }
    pasteboard.string = strComponents;
    
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:LOCAL(CALENDAR_COPY) message:strComponents delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)clickToSwitch {
    self.timeMode = self.wholeDaySwitch.isOn ? CalendarNewEventTimeSelectModeWholeDay : CalendarNewEventTimeSelectModeWithTime;
    [self.tableView reloadData];
}

#pragma mark - Private Method
/** 删除候选时间 */
- (void)deleteTimeAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    switch (indexPath.section) {
        case 0:
            [self.dictSelectedStart setObject:[self.dictSelectedStart objectForKey:@1] forKey:@0];
            [self.dictSelectedStart setObject:[self.dictSelectedStart objectForKey:@2] forKey:@1];
            [self.dictSelectedStart setObject:@YES forKey:@2];
            break;
        case 1:
            [self.dictSelectedStart setObject:[self.dictSelectedStart objectForKey:@2] forKey:@1];
            [self.dictSelectedStart setObject:@YES forKey:@2];
            break;
        case 2:
            [self.dictSelectedStart setObject:@YES forKey:@2];
            break;
        default:
            break;
    }
    
    if (self.arrTimes.count == maxNewTiem * 2) {
        // 已经满了，删除一行，加入添加候补时间
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.arrTimes.count / 2 - 1] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.arrTimes removeObjectAtIndex:indexPath.section * 2];
    [self.arrTimes removeObjectAtIndex:indexPath.section * 2];
    
    NSInteger s = _arrTimes.count/2;
    if (s == 3 || s == 2)
    {
        s = 1;
    }
    else if (s == 1)
    {
        s = 0;
    }
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.edges.equalTo(self).insets(UIEdgeInsetsMake(120, 15, 0, 15));
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@(450 + s * 50));
    }];
    
    // 为最后选中
    self.selectedIndex = [self.arrTimes count] / 2 - 1;
    
    [self.tableView endUpdates];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.selectedIndex] withRowAnimation:UITableViewRowAnimationFade];
}

/** 选择时间更新后返回 */
- (void)timeDidChangedAtIndexPath:(NSIndexPath *)indexPath firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate{
    NSInteger realIndex = indexPath.section * 2;
    [self.arrTimes replaceObjectAtIndex:realIndex withObject:firstDate];
    [self.arrTimes replaceObjectAtIndex:realIndex + 1 withObject:lastDate];
}

/** 增加时间 */
- (void)addDate {
    // 调整时间
    NSDate *date = [[NSDate date] mtc_calculatorMinuteIntervalDidChange:nil];
    [_arrTimes addObject:date];
    [_arrTimes addObject:[date dateByAddingHours:1]];
    
    NSInteger s = _arrTimes.count/2;
    if (s == 3 || s == 2)
    {
        s = 1;
    }
    else if (s == 1)
    {
        s = 0;
    }
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.edges.equalTo(self).insets(UIEdgeInsetsMake(120, 15, 0, 15));
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@(450 + s * 50));
    }];
}

- (void)segmentSelectedAtIndex:(NSUInteger)index selectedIndex:(NSUInteger)selectedIndex {
    [self.dictSelectedStart setObject:@(selectedIndex ? NO : YES) forKey:@(index)];
}

#pragma mark - UITabelView Delegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.arrTimes.count != maxNewTiem * 2) {
        return self.arrTimes.count / 2 + 1;
    }
    return self.arrTimes.count / 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrTimes.count / 2 == indexPath.section) {
        // 候补时间增加
        return 40;
    }
    
    if (self.selectedIndex == indexPath.section) {
        // 选中的时间
        if (self.timeMode == CalendarNewEventTimeSelectModeWholeDay) {
            return [CalendarNewTimeDaySelectTableViewCell height];
        }
        return [CalendarNewTimeDateSelectTableViewCell height];
    }
    
    return [CalendarNewTimeSelectFoldTableViewCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    
    NSInteger section = indexPath.section;
    
    if (section == self.arrTimes.count / 2)
    {
        // 候补时间增加栏
        cell = [tableView dequeueReusableCellWithIdentifier:timeAddCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timeAddCellIdentifier];
            UIImage *image = [UIImage imageNamed:@"Cross_Add"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [cell setAccessoryView:imageView];
            
            [cell textLabel].text = LOCAL(CALENDAR_TIMEPICKER_ADDALTERNATEDATA);
            [cell textLabel].font = [UIFont mtc_font_30];
        }
    }
    else
    {
        NSString *title = [NSString stringWithFormat:@"%@%ld", LOCAL(CALENDAR_CONFIRM_ALTERNATE), (section + 1)];
        NSInteger realIndex = section * 2;
        
        if ([self numberOfSectionsInTableView:tableView] == 2) {
            title = [NSString stringWithFormat:@"%@", LOCAL(CALENDAR_PLACEHOLDERTIME)];
        }
        
        if (section != self.selectedIndex) {
            // 折叠状态
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarNewTimeSelectFoldTableViewCell identifier]];
            [cell setTitle:title];
            [cell setStartDate:self.arrTimes[realIndex] endData:self.arrTimes[realIndex + 1] wholeDay:(self.timeMode == CalendarNewEventTimeSelectModeWholeDay)];
            return cell;
        }
        
        BOOL allday = NO;
        if (self.timeMode == CalendarNewEventTimeSelectModeWithTime) {
            // 有分秒的状态
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarNewTimeDateSelectTableViewCell identifier]];
            allday = NO;
        } else {
            // 全天模式
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarNewTimeDaySelectTableViewCell identifier]];
            allday = YES;
        }
        if (section == 0)
        {
            // 第一个不能删除
            [cell setTitle:title showTrash:NO];
        }
        else
        {
            // 其余时间，可以删
            [cell setTitle:title showTrash:YES];
        }
        
        [cell setDeleteBlock:^(id deleteCell) {
            // 删除回调
            NSIndexPath *deleteIndexPath = [tableView indexPathForCell:deleteCell];
            [self deleteTimeAtIndexPath:deleteIndexPath];
            
        } didChange:^(id cell, NSDate *firstDate, NSDate *lastDate) {
            // 更改时间回调
            NSIndexPath *changedIndexPath = [tableView indexPathForCell:cell];
            [self timeDidChangedAtIndexPath:changedIndexPath firstDate:firstDate lastDate:lastDate];
        }];
        
        if ([cell respondsToSelector:@selector(selectedSegmentIndexBlock:)]) {
            [cell selectedSegmentIndexBlock:^(id cell, NSUInteger selectedIndex) {
                NSIndexPath *indexPath = [tableView indexPathForCell:cell];
                [self segmentSelectedAtIndex:indexPath.section selectedIndex:selectedIndex];
            }];
        }
        
        // 回传时间
        [cell setStartDate:self.arrTimes[realIndex] endData:self.arrTimes[realIndex + 1]];
        
        if ([cell respondsToSelector:@selector(isSelectedStartSegment:)]) {
            NSNumber *boolNumber = [self.dictSelectedStart objectForKey:@(indexPath.section)];
            [cell isSelectedStartSegment:[boolNumber boolValue]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectedIndex == indexPath.section) {
        // 点击已经是展开的时间
        return;
    }
    
    if (indexPath.section != self.arrTimes.count / 2 || maxNewTiem * 2 == [self.arrTimes count]) {
        // 需要展开
        [tableView beginUpdates];
        
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:indexPath.section];
        [indexSet addIndex:self.selectedIndex];
        
        self.selectedIndex = indexPath.section;
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView endUpdates];
        return;
    }
    

    // 候补时间添加
    [tableView beginUpdates];
    
    if (self.arrTimes.count == maxNewTiem * 2 - 2) {
        // 正好还剩一条，直接更新候补时间增加按钮
        [self addDate];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:maxNewTiem - 1]] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        // 还剩好几条
        [self addDate];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        // 插入一条展开的
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
    // 关闭一条展开的
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.selectedIndex] withRowAnimation:UITableViewRowAnimationFade];

    self.selectedIndex = indexPath.section;
    
    [tableView endUpdates];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.selectedIndex] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - Create
- (UIView *)createTableFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 70)];
    footerView.backgroundColor = [UIColor clearColor];

    // 复制按钮
    UIButton *btnCopy = [[UIButton alloc] init];
    [btnCopy titleLabel].font = [UIFont systemFontOfSize:12];
    
    [btnCopy setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
    [btnCopy setTitle:LOCAL(CALENDAR_TIMEPICKER_COPYALTERNATEDATA) forState:UIControlStateNormal];
    
    [btnCopy setBackgroundImage:[UIImage mtc_imageColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btnCopy setBackgroundImage:[UIImage mtc_imageColor:[UIColor buttonHighlightColor]] forState:UIControlStateHighlighted];
    
    btnCopy.expandSize = CGSizeMake(30, 0);
    [btnCopy layer].borderColor = [[UIColor themeBlue] CGColor];
    [btnCopy layer].borderWidth = 0.5;
    [btnCopy layer].cornerRadius = 4.0;
    [btnCopy layer].masksToBounds = YES;
    
    [btnCopy addTarget:self action:@selector(clickToCopy) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:btnCopy];
    
    [btnCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footerView).offset(-12);
        make.centerY.equalTo(footerView);
        make.height.equalTo(@30);
    }];
    
    UILabel *wholedayLabel = [UILabel new];
    wholedayLabel.font = [UIFont mtc_font_24];
    wholedayLabel.text = LOCAL(CALENDAR_ADD_ORDERWHOLEDAY);
    
    [footerView addSubview:wholedayLabel];
    [footerView addSubview:self.wholeDaySwitch];
    
    [wholedayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(12);
        make.centerY.equalTo(footerView);
    }];
    
    [self.wholeDaySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wholedayLabel.mas_right).offset(8);
        make.centerY.equalTo(footerView);
    }];
    
    return footerView;
}

#pragma mark - Initializer
- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor grayBackground];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor grayBackground];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [self createTableFooterView];
        
        [_tableView registerClass:[CalendarNewTimeDateSelectTableViewCell class] forCellReuseIdentifier:[CalendarNewTimeDateSelectTableViewCell identifier]];
        [_tableView registerClass:[CalendarNewTimeDaySelectTableViewCell class] forCellReuseIdentifier:[CalendarNewTimeDaySelectTableViewCell identifier]];
        [_tableView registerClass:[CalendarNewTimeSelectFoldTableViewCell class] forCellReuseIdentifier:[CalendarNewTimeSelectFoldTableViewCell identifier]];
    }
    return _tableView;
}

- (UIButton *)btnDone
{
    if (!_btnDone)
    {
        _btnDone = [[UIButton alloc] init];
//        _btnDone.expandSize = CGSizeMake(30, 10);
//        _btnDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [_btnDone setImage:[UIImage imageNamed:@"Calendar_check"] forState:UIControlStateNormal];
        [_btnDone setTitle:LOCAL(CERTAIN) forState:UIControlStateNormal];
        [_btnDone.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_btnDone setTitleColor:[UIColor mtc_colorWithHex:0x2e9efb] forState:UIControlStateNormal];
        [_btnDone addTarget:self action:@selector(clickToDone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDone;
}

- (UIButton *)btnCancel
{
    if (!_btnCancel)
    {
        _btnCancel = [[UIButton alloc] init];
//        _btnCancel.expandSize = CGSizeMake(30, 10);
//        _btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [_btnCancel setImage:[UIImage imageNamed:@"Calendar_check"] forState:UIControlStateNormal];
        [_btnCancel setTitle:LOCAL(CANCEL) forState:UIControlStateNormal];
        [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_btnCancel setTitleColor:[UIColor mtc_colorWithHex:0x2e9efb] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(clickToCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}

- (NSMutableArray *)arrTimes
{
    if (!_arrTimes)
    {
        _arrTimes = [NSMutableArray array];
    }
    return _arrTimes;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        [_lblTitle setText:LOCAL(CALENDAR_TIMEPICKER_ADDALTERNATEDATA)];
        [_lblTitle setTextColor:[UIColor blackColor]];
        [_lblTitle setFont:[UIFont systemFontOfSize:15]];
    }
    return _lblTitle;
}

- (UISwitch *)wholeDaySwitch {
    if (!_wholeDaySwitch) {
        _wholeDaySwitch = [UISwitch new];
        _wholeDaySwitch.onTintColor = [UIColor themeBlue];
        
        [_wholeDaySwitch addTarget:self action:@selector(clickToSwitch) forControlEvents:UIControlEventValueChanged];
    }
    return _wholeDaySwitch;
}

@end
