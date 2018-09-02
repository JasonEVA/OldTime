//
//  NewCalendarAddNewEventViewController.m
//  launcher
//
//  Created by 马晓波 on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarAddNewEventViewController.h"
#import "CalendarTextFieldTableViewCell.h"
#import "CalendarTextViewTableViewCell.h"
#import "CalendarSwitchTableViewCell.h"
#import "CalendarTimeTableViewCell.h"
#import "CalendarNewEventTimeSelectView.h"
#import "NewCalendarMakeSureViewController.h"
#import "NewCalendarViewController.h"
#import "NewCalendarMapAddressSelectedViewController.h"
#import "CalendarMakeSureMapTableViewCell.h"
#import "CalendarNewEventRepeatViewController.h"
#import "CalendarNewEventRemindViewController.h"
#import "CalendarLaunchrModel.h"
//#import "CalendarNewRequest.h"
//#import "CalendarEditRequst.h"
#import "MixpanelMananger.h"
#import "PlaceModel.h"
#import "MyDefine.h"
#import "Category.h"
#import <Masonry.h>
#import "NewApplyAddApplyTitleTableViewCell.h"
#import "MeTextFieldTableViewCell.h"
#import "NewCalenadarMapTableViewCell.h"
#import "NewCalendarNewRequest.h"
#import "NewCalendarEditRequest.h"
#import "TaskOnlyTextFieldTableViewCell.h"
#import "NSString+HandleEmoji.h"
static NSString * const accessoryCellID    = @"AccessoryCellID";
static NSString * const accessoryAddCellID = @"AccessoryAddCellID";
static NSString *const killMapDelegateNotification = @"killMapDelegate";

typedef NS_ENUM(NSInteger, cellMode)
{
    /** 标题 */
    cellModeTitle = 0,
    /** 候选时间 */
    cellModeSelectTime = 10,
    
    cellModeAddress = 11,
    
    cellModeMap = 12,
    /** 重要 */
    cellModeImportant = 13,

    /** 提醒 */
    cellModeAlert = 20,
    /** 仅自己可见*/
    cellModeIsVisible = 30,
    /** 备注 */
    cellModeDetail = 40,
    
    /** 场所 */
    cellModePlace = 101,
    /** 重复 */
    cellModeRepeat = 100
};


@interface NewCalendarAddNewEventViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, CalendarNewEventTimeSelectViewDelegate, BaseRequestDelegate,UIAlertViewDelegate,NewApplyAddApplyTitleTableViewCellDelegate,UITextFieldDelegate>

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
@property (nonatomic, strong) NewApplyAddApplyTitleTableViewCell *mytitlecell;
/** 最后修改的开始时间 */
@property (nonatomic, strong) NSString *recentStartTimes;

@property (nonatomic, copy) NewCalendarAddNewEventViewControllerBlick block;
@property (nonatomic, assign) BOOL avoidClearDate;
@property (nonatomic, strong) NSIndexPath *detailTextIndexPath;

@end

@implementation NewCalendarAddNewEventViewController
- (instancetype)initWithNSDate:(NSDate *)date
{
    if (self = [super init])
    {
        if (date)
        {
            if (self.modelCalendar.try_time == self.modelCalendar.time) {
            self.modelCalendar.try_time = [NSMutableArray array];
            }
            
            [self.modelCalendar.try_time removeAllObjects];
            [self.modelCalendar.try_time addObjectsFromArray:@[date, date]];
            self.modelCalendar.try_remindType = 0;
			self.avoidClearDate = YES;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.eventType == calendar_eventTypeSave?LOCAL(CALENDAR_ADD_ADDORDER):LOCAL(CALENDAR_EDIT_EVENT);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CALENDAR_ADD_SAVE) style:UIBarButtonItemStyleBordered target:self action:@selector(clickToSave)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self showLeftItemWithSelector:@selector(clickToBack)];
    
    [self initComponents];
	
	[self reloadCalendarEventModelWhileIsNewModel];
}

- (void)reloadCalendarEventModelWhileIsNewModel {
	// 新增日程事件时进入
	if (!self.noDeleteTryAction && (self.eventType != calendar_eventTypeEdit)) {
		if (!self.avoidClearDate) {
			[self.modelCalendar removeTryAction];
		}
		self.modelCalendar.try_remindType = 0;
		self.modelCalendar.try_isVisible = YES;
		
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    [self.tableView endEditing:YES];
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

- (void)refreshDataBlick:(NewCalendarAddNewEventViewControllerBlick)block
{
    self.block = block;
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
        
    } else if(type == CalendarSwitchTypeImportant)
    {
        self.modelCalendar.try_important = isOn;
    }
    else if(type==CalendarSwitchTypeisVisible)
    {
        self.modelCalendar.try_isVisible = !isOn;
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
    }/* else if (!self.modelCalendar.try_place) {
        errorString = LOCAL(MEETING_INPUT_ADDRESS);
    } else if (![self.modelCalendar.try_time count]) {
        errorString = LOCAL(MEETING_INPUT_TIME);
    }*/
    
    if (![errorString length]) {
        return YES;
    }
    
    [self postError:errorString];
    return NO;
}

#pragma mark - Button Click
- (void)clickToBack {
    [MixpanelMananger track:@"calendar/cancel"];
    if (_isPresented) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
        NewCalendarNewRequest *newRequest = [[NewCalendarNewRequest alloc] initWithDelegate:self];
        [newRequest newCalendarModel:self.modelCalendar];
    } else if (self.eventType == calendar_eventTypeEdit) {
        // 编辑模式
        if (!self.recentStartTimes) {
            NSDate *date = [self.modelCalendar.try_time objectAtIndex:0];
            long timeInterval = [date timeIntervalSince1970] * 1000;
            self.recentStartTimes = [NSString stringWithFormat:@"%ld", timeInterval];
        }
        
        if (self.saveType == 0)
        {
            [self postLoading];
            NewCalendarEditRequest *editRequest = [[NewCalendarEditRequest alloc] initWithDelegate:self];
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
    NewCalendarEditRequest *editRequest = [[NewCalendarEditRequest alloc] initWithDelegate:self];
    [editRequest editScheduleByCalendarModel:self.modelCalendar initialStartTime:self.recentStartTimes WithSaveType:saveType];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([response isKindOfClass:[NewCalendarNewResponse class]]) {
        // 新建成功
        [self RecordToDiary:@"新建日程事件成功"];
        [self postSuccess:LOCAL(SENDER_SUCCESS)];
        
        NSArray *timeShowId = [(NewCalendarNewResponse *)response showIds];
        NSString *showId    = [(NewCalendarNewResponse *)response showId];
        NSString *relateId  = [(NewCalendarNewResponse *)response relateId];
        
        [self.modelCalendar refreshAllAction];
        
        self.modelCalendar.showId = showId;
        self.modelCalendar.showIdList = [NSMutableArray arrayWithArray:timeShowId];
        self.modelCalendar.type = [timeShowId count] == 1 ? @"event" : @"event_sure";
        self.modelCalendar.relateId = relateId;
        
        
        
        NSArray *startTime = [(NewCalendarNewResponse *)response startTime];
        self.recentStartTimes = [startTime objectAtIndex:0];
        
        NewCalendarMakeSureViewController *CNEMSVC = [[NewCalendarMakeSureViewController alloc] initWithModelShow:self.modelCalendar];
        [self performSelector:@selector(popActionWithVc:) withObject:CNEMSVC afterDelay:1.0];
        
        
    }
    
    else if ([response isKindOfClass:[NewCalendarEditResponse class]]) {
        // 编辑成功
        [self postSuccess];
        [self RecordToDiary:@"编辑日程事件成功"];
        [self postSuccess:LOCAL(SENDER_SUCCESS)];
        [self.modelCalendar refreshAllAction];
        
        NSArray *timeShowId = [(NewCalendarEditResponse *)response showIds];
        self.modelCalendar.showIdList = [NSMutableArray arrayWithArray:timeShowId];
        
        self.modelCalendar.showId = [(NewCalendarEditResponse *)response showIdNew];
        
        NSArray *startTime = [(NewCalendarEditResponse *)response startTime];
        self.recentStartTimes = [startTime objectAtIndex:0];
        
        NewCalendarMakeSureViewController *CNEMSVC = [[NewCalendarMakeSureViewController alloc] initWithModelShow:self.modelCalendar];
        
        [self performSelector:@selector(popActionWithVc:) withObject:CNEMSVC afterDelay:1.0];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MCCalendarDidChangedNotification object:nil];
}

- (void)popActionWithVc:(UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - CalendarNewEventTimeSelectView Delegate
- (void)CalendarNewEventTimeSelectViewDelegateCallBack_SelectTimes:(NSArray *)timeArray selectMode:(CalendarNewEventTimeSelectMode)selectMode {
    
    if (self.modelCalendar.try_time == self.modelCalendar.time) {
        self.modelCalendar.try_time = [NSMutableArray array];
    }
    
    [self.modelCalendar.try_time removeAllObjects];
    [self.modelCalendar.try_time addObjectsFromArray:timeArray];
    
    BOOL wholeDay = selectMode == CalendarNewEventTimeSelectModeWholeDay;
    [self switchDidChangWithCalendarType:CalendarSwitchTypeWholeDay isOn:wholeDay];
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
    
    if (currentIndex == cellModeMap) { // 场所
        if ([self canUseMap]) {
            return 205;
        }
        else
        {
            return 55;
        }
    }
    if (currentIndex == cellModeTitle)
    {
        return 45;
//        return self.mytitlecell.cellheight;
//       return 45;
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
            cell = [tableView dequeueReusableCellWithIdentifier:[TaskOnlyTextFieldTableViewCell identifier]];
            [cell texfFieldTitle].delegate = self;
            [[cell texfFieldTitle] setTag:10];
            
			[cell texfFieldTitle].text = self.modelCalendar.try_title? [self.modelCalendar.try_title stringByRemovingEmoji]:@"";
            return cell;
//            if (self.modelCalendar) [self.mytitlecell setContent:self.modelCalendar.try_title];
//            return self.mytitlecell;
            break;
        }
        case cellModeImportant: // 重要
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
			
			__weak typeof(self) weakSelf = self;
            [cell calendarSwitchDidChange:^(CalendarSwitchType swithType, BOOL isOn) {
                // switch 按钮回调
				__strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf switchDidChangWithCalendarType:swithType isOn:isOn];
            }];
            
            break;
        }
        case cellModeAddress:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[MeTextFieldTableViewCell identifier]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setTfdaligent:aligent_right];
            [cell tfdOriginal].delegate = self;
			[cell tfdOriginal].text = (self.modelCalendar.address != nil ? self.modelCalendar.address : self.modelCalendar.place.name);
            [[cell lblTitle] setText:LOCAL(PLACE)];
            [[cell lblTitle] setTextColor:[UIColor mtc_colorWithHex:0x666666]];
        }
            break;
        case cellModeMap: // 场所
            if ([self canUseMap]) {
                // 能够加载图片,则加载图片，不与下面同流合污
                cell = [[NewCalenadarMapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewCalenadarMapTableViewCell identifier] needMap:YES];
                [cell setbtnselectd:YES];
				
				__weak typeof(self) weakSelf = self;
                [cell setBlock:^(BOOL isshow) {

					__strong typeof(weakSelf) strongSelf = weakSelf;
                    if (strongSelf.modelCalendar.try_place == strongSelf.modelCalendar.place) {
                        strongSelf.modelCalendar.try_place = [PlaceModel nullPlace];
                    }
                    strongSelf.modelCalendar.try_place.coordinate = CLLocationCoordinate2DMake(MAXLAT, MAXLAT);
					strongSelf.modelCalendar.address = strongSelf.modelCalendar.try_place.name;
					
					if (isshow) {
						strongSelf.modelCalendar.place.name = strongSelf.modelCalendar.address;
					}
					
                    [strongSelf.tableView reloadRowsAtIndexPaths:@[[strongSelf indexPathFromCellMode:cellModeMap], [strongSelf indexPathFromCellMode:cellModeAddress]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
                [cell mapWithPlaceModel:self.modelCalendar.try_place];
                return cell;
            }
            else
            {
                cell = [[NewCalenadarMapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewCalenadarMapTableViewCell identifier] needMap:NO];
				
                [cell setbtnselectd:NO];
				
				__weak typeof(self) weakSelf = self;
                [cell setBlock:^(BOOL isshow) {
                    //跳转

					__strong typeof(weakSelf) strongSelf = weakSelf;
                    NewCalendarMapAddressSelectedViewController *CAMPSVC = [[NewCalendarMapAddressSelectedViewController alloc] init];
                    
                    [CAMPSVC getSelectedPlace:^(PlaceModel *selectedPlace) {
                        // 获取场所回调
                        strongSelf.modelCalendar.try_place = selectedPlace;
						strongSelf.modelCalendar.address = strongSelf.modelCalendar.try_place.name;
						
                        [strongSelf.tableView reloadRowsAtIndexPaths:@[[strongSelf indexPathFromCellMode:cellModeMap], [strongSelf indexPathFromCellMode:cellModeAddress]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }];
                    
                    [strongSelf.navigationController pushViewController:CAMPSVC animated:YES];
                }];
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
        case cellModeIsVisible:  // 仅自己可见
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarSwitchTableViewCell identifier]];
            [cell textLabel].text =  [array objectAtIndex:row];
            [cell setSwitchColor:[UIColor themeRed]];
            [cell setSwitchType:CalendarSwitchTypeisVisible];
            [cell isOn:!self.modelCalendar.try_isVisible];
			
			__weak typeof(self) weakSelf = self;
            [cell calendarSwitchDidChange:^(CalendarSwitchType swithType, BOOL isOn) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
                // switch 按钮回调
                [strongSelf switchDidChangWithCalendarType:swithType isOn:isOn];
            }];
            
            break;
        }
        case cellModeDetail: // 详细
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarTextViewTableViewCell identifier]];
            [cell setDelegate:self];
            [cell setContent:self.modelCalendar.try_content?:@""];
			self.detailTextIndexPath = indexPath;
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
            NewCalendarMapAddressSelectedViewController *CAMPSVC = [[NewCalendarMapAddressSelectedViewController alloc] init];
			
			__weak typeof(self) weakSelf = self;
            [CAMPSVC getSelectedPlace:^(PlaceModel *selectedPlace) {
                // 获取场所回调
				__strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.modelCalendar.try_place = selectedPlace;
                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            
            [self.navigationController pushViewController:CAMPSVC animated:YES];
            break;
        }
        case cellModeRepeat: // 重复
        {
			__weak typeof(self) weakSelf = self;
            CalendarNewEventRepeatViewController *CNERVC = [[CalendarNewEventRepeatViewController alloc] initWithRepeatType:^(NSInteger repatType) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.modelCalendar.try_repeatType = repatType;
                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            
            [self.navigationController pushViewController:CNERVC animated:YES];
            break;
        }
        case cellModeAlert:
        {
			__weak typeof(self) weakSelf = self;
            CalendarNewEventRemindViewController *CNERVC = [[CalendarNewEventRemindViewController alloc] initWithWholeDayMode:self.modelCalendar.try_wholeDay RemindType:^(NSInteger remindType) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.modelCalendar.try_remindType = remindType;
                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];			
			CNERVC.title = LOCAL(MEETING_NOTIFICATE);
            
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
	[self.tableView scrollToRowAtIndexPath:self.detailTextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	[UIView animateWithDuration:0.25 animations:^{
		self.view.transform  = CGAffineTransformMakeTranslation(0, -200);
	}];
	
//    [self textViewWillMoving:textView];
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

- (void)textViewCell:(NewApplyAddApplyTitleTableViewCell *)cell didChangeText:(NSString *)text needreload:(BOOL)need
{
    self.modelCalendar.try_title = cell.tvwTitle.text;
    if (need)
    {
        //        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        //        [self.tableView reloadData];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
//        [cell.tvwTitle becomeFirstResponder];
    }
}

#pragma mark - textfielddelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];

//    if (range.length == 0)
//    {
//        strtextfield = [NSString stringWithFormat:@"%@%@",textField.text,string];
//    }
//    else
//    {
//        strtextfield = [textField.text substringToIndex:([textField.text length] - 1)];
//        self.modelCalendar.address = strtextfield;
//    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 10)
    {
        self.modelCalendar.try_title = textField.text;
    }else
    {
        self.modelCalendar.address = textField.text;
        self.modelCalendar.place.name = textField.text;
    }
}

#pragma mark - Keyboard Method
- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    self.keyboardHeight = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (self.textView) {
        [self textViewWillMoving:self.textView];
		[UIView animateWithDuration:0.25 animations:^{
			self.view.transform  = CGAffineTransformIdentity;
		}];
	} else {
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
        [_tableView registerClass:[MeTextFieldTableViewCell class] forCellReuseIdentifier:[MeTextFieldTableViewCell identifier]];
        
        [_tableView registerClass:[TaskOnlyTextFieldTableViewCell class] forCellReuseIdentifier:[TaskOnlyTextFieldTableViewCell identifier]];
//        [_tableView registerClass:[NewApplyAddApplyTitleTableViewCell class] forCellReuseIdentifier:[NewApplyAddApplyTitleTableViewCell identifier]];
    }
    return _tableView;
}

- (NSArray *)arrTitle {
    if (!_arrTitle) {
        NSArray *array1 = @[@""];
        NSArray *array2 = @[LOCAL(CALENDAR_ADD_CHOOSETIME),LOCAL(CALENDAR_ADD_PLACE),@"",LOCAL(CALENDAR_ADD_IMPORTANT)];
//        NSArray *array3 = @[];
        //        NSArray *array4 = @[LOCAL(CALENDAR_ADD_REPEAT)];
        NSArray *array5 = @[LOCAL(CALENDAR_ADD_NOTIFICATION)];
        NSArray *array6 = @[LOCAL(NEWCALENDAR_ONLYMECANSEE)];
        NSArray *array7 = @[@""];
        _arrTitle = @[array1, array2, array5, array6,array7];
    }
    return _arrTitle;
}

- (CalendarLaunchrModel *)modelCalendar {
    if (!_modelCalendar) {
        _modelCalendar = [[CalendarLaunchrModel alloc] init];
        _modelCalendar.wholeDay = YES;
		_modelCalendar.try_isVisible = YES;
        _modelCalendar.remindType = calendar_remindTypeWholeDay;
    }
    return _modelCalendar;
}

- (NewApplyAddApplyTitleTableViewCell *)mytitlecell
{
    if (!_mytitlecell)
    {
        _mytitlecell = [[NewApplyAddApplyTitleTableViewCell alloc] init];
        _mytitlecell.delegate = self;
        _mytitlecell.placeholderLabel.text = LOCAL(NEWCALENDAR_INPUTEVENTTITLE);

    }
    return _mytitlecell;
}
@end
