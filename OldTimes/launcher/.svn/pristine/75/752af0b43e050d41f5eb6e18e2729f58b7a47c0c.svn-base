//
//  NewMissionAddMissionViewController.m
//  launcher
//
//  Created by jasonwang on 16/2/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionAddMissionViewController.h"
#import <Masonry/Masonry.h>
#import "TaskOnlyTextFieldTableViewCell.h"
#import "CalendarTextViewTableViewCell.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import "NewMissionTimeSelectView.h"
#import "SelectContactBookViewController.h"
#import "CalendarNewEventRemindViewController.h"
#import "TaskCreateAndEditDefine.h"
#import "MissionDetailModel.h"
#import "NSDate+String.h"
#import "ContactPersonDetailInformationModel.h"
#import "ApplicationAttachmentTableViewCell.h"
#import "MWPhotoBrowser.h"
#import "WZPhotoPickerController.h"
#import "ApplicationAttachmentModel.h"
#import "NewMissionSelectProjectViewController.h"
#import "NewProjectDetailRequest.h"
#import "ProjectModel.h"
#import "NewTaskWithSegmentTableViewCell.h"
#import "MixpanelMananger.h"
#import "AttachmentUploadRequest.h"
#import "NewTaskCreateRequest.h"
#import "NewMissionGetMissionDetailRequest.h"
#import "ApplicationAttachmentGetRequest.h"
#import "NewTaskUpdateRequest.h"
#import "NomarlDealWithEventView.h"
#import <DateTools/DateTools.h>
#import "NewMissionBaseTableViewCell.h"


typedef enum{
    CellType_Title = 00,        // 标题
    CellType_Details = 01,      // 详情
    
    CellType_StartTime = 10,    // 开始时间
    CellType_Deadline = 11,     // 截止时间
    CellType_Member = 12,       // 参与者
    
    CellType_Priority = 20,     // 优先级
    
    CellType_ProjectTitle = 30, // 项目名称
    CellType_Tag = 31,          // 标签
    CellType_Alert = 32,        // 提醒
    CellType_Accessory = 33,    // 附件
}Cell_Type;


static NSInteger const maxImageCount = 9;
static NSInteger const photoActionSheetTag = 11;

@interface NewMissionAddMissionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,NewMissionTimeSelectViewDelegate,MWPhotoBrowserDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,WZPhotoPickerControllerDelegate,BaseRequestDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dictModel;
@property (nonatomic, strong) NewMissionDetailModel *detailModel;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, copy) NSArray *projectMember;             //所选项目成员数组
@property (nonatomic) BOOL isSetStartTime;
@property (nonatomic) BOOL isSetEndTime;
@property (nonatomic) BOOL isWholeDay;
@property (nonatomic) BOOL isSubMission;
@property (nonatomic, strong) NSString *presentMissionTitel;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *rightString;
@property (nonatomic, strong) UIView *viewshadow;
@property (nonatomic, strong) NomarlDealWithEventView * dropListView ;

@end

@implementation NewMissionAddMissionViewController

//编辑任务
- (instancetype)initWithEditMissionWithShowID:(NSString *)showID
{
    self = [super init];
    if (self) {
        self.title = LOCAL(MISSION_EDITTASK_TITLE);
        self.rightString = LOCAL(SAVE);
        [self startGetMissionDetailRequestWithShowID:showID];
    }
    return self;
}

//新建子任务
- (instancetype)initWithCreatSubMission:(NSString *)mainMissionTitel mainMissionShowID:(NSString *)mainMissionShowID mainMissionPrjectShowID:(NSString *)mainMissionPrjectShowID
{
    self = [super init];
    if (self) {
        self.title = LOCAL(MISSION_NEWSUBTASK);
        self.rightString = LOCAL(SEND);
        self.isSubMission = YES;
        self.presentMissionTitel = mainMissionTitel;
        self.parentTaskShowId = mainMissionShowID;
        ProjectModel *model = [[ProjectModel alloc] init];
        model.showId = mainMissionPrjectShowID;
        [self selectProject:model];
        [self setDefinePeople];
    }
    return self;
}
//新建任务
- (instancetype)initWithCreatMainMission
{
    self = [super init];
    if (self) {
        self.title = LOCAL(QUICK_NEW_TASK);
        self.rightString = LOCAL(SEND);
        
        [self setDefinePeople];
      
    }
    return self;
}

- (void)setProjectName:(NSString *)name ShowId:(NSString *)showID
{
    ProjectModel * model = [[ProjectModel alloc] init];
    model.name = name;
    model.showId = showID;
    [self.dictModel setObject:model forKey:@(kTaskCreateAndEditRequestTypeProject)];
    self.detailModel.projectName  = name;
    self.detailModel.projectId = showID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CALENDAR_ADD_CANCLE) style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:self.rightString style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [self configElements];
    if (self.missionDict)
    {
        self.dictModel = self.missionDict;
    }
    // Do any additional setup after loading the view.
}


#pragma mark - private method
- (void)setShowTypeblock:(showTypeblock)block
{
    self.backblock = block;
}

- (void)setTimeType:(Time_Type)type
{
    switch (type) {
        case Time_Type_Today:
        {
            long long time = [[NSDate date] timeIntervalSince1970] ;
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
            
            self.isWholeDay = YES;
            [self.dictModel setObject:date forKey:@(kTaskCreateAndEditRequestTypeStartTime)];
            [self.dictModel setObject:@(self.isWholeDay) forKey:@(kTaskCreateAndEditRequestTypeIsStartTimeAllDay)];
            [self reloadRealIndex:CellType_StartTime];
            self.startDate = date;
            self.isSetStartTime = YES;
        }
            break;
            
        case Time_Type_Tomorrow:
        {
            long long time = [[NSDate date] timeIntervalSince1970] + 24*3600;
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
            
            self.isWholeDay = YES;
            [self.dictModel setObject:date forKey:@(kTaskCreateAndEditRequestTypeStartTime)];
            [self.dictModel setObject:@(self.isWholeDay) forKey:@(kTaskCreateAndEditRequestTypeIsStartTimeAllDay)];
            [self reloadRealIndex:CellType_StartTime];
            self.startDate = date;
            self.isSetStartTime = YES;
        }
            break;
        default:
            break;
    }
}

- (void)setMyModel
{
    ContactPersonDetailInformationModel *model = [ContactPersonDetailInformationModel new] ;
    model.u_true_name = self.detailModel.userTrueName;
    model.show_id = self.detailModel.userName;
    [self selectPeople:@[model]];
}

- (void)setDefinePeople
{
    ContactPersonDetailInformationModel *model = [ContactPersonDetailInformationModel new] ;
    model.u_true_name = [UnifiedUserInfoManager share].userName;
    model.show_id = [UnifiedUserInfoManager share].userShowID;
    [self selectPeople:@[model]];
}

//获取任务详情
- (void)startGetMissionDetailRequestWithShowID:(NSString *)showID
{
    NewMissionGetMissionDetailRequest *request = [[NewMissionGetMissionDetailRequest alloc] initWithDelegate:self];
    [request getDetailTaskWithId:showID];
}


- (void)configElements {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (NSUInteger)realIndexAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section * 10 + indexPath.row;
}

- (NSIndexPath *)indexPathForRealIndex:(Cell_Type)realIndex {
    return [NSIndexPath indexPathForItem:realIndex % 10 inSection:realIndex / 10];
}
- (void)reloadRealIndex:(Cell_Type)realIndex {
    NSIndexPath *indexPathNeedReload = [self indexPathForRealIndex:realIndex];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathNeedReload] withRowAnimation:UITableViewRowAnimationNone];
}

- (id)getComponentFromDictionaryOrModel:(TaskCreateAndEditRequestType)requestStyle {
    id value = [self.dictModel objectForKey:@(requestStyle)];
    if (value) {
        return value;
    }
    
    switch (requestStyle) {
        case kTaskCreateAndEditRequestTypeTitle:
            return self.detailModel.title;
        case kTaskCreateAndEditRequestTypeProject:
            return self.detailModel.projectName;
        case kTaskCreateAndEditRequestTypeDeadline:
            return [NSDate dateWithTimeIntervalSince1970:self.detailModel.endTime / 1000];
        case kTaskCreateAndEditRequestTypeStartTime:
            return [NSDate dateWithTimeIntervalSince1970:self.detailModel.startTime / 1000];
        case kTaskCreateAndEditRequestTypePriority:
            [self.dictModel setObject:@(MissionTaskPriorityLow) forKey:@(kTaskCreateAndEditRequestTypePriority)];
            return @(self.detailModel.priority);
        case kTaskCreateAndEditRequestTypeComment:
            return self.detailModel.content;
        case kTaskCreateAndEditRequestTypeAttach:
            return self.detailModel.attachMentArray;
        case kTaskCreateAndEditRequestTypePeople:
            return self.detailModel.userTrueName;
        default:
            return nil;
    }
}

/** 获取分配组成的string */
- (NSString *)personString {
    NSArray *arrayPeople = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypePeople];
    if (!arrayPeople) {
        return @"";
    }
    ContactPersonDetailInformationModel *person = [arrayPeople firstObject];
    return person.u_true_name;
}

/** 选择Project */
- (void)selectProject:(ProjectModel *)project {
    [self.dictModel setObject:project forKey:@(kTaskCreateAndEditRequestTypeProject)];
    [self reloadRealIndex:CellType_ProjectTitle];
}

/** 选择人员 */
- (void)selectPeople:(NSArray *)people {
    [self.dictModel setObject:people forKey:@(kTaskCreateAndEditRequestTypePeople)];
    [self reloadRealIndex:CellType_Member];
}

/** 优先度Cell点击 */
- (void)selectImportanceAtIndex:(NSUInteger)selectedIndex {
    [self.dictModel setObject:@(selectedIndex) forKey:@(kTaskCreateAndEditRequestTypePriority)];
}

/** 选择提醒 */
- (void)selectRemind:(NSInteger)remindType {
    [self.dictModel setObject:@(remindType) forKey:@(kTaskCreateAndEditRequestTypeRemind)];
    [self reloadRealIndex:CellType_Alert];
}

/** 点击查看照片 */
- (void)selectShowImageAtIndex:(NSUInteger)selectedIndex {
    self.photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.photoBrowser.displayTrashButton = YES;
    self.photoBrowser.alwaysShowControls = YES;
    self.photoBrowser.zoomPhotosToFill = YES;
    self.photoBrowser.enableGrid = NO;
    self.photoBrowser.gridButton.hidden = YES;
    self.photoBrowser.enableSwipeToDismiss = NO;
    self.photoBrowser.showNavigationBar = YES;
    
    [self.photoBrowser showNextPhotoAnimated:YES];
    [self.photoBrowser showPreviousPhotoAnimated:YES];
    [self.navigationController pushViewController:self.photoBrowser animated:NO];
    [self.photoBrowser setCurrentPhotoIndex:selectedIndex];
}

- (void)imagePickerImage:(UIImage *)image {
    ApplicationAttachmentModel *attachModel = [[ApplicationAttachmentModel alloc] initWithLocalImage:image];
    [self addAttachment:attachModel];
    [self reloadRealIndex:CellType_Accessory];
}

- (void)addAttachment:(ApplicationAttachmentModel *)attachment {
    NSMutableArray *arrayAttach = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeAttach)];
    if (!arrayAttach) {
        arrayAttach = [NSMutableArray array];
        
        if (self.detailModel) {
            [arrayAttach addObjectsFromArray:self.detailModel.attachMentArray];
        }
        
        [self.dictModel setObject:arrayAttach forKey:@(kTaskCreateAndEditRequestTypeAttach)];
    }
    
    [arrayAttach addObject:attachment];
}
- (void)imagePickerImages:(NSArray *)assets {
    [self postLoading];
    for (ALAsset *asset in assets) {
        
        UIImage *image = [ApplicationAttachmentModel originalImageFromAsset:asset];
        ApplicationAttachmentModel *attachModel = [[ApplicationAttachmentModel alloc] initWithLocalImage:image];
        
        [self addAttachment:attachModel];
    }
    [self hideLoading];
    [self reloadRealIndex:CellType_Accessory];
}

- (void)requestProjectDetailWithShowID:(NSString *)showID
{
    NewProjectDetailRequest *request = [[NewProjectDetailRequest alloc] initWithDelegate:self];
    [request detailShowId:showID];
    [self postLoading];
}

- (void)chackShowType
{
    ContactPersonDetailInformationModel *model = [ContactPersonDetailInformationModel new] ;
    NSArray *arr = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypePeople)];
    model = arr.firstObject;
    if (self.myVCkind == VCkind_nil)
    {
        if (((ProjectModel *)[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeProject)]) == nil)
        {
            if ([model.show_id isEqualToString:[UnifiedUserInfoManager share].userShowID])
            {
                if ([[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)] isKindOfClass:[NSDate class]]) {
                    NSDate *date = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)];
                    if ([self checkDateIsToday:date]) {
                        self.myVCkind = VCkind_Today;
                    }
                    else if ([self checkDateIsTommory:date])
                    {
                        self.myVCkind = VCkind_Tomorrow;
                    }
                    else
                    {
                        self.myVCkind = VCkind_All;
                    }
                }
                else
                {
                    self.myVCkind = VCkind_Notime;
                }
            }
            else
            {
                self.myVCkind = VCkind_Send;
            }
        }
    }
    else
    {
        if ([model.show_id isEqualToString:[UnifiedUserInfoManager share].userShowID])
        {
            if ([[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)] isKindOfClass:[NSDate class]]) {
                NSDate *date = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)];
                if ([self checkDateIsToday:date]) {
                    self.myVCkind = VCkind_Today;
                }
                else if ([self checkDateIsTommory:date])
                {
                    self.myVCkind = VCkind_Tomorrow;
                }
                else
                {
                    self.myVCkind = VCkind_All;
                }
            }
            else
            {
                self.myVCkind = VCkind_Notime;
            }
        }
        else
        {
            self.myVCkind = VCkind_Send;
        }
    }
    
//    VCkind kind = 100;
//    if ([model.show_id isEqualToString:[UnifiedUserInfoManager share].userShowID]) {
//        if ([[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)] isKindOfClass:[NSDate class]]) {
//            NSDate *date = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)];
//            if ([self checkDateIsToday:date]) {
//                kind = VCkind_Today;
//            } else if ([self checkDateIsTommory:date])
//            {
//                kind = VCkind_Tomorrow;
//            }
//        } else {
//            kind = VCkind_Notime;
//        }
//    } else {
//        kind = VCkind_Send;
//    }
    if (self.backblock) {
        self.backblock(self.myVCkind,((ProjectModel *)[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeProject)]));
//        [self.dictModel setObject:project forKey:@(kTaskCreateAndEditRequestTypeProject)];
    }
}

- (BOOL)checkInformation {
    id tmpObject = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeTitle];
    if (!tmpObject || ![tmpObject length]) {
        [self postError:LOCAL(MEETING_INPUT_TITLE)];
        return NO;
    }
    
//    tmpObject = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeProject];
//    if (!tmpObject) {
//        [self postError:LOCAL(MISSION_SELECTPROJECT)];
//        return NO;
//    }
    
    tmpObject = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypePeople];
    if (!tmpObject) {
        [self postError:LOCAL(NEWMISSION_PLEASE_SELECT_PEOPLE)];
        return NO;
    }

    return YES;
}
//检查是否为同年
- (BOOL)checkDateSameYear:(NSDate *)date
{
    if (date.year == [NSDate date].year) {
        return YES;
    } else {
        return NO;
    }
}
//检查是否为同月
- (BOOL)checkDateSameMonth:(NSDate *)date
{
    if (date.month == [NSDate date].month) {
        return YES;
    } else {
        return NO;
    }
}
//检查是否为今天
- (BOOL)checkDateIsToday:(NSDate *)date
{
    if ([self checkDateSameYear:date]) {
        if ([self checkDateSameMonth:date]) {
            if (date.day == [NSDate date].day) {
                return YES;
            }
        }
    }
    return NO;
}
//检查是否为明天
- (BOOL)checkDateIsTommory:(NSDate *)date
{
    if ([self checkDateSameYear:date]) {
        if ([self checkDateSameMonth:date]) {
            if (date.day == [NSDate date].day + 1) {
                return YES;
            }
        }
    }
    return NO;
}
#pragma mark - event Response
//取消
- (void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//保存
- (void)rightClick
{
    [self.view endEditing:YES];
    
    if (self.isLoading) {
        return;
    }
    
    if (![self checkInformation]) {
        return;
    }
    
    [MixpanelMananger track:@"task/save"];
    BOOL attachUpload = NO;
    NSArray *arrayAttach = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeAttach];
    for (NSInteger i = 0; i < arrayAttach.count; i ++) {
        
        ApplicationAttachmentModel *attachmentModel = [arrayAttach objectAtIndex:i];
        if (attachmentModel.showId) {
            continue;
        }
        
        [self postProgress:0];
        AttachmentUploadRequest *uploadRequest = [[AttachmentUploadRequest alloc] initWithDelegate:self identifier:i];
        [uploadRequest uploadImageData:UIImageJPEGRepresentation(attachmentModel.originalImage, 1.0) appShowIdType:kAttachmentAppShowIdNewTask];
        attachUpload = YES;
    }
    
    if (attachUpload) {
        return;
    }
    
    [self postLoading];
    if (self.detailModel) {
        // 编辑
        NewTaskUpdateRequest *editRequest = [[NewTaskUpdateRequest alloc] initWithDelegate:self];
        [editRequest editTaskModel:self.detailModel editDitionary:self.dictModel];
    }
    else {
        // 新建
        NewTaskCreateRequest *createRequest = [[NewTaskCreateRequest alloc] initWithDelegate:self];
        [createRequest createTask:self.dictModel parentId:self.parentTaskShowId];
        
    }

}
#pragma mark - Delegate
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == photoActionSheetTag) {
        // 附件上传照片
        if (buttonIndex == 0) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self postError:LOCAL(ERROR_NOCAMERA)];
                return;
            }
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
        else if (buttonIndex == 1) {
            NSInteger selectedAttachCount = [[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeAttach)] count];
            
            WZPhotoPickerController *imagePicker = [[WZPhotoPickerController alloc] init];
            [imagePicker setDelegate:self];
            
            NSInteger count = maxImageCount - selectedAttachCount;
            [imagePicker setMaximumNumberOfSelection:count];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
        return;
    }
    
    // 附件删除
    if (buttonIndex == 1) {
        return;
    }
    
    NSMutableArray *arrayTmp = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeAttach)];
    if (!arrayTmp) {
        arrayTmp = [NSMutableArray arrayWithArray:self.detailModel.attachMentArray];
        [self.dictModel setObject:arrayTmp forKeyedSubscript:@(kTaskCreateAndEditRequestTypeAttach)];
    }
    
    
    [arrayTmp removeObjectAtIndex:[self.photoBrowser currentIndex]];
    [self.photoBrowser reloadData];
    [self reloadRealIndex:CellType_Accessory];
    
    if (![arrayTmp count]) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self imagePickerImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WZPhotoPickerController Delegate
- (void)wz_imagePickerController:(WZPhotoPickerController *)photoPickerController didSelectAssets:(NSArray *)assets {
    [self imagePickerImages:assets];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeAttach] count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeAttach] count]) {
        ApplicationAttachmentModel *attachmentModel = [[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeAttach] objectAtIndex:index];
        if (attachmentModel.localPath) {
            return [MWPhoto photoWithImage:attachmentModel.originalImage];
        }
        else if (attachmentModel)
            return [MWPhoto photoWithURL:[NSURL URLWithString:attachmentModel.path]];
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LOCAL(APPLY_DELETE_PICTURE) delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:LOCAL(DELETE) otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma mark - ApplyAddDeadLineActionSheetView Delegate
- (void)NewMissionTimeSelectView:(NewMissionTimeSelectView *)timeView didSelectDate:(NSDate *)date {
    TaskCreateAndEditRequestType timeType;
    TaskCreateAndEditRequestType wholeDayType;
    Cell_Type reloadCellType;
	
    if (timeView.task_identifier == CellType_StartTime) {
        
        self.isSetStartTime = (date != nil);
        timeType = kTaskCreateAndEditRequestTypeStartTime;
        wholeDayType = kTaskCreateAndEditRequestTypeIsStartTimeAllDay;
        reloadCellType = CellType_StartTime;
        self.startDate = date ?: [NSDate dateWithTimeIntervalSince1970:0];
        self.dictModel[@(timeType)] = self.startDate;
    } else {
        
        self.isSetEndTime = (date != nil);
        timeType = kTaskCreateAndEditRequestTypeDeadline;
        wholeDayType = kTaskCreateAndEditRequestTypeIsEndTimeAllDay;
        reloadCellType = CellType_Deadline;
        if (self.isWholeDay) {
            date = [NSDate dateWithYear:date.year month:date.month day:date.day hour:23 minute:59 second:59];
        }
        
        self.endDate = date ?: [NSDate dateWithTimeIntervalSince1970:0];
        self.dictModel[@(timeType)] = self.endDate;
    }
    
    [self.dictModel setObject:@(self.isWholeDay) forKey:@(wholeDayType)];
    [self reloadRealIndex:reloadCellType];
}

- (void)NewMissionTimeSelectViewDelegateCallBack_isWholeDay:(BOOL) isWholdDay{
    self.isWholeDay = isWholdDay;
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (section) {
        case 0:
            num = 2;
            break;
        case 1:
            num = 3;
            break;
        case 2:
            num = 1;
            break;
        case 3:
            num = 4;
            break;
        default:
            break;
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger realIndex = [self realIndexAtIndexPath:indexPath];
    if (realIndex == CellType_Details) {
        return 72;
    } else if (realIndex == CellType_Accessory)
    {
        return [ApplicationAttachmentTableViewCell heightForCellWithImageCount:[[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeAttach] count] accessoryMode:YES];
    } else if (realIndex == CellType_Tag) {
        return 0;
    } else {
        return 45;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = nil;
    NSUInteger realIndex = [self realIndexAtIndexPath:indexPath];
    switch (realIndex) {
        case CellType_Title: //标题
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[TaskOnlyTextFieldTableViewCell identifier]];
            [cell texfFieldTitle].delegate = self;
            
            [cell texfFieldTitle].text = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeTitle];
        }
            break;
        case CellType_Details:  //详情
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarTextViewTableViewCell identifier]];
            [cell setDelegate:self];
            [cell setContent:[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeComment]];

        }
            break;
        case CellType_StartTime:
        case CellType_Deadline:
        case CellType_Member:
        case CellType_ProjectTitle:
        case CellType_Tag:
        case CellType_Alert:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[NewMissionBaseTableViewCell identifier]];
            [cell myDetailTextLb].textColor = [UIColor minorFontColor];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            NSString *title = @"";
            NSString *detailTitle = @"";

            switch (realIndex) {
                case CellType_StartTime://开始
                {
                    title       = LOCAL(APPLY_BEGIN_TIME);
                    detailTitle = LOCAL(NONE);
                    
                    if (self.startDate.year == 1970) {
                        // do nothing
						detailTitle = LOCAL(NONE);
                    }
                    else if (self.isSetStartTime) {
                        detailTitle = [[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeStartTime] mtc_getStringWithDateWholeDay:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeIsStartTimeAllDay)] boolValue]];
                    }
                    
                    else if (self.detailModel && self.detailModel.startTime) {
                        detailTitle = [[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeStartTime] mtc_getStringWithDateWholeDay:self.detailModel.isStartTimeAllDay];
                    }
                    if (self.missionDict)
                    {
                         id strartDate = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeStartTime)];
                        if (strartDate)
                        {
                         detailTitle = [strartDate mtc_getStringWithDateWholeDay:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeIsStartTimeAllDay)] boolValue]];
                        }
                    }
                    
                }
                    break;
                case CellType_Deadline: //截止
                {
                    title = LOCAL(NEWMISSION_SELECT_END_TIME);
                    detailTitle = LOCAL(NONE);
                    
                    if (self.endDate.year == 1970) {
                        // do nothing
						detailTitle = LOCAL(NONE);
                    }
                    else if (self.isSetEndTime) {
                        detailTitle = [[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeDeadline] mtc_getStringWithDateWholeDay:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeIsEndTimeAllDay)] boolValue]];
                    }
                    
                    else if (self.detailModel && self.detailModel.endTime) {
                        detailTitle = [[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeDeadline] mtc_getStringWithDateWholeDay:self.detailModel.isEndTimeAllDay];
                    }
                    if (self.missionDict)
                    {
                        id endateStr = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeDeadline)];
                        if (endateStr)
                        {
                            detailTitle = [endateStr mtc_getStringWithDateWholeDay:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeIsEndTimeAllDay)] boolValue]];
                        }
                    }
                }
                    break;
                case CellType_Member: //参与者
                {
                    title = LOCAL(MISSION_PARTICIPANT);
                    detailTitle = [self personString];
                }
                    break;
                    
                case CellType_ProjectTitle://项目,主任务
                {
                    if (self.isSubMission) {
                        title = LOCAL(NEWMISSION_MAIN_MISSION);
                        detailTitle = self.presentMissionTitel;
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    } else {
                        title = LOCAL(MISSION_PROJECT);
                        if ([self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeProject)]) {
                            detailTitle = [[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeProject] name];
                        } else {
                            detailTitle = [self.detailModel.projectName isEqualToString:@""]?self.detailModel.projectName:LOCAL(NONE);
                        }
                    }
                }
                    break;
                case CellType_Tag:  //标签
                {
                    //title = @"标签";
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                }
                    break;
                case CellType_Alert://提醒
                {
                    title = LOCAL(MEETING_NOTIFICATE);
                    if ([self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeRemind)]) {
                        detailTitle = [CalendarLaunchrModel remindTypeStringAtIndex:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeRemind)] integerValue]];
                    } else {
                        detailTitle = [CalendarLaunchrModel remindTypeStringAtIndex:self.detailModel.remindType];
                    }
                    break;
                }
                    break;

                default:
                    break;
            }
            [cell myTextLb].text = title;
            [cell myDetailTextLb].text = detailTitle;

        }
            break;
            
        case CellType_Accessory: //附件
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell titleLabel].text = LOCAL(APPLY_ATTACHMENT_TITLE);
			
			__weak typeof(self) weakSelf = self;
            [cell clickToSeeImage:^(NSUInteger clickedIndex) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf selectShowImageAtIndex:clickedIndex];
            }];
            
            [cell setImages:[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeAttach]];

        }
            break;
            
        case CellType_Priority: //优先度
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[NewTaskWithSegmentTableViewCell identifier]];
            
            [cell lblTitle].text = LOCAL(MISSION_WHOFIRST);
            MissionTaskPriority priority;
            if (self.detailModel) {
                //编辑读取优先度
                priority = self.detailModel.priority;
            } else {
                //新建 默认为无
                priority = MissionTaskPriorityWithout;
            }
            [self selectImportanceAtIndex:priority];
            [cell setCurrentSelectPriority:priority];
			
			
			__weak typeof(self) weakSelf = self;
            [cell segmentDidSelect:^(NSUInteger selectedIndex) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf selectImportanceAtIndex:selectedIndex];
            }];

        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    NSUInteger realIndex = [self realIndexAtIndexPath:indexPath];
    id VC;
    switch (realIndex) {
        case CellType_StartTime:
        {
            NewMissionTimeSelectView *sheetView = [[NewMissionTimeSelectView alloc] init];
            sheetView.task_identifier = CellType_StartTime;
            [sheetView setShowWholeDayMode:YES];
            sheetView.delegate = self;
            [sheetView setTitle:LOCAL(NEWMISSION_SELECT_START_TIME) noSelect:LOCAL(NEWMISSION_ONEDAY)];
            [sheetView wholeDayIsOn:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeIsStartTimeAllDay)] boolValue]];
            if (self.startDate) {
                [sheetView setDate:self.startDate];
            }
            if (self.endDate) {
                [sheetView setMyMaxDate:self.endDate MinDate:[NSDate date]];
            }
            [self.view addSubview:sheetView];
        }
            break;
        case CellType_Deadline:
        {
            NewMissionTimeSelectView *sheetView = [[NewMissionTimeSelectView alloc] init];
            sheetView.task_identifier = CellType_Deadline;
            [sheetView setShowWholeDayMode:YES];
            sheetView.delegate = self;
            [sheetView setTitle:LOCAL(NEWMISSION_SELECT_END_TIME) noSelect:LOCAL(NONE)];
            [sheetView wholeDayIsOn:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeIsEndTimeAllDay)] boolValue]];
            if (self.startDate) {
                [sheetView setMyMaxDate:nil MinDate:self.startDate];
            }
            if (self.endDate && self.endDate.year != 1970) {
                [sheetView setDate:self.endDate];
            }
            [self.view addSubview:sheetView];
        }
            break;
        case CellType_Member:
        {
            VC = [[SelectContactBookViewController alloc] initWithSelectedPeople:[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypePeople] unableSelectPeople:nil];
            [VC setSingleSelectable:YES];
            [VC setSelfSelectable:YES];
            [VC setIsMission:NO];
            
            __weak typeof(self) weakSelf = self;
            [VC selectedPeople:^(NSArray *selectedPeople) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf selectPeople:selectedPeople];
            }];
            
            [self presentViewController:VC animated:YES completion:nil];
            return;
            
        }
            break;
        case CellType_ProjectTitle:
        {
            if (!self.isSubMission) {
				__weak typeof(self) weakSelf = self;
                VC = [[NewMissionSelectProjectViewController alloc] initWithSelectProject:^(ProjectModel *project) {
					__strong typeof(weakSelf) strongSelf = weakSelf;
                    if (project) {
                        [strongSelf requestProjectDetailWithShowID:project.showId];
                        [strongSelf selectProject:project];
                    } else {
                        [strongSelf.dictModel removeObjectForKey:@(kTaskCreateAndEditRequestTypeProject)];
                        strongSelf.detailModel.projectId = @"";
                        strongSelf.detailModel.projectName = @"";
                        [strongSelf reloadRealIndex:CellType_ProjectTitle];
                    }
                }];
                NSString *showID;
                if ([self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeProject)]) {
                    ProjectModel *model = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeProject)];
                    showID = model.showId;
                } else {
                    if (self.detailModel) {
                        showID = self.detailModel.projectId;
                    } else {
                        showID = @"";
                    }
                }
                [VC setSelectedProjectShowID:showID];
            }
        }
            break;
        case CellType_Tag:
        {
            
        }
            break;
        case CellType_Alert:
        {
			__weak typeof(self) weakSelf = self;
            VC = [[CalendarNewEventRemindViewController alloc] initWithWholeDayMode:NO RemindType:^(NSInteger remindType) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf selectRemind:remindType];
            }];
            NSString *detailTitle;
            if ([self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeRemind)]) {
                detailTitle = [CalendarLaunchrModel remindTypeStringAtIndex:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeRemind)] integerValue]];
            } else {
                detailTitle = [CalendarLaunchrModel remindTypeStringAtIndex:self.detailModel.remindType];
            }
            [VC setMySelectType:detailTitle];

        }
            break;
        case CellType_Accessory:
        {
            NSInteger selectedAttachCount = [[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeAttach)] count];
            if (selectedAttachCount == maxImageCount) {
                return;
            }
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(CAMERA), LOCAL(GALLERY), nil];
            actionSheet.tag = photoActionSheetTag;
            [actionSheet showInView:self.view];
            
        }
            break;
        default:
            break;
    }
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.dictModel setObject:textView.text forKey:@(kTaskCreateAndEditRequestTypeComment)];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.dictModel setObject:textField.text forKey:@(kTaskCreateAndEditRequestTypeTitle)];
}
#pragma mark - request Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    [self hideLoading];
    if ([request isKindOfClass:[NewProjectDetailRequest class]]) {
        NewProjectDetailResponse *result = (NewProjectDetailResponse *)response;
        self.projectMember = result.model.members;
    } else if ([request isKindOfClass:[NewTaskCreateRequest class]]) {
        [self chackShowType];
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([request isKindOfClass:[AttachmentUploadRequest class]]) {
        NSArray *arrayAttach = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeAttach)];
        ApplicationAttachmentModel *attachModel = [arrayAttach objectAtIndex:[(AttachmentUploadResponse *)response identifier]];
        attachModel.showId = [(id)response attachmentShowId];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"showId != nil && showId.length > 0"];
        NSArray *arrayUploaded = [arrayAttach filteredArrayUsingPredicate:predicate];
        
        BOOL isSuccess = [arrayUploaded count] == [arrayAttach count];
        [self postProgress:(1.0 * [arrayUploaded count] / [arrayAttach count])];
        
        if (isSuccess) {
            if (self.detailModel) {
//                // 编辑
//                TaskEditRequest *editRequest = [[TaskEditRequest alloc] initWithDelegate:self];
//                [editRequest editTaskModel:self.detailModel editDitionary:self.dictModel];
            }
            else {
                // 新建
                NewTaskCreateRequest *createRequest = [[NewTaskCreateRequest alloc] initWithDelegate:self];
                [createRequest createTask:self.dictModel parentId:self.parentTaskShowId];
            }
        }
    }else if ([request isKindOfClass:[NewMissionGetMissionDetailRequest class]]) {
        NewMissionGetMissionDetailResponse *result = (NewMissionGetMissionDetailResponse *)response;
        self.detailModel = result.detailModel;
        self.startDate = [NSDate dateWithTimeIntervalSince1970:result.detailModel.startTime / 1000];
        self.endDate = [NSDate dateWithTimeIntervalSince1970:result.detailModel.endTime / 1000];
        [self.tableView reloadData];
        [self setMyModel];
        if (self.detailModel.isAnnex) {
            // 有附件但不存在附件 需要请求下载
            ApplicationAttachmentGetRequest *attachRequest = [[ApplicationAttachmentGetRequest alloc] initWithDelegate:self];
            [attachRequest getAppShowId:kAttachmentAppShowIdNewTask mainShowId:self.detailModel.showId];
            [self postLoading];
        }
        
    } else if ([request isKindOfClass:[ApplicationAttachmentGetRequest class]]) {
        self.detailModel.attachMentArray = [NSMutableArray arrayWithArray:[(id)response arrayAttachments]];
        [self.tableView reloadRowsAtIndexPaths:@[[self indexPathForRealIndex:CellType_Accessory]] withRowAnimation:UITableViewRowAnimationFade];
        [self hideLoading];
    } else if ([request isKindOfClass:[NewTaskUpdateRequest class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self hideLoading];
    [self postError:errorMessage];
}

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        [_tableView registerClass:[TaskOnlyTextFieldTableViewCell class]        forCellReuseIdentifier:[TaskOnlyTextFieldTableViewCell identifier]];
        [_tableView registerClass:[CalendarTextViewTableViewCell class]        forCellReuseIdentifier:[CalendarTextViewTableViewCell identifier]];
        [_tableView registerClass:[ApplicationAttachmentTableViewCell class]        forCellReuseIdentifier:[ApplicationAttachmentTableViewCell identifier]];
        [_tableView registerClass:[NewTaskWithSegmentTableViewCell class]        forCellReuseIdentifier:[NewTaskWithSegmentTableViewCell identifier]];
        [_tableView registerClass:[NewMissionBaseTableViewCell class]        forCellReuseIdentifier:[NewMissionBaseTableViewCell identifier]];
    }
    return _tableView;
}

- (NSMutableDictionary *)dictModel
{
    if (!_dictModel) {
        _dictModel = [[NSMutableDictionary alloc] init];
    }
    return _dictModel;
}

//- (MissionDetailModel *)detailModel
//{
//    if (!_detailModel) {
//        _detailModel = [[MissionDetailModel alloc] init];
//    }
//    return _detailModel;
//}
- (UIView *)viewshadow
{
    if (!_viewshadow)
    {
        _viewshadow = [[UIView alloc] init];
    }
    return _viewshadow;
}
@end
