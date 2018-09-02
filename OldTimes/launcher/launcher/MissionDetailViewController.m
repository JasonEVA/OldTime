//
//  MissionDetailViewController.m
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionDetailViewController.h"
#import "ApplyTotalDetail_CenterLbelTableViewCell.h"
#import "ApplyTotalDetail_RightTableViewCell.h"
#import "ApplicationAttachmentTableViewCell.h"
#import "ApplyDetail_ReviewTableViewCell.h"
#import "MeetingTwoBtnsTableViewCell.h"
#import "MissionDetailHeadTableViewCell.h"
#import "MissionDetailToolTableViewCell.h"
#import "MissionDetailSubcellTableViewCell.h"
#import "MissionDetailTitleTableViewCell.h"
#import "CalendarMakeSureDetailTableViewCell.h"
#import "MissionDetailViewController.h"
#import "TaskNewTaskViewController.h"
#import "ProjectModel.h"
#import "Masonry.h"
#import "Category.h"
#import "MyDefine.h"
#import "TaskDeleteRequest.h"
#import "GetTaskDetailRequest.h"
#import "TaskChangeLevelRequest.h"
#import "ApplicationAttachmentGetRequest.h"
#import "TaskNewTaskViewController.h"
#import "MWPhotoBrowser.h"
#import "AttachmentUploadRequest.h"
#import "UIActionSheet+Util.h"
#import "MissionDetailModel.h"
#import "ApplicationAttachmentModel.h"
#import "NomarlDealWithEventView.h"

typedef NS_ENUM(NSUInteger, MissionDetailCellRealIndex) {
    kMissionDetailCellRealIndexHeader = 0,
    kMissionDetailCellRealIndexProject,
    kMissionDetailCellRealIndexTag,
    kMissionDetailCellRealIndexAttach,
    kMissionDetailCellRealIndexComment,
    kMissionDetailCellRealIndexButtons
};

typedef NS_ENUM(NSUInteger, PhotoShowType) {
    /** 详情中查看照片 与父类中区分 */
    photoShowTypeFromDetail = 1,
};

typedef NS_ENUM(NSUInteger, ActionSheetIdentifier) {
    // 与父类中区分
    actionSheetIdentifierSubTask = 1,
};

@interface MissionDetailViewController () <MissionDetailTitleTableViewCellDelegate, UIAlertViewDelegate, MWPhotoBrowserDelegate>

// Data

/** 链接内容 */
@property(nonatomic, strong) NSMutableArray *linkArray;
/** 显示子任务 */
@property(nonatomic, assign) BOOL  isShowSubTask;

@property (nonatomic, strong) MissionDetailModel *detailModel;
/** 有关联的model */
@property (nonatomic, strong) MissionDetailModel *relatedModel;
/** 是否显示关联model */
@property (nonatomic, assign) BOOL showRelated;

@property (nonatomic, strong)NomarlDealWithEventView *DealWithEventview;

@property (nonatomic, copy) void (^reloadBlock)();

@end

@implementation MissionDetailViewController

- (instancetype)initWithMissionDetailModel:(MissionDetailModel *)detailModel {
    self = [super initWithAppShowIdType:kAttachmentAppShowIdTask rmShowID:detailModel.showId];
    if (self) {
        self.detailModel = detailModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self popGestureDisabled:YES];
    [self showLeftItemWithSelector:@selector(clickToBack)];
    
    self.navigationItem.title = LOCAL(MISSION_DETAIL_TITLE);
    
    [self.tableView registerClass:[MissionDetailHeadTableViewCell class]              forCellReuseIdentifier:[MissionDetailHeadTableViewCell identifier]];
    [self.tableView registerClass:[ApplyTotalDetail_CenterLbelTableViewCell class]    forCellReuseIdentifier:[ApplyTotalDetail_CenterLbelTableViewCell identifier]];
    [self.tableView registerClass:[ApplyTotalDetail_RightTableViewCell class]         forCellReuseIdentifier:[ApplyTotalDetail_RightTableViewCell identifier]];
    [self.tableView registerClass:[ApplicationAttachmentTableViewCell class]          forCellReuseIdentifier:[ApplicationAttachmentTableViewCell identifier]];
    [self.tableView registerClass:[MissionDetailToolTableViewCell class]              forCellReuseIdentifier:[MissionDetailToolTableViewCell identifier]];
    [self.tableView registerClass:[MissionDetailTitleTableViewCell class]             forCellReuseIdentifier:[MissionDetailTitleTableViewCell identifier]];
    [self.tableView registerClass:[MissionDetailSubcellTableViewCell class]           forCellReuseIdentifier:[MissionDetailSubcellTableViewCell identifier]];
    [self.tableView registerClass:[CalendarMakeSureDetailTableViewCell class]         forCellReuseIdentifier:[CalendarMakeSureDetailTableViewCell identifier]];
    
    MissionDetailModel *model = [self missionModelShowNeeded];;
    NSString *userShowId = [[UnifiedUserInfoManager share] userShowID];
    BOOL showAll = [model.createrUser isEqualToString:userShowId];
    BOOL showTwo = [[@[model.arrayUser] firstObject] isEqualToString:userShowId];
    
    if (showAll || showTwo) {
        UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cyclecyclecycle"] style:UIBarButtonItemStyleDone target:self action:@selector(dealwithEvent)];
        [self.navigationItem setRightBarButtonItem:barbtn];
    }
    
    if (!self.detailModel.isAnnex) {
        return;
    }
    
    // 下载附件
    [self postLoading];
    ApplicationAttachmentGetRequest *getAttachRequest = [[ApplicationAttachmentGetRequest alloc] initWithDelegate:self];
    [getAttachRequest getAppShowId:kAttachmentAppShowIdTask mainShowId:self.detailModel.showId];
    
    
}

- (void)configCreateComment {
    MissionDetailModel *showModel = [self missionModelShowNeeded];
    [self.createRequest setRmShowId:showModel.showId];
    [self.createRequest setToUser:showModel.arrayUser toUserName:showModel.arrayUserName title:showModel.title];
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
        [self.DealWithEventview setpassbackBlock:^(NSInteger index) {
      
            [self missionClickAtIndex:index + 1];
            
            [self.DealWithEventview tapdismess];
        }];
        [self.view addSubview:self.DealWithEventview];
        [self.DealWithEventview appear];
    }
}


#pragma mark - Button Click
- (void)clickToBack {
    if (self.showRelated) {
        self.showRelated ^= 1;
        [self.tableView reloadData];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:NO];
    [self popGestureDisabled:NO];
}

#pragma mark - Interface Method
- (void)taskReload:(void (^)())reloadBlock {
    self.reloadBlock = reloadBlock;
}

#pragma mark - Private Method
- (NSString *)tagDisplay {
    if (![self missionModelShowNeeded].tagArray) {
        return @"";
    }
    
    NSMutableArray *tagNameArray = [NSMutableArray array];
    for (ProjectModel *tagModel in [self missionModelShowNeeded].tagArray) {
        [tagNameArray addObject:tagModel.name];
    }
    
    return [tagNameArray componentsJoinedByString:@", "];
}

- (MissionDetailModel *)missionModelShowNeeded {
    return self.showRelated ? self.relatedModel : self.detailModel;
}

- (MissionDetailModel *)missionModelHide {
    return !self.showRelated ? self.relatedModel : self.detailModel;
}

/** 删除子任务后 */
- (void)deleteReloadTaskId:(NSString *)deleteTaskId {
    NSMutableArray *array = [[self missionModelShowNeeded] subMissionArray];
    NSUInteger indexDeleted = -1;
    for (MissionMainViewModel *subModel in array) {
        if (![subModel.showId isEqualToString:deleteTaskId]) {
            continue;
        }
        
        indexDeleted = [array indexOfObject:subModel] + 1;
        [array removeObject:subModel];
        break;
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];

    if (self.isShowSubTask && indexDeleted != -1) {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexDeleted inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    [self.tableView endUpdates];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.identifier != actionSheetIdentifierSubTask) {
        [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
        return;
    }
    
    // actionSheet tag 被拿来标记是哪个子任务
    MissionMainViewModel *subMissionModel = [[[self missionModelShowNeeded] subMissionArray] objectAtIndex:actionSheet.tag];
    if (buttonIndex == 0) {
        // 编辑子任务
        [self postLoading];
        GetTaskDetailRequest *detailRequest = [[GetTaskDetailRequest alloc] initWithDelegate:self identifier:1];
        [detailRequest getDetailTaskWithId:subMissionModel.showId];
    }
    
    else if (buttonIndex == 1) {
        // 删除子任务
        [self postLoading];
        TaskDeleteRequest *deleteRequest = [[TaskDeleteRequest alloc] initWithDelegate:self];
        deleteRequest.deleteType = kTaskDeleteTypeSubMission;
        [deleteRequest deleteTaskId:subMissionModel.showId];
    }
    
    else if (buttonIndex == 2) {
        // 转化为父任务
        [self postLoading];
        TaskChangeLevelRequest *changeLevelRequest = [[TaskChangeLevelRequest alloc] initWithDelegate:self];
        [changeLevelRequest changeLevelShowId:subMissionModel.showId index:actionSheet.tag];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buttonIndex) {
        return;
    }
    
    [self postLoading];
    TaskDeleteRequest *deleteRequest = [[TaskDeleteRequest alloc] initWithDelegate:self];
    deleteRequest.deleteType = kTaskDeleteTypeMain;
    [deleteRequest deleteTaskId:[self missionModelShowNeeded].showId];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[TaskDeleteRequest class]]) {
        [self postSuccess];
        if ([(id)request deleteType] == kTaskDeleteTypeMain) {
            [self RecordToDiary:[NSString stringWithFormat:@"删除主任务成功:%@",self.detailModel.project.showId]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        else {
            // 删除子任务本地数据
            [self deleteReloadTaskId:[(id)request taskIdDeleted]];
        }
        
        if (self.reloadBlock) {
            self.reloadBlock();
        }
    }
    
    else if ([request isKindOfClass:[GetTaskDetailRequest class]]) {
        GetTaskDetailRequest *detailRequest = (GetTaskDetailRequest *)request;
        __block MissionDetailModel *detailModel = [(id)response detailModel];
        if ([detailRequest identifier] != wz_defaultIdentifier) {
            // 编辑子任务
            [self hideLoading];
            [self RecordToDiary:[NSString stringWithFormat:@"获取任务详情成功:%@",self.detailModel.project.showId]];
            TaskNewTaskViewController *VC = [[TaskNewTaskViewController alloc] initWithMissionDetail:detailModel editCompletion:^{
                if ([self.detailModel.showId isEqualToString:detailModel.showId]) {
                    self.detailModel = detailModel;
                }
                
                if ([self.relatedModel.showId isEqualToString:detailModel.showId]) {
                    self.relatedModel = detailModel;
                }
                
                for (MissionMainViewModel *subMission in [self missionModelShowNeeded].subMissionArray) {
                    if (![subMission.showId isEqualToString:detailModel.showId]) {
                        continue;
                    }
                    
                    subMission.image = detailModel.image;
                    subMission.title = detailModel.title;
                    break;
                }
                
                [self.tableView reloadData];
                if (self.reloadBlock) {
                    self.reloadBlock();
                }
            }];
            
            [self.navigationController pushViewController:VC animated:YES];
        }
        
        else if ([detailRequest detailType] == getTaskDetailRequestTypeRefreshSubTask) {
            // 只想刷新下子任务，不切换关联任务
            [self missionModelShowNeeded].subMissionArray = [(id)response detailModel].subMissionArray;
            if (self.reloadBlock) {
                self.reloadBlock();
            }
            [self postSuccess];
        }
        else {
            // 切换显示任务
            self.showRelated ^= 1;
            self.relatedModel = [(id)response detailModel];
            
            self.rmShowId = self.relatedModel.showId;
            [self reloadComments];
            
            if (self.relatedModel.isAnnex) {
                ApplicationAttachmentGetRequest *getAttachRequest = [[ApplicationAttachmentGetRequest alloc] initWithDelegate:self];
                [getAttachRequest getAppShowId:kAttachmentAppShowIdTask mainShowId:self.relatedModel.showId];
            }
        }
        
        [self.tableView reloadData];
        
    }
    
    else if ([request isKindOfClass:[TaskChangeLevelRequest class]]) {
        [self postSuccess];
        [self RecordToDiary:[NSString stringWithFormat:@"改变任务等级层次成功:%@",self.detailModel.project.showId]];
        // 变成父任务的index
        NSUInteger indexChanged = [(id)request index];
        [[self missionModelShowNeeded].subMissionArray removeObjectAtIndex:indexChanged];
        
        if (self.reloadBlock) {
            self.reloadBlock();
        }
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
        if (self.isShowSubTask) {
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexChanged + 1 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
        }

        [self.tableView endUpdates];
    }
    
    else if ([request isKindOfClass:[ApplicationAttachmentGetRequest class]]) {
        [self RecordToDiary:[NSString stringWithFormat:@"获取任务附件成功:%@",self.detailModel.project.showId]];
        [self hideLoading];
        [self missionModelShowNeeded].attachMentArray = [NSMutableArray arrayWithArray:[(id)response arrayAttachments]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:kMissionDetailCellRealIndexAttach  inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    else {
        [super requestSucceeded:request response:response totalCount:totalCount];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - Cell Block
/** 子任务点击更多 */
- (void)subMissionClickToMoreAtIndex:(NSUInteger)index {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(MISSION_EDITSUBTASK), LOCAL(MISSION_DELETESUBTASK), LOCAL(MISSION_CHANGETOPARENT),nil];
    actionSheet.identifier = actionSheetIdentifierSubTask;
    actionSheet.tag = index;
    [actionSheet showInView:self.view];
}

/** 父任务事件 */
- (void)missionClickAtIndex:(NSUInteger)clickedIndex {
    switch (clickedIndex) {
        case 0: // 转发
            
            break;
        case 1: // 编辑
        {
            TaskNewTaskViewController *VC = [[TaskNewTaskViewController alloc] initWithMissionDetail:[self missionModelShowNeeded] editCompletion:^{
                
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                if (self.reloadBlock) {
                    self.reloadBlock();
                }
                
            }];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2: // 删除
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL(MISSION_COMFIRMDELETE) message:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) otherButtonTitles:LOCAL(CONFIRM), nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
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

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 + [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
//        return kMissionDetailCellRealIndexButtons + 1;
        return kMissionDetailCellRealIndexButtons;
    }
    if (section == 1) {
        if ([[self missionModelShowNeeded] parentTaskId].length) {
            return 1;
        }
        
        if (!self.isShowSubTask) {
            return 1;
        }
        return [[self missionModelShowNeeded] subMissionArray].count + 1;
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1)
    {
        return 15;
    }
    else
    {
        return 55;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        return [super tableView:tableView viewForHeaderInSection:section];
    }
    else
    {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (!indexPath.section) {
        if (row == kMissionDetailCellRealIndexHeader) {
            return [MissionDetailHeadTableViewCell height];
        }
        if (row  == kMissionDetailCellRealIndexAttach) {
            NSUInteger attachCount = [[self missionModelShowNeeded] attachMentArray].count;
            if (!attachCount) {
                return 0;
            }
            
			return [ApplicationAttachmentTableViewCell heightForCellWithImages:[[self missionModelShowNeeded] attachMentArray]];
        }
        if (row == kMissionDetailCellRealIndexComment) {
            return [CalendarMakeSureDetailTableViewCell heightForCell:[self missionModelShowNeeded].comment];
        }
        
        if (row == kMissionDetailCellRealIndexButtons) {
//            return [MissionDetailToolTableViewCell heightFromDetail:[self missionModelShowNeeded]];
            return 0;
        }
        
        if (row == kMissionDetailCellRealIndexTag) {
            return 0.0;
        }
    }
    
    else if (indexPath.section == 2) {
        // 评论高度
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = nil;
    NSInteger row = indexPath.row;
    NSInteger currentIndex = indexPath.section * 10 + row;
    if (!indexPath.section) {
        switch (currentIndex) {
            case  kMissionDetailCellRealIndexHeader:
                cell = [tableView dequeueReusableCellWithIdentifier:[MissionDetailHeadTableViewCell identifier]];
                [cell setDataWithModel:[self missionModelShowNeeded]];
                break;
            case kMissionDetailCellRealIndexProject:
            case kMissionDetailCellRealIndexTag:
            {
                static NSString *identifier = @"value2Identifier";
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
                    [cell textLabel].font = [UIFont mtc_font_30];
                    [cell textLabel].textColor = [UIColor minorFontColor];
                    [cell textLabel].textAlignment = NSTextAlignmentLeft;
                    
                    [cell detailTextLabel].font = [UIFont mtc_font_30];
                    [cell detailTextLabel].textColor = [UIColor blackColor];
                }
                if (currentIndex == kMissionDetailCellRealIndexProject)
                {
                    [cell detailTextLabel].text = [[self missionModelShowNeeded] projectName];
                    [cell textLabel].text = LOCAL(MISSION_DETAIL_ITEM);
                }
                if (currentIndex == kMissionDetailCellRealIndexTag)
                {
                    [cell detailTextLabel].text = @"";//[self tagDisplay];
                    [cell textLabel].text = @"";//LOCAL(MISSION_DETAIL_TAG);
                }
            }
                break;
            case kMissionDetailCellRealIndexAttach:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell titleLabel].text = LOCAL(APPLY_ATTACHMENT_TITLE);
                [cell setImages:[self missionModelShowNeeded].attachMentArray];
                [cell setHidden:![[self missionModelShowNeeded] attachMentArray].count];
                
                [cell clickToSeeImage:^(NSUInteger clickedIndex) {
                    [self clickToSeeImageAtIndex:clickedIndex];
                }];
            }
                break;
            case kMissionDetailCellRealIndexComment:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[CalendarMakeSureDetailTableViewCell identifier]];
                [cell setDetailText:[self missionModelShowNeeded].comment];
            }
                break;
            case kMissionDetailCellRealIndexButtons: {
                cell = [tableView dequeueReusableCellWithIdentifier:[MissionDetailToolTableViewCell identifier]];
                
                [cell clickButtonAtIndex:^(NSUInteger clickedIndex) {
                    [self missionClickAtIndex:clickedIndex];
                }];
                
                [cell setMissionDetail:[self missionModelShowNeeded]];
                break;
            }
        }
    }
    
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            // 父任务状态 能加子任务，能添加，能编辑
            if (![[self missionModelShowNeeded].parentTaskId length]) {
                cell = [tableView dequeueReusableCellWithIdentifier:[MissionDetailTitleTableViewCell identifier]];
                [cell setSubTaskCount:[[self missionModelShowNeeded] subMissionArray].count isFolder:self.isShowSubTask];
                [cell canCreateTaskForDetailModel:[self missionModelShowNeeded]];
                [cell setDelegate:self];
            }
            else {
               // 子任务状态 返回父任务
                static NSString *identifer = @"parentIdentifier";
                cell = [tableView dequeueReusableCellWithIdentifier:identifer];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
                    [cell textLabel].text = LOCAL(MISSION_PARENTTASK);
                    [cell textLabel].font = [UIFont mtc_font_30];
                }
            }
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionDetailSubcellTableViewCell identifier]];
            [cell clickedMore:^(MissionDetailSubcellTableViewCell *clickedCell) {
                NSIndexPath *clickedIndexPath = [tableView indexPathForCell:clickedCell];
                [self subMissionClickToMoreAtIndex:clickedIndexPath.row - 1];
            }];
            [cell setDataWithModel:[[[self missionModelShowNeeded] subMissionArray] objectAtIndex:row - 1]];
        }
    }
    
    else {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSString *showIdNeedShow = @"";
    if (section == 0)
    {
        return;
    }
    if (section == 1) {
        // 关联任务点击
        MissionDetailModel *showModel = [self missionModelShowNeeded];
        MissionDetailModel *hideModel = [self missionModelHide];
        
        if (row == 0) {
            if (![showModel.parentTaskId length]) {
                // 父任务状态，点击无效
                return;
            }
            
            if ([hideModel.showId isEqualToString:showModel.parentTaskId]) {
                // 子任务状态，已经加载过，直接显示
                self.showRelated ^= 1;
                self.rmShowId = hideModel.showId;
                [self reloadComments];
                [tableView reloadData];
                return;
            }
            
            showIdNeedShow = showModel.parentTaskId;
        }
        else {
            // 点击了子任务
            MissionDetailModel *subModel = [showModel.subMissionArray objectAtIndex:row - 1];
            if ([hideModel isEqual:subModel]) {
                // 已经加载过了，直接显示
                self.showRelated ^= 1;
                self.rmShowId = hideModel.showId;
                [self reloadComments];
                [tableView reloadData];
                return;
            }
            
            showIdNeedShow = subModel.showId;
        }
        
        if (![showIdNeedShow length]) {
            return;
        }
        
        // 获取关联任务
        GetTaskDetailRequest *detailRequest = [[GetTaskDetailRequest alloc] initWithDelegate:self];
        [detailRequest getDetailTaskWithId:showIdNeedShow];
        [self postLoading];
    }
    
    else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - MissionDetailTitleTableViewCell Delegate
- (void)MissionDetailTitleTableViewCellDelegateCallBack_showSubTasks {
    self.isShowSubTask = !self.isShowSubTask;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)MissionDetailTitleTableViewCellDelegateCallBack_pushAddNewTaskVC {
    TaskNewTaskViewController *VC = [[TaskNewTaskViewController alloc] initWithTitle:@"" createNewTaskBlock:^(NSString *projectId) {
        // 增加任务后回来刷新
        [self postLoading];
        GetTaskDetailRequest *detailRequest = [[GetTaskDetailRequest alloc] initWithDelegate:self];
        [detailRequest getDetailTaskWithId:[self missionModelShowNeeded].showId];
        detailRequest.detailType = getTaskDetailRequestTypeRefreshSubTask;
        
        if (self.reloadBlock) {
            self.reloadBlock();
        }
    }];
    
    VC.parentProject = [self missionModelShowNeeded].project;
//    if ([VC.parentProject.showId isEqualToString:@""]||VC.parentProject.showId == nil)
//    {
//        VC.parentProject.showId = [self missionModelShowNeeded].showId;
//    }
    VC.parentTaskShowId = [self missionModelShowNeeded].showId;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - initializer

@synthesize createRequest = _createRequest;
- (ApplicationCommentNewRequest *)createRequest {
    if (!_createRequest) {
        _createRequest = [[ApplicationCommentNewRequest alloc] initWithDelegate:self appShowID:self.appShowId commentType:ApplicationMsgType_taskComment];
    }
    return _createRequest;
}

- (NomarlDealWithEventView *)DealWithEventview
{
    if (!_DealWithEventview)
    {
        _DealWithEventview = [[NomarlDealWithEventView alloc] initWithArrayLogos:@[[UIImage imageNamed:@"edit_new"],[UIImage imageNamed:@"delete_new"]] arrayTitles:@[LOCAL(EDIT),LOCAL(MEETING_DELETE)]];
        _DealWithEventview.canappear = YES;
    }
    return _DealWithEventview;
}
@end
