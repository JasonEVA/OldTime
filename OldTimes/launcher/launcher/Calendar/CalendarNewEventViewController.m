//
//  CalendarNewEventViewController.m
//  launcher
//
//  Created by William Zhang on 15/7/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarNewEventViewController.h"
#import "CalendarTextFieldTableViewCell.h"
#import "CalendarTextViewTableViewCell.h"
#import "CalendarSwitchTableViewCell.h"
#import "CalendarTimeTableViewCell.h"
#import "CalendarNewEventTimeSelectView.h"
#import "CalendarNewEventMakeSureViewController.h"
#import "CalendarAndMeetingPlaceSelectViewController.h"
#import "CalendarMakeSureMapTableViewCell.h"
#import "CalendarNewEventRepeatViewController.h"
#import "CalendarNewEventRemindViewController.h"
#import "CalendarLaunchrModel.h"
#import "CalendarNewRequest.h"
#import "CalendarEditRequst.h"
#import "MixpanelMananger.h"
#import "PlaceModel.h"
#import "MyDefine.h"
#import "Category.h"
#import <Masonry.h>

static NSString * const accessoryCellID    = @"AccessoryCellID";
static NSString * const accessoryAddCellID = @"AccessoryAddCellID";
static NSString *const killMapDelegateNotification = @"killMapDelegate";

typedef NS_ENUM(NSInteger, cellMode)
{
    /** 标题 */
    cellModeTitle = 0,
    /** 重要 */
    cellModeImportant = 01,
    /** 场所 */
    cellModePlace = 10,
    /** 全天模式 */
    cellModeWholeDay = 20,
    /** 候选时间 */
    cellModeSelectTime = 21,
    /** 重复 */
    cellModeRepeat = 60,
    /** 提醒 */
    cellModeAlert = 30,
    /** 备注 */
    cellModeDetail = 40
};


@interface CalendarNewEventViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, CalendarNewEventTimeSelectViewDelegate, BaseRequestDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *arrTitle;

/** 候补时间选择器 */
@property (nonatomic, strong) CalendarNewEventTimeSelectView *timeSelectView;

// Data

/////// 计算键盘影响动画  ///////
@property (nonatomic, assign) CGFloat    keyboardHeight;
@property (nonatomic, strong) UITextView *textView;
/** tableView centerY constraints */
@property (nonatomic, strong) MASConstraint *centerYConstraints;
@property (nonatomic, assign) CGFloat offset;
/////// 计算键盘影响动画  ///////

/** 最后修改的开始时间 */
@property (nonatomic, strong) NSString *recentStartTimes;

@end

@implementation CalendarNewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(CALENDAR_ADD_ADDORDER);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CALENDAR_ADD_SAVE) style:UIBarButtonItemStyleBordered target:self action:@selector(clickToSave)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self showLeftItemWithSelector:@selector(clickToBack)];
    
    [self initComponents];
    if (!self.noDeleteTryAction) {
        [self.modelCalendar removeTryAction];
    }
}

- (void)initComponents {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.view);
        self.centerYConstraints = make.centerY.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:killMapDelegateNotification object:nil];
}

- (void)dealloc {
    if (self.timeSelectView) {
        [self.timeSelectView removeFromSuperview];
        self.timeSelectView = nil;
    }
}

#pragma mark - Private Method
- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

/** 计算indexPath对应的cellmode */
- (NSInteger)calculateIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section * 10 + indexPath.row;
}

/** 根据cellMode计算返回indexPath */
- (NSIndexPath *)indexPathFromCellMode:(cellMode)cellMode {
    NSInteger row = cellMode % 10;
    NSInteger section = cellMode / 10;
    return [NSIndexPath indexPathForRow:row inSection:section];
}

/** switch值变化后续操作 */
- (void)switchDidChangWithCalendarType:(CalendarSwitchType)type isOn:(BOOL)isOn {
    if (type == CalendarSwitchTypeWholeDay) {
        self.modelCalendar.try_wholeDay = isOn;
        
        // wholeday变换后需要改变提醒方式
        NSArray *arrayRemind = [CalendarLaunchrModel remindNumbersIsWholeDay:isOn];
        self.modelCalendar.try_remindType = [[arrayRemind firstObject] integerValue];
        
        [self.tableView reloadRowsAtIndexPaths:@[[self indexPathFromCellMode:cellModeSelectTime], [self indexPathFromCellMode:cellModeAlert]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } else
    {
        self.modelCalendar.try_important = isOn;
    }
}

/** 根据placeModel判断是否显示地图 */
- (BOOL)canUseMap {
    if (!self.modelCalendar.try_place) {
        return NO;
    }
    
    CLLocationCoordinate2D coordinate = self.modelCalendar.try_place.coordinate;
    if (coordinate.latitude == MAXLAT && coordinate.longitude == MAXLAT) {
        return NO;
    }
    
    return YES;
}

- (void)titleString:(NSString *)titleString {
    self.modelCalendar.try_title = titleString;
}

- (BOOL)checkInformation {
    NSString *errorString = @"";
    if (![self.modelCalendar.try_title length]) {
        errorString = LOCAL(MEETING_INPUT_TITLE);
    } else if (!self.modelCalendar.try_place) {
        errorString = LOCAL(MEETING_INPUT_ADDRESS);
    } else if (![self.modelCalendar.try_time count]) {
        errorString = LOCAL(MEETING_INPUT_TIME);
    }
    
    if (![errorString length]) {
        return YES;
    }
    
    [self postError:errorString];
    return NO;
}

#pragma mark - Button Click
- (void)clickToBack {
    [MixpanelMananger track:@"calendar/cancel"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickToSave {
    [self.view endEditing:YES];

    if (![self checkInformation]) {
        return;
    }
    
    [MixpanelMananger track:@"calendar/save"];
    if (self.eventType == calendar_eventTypeSave) {
        [self postLoading];
        // 保存请求
        CalendarNewRequest *newRequest = [[CalendarNewRequest alloc] initWithDelegate:self];
        [newRequest newCalendarModel:self.modelCalendar];
    }
    
    else if (self.eventType == calendar_eventTypeEdit) {
        // 编辑模式
        if (!self.recentStartTimes) {
            NSDate *date = [self.modelCalendar.try_time objectAtIndex:0];
            long timeInterval = [date timeIntervalSince1970] * 1000;
            self.recentStartTimes = [NSString stringWithFormat:@"%ld", timeInterval];
        }
        
        if (self.saveType == 0)
        {
            [self postLoading];
            CalendarEditRequst *editRequest = [[CalendarEditRequst alloc] initWithDelegate:self];
            [editRequest editScheduleByCalendarModel:self.modelCalendar initialStartTime:self.recentStartTimes WithSaveType:1];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCAL(CALENDAR_SELECTEDITTYPE) message:@"" delegate:self cancelButtonTitle:LOCAL(CALENDAR_ADD_CANCLE) otherButtonTitles:LOCAL(CALENDAR_ONLYTYPE),LOCAL(CALENDAR_ALLTYPE), nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    [self postLoading];
    NSInteger saveType = 0;
    if (buttonIndex == 2)
    {
        saveType = 1;
    }
    CalendarEditRequst *editRequest = [[CalendarEditRequst alloc] initWithDelegate:self];
    [editRequest editScheduleByCalendarModel:self.modelCalendar initialStartTime:self.recentStartTimes WithSaveType:saveType];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([response isKindOfClass:[CalendarNewResponse class]]) {
        // 新建成功
        [self RecordToDiary:@"新建日程事件成功"];
        [self postSuccess];
        
        NSArray *timeShowId = [(CalendarNewResponse *)response showIds];
        NSString *showId    = [(CalendarNewResponse *)response showId];
        NSString *relateId  = [(CalendarNewResponse *)response relateId];
        
        [self.modelCalendar refreshAllAction];

        self.modelCalendar.showId = showId;
        self.modelCalendar.showIdList = [NSMutableArray arrayWithArray:timeShowId];
        self.modelCalendar.type = [timeShowId count] == 1 ? @"event" : @"event_sure";
        self.modelCalendar.relateId = relateId;
        
        NSArray *startTime = [(CalendarNewResponse *)response startTime];
        self.recentStartTimes = [startTime objectAtIndex:0];
        
        CalendarNewEventMakeSureViewController *CNEMSVC = [[CalendarNewEventMakeSureViewController alloc] initWithModelShow:self.modelCalendar];
        
        [self.navigationController pushViewController:CNEMSVC animated:YES];
    }
    
    else if ([response isKindOfClass:[CalendarEditResponse class]]) {
        // 编辑成功
        [self postSuccess];
        [self RecordToDiary:@"编辑日程事件成功"];
        [self.modelCalendar refreshAllAction];
        
        NSArray *timeShowId = [(CalendarEditResponse *)response showIds];
        self.modelCalendar.showIdList = [NSMutableArray arrayWithArray:timeShowId];
        
        self.modelCalendar.showId = [(CalendarEditResponse *)response showIdNew];
        
        NSArray *startTime = [(CalendarNewResponse *)response startTime];
        self.recentStartTimes = [startTime objectAtIndex:0];
        
        CalendarNewEventMakeSureViewController *CNEMSVC = [[CalendarNewEventMakeSureViewController alloc] initWithModelShow:self.modelCalendar];
        
        [self.navigationController pushViewController:CNEMSVC animated:YES];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - CalendarNewEventTimeSelectView Delegate
- (void)CalendarNewEventTimeSelectViewDelegateCallBack_SelectTimes:(NSArray *)timeArray {
    if (self.modelCalendar.try_time == self.modelCalendar.time) {
        self.modelCalendar.try_time = [NSMutableArray array];
    }
    
    [self.modelCalendar.try_time removeAllObjects];
    [self.modelCalendar.try_time addObjectsFromArray:timeArray];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[self indexPathFromCellMode:cellModeSelectTime]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:cellModeRepeat / 10] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrTitle count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.arrTitle objectAtIndex:section];
    if (section == cellModeRepeat / 10 && [self.modelCalendar try_time].count > 2) {
        return 0;
    }
    
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentIndex = indexPath.row + indexPath.section * 10;
    if (currentIndex == cellModeSelectTime) { // 候选时间
        return 80;
    }
    
    if (currentIndex == cellModeDetail) { // 详细
        return 215;
    }
    
    if (currentIndex == cellModePlace) { // 场所
        if ([self canUseMap]) {
            return [CalendarMakeSureMapTableViewCell height];
        }
    }
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    NSInteger row = indexPath.row;
    NSInteger currentIndex = indexPath.section * 10 + indexPath.row;
    NSArray *array = [self.arrTitle objectAtIndex:indexPath.section];
    
    switch (currentIndex) {
        case cellModeTitle: // 事件名称
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarTextFieldTableViewCell identifier]];
            [cell setTitle:self.modelCalendar.try_title];
            
            [cell textEndEditingBlock:^(NSString *text) {
                [self titleString:text];
            }];
            break;
        }
        case cellModeImportant: // 重要
        case cellModeWholeDay:  // 全天
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarSwitchTableViewCell identifier]];
            [cell textLabel].text =  [array objectAtIndex:row];
            if (currentIndex == cellModeImportant) {
                [cell setSwitchColor:[UIColor themeRed]];
                [cell setSwitchType:CalendarSwitchTypeImportant];
                [cell isOn:self.modelCalendar.try_important];
            } else {
                [cell setSwitchColor:[UIColor themeBlue]];
                [cell setSwitchType:CalendarSwitchTypeWholeDay];
                [cell isOn:self.modelCalendar.try_wholeDay];
            }
            
            [cell calendarSwitchDidChange:^(CalendarSwitchType swithType, BOOL isOn) {
                // switch 按钮回调
                [self switchDidChangWithCalendarType:swithType isOn:isOn];
            }];
            
            break;
        }
        case cellModePlace: // 场所
            if ([self canUseMap]) {
                // 能够加载图片,则加载图片，不与下面同流合污
                cell = [tableView dequeueReusableCellWithIdentifier:[CalendarMakeSureMapTableViewCell identifier]];
                [cell mapWithPlaceModel:self.modelCalendar.try_place];
//                [cell setAccessoryDisclosureIndicator];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            }
        case cellModeRepeat: // 重复
        case cellModeAlert: // 提醒
            cell = [tableView dequeueReusableCellWithIdentifier:accessoryCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:accessoryCellID];
                
//                UIImage *imageDisclosureIndicator = [UIImage imageNamed:@"disclosureIndicator"];
//                UIImageView *imgViewDisclosureIndicator = [[UIImageView alloc] initWithImage:imageDisclosureIndicator];
//                [cell setAccessoryView:imgViewDisclosureIndicator];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
                [cell detailTextLabel].textColor = [UIColor mtc_colorWithHex:0x000000];
                [cell detailTextLabel].font      = [UIFont mtc_font_30];
                [cell textLabel].textColor       = [UIColor mtc_colorWithHex:0x666666];
                [cell textLabel].font            = [UIFont mtc_font_30];
            }
            [cell textLabel].text = [array objectAtIndex:row];
            
            if (currentIndex == cellModePlace) {
                NSString *name = self.modelCalendar.try_place.name;
                [cell detailTextLabel].text = name ? : @"";
            }
            else if (currentIndex == cellModeRepeat) {
                [cell detailTextLabel].text = [self.modelCalendar repeatTypeString];
            } else {
                // 提醒
                [cell detailTextLabel].text = [self.modelCalendar remindTypeString];
            }
            break;
        case cellModeSelectTime: // 候补时间
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarTimeTableViewCell identifier]];
            [cell setTitle:[array objectAtIndex:row]];
            [cell setStandByTime:self.modelCalendar.try_time wholeDayMode:self.modelCalendar.try_wholeDay];
            break;
        case cellModeDetail: // 详细
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarTextViewTableViewCell identifier]];
            [cell setDelegate:self];
            [cell setContent:self.modelCalendar.try_content?:@""];
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissKeyboard];
    NSInteger currentIndex = [self calculateIndexPath:indexPath];
    
    switch (currentIndex) {
        case cellModeSelectTime: // 候补时间
        {
            if (self.timeSelectView) {
                [self.timeSelectView removeFromSuperview];
                self.timeSelectView = nil;
            }
            
            CalendarNewEventTimeSelectMode selectMode = self.modelCalendar.try_wholeDay ? CalendarNewEventTimeSelectModeWholeDay : CalendarNewEventTimeSelectModeWithTime;
            self.timeSelectView = [[CalendarNewEventTimeSelectView alloc] initWithMode:selectMode timeList:self.modelCalendar.try_time];
            self.timeSelectView.delegate = self;
            
            [self.timeSelectView show];
            break;
        }
        case cellModePlace: // 场所
        {
            CalendarAndMeetingPlaceSelectViewController *CAMPSVC = [[CalendarAndMeetingPlaceSelectViewController alloc] init];
            
            [CAMPSVC getSelectedPlace:^(PlaceModel *selectedPlace) {
               // 获取场所回调
                self.modelCalendar.try_place = selectedPlace;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            
            [self.navigationController pushViewController:CAMPSVC animated:YES];
            break;
        }
        case cellModeRepeat: // 重复
        {
            CalendarNewEventRepeatViewController *CNERVC = [[CalendarNewEventRepeatViewController alloc] initWithRepeatType:^(NSInteger repatType) {
                self.modelCalendar.try_repeatType = repatType;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            
            [self.navigationController pushViewController:CNERVC animated:YES];
            break;
        }
        case cellModeAlert:
        {
            CalendarNewEventRemindViewController *CNERVC = [[CalendarNewEventRemindViewController alloc] initWithWholeDayMode:self.modelCalendar.try_wholeDay RemindType:^(NSInteger remindType) {
                self.modelCalendar.try_remindType = remindType;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            
            [self.navigationController pushViewController:CNERVC animated:YES];
            break;
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView != self.tableView) {
        return;
    }
    
    [self dismissKeyboard];
}

#pragma mark - TextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textView = textView;
    [self textViewWillMoving:textView];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self textViewWillMoving:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.modelCalendar.try_content = [textView text];
    
    self.offset = 0;
    self.centerYConstraints.offset = 0;
    self.textView = nil;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/** 变换位置，与光标位置 */
- (void)textViewWillMoving:(UITextView *)textView {
    CGRect textViewFrame = [textView.superview convertRect:textView.frame toView:self.view.window];
    // 计算光标位置
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
    
    // 好难算，考虑了好多！！！！！！！算了我一个下午！！！！！！日了🐶了！！！！！！
    // 光标相对window位置  25为光标高度
    CGFloat cursorPositionToWindow = floor(CGRectGetMinY(textViewFrame) + (NSInteger)(cursorPosition.y) % (NSInteger)(CGRectGetHeight(textView.frame)) + 25.0);
    
    CGFloat offsetTmp = cursorPositionToWindow - (IOS_SCREEN_HEIGHT - self.keyboardHeight);
    if (offsetTmp < FLT_EPSILON || offsetTmp < 0) {
        // 不需要移动
        return;
    }
    
    self.offset -= offsetTmp;
    self.centerYConstraints.offset = self.offset;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Keyboard Method
- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    self.keyboardHeight = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (self.textView) {
        [self textViewWillMoving:self.textView];
    }
}

@synthesize modelCalendar = _modelCalendar;
#pragma mark - Setter
- (void)setModelCalendar:(CalendarLaunchrModel *)modelCalendar {
    _modelCalendar = modelCalendar;
    if (modelCalendar.repeatType == calendar_repeatNo) {
        self.saveType = 0;
    }
    else {
        self.saveType = 1;
    }
    [self.tableView reloadData];
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor grayBackground];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        
        [_tableView registerClass:[CalendarTextViewTableViewCell class] forCellReuseIdentifier:[CalendarTextViewTableViewCell identifier]];
        [_tableView registerClass:[CalendarTextFieldTableViewCell class] forCellReuseIdentifier:[CalendarTextFieldTableViewCell identifier]];
        [_tableView registerClass:[CalendarSwitchTableViewCell class] forCellReuseIdentifier:[CalendarSwitchTableViewCell identifier]];
        [_tableView registerClass:[CalendarTimeTableViewCell class] forCellReuseIdentifier:[CalendarTimeTableViewCell identifier]];
        [_tableView registerClass:[CalendarMakeSureMapTableViewCell class] forCellReuseIdentifier:[CalendarMakeSureMapTableViewCell identifier]];
    }
    return _tableView;
}

- (NSArray *)arrTitle {
    if (!_arrTitle) {
        NSArray *array1 = @[@"", LOCAL(CALENDAR_ADD_IMPORTANT)];
        NSArray *array2 = @[LOCAL(CALENDAR_ADD_PLACE)];
        NSArray *array3 = @[LOCAL(CALENDAR_ADD_ORDERWHOLEDAY), LOCAL(CALENDAR_ADD_CHOOSETIME)];
//        NSArray *array4 = @[LOCAL(CALENDAR_ADD_REPEAT)];
        NSArray *array5 = @[LOCAL(CALENDAR_ADD_NOTIFICATION)];
        NSArray *array6 = @[@""];
        _arrTitle = @[array1, array2,array3, array5, array6];
    }
    return _arrTitle;
}

- (CalendarLaunchrModel *)modelCalendar {
    if (!_modelCalendar) {
        _modelCalendar = [[CalendarLaunchrModel alloc] init];
        _modelCalendar.wholeDay = YES;
        _modelCalendar.remindType = calendar_remindTypeWholeDay;
    }
    return _modelCalendar;
}
@end
