//
//  NewDetailMissionViewController.m
//  launcher
//
//  Created by jasonwang on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewDetailMissionViewController.h"
#import <Masonry/Masonry.h>
#import "NewMissionDetailTitelTableViewCell.h"
#import "CalendarTextViewTableViewCell.h"
#import "MyDefine.h"
#import "ApplicationAttachmentTableViewCell.h"
#import "MWPhotoBrowser.h"
#import "TaskListModel.h"
#import "NewMissionGetMissionDetailRequest.h"
#import "NewMissionDetailModel.h"
#import "NSDate+String.h"
#import "NewMissionAddMissionViewController.h"
#import "BaseNavigationController.h"
#import "NewSubMissionTableViewCell.h"
#import "NewMissionChangeMissionStatusRequest.h"
#import "WhiteBoradStatusType.h"
#import "ReturnToMainMissionTableViewCell.h"
#import "ApplicationAttachmentGetRequest.h"
#import "ApplicationAttachmentModel.h"
#import "NewDeleteTaskRequest.h"
#import "NomarlBtnsWithNoimagesView.h"
#import "NewMissionAddMissionViewController.h"
#import "NewDeleteTaskRequest.h"
#import "UIColor+Hex.h"
#import "UpDateCommmentRequest.h"
#import "ChatSingleViewController.h"
#import "ChatGroupViewController.h"
#import "WebViewController.h"
#import <UIActionSheet+Blocks.h>
//#import "UpDateCommmentRequest.h"
typedef enum{
    
    CellType_Title = 00,        // 标题
    CellType_Details = 01,      // 详情
    CellType_TimeAndPerson = 02,    // 时间和参与人
    
    CellType_childMission = 10,     // 子任务添加
    
    CellType_ProjectTitle = 20, // 项目名称
    CellType_Tag = 21,          // 标签
    CellType_Alert = 22,        // 提醒
    CellType_Accessory = 23,    // 附件
}Cell_Type;

typedef NS_ENUM(NSUInteger, PhotoShowType) {
    
    /** 详情中查看照片 与父类中区分 */
    photoShowTypeFromDetail = 1,
    
};

@interface NewDetailMissionViewController ()<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate,BaseRequestDelegate,NewMissionDetailTitelTableViewCellDelegate,NewSubMissionTableViewCellDelegate,SWTableViewCellDelegate, CalendarTextViewTableViewCellClickDelegate>

@property (nonatomic, strong) NewMissionDetailModel *detailModel;
@property (nonatomic, copy) NSString *myShowID;
@property (nonatomic) BOOL isSubMission;
@property (nonatomic, strong) NomarlBtnsWithNoimagesView *moreView;
@property (nonatomic) BOOL isDeleteMainMission;
@property (nonatomic) BOOL needRefresh;
@end

@implementation NewDetailMissionViewController
- (instancetype)initWithOnlyShowID:(NSString *)strshowid
{
    self = [super initWithAppShowIdType:kAttachmentAppShowIdNewTask rmShowID:strshowid];
    if (self) {
        self.myShowID = strshowid;
        self.needRefresh = YES;
        self.isFirstVC = NO;
        [self setTitle:LOCAL(MISSION_DETAIL_TITLE)];
    }
    return self;
}

- (instancetype)initWithMissionDetailModel:(TaskListModel *)detailModel {
    self = [super initWithAppShowIdType:kAttachmentAppShowIdNewTask rmShowID:detailModel.showId];
    if (self) {
        self.myShowID = detailModel.showId;
        self.needRefresh = YES;
        self.isFirstVC = NO;
        [self setTitle:LOCAL(MISSION_DETAIL_TITLE)];
    }
    return self;
}

- (instancetype)initWithParentMission:(NSString *)showID {
    self = [super initWithAppShowIdType:kAttachmentAppShowIdNewTask rmShowID:showID];
    if (self) {
        self.myShowID = showID;
        self.needRefresh = YES;
        self.isFirstVC = NO;
        [self setTitle:LOCAL(MISSION_DETAIL_TITLE)];
    }
    return self;
}

- (instancetype)initWithSubMission:(NSString *)showID
{
    self = [super initWithAppShowIdType:kAttachmentAppShowIdNewTask rmShowID:showID];
    if (self) {
        [self setTitle:LOCAL(NEWMISSION_SUBMISSION_DETAIL)];
        self.needRefresh = YES;
        self.myShowID = showID;
        self.isSubMission = YES;
        self.isFirstVC = NO;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configElements];
    [self showLeftItemWithSelector:@selector(leftBarButtonItemClick)];
    [self.tableView registerClass:[NewMissionDetailTitelTableViewCell class]        forCellReuseIdentifier:[NewMissionDetailTitelTableViewCell identifier]];
    [self.tableView registerClass:[CalendarTextViewTableViewCell class]        forCellReuseIdentifier:[CalendarTextViewTableViewCell identifier]];
    [self.tableView registerClass:[ApplicationAttachmentTableViewCell class]        forCellReuseIdentifier:[ApplicationAttachmentTableViewCell identifier]];
    [self.tableView registerClass:[NewSubMissionTableViewCell class]        forCellReuseIdentifier:[NewSubMissionTableViewCell identifier]];
    [self.tableView registerClass:[ReturnToMainMissionTableViewCell class]        forCellReuseIdentifier:[ReturnToMainMissionTableViewCell identifier]];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }

    // Do any additional setup after loading the view.
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.needRefresh)
    {
        [self startGetMissionDetailRequestWithShowID:self.myShowID];
        self.moreView.canappear = YES;
        [self reloadComments];
    }
    else
    {
        self.needRefresh = YES;
    }
}

- (void)leftBarButtonItemClick
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method

//更新评论字段

- (void)updateComment
{
    UpDateCommmentRequest *request = [[UpDateCommmentRequest alloc] initWithDelegate:self];
    [request updateWithshowID:self.detailModel.showId isComment:[NSString stringWithFormat:@"%d",1]];
}

//获取任务详情
- (void)startGetMissionDetailRequestWithShowID:(NSString *)showID
{
    NewMissionGetMissionDetailRequest *request = [[NewMissionGetMissionDetailRequest alloc] initWithDelegate:self];
    [request getDetailTaskWithId:showID];
}
//改变任务状态
- (void)changeMissionStatusWithShowID:(NSString *)showID Status:(whiteBoardStyle)Status
{
    NSString *myType;
    NewMissionChangeMissionStatusRequest *request = [[NewMissionChangeMissionStatusRequest alloc] initWithDelegate:self];
    if (Status == whiteBoardStyleWaiting) {
        myType = @"FINISH";
    } else if (Status == whiteBoardStyleFinish)
    {
        myType = @"WAITING";
    }
    [request requestWithShowID:showID status:myType];
}
- (void)configElements {
//    self.moreView.canappear = NO ;
//    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.equalTo(self.view);
//    }];
    
}


- (NSUInteger)realIndexAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section * 10 + indexPath.row;
}

/// 选择点击的附件
- (void)selectedAttchmentAtIndex:(NSUInteger)selectedIndex {
	self.needRefresh = NO;
	ApplicationAttachmentModel *model = self.detailModel.attachMentArray[selectedIndex];
	if (![AttachmentUtil isImage: model.title]) {
		[self selectedShowFileWithModel:model];
	} else {
		[self clickToSeeImageAtIndex:selectedIndex];
	}
}

/// 查看文件
- (void)selectedShowFileWithModel:(ApplicationAttachmentModel *)model {
	WebViewController *webVC = [[WebViewController alloc] initWithURL:model.path shouldDownload:YES];
	webVC.title = model.title;
	[self.navigationController pushViewController:webVC animated:YES];
}

/** 图片点击查看 */
- (void)clickToSeeImageAtIndex:(NSUInteger)index {
    
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.identifier = photoShowTypeFromDetail;
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableSwipeToDismiss = NO;
    photoBrowser.gridButton.hidden = YES;
    [photoBrowser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:photoBrowser animated:NO];
    
}
//转换时间间隔字段
- (NSString *)getTimeWithStartLong:(long long)StartLong endLong:(long long)endLong
{
    NSString *startString = @"";
    NSString *endString = @"";
    if (StartLong) {
        NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:StartLong/1000];
        startString = [startDate mtc_getStringWithDateWholeDay:self.detailModel.isStartTimeAllDay];

    } else {
        startString = LOCAL(NEWMISSION_NO_START_TIME);
    }
    
    if (endLong) {
        NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:endLong/1000];
        endString = [endDate mtc_getStringWithDateWholeDay:self.detailModel.isEndTimeAllDay];
    } else {
        endString = LOCAL(NEWMISSION_UNSET);
    }
    
    
    if (StartLong && endLong)
    {
        return [NSString stringWithFormat:@"%@~%@",startString,endString];
    }
    else if (StartLong)
    {
        return [NSString stringWithFormat:@"%@ %@",LOCAL(NEWMISSION_SELECT_START_TIME),startString];
    }
    else if (endLong)
    {
        return [NSString stringWithFormat:@"%@ %@",LOCAL(NEWMISSION_SELECT_END_TIME),endString];
    }
    else
    {
        return [NSString stringWithFormat:@"%@、%@",startString, endString];
    }
}

- (NSString *)getRemindString:(calendar_remindType)remindType
{
    NSString *type;
    switch (remindType) {
        case calendar_remindTypeEventNo:
            type = LOCAL(CALENDAR_NEVER_REMIND);
            break;
        case calendar_remindTypeEventStart:
            type = LOCAL(CALENDAR_BEFORE_EVENT_BEGIN);
            break;
        case calendar_remindTypeFiveMM:
            type = [NSString stringWithFormat:@"5%@",LOCAL(CALENDAR_MINUTES_BEFORE)];
            break;
        case calendar_remindTypeFifthMM:
            type = [NSString stringWithFormat:@"15%@",LOCAL(CALENDAR_MINUTES_BEFORE)];
            break;
        case calendar_remindTypeThirtyMM:
            type = [NSString stringWithFormat:@"30%@",LOCAL(CALENDAR_MINUTES_BEFORE)];
            break;
        case calendar_remindTypeOneHH:
            type = [NSString stringWithFormat:@"1%@",LOCAL(CALENDAR_HOURS_BEFORE)];
            break;
        case calendar_remindTypeTwoHH:
            type = [NSString stringWithFormat:@"2%@",LOCAL(CALENDAR_HOURS_BEFORE)];
            break;
        case calendar_remindTypeOneDay:
            type = [NSString stringWithFormat:@"1%@",LOCAL(CALENADR_DAYS_BEFORE)];
            break;
        case calendar_remindTypeTwoDay:
            type = [NSString stringWithFormat:@"2%@",LOCAL(CALENADR_DAYS_BEFORE)];
            break;
        case calendar_remindTypeOneWeek:
            type = [NSString stringWithFormat:@"1%@",LOCAL(CALENDAR_WEEKS_BEFORE)];
            break;
        case calendar_remindTypeWholeDay:
            type = LOCAL(MEETING_EVENT_DAY);
            break;
        case calendar_remindTypeWholeOneDay:
            type = [NSString stringWithFormat:@"1%@",LOCAL(CALENADR_DAYS_BEFORE)];
            break;
        case calendar_remindTypeWholeTwoDay:
            type = [NSString stringWithFormat:@"2%@",LOCAL(CALENADR_DAYS_BEFORE)];
            break;
        case calendar_remindTypeWholeOneWeek:
            type = [NSString stringWithFormat:@"1%@",LOCAL(CALENDAR_WEEKS_BEFORE)];
            break;
            
        default:
            break;
    }
    return type;
}

- (void)configCreateComment {
    NewMissionDetailModel *showModel = self.detailModel;
    [self.createRequest setRmShowId:showModel.showId];
    [self.createRequest setToUser:@[showModel.userName] toUserName:@[showModel.userTrueName] title:showModel.title];
}

- (void)changeCommentParameter
{
    if (!self.detailModel.isComment)
    {
        [self updateComment];
    }
}

//删除子任务
- (void)deleteTaskRequestWithShowID:(NSString *)showId path:(NSIndexPath *)path
{
    NewDeleteTaskRequest * request = [[NewDeleteTaskRequest alloc] initWithDelegate:self];
    request.showId = showId;
    request.path = path;
    [request requestData];
    [self postLoading];
}
#pragma mark - event Response
- (void)moreClick
{
    if (!self.moreView.canappear) {
        self.moreView.canappear = YES;
        [self.moreView removeFromSuperview];
        return;
    }
    [self.view addSubview:self.moreView];
    [self.moreView appear];
}
- (void)selectMoreViewIndex:(NSInteger)index
{
    if (!index) {
        //编辑
        NewMissionAddMissionViewController *VC = [[NewMissionAddMissionViewController alloc] initWithEditMissionWithShowID:self.detailModel.showId];
        [self.navigationController pushViewController:VC animated:YES];
//        BaseNavigationController *naVC = [[BaseNavigationController alloc] initWithRootViewController:VC];
//        [self presentViewController:naVC animated:YES completion:nil];
    } else {
        //删除

        self.isDeleteMainMission = YES;
        NewDeleteTaskRequest *request = [[NewDeleteTaskRequest alloc] initWithDelegate:self];
        request.showId = self.detailModel.showId;
        [request requestData];
        [self postLoading];
        
    }
    
}

#pragma mark - UIActionSheet Delegate
- (void)calendarTextViewTableViewCellDidClickSpecialText:(NSString *)text textType:(RichTextType)textType {
	
	switch (textType) {
		case RichTextNumber: {
			NSString *title = [NSString stringWithFormat:LOCAL(CHAT_CALL_NUMBER), text];
			[UIActionSheet showInView:self.view withTitle:title cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:@[LOCAL(CHAT_CALL), LOCAL(MESSAGE_COPY)] tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
				NSLog(@"%ld", buttonIndex);
				if(buttonIndex == 0){
					if(!text.length){
						return;
					}
					NSString *phone =[NSString stringWithFormat:@"tel:%@", text];
					NSURL *url = [NSURL URLWithString:phone];
					[[UIApplication sharedApplication] openURL:url];
				}
				
				if(buttonIndex == 1){
					UIPasteboard *pboard = [UIPasteboard generalPasteboard];
					pboard.string = text;
				}
				
			}];
			
			break;
		}
			
		case RichTextEmail:
		case RichTextURL:
		case RichTextNone:
			break;
	}
	
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NewMissionDetailBaseModel *model = self.detailModel.childTasks[cellIndexPath.row - 1];
    if (index == 0) {
        // 删除任务
        [self deleteTaskRequestWithShowID:model.showId path:cellIndexPath];
    }
//    
//    TaskListModel * model;
//    if (_sections ==2) {
//        model = [self.todayArray objectAtIndex:cellIndexPath.row];
//    }else {
//        model = [self.dataArray objectAtIndex:cellIndexPath.row];
//    }
//    
//    NSLog(@"--- cellIndexpath = %@",cellIndexPath);
//    switch (index) {
//        case 0:
//            // 编辑任务(任务详情)
//            
//        {
//            NewMissionAddMissionViewController *VC = [[NewMissionAddMissionViewController alloc] initWithEditMissionWithShowID:model.showId];
//            [self.navigationController pushViewController:VC animated:YES];
//        }
//            break;
//            
//        case 1:
//            // 删除任务
//        {
//            [self deleteTaskRequestWithShowID:model.showId path:cellIndexPath];
//        }
//            break;
//            
//        default:
//            break;
//    }
    
    
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

#pragma mark - NewMissionDetailTitelTableViewCellDelegate

- (void)NewMissionDetailTitelTableViewCellDelegateCallBack_statusChange
{
    [self changeMissionStatusWithShowID:self.detailModel.showId Status:self.detailModel.type];
}


- (void)NewSubMissionTableViewCellDelegateCallBack_statusChange:(NSIndexPath *)indexPath
{
    NewMissionDetailBaseModel *model = self.detailModel.childTasks[indexPath.row - 1];
    [self changeMissionStatusWithShowID:model.showId Status:model.type];
}

#pragma mark - MWPhotoBrowser

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    
    if (photoBrowser.identifier == photoShowTypeFromDetail) {
        return [self.detailModel attachMentArray].count;
    }

    return [super numberOfPhotosInPhotoBrowser:photoBrowser];
    
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (photoBrowser.identifier == photoShowTypeFromDetail) {
        NSArray *arrayAttach = [self.detailModel attachMentArray];
        if (index >= [arrayAttach count]) {
            return nil;
        }
        ApplicationAttachmentModel *attachModel = [arrayAttach objectAtIndex:index];
        if (attachModel.localPath) {
            return [[MWPhoto alloc] initWithImage:attachModel.originalImage];
        }
        return [[MWPhoto alloc] initWithURL:[NSURL URLWithString:attachModel.path]];
    } else {
        return [super photoBrowser:photoBrowser photoAtIndex:index];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3 + [super numberOfSectionsInTableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 55;
    } else {
        return 15;

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3)
    {
        return [super tableView:tableView viewForHeaderInSection:section];
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSInteger realIndexPath = [self realIndexAtIndexPath:indexPath];
    CGFloat height;
    if (indexPath.section == 3) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    switch (realIndexPath) {
        case CellType_Details:
        {
            if ([self.detailModel.content isEqualToString:@""]) {
                height = 0;
            } else {
				height = [CalendarTextViewTableViewCell cellForRowHeightWithText:self.detailModel.content];
            }
        }
            break;
            
        case CellType_Tag:
            height = 0;
            break;
			
		case CellType_Accessory:
        {
            if ([self.detailModel attachMentArray].count <= 0) {
                return 0;
            }
            
			return [ApplicationAttachmentTableViewCell heightForCellWithImages:[self.detailModel attachMentArray]];
        }
            break;
        default:
        {
            if (indexPath.section == 1 && indexPath.row != 0) {
                height = 75;
            } else {
                height = 45;
            }
        }
            break;
            
    }
    return height;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    if (section == 3) {
        return 50;
    }
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num;
    switch (section) {
        case 0:
            num = 3;
            break;
        case 1:
            num = 1 + self.detailModel.childTasks.count;
            break;
        case 2:
            num = 4;
            break;
        case 3:
            num = [super tableView:tableView numberOfRowsInSection:section];
            break;
        default:
            break;
    }
    return num;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    id cell;
    NSInteger realIndexPath = [self realIndexAtIndexPath:indexPath];
    switch (realIndexPath) {
        case CellType_Title: //标题
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[NewMissionDetailTitelTableViewCell identifier]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setDataWithModel:self.detailModel];
            [cell setDelegate:self];
        }
            break;
            
        case CellType_Details: //详情
        {
			cell = (CalendarTextViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CalendarTextViewTableViewCell identifier]];
			[(CalendarTextViewTableViewCell *)cell setClickDelegate:self];
            [cell textViewEditable:NO];
            [[cell placeholderLabel] setText:@""];
            [cell setContent:self.detailModel.content];
            
        }
            break;
            
        case CellType_childMission: //子任务
        {
            if (self.isSubMission) {
                cell = [tableView dequeueReusableCellWithIdentifier:[ReturnToMainMissionTableViewCell identifier]];
                [[cell titelLb] setText:self.detailModel.parentTask.title];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCellID"];
                
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"defaultCellID"];
                    [cell textLabel].textColor = [UIColor blackColor];
                    [cell textLabel].font = [UIFont systemFontOfSize:14];
                    [cell detailTextLabel].textColor = [UIColor blackColor];
                    [cell detailTextLabel].font = [UIFont systemFontOfSize:14];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                [[cell imageView] setImage:[UIImage imageNamed:@"Mission_add"]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                [[cell textLabel] setText:LOCAL(NEWMISSION_ADD_SUBMISSION)];
            }
        }
            break;

        case CellType_ProjectTitle: //项目
        case CellType_Alert: //提醒
        case CellType_Tag:  //标签
        case CellType_TimeAndPerson:  //时间和参与人
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCellID"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"defaultCellID"];
                [cell textLabel].textColor = [UIColor mtc_colorWithHex:0x666666];
                [cell textLabel].font = [UIFont systemFontOfSize:14];
                [cell detailTextLabel].textColor = [UIColor blackColor];
                [cell detailTextLabel].font = [UIFont systemFontOfSize:14];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            NSString *title = @"";
            NSString *detailTitle = @"";
            switch (realIndexPath) {
                case CellType_ProjectTitle: //项目
                {
                    title = LOCAL(MISSION_PROJECT);
                    detailTitle = self.detailModel.projectName.length != 0 ? self.detailModel.projectName : LOCAL(NONE);
                }
                    break;
                    
                case CellType_Alert: //提醒
                {
                    title = LOCAL(MEETING_NOTIFICATE);
                    detailTitle = [self getRemindString:self.detailModel.remindType];
                }
                    
                    break;
                case CellType_TimeAndPerson:  //时间和参与人
                {
                    [[cell imageView] setImage:[UIImage imageNamed:@"New_TimeClock"]];
                    title = [self getTimeWithStartLong:self.detailModel.startTime endLong:self.detailModel.endTime];
                    detailTitle = self.detailModel.userTrueName;
                }
                    break;
                default:
                    
                    break;
                    
            }
            [[cell textLabel] setText:title];
            [[cell detailTextLabel] setText:detailTitle];
        }
            
            break;
            
        case CellType_Accessory: //附件
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if (self.detailModel.attachMentArray.count) {
                [cell titleLabel].text = LOCAL(APPLY_ATTACHMENT_TITLE);
            }
            [cell setImages:self.detailModel.attachMentArray];
            //[cell setHidden:![self.detailModel attachMentArray].count];
			__weak typeof(self) weakSelf = self;
            [cell clickToSeeImage:^(NSUInteger clickedIndex) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
				[strongSelf selectedAttchmentAtIndex:clickedIndex];
            }];
        }
            break;
            
        default:
            if (indexPath.section == 1 && indexPath.row != 0) {
                //子任务
                NewMissionDetailBaseModel *model = self.detailModel.childTasks[indexPath.row - 1];
                cell = [tableView dequeueReusableCellWithIdentifier:[NewSubMissionTableViewCell identifier]];
                [cell setSubDataWithModel:model indexPath:indexPath];
                [cell setDelegate:self];
                [cell setSubdelegate:self];
                [cell setRightUtilityButtons:[self rightButtons]];
            } else {
                //父类cell
                cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
            }
            break;
            
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger realIndexPath = [self realIndexAtIndexPath:indexPath];

    if (indexPath.section == 3) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else if (realIndexPath == CellType_childMission) {
        //是否是子任务
        if (self.isSubMission) {
            if (self.isFirstVC)
            {
                //点击进入父任务详情
                NewDetailMissionViewController *VC = [[NewDetailMissionViewController alloc] initWithParentMission:self.detailModel.parentTaskId];
                VC.strBeforeShowID = self.myShowID;
                [self.navigationController pushViewController:VC animated:YES];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } else {
            //点击添加子任务
            NewMissionAddMissionViewController *VC = [[NewMissionAddMissionViewController alloc]initWithCreatSubMission:self.detailModel.title mainMissionShowID:self.detailModel.showId mainMissionPrjectShowID:self.detailModel.projectId];
            //  呵呵呵呵呵呵呵呵呵呵   测试
            switch (self.myVCUsedto)
            {
                case DVCkind_Today:
                {
                    [VC setTimeType:Time_Type_Today];
                }
                    break;
                case DVCkind_Tomorrow:
                {
                    [VC setTimeType:Time_Type_Tomorrow];
                }
                    break;
                case DVCkind_NoTime:
                {
                    [VC setTimeType:Time_Type_NO];
                }
                    break;
                case DVCkind_nil:
                {
                    
                }
                    break;
                default:
                    break;
            }
            //呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵呵
            
            
            [self.navigationController pushViewController:VC animated:YES];

        }
        
    } else if (indexPath.section == 1 && indexPath.row != 0) {
        //点击进入子任务详情
        NewMissionDetailBaseModel *model = self.detailModel.childTasks[indexPath.row - 1];
        if (self.strBeforeShowID.length>0 && [self.strBeforeShowID isEqualToString:model.showId])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NewDetailMissionViewController *VC = [[NewDetailMissionViewController alloc] initWithSubMission:model.showId];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}


#pragma mark - request Delegate
-(void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self hideLoading];
    [self postError:errorMessage];
    if ([request isKindOfClass:[NewDeleteTaskRequest class]]) {
        if (self.isDeleteMainMission) {
            self.isDeleteMainMission = NO;
        }
    }

}

- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    [self hideLoading];
    if ([request isKindOfClass:[NewMissionGetMissionDetailRequest class]]) {
        NewMissionGetMissionDetailResponse *result = (NewMissionGetMissionDetailResponse *)response;
        self.detailModel = result.detailModel;
        //[self updateComment];
        if ([self.detailModel.createUser isEqualToString:[UnifiedUserInfoManager share].userShowID]) {
            UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cyclecyclecycle"] style:UIBarButtonItemStylePlain target:self action:@selector(moreClick)];
            [self.navigationItem setRightBarButtonItem:right];
        }
        // 下载附件
        [self postLoading];
        ApplicationAttachmentGetRequest *getAttachRequest = [[ApplicationAttachmentGetRequest alloc] initWithDelegate:self];
        [getAttachRequest getAppShowId:kAttachmentAppShowIdNewTask mainShowId:self.detailModel.showId];

        [self.tableView reloadData];
    } else if ([request isKindOfClass:[NewMissionChangeMissionStatusRequest class]]) {
        NewMissionChangeMissionStatusResponse *result = (NewMissionChangeMissionStatusResponse *)response;
        if (!result.isSuccess) {
            [self postError:LOCAL(NEWMISSION_CHANGE_FAIL)];
            [self.tableView reloadData];
        } else {
            [self reloadComments];
            [self startGetMissionDetailRequestWithShowID:self.myShowID];
        }
    } else if ([request isKindOfClass:[ApplicationAttachmentGetRequest class]]) {
        //[self RecordToDiary:[NSString stringWithFormat:@"获取任务附件成功:%@",self.detailModel.project.showId]];
        [self hideLoading];
        self.detailModel.attachMentArray = [NSMutableArray arrayWithArray:[(id)response arrayAttachments]];
        [self.tableView reloadData];
    } else if ([request isKindOfClass:[NewDeleteTaskRequest class]]) {
        if (!self.isDeleteMainMission) {
            NewDeleteTaskRequest * requ = (NewDeleteTaskRequest *)request;
            [self.detailModel.childTasks removeObjectAtIndex:requ.path.row- 1];
            [self.tableView reloadData];
        } else {
             [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([request isKindOfClass:[UpDateCommmentRequest class]]) {
         UpDateCommmentResponse *result = (UpDateCommmentResponse *)response;
        if (result.isSuccess) {
            //[self configCreateComment];
            self.detailModel.isComment = 1;
        }
    }
    else {
        [super requestSucceeded:request response:response totalCount:totalCount];
    }

}

#pragma mark - updateViewConstraints



#pragma mark - init UI

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] icon:[UIImage imageNamed:@"NewDelect"]];
    
    return rightUtilityButtons;
}
@synthesize createRequest = _createRequest;
- (ApplicationCommentNewRequest *)createRequest {
    if (!_createRequest) {
        _createRequest = [[ApplicationCommentNewRequest alloc] initWithDelegate:self appShowID:self.appShowId commentType:ApplicationMsgType_taskComment];
    }
    return _createRequest;
}

- (NomarlBtnsWithNoimagesView *)moreView
{
    if (!_moreView) {
        _moreView = [[NomarlBtnsWithNoimagesView alloc] initWithArrayLogos:@[[UIImage imageNamed:@"edit_new"],[UIImage imageNamed:@"delete_new"]] arrayTitles:@[LOCAL(CALENDAR_CONFIRM_EDIT),LOCAL(DELETE)]];
        __weak typeof(self) weakSelf = self;
        [_moreView setpassbackBlock:^(NSInteger index) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf selectMoreViewIndex:index];
        }];
    }
    return _moreView;
}


/*
 
 #pragma mark - Navigation
 
 
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 // Get the new view controller using [segue destinationViewController].
 
 // Pass the selected object to the new view controller.
 
 }
 
 */


@end

