//
//  NewCalendarMakeSureViewController.m
//  launcher
//
//  Created by 马晓波 on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarMakeSureViewController.h"
#import "NewCalendarAddNewEventViewController.h"
#import "NewCalendarViewController.h"
#import "CalendarEventMakeSureHeaderView.h"
#import "CalendarMakeSureMapTableViewCell.h"
#import "CalendarMakeSureDetailTableViewCell.h"
#import "CalendarEventRemindTimeCell.h"
#import "CalendarNewMakeSureRequest.h"
#import "CalendarDeleteRequest.h"
#import "CalendarGetRequest.h"
#import <Masonry/Masonry.h>
#import "CalendarLaunchrModel.h"
#import "PlaceModel.h"
#import "UIView+Util.h"
#import "MyDefine.h"
#import "Category.h"
#import "NomarlDealWithEventView.h"
#import "ChatViewController.h"
#import "ChatApplicationCalendarViewController.h"
#import "RichTextConstant.h"
#import <UIActionSheet+Blocks.h>

static NSString * const noMapCellIdentifier = @"noMapCellIdentifier";
static NSString *const killMapDelegateNotification = @"killMapDelegate";

@interface NewCalendarMakeSureViewController () <CalendarMakeSureDetailTableViewCellDelegate>
@property (nonatomic, strong) CalendarLaunchrModel *modelCalendar;

@property (nonatomic, strong) CalendarEventMakeSureHeaderView *tableHeaderView;

@property (nonatomic, strong)NomarlDealWithEventView *DealWithEventview;

/** 时间选择行数(默认为－1) */
@property (nonatomic, assign) NSInteger indexTime;

@property (nonatomic, readonly) CalendarLaunchrModel *readOnlyModel;

@property (nonatomic, assign) BOOL justSee;
@end

@implementation NewCalendarMakeSureViewController

- (instancetype)initWithModelShow:(CalendarLaunchrModel *)modelShow {
    return [self initWithModelShow:modelShow justSee:NO];
}

- (instancetype)initWithModelShow:(CalendarLaunchrModel *)modelShow justSee:(BOOL)justSee {
    self = [super initWithAppShowIdType:kAttachmentAppShowIdCalendar rmShowID:modelShow.showId];
    if (self) {
        _justSee = justSee;
        self.modelCalendar = modelShow;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indexTime = -1;
    
    self.title = LOCAL(CALENDAR_CONFIRM_CONFIRMORDER);
    if ([self.readOnlyModel.time count] == 2) {
        self.title = LOCAL(CALENDAR_CONFIRM_DETAILTITLE);
    }
    
    [self showLeftItemWithSelector:@selector(clickToSure)];
    
	self.tableView.tableHeaderView = self.tableHeaderView;
	self.tableView.backgroundColor = [UIColor grayBackground];
	
	[self registerTableViewCells];
	
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    
    if (!self.justSee)
    {
        UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cyclecyclecycle"] style:UIBarButtonItemStyleDone target:self action:@selector(dealwithEvent)];
        [self.navigationItem setRightBarButtonItem:barbtn];
    }
    [self configCreateComment];
}

- (void)registerTableViewCells {
	[self.tableView registerClass:[CalendarMakeSureMapTableViewCell class] forCellReuseIdentifier:[CalendarMakeSureMapTableViewCell identifier]];
	[self.tableView registerClass:[CalendarMakeSureDetailTableViewCell class] forCellReuseIdentifier:[CalendarMakeSureDetailTableViewCell identifier]];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:noMapCellIdentifier];
	[self.tableView registerClass:[CalendarEventRemindTimeCell class] forCellReuseIdentifier:[CalendarEventRemindTimeCell identifier]];
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self popGestureDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self popGestureDisabled:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:killMapDelegateNotification object:nil];
}

- (void)configCreateComment {
    //修复创建事件的时候崩溃的问题
    if (self.modelCalendar.createUserName && self.modelCalendar.createUser) {
        [self.createRequest setRmShowId:self.modelCalendar.showId];
        [self.createRequest setToUser:@[self.modelCalendar.createUser] toUserName:@[self.modelCalendar.createUserName] title:self.modelCalendar.title];
    }
}

#pragma mark - Button Click
- (void)clickToSure {
    // 直接弹出标志
    BOOL canPop = NO;
    
    if ([self.modelCalendar time].count <= 2) {
        canPop = YES;
    }
    
    if (self.indexTime == -1) {
        canPop = YES;
    }
    
    if (canPop) {
        [self popViewControllerRoot];
        return;
    }
    
    [self postLoading];
    CalendarNewMakeSureRequest *request = [[CalendarNewMakeSureRequest alloc] initWithDelegate:self];
    [request sureWithShowId:[self.modelCalendar.showIdList objectAtIndex:self.indexTime]];
}

- (void)dealwithEvent
{
    if (self.DealWithEventview.canappear == NO)
    {
        self.DealWithEventview.canappear = YES;
        [self.DealWithEventview removeFromSuperview];
    }
    else
    {
		__weak typeof(self) weakSelf = self;
        [self.DealWithEventview setpassbackBlock:^(NSInteger index) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
            if (index == 0) {
                [strongSelf clickToEdit];
            } else {
                [strongSelf clickToDelete];
            }
            
            [strongSelf.DealWithEventview tapdismess];
        }];
		
        [self.view addSubview:self.DealWithEventview];
        [self.DealWithEventview appear];
        
    }
    
}

- (void)clickToEdit {                       
    if (!self.modelCalendar) {
        return;
    }
    NSArray *array = [self.navigationController viewControllers];
    
    id VC = [array objectAtIndex:[array count] - 2];
    if ([VC isKindOfClass:[NewCalendarAddNewEventViewController class]]) {
        // 返回编辑模式
        [(NewCalendarAddNewEventViewController *)VC setEventType:calendar_eventTypeEdit];
        if (((NewCalendarAddNewEventViewController *)VC).modelCalendar.repeatType == calendar_repeatNo)
        {
            ((NewCalendarAddNewEventViewController *)VC).saveType = 0;
        }
        else
        {
            ((NewCalendarAddNewEventViewController *)VC).saveType = 1;
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
    else {
        // 新建编辑模式
        NewCalendarAddNewEventViewController *newVC = [[NewCalendarAddNewEventViewController alloc] init];
        
        [newVC setEventType:calendar_eventTypeEdit];
        [newVC setModelCalendar:self.modelCalendar];
        
        [self.navigationController pushViewController:newVC animated:YES];
    }
}

- (void)clickToDelete
{
    if (self.modelCalendar.repeatType == calendar_repeatNo)
    {
        UIAlertView *ShowDeleteView = [[UIAlertView alloc] initWithTitle:LOCAL(MEETING_SURE) message:LOCAL(MEETING_COMFIRM_DELETE) delegate:self cancelButtonTitle:LOCAL(CALENDAR_ADD_CANCLE)otherButtonTitles:LOCAL(MEETING_DELETE), nil];
        [ShowDeleteView show];
    }
    else
    {
        UIAlertView *ShowDeleteView = [[UIAlertView alloc] initWithTitle:LOCAL(MEETING_SURE) message:LOCAL(MEETING_COMFIRM_DELETE) delegate:self cancelButtonTitle:LOCAL(CALENDAR_ADD_CANCLE) otherButtonTitles:LOCAL(MEETING_DELETE_CURRENT),LOCAL(CALENDAR_DELETE_CURRENT_AFTER), nil];
        [ShowDeleteView show];
    }
}

/** 转发 */
- (void)clickToForward {
    
}

#pragma mark - Private Method
/** 根据placeModel判断是否显示地图 */
- (BOOL)canUseMap {
    if (!self.modelCalendar.place) {
        return NO;
    }
    
    CLLocationCoordinate2D coordinate = self.modelCalendar.place.coordinate;
    if (coordinate.latitude == MAXLAT && coordinate.longitude == MAXLAT) {
        return NO;
    }
    return YES;
}

/** 跳转到日程界面 */
- (void)popViewControllerRoot {
	
    for (id VC in [self.navigationController viewControllers].reverseObjectEnumerator) {
        if ([VC isKindOfClass:[NewCalendarViewController class]]) {
            [self.navigationController popToViewController:VC animated:NO];
			return;
        } else if ([VC isKindOfClass:[ChatApplicationCalendarViewController class]]) {
			[self.navigationController popToViewController:VC animated:YES];
			return;
		} else if ([VC isKindOfClass:[ChatViewController class]])
        {
            [self.navigationController popToViewController:VC animated:NO];
			return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CalendarMakeSureDetailTableViewCellDelegate
- (void)calendarMakeSureDetailTableViewCellDidClickRichText:(NSString *)text textType:(RichTextType)textType {
	switch (textType) {
		case RichTextNumber: {
			NSString *title = [NSString stringWithFormat:LOCAL(CHAT_CALL_NUMBER), text];
			[UIActionSheet showInView:self.view withTitle:title cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:@[LOCAL(CHAT_CALL), LOCAL(MESSAGE_COPY)] tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
				if(buttonIndex == 0){
					NSString *callPhone =[NSString stringWithFormat:@"tel:%@", text];
					NSURL *url = [NSURL URLWithString:callPhone];
					[[UIApplication sharedApplication] openURL:url];
				}
				
				if(buttonIndex == 1){
					UIPasteboard *pboard = [UIPasteboard generalPasteboard];
					pboard.string = text;
				}
				
			}];
			
			break;
		}
			
		case RichTextNone:
		case RichTextURL:
		case RichTextEmail:
			break;
			
	}

}

#pragma mark - AlertviewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
	
    NSInteger saveType = 0;
    if (buttonIndex == 2)
    {
        saveType = 1;
    }
	
    //删除代码
    [self postLoading];
    CalendarDeleteRequest *deleteRequest = [[CalendarDeleteRequest alloc] initWithDelegate:self];
    [deleteRequest deleteSheduleByShowId:self.modelCalendar.showId initialStartTime:self.modelCalendar.time[0] saveType:saveType];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[CalendarNewMakeSureRequest class]] || [request isKindOfClass:[CalendarDeleteRequest class]]) {
        // 确定候补时间、删除
        [self postSuccess];
        [self performSelector:@selector(popViewControllerRoot) withObject:nil afterDelay:0.5];
         [[NSNotificationCenter defaultCenter]postNotificationName:MCCalendarDidChangedNotification object:nil];
    }
    else {
        [super requestSucceeded:request response:response totalCount:totalCount];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
		
		if (self.hideRemindTimeCell) {
			return 2;
		} else {
			return 3;
		}
		
	} else {
		return [super tableView:tableView numberOfRowsInSection:section];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1)
    {
        return 55;
    }else
    {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return [super tableView:tableView viewForHeaderInSection:section];
    }
    else
    {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    if (indexPath.row == 0 && [self canUseMap])
    {
        // 地图
        return [CalendarMakeSureMapTableViewCell height];
    }
    else if (indexPath.row == 0 && self.modelCalendar.place.name.length == 0 &&  self.modelCalendar.address.length == 0)
    {
        return 0.01;
    }
    
    
    if (indexPath.row == 1)
    {
        // 详细
        return [CalendarMakeSureDetailTableViewCell heightForCell:self.modelCalendar.content];
    }
    else if (indexPath.row == 2)
    {
        if (self.hideRemindTimeCell)
        {
            return 0;
        }
    }
    
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    id cell = nil;
    switch (indexPath.row) {
        case 0: // 地图
        {
            if (![self canUseMap]) { // 不能使用地图
                cell = [tableView dequeueReusableCellWithIdentifier:noMapCellIdentifier];
                
                UIImage *image = [UIImage imageNamed:@"Calendar_Location_Logo"];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                [cell setAccessoryView:imageView];
                
                [cell textLabel].font = [UIFont mtc_font_30];
                if (self.modelCalendar.address.length > 0)
                {
                    [cell textLabel].text = self.modelCalendar.address;
                }
                else
                {
                    [cell textLabel].text = self.modelCalendar.place.name;
                }
                
                if (self.modelCalendar.place.name.length == 0 &&  self.modelCalendar.address.length == 0)
                {
                    [cell setHidden:YES];
                }
            }
            else {
                cell = [tableView dequeueReusableCellWithIdentifier:[CalendarMakeSureMapTableViewCell identifier]];
                if (self.modelCalendar.place) {
                    if (self.modelCalendar.address.length> 0) {
                        self.modelCalendar.place.name = self.modelCalendar.address;
						
                    } else {
                        if (self.modelCalendar.place.name.length > 0) {
                            self.modelCalendar.address = self.modelCalendar.place.name;
							
                        }
                    }
					
                    [cell mapWithPlaceModel:self.modelCalendar.place];
                }
            }

        }
            break;
        case 1: // 详细
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarMakeSureDetailTableViewCell identifier]];
			[(CalendarMakeSureDetailTableViewCell *)cell setDelegate:self];
            [cell setDetailText:self.modelCalendar.content];
            break;
        case 2: // buttons

			cell = (CalendarEventRemindTimeCell *)[tableView dequeueReusableCellWithIdentifier:[CalendarEventRemindTimeCell identifier]];
			
			[cell setRemindTimeText:self.modelCalendar.remindTypeString];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
    }
    else
    {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Setter Getter
- (void)setModelCalendar:(CalendarLaunchrModel *)modelCalendar {
    _modelCalendar = modelCalendar;
    [self.tableHeaderView setDataWithModel:self.readOnlyModel];

    [self.tableView reloadData];
}

- (CalendarLaunchrModel *)readOnlyModel {
    return self.modelCalendar;
}

- (BOOL)hideRemindTimeCell {
	return self.modelCalendar.remindType == calendar_repeatNo;
	
}

#pragma mark - Initializer
- (CalendarEventMakeSureHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
		_tableHeaderView = [[CalendarEventMakeSureHeaderView alloc] initWithReadOnlyMode:self.justSee];
		
		__weak typeof(self) weakSelf = self;
		[_tableHeaderView getSelectIndexBlock:^(NSInteger index) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
			if (!strongSelf) return ;

            strongSelf.indexTime = index;
			[strongSelf clickToSure];
			
        }];
        [_tableHeaderView clearSelectionBlock:^{
			__strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.indexTime = -1;
        }];
    }
    return _tableHeaderView;
}

@synthesize createRequest = _createRequest;
- (ApplicationCommentNewRequest *)createRequest {
    if (!_createRequest) {
        _createRequest = [[ApplicationCommentNewRequest alloc] initWithDelegate:self appShowID:self.appShowId commentType:ApplicationMsgType_eventComment];
    }
    return _createRequest;
}

- (NomarlDealWithEventView *)DealWithEventview
{
    if (!_DealWithEventview)
    {
        _DealWithEventview = [[NomarlDealWithEventView alloc] initWithArrayLogos:@[[UIImage imageNamed:@"edit_new"],[UIImage imageNamed:@"delete_new"]] arrayTitles:@[LOCAL(EDIT),LOCAL(DELETE)]];
        _DealWithEventview.canappear = YES;
    }
    return _DealWithEventview;
}

@end
