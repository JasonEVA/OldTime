//
//  TaskNewTaskViewController.m
//  launcher
//
//  Created by Conan Ma on 15/8/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskNewTaskViewController.h"
#import "TaskOnlyTextFieldTableViewCell.h"
#import "TaskTwoLabelsWithArrowTableViewCell.h"
#import "TaskWithSegmentTableViewCell.h"
#import "CalendarTextViewTableViewCell.h"
#import "TaskWhiteBoardViewController.h"
#import "MissionSelectProjectViewController.h"
#import "MissionSelectTagViewController.h"
#import "CalendarNewEventRemindViewController.h"
#import "CalendarNewEventRepeatViewController.h"
#import "ApplyAddDeadlineActionSheetView.h"
#import "ContactPersonDetailInformationModel.h"
#import "MWPhotoBrowser.h"
#import "ApplicationAttachmentTableViewCell.h"
#import "MissionDetailModel.h"
#import "ProjectModel.h"
#import "UIColor+Hex.h"
#import "NSDate+String.h"
#import "Masonry.h"
#import "MyDefine.h"
#import "TaskCreateRequest.h"
#import "AttachmentUploadRequest.h"
#import "TaskEditRequest.h"
#import "ApplicationAttachmentGetRequest.h"
#import "SelectContactBookViewController.h"
#import "WZPhotoPickerController.h"
#import "ApplicationAttachmentModel.h"
#import "MixpanelMananger.h"
#import "ProjectDetailRequest.h"
#import "UnifiedSqlManager.h"

typedef NS_ENUM(NSUInteger, NewTaskCellStyle) {
    kNewTaskCellStyleTitle = 00,
    kNewTaskCellStyleProject,
    kNewTaskCellStylePerson,
    
    kNewTaskCellStyleTime = 10,
    kNewTaskCellStyleImportance,
    
    kNewTaskCellStyleTag = 20,
    kNewTaskCellStyleRepeat = 30,
    kNewTaskCellStyleRemind = 40,
    
    kNewTaskCellStyleAttach = 50,
    kNewTaskCellStyleComment
};

static NSInteger const maxImageCount = 9;
static NSInteger const photoActionSheetTag = 11;

@interface TaskNewTaskViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate, UITextFieldDelegate, ApplyAddDeadlineActionSheetViewDelegate, MWPhotoBrowserDelegate, WZPhotoPickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, BaseRequestDelegate>

@property (nonatomic, strong  ) UITableView *tableview;

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@property (nonatomic, strong) MissionDetailModel *detailModel;

@property (nonatomic, copy) void (^createTaskBlock)(NSString *projectId);
@property (nonatomic, copy) void (^editCompletionBlock)();
@property (nonatomic, copy) void (^chatCreateTaskBlock)(NSMutableDictionary *dictModel);

@property (nonatomic, strong) NSMutableDictionary *dictModel;
@property (nonatomic, strong) NSIndexPath *projectIndexPath;    //项目的IndexPath
@property (nonatomic, copy) NSArray *projectMember;             //所选项目成员数组

@end

@implementation TaskNewTaskViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dictModel = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithDictModel:(NSMutableDictionary *)dictModel CreateNewTaskBlock:(void (^)(NSMutableDictionary *))taskBlock
{
    self = [self init];
    if (self) {
        self.chatCreateTaskBlock = taskBlock;
        self.dictModel = dictModel;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title createNewTaskBlock:(void (^)(NSString *projectId))taskBlock {
    self = [self init];
    if (self) {
        self.createTaskBlock = taskBlock;
        if (title && [title length]) {
            [self.dictModel setObject:title forKey:@(kNewTaskCellStyleTitle)];
        }
    }
    return self;
}

- (instancetype)initWithMissionDetail:(MissionDetailModel *)detailModel editCompletion:(void (^)())completion {
    self = [self init];
    if (self) {
        self.detailModel = detailModel;
        self.editCompletionBlock = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = !self.detailModel ? LOCAL(MISSION_NEWTASK_TITLE) : LOCAL(MISSION_EDITTASK_TITLE);
    
    UIBarButtonItem *btnLeft = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(clickToBack)];
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithTitle:LOCAL(SAVE) style:UIBarButtonItemStylePlain target:self action:@selector(clickToSave)];
    
    [self.navigationItem setLeftBarButtonItem:btnLeft];
    [self.navigationItem setRightBarButtonItem:btnRight];
    
    [self createFrames];
    //新建子任务时，请求项目人员
    if (self.parentProject) {
        [self requestProjectDetailWithShowID:self.parentProject.showId];
        
    } else if (self.detailModel) {
        [self requestProjectDetailWithShowID:self.detailModel.project.showId];
    }
    if (self.detailModel && self.detailModel.isAnnex && ![self.detailModel.subMissionArray count]) {
        // 有附件但不存在附件 需要请求下载
        ApplicationAttachmentGetRequest *attachRequest = [[ApplicationAttachmentGetRequest alloc] initWithDelegate:self];
        [attachRequest getAppShowId:kAttachmentAppShowIdNewTask mainShowId:self.detailModel.showId];
        [self postLoading];
    }
}

- (void)createFrames {
    [self.view addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Button Click
- (void)clickToBack {
    [self.navigationController popViewControllerAnimated:YES];
    [MixpanelMananger track:@"task/cancel"];
}

- (void)clickToSave {
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
        TaskEditRequest *editRequest = [[TaskEditRequest alloc] initWithDelegate:self];
        [editRequest editTaskModel:self.detailModel editDitionary:self.dictModel];
    }
    else {
        // 新建
        TaskCreateRequest *createRequest = [[TaskCreateRequest alloc] initWithDelegate:self];
        [createRequest createTask:self.dictModel parentId:self.parentTaskShowId];
    }
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    [self hideLoading];
    if ([request isKindOfClass:[TaskCreateRequest class]]) {
        
        if (self.createTaskBlock) {
            self.createTaskBlock([(id)response projectId]);
        }
        
        if (self.chatCreateTaskBlock) {
            [self.dictModel setObject:[(id)response showId] forKey:@(kTaskCreateAndEditRequestTypeId)];
            self.chatCreateTaskBlock(self.dictModel);
        }
        [self postSuccess];
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@NO afterDelay:1.0];
    }
    
    else if ([request isKindOfClass:[AttachmentUploadRequest class]]) {
        NSArray *arrayAttach = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeAttach)];
        ApplicationAttachmentModel *attachModel = [arrayAttach objectAtIndex:[(AttachmentUploadResponse *)response identifier]];
        attachModel.showId = [(id)response attachmentShowId];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"showId != nil && showId.length > 0"];
        NSArray *arrayUploaded = [arrayAttach filteredArrayUsingPredicate:predicate];
        
        BOOL isSuccess = [arrayUploaded count] == [arrayAttach count];
        [self postProgress:(1.0 * [arrayUploaded count] / [arrayAttach count])];
        
        if (isSuccess) {
            if (self.detailModel) {
                // 编辑
                TaskEditRequest *editRequest = [[TaskEditRequest alloc] initWithDelegate:self];
                [editRequest editTaskModel:self.detailModel editDitionary:self.dictModel];
            }
            else {
                // 新建
                TaskCreateRequest *createRequest = [[TaskCreateRequest alloc] initWithDelegate:self];
                [createRequest createTask:self.dictModel parentId:self.parentTaskShowId];
            }
        }
    }
    
    else if ([request isKindOfClass:[TaskEditRequest class]]) {
        [self postSuccess];
        NSArray *arrayKey = [self.dictModel allKeys];
        for (NSNumber *key in arrayKey) {
            TaskCreateAndEditRequestType keyType = [key integerValue];
            switch (keyType) {
                case kTaskCreateAndEditRequestTypeTitle:
                    self.detailModel.title = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeTitle];
                    break;
                case kTaskCreateAndEditRequestTypeDeadline:
                    self.detailModel.deadlineDate = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeDeadline];
                    break;
                case kTaskCreateAndEditRequestTypePriority:
                    self.detailModel.priority = [[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypePriority] integerValue];
                    break;
                case kTaskCreateAndEditRequestTypeComment:
                    self.detailModel.comment = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeComment];
                    break;
                case kTaskCreateAndEditRequestTypeAttach:
                    self.detailModel.attachMentArray = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeAttach];
                    break;
                case kTaskCreateAndEditRequestTypeProject:
                    self.detailModel.project = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeProject];
                    break;
                case kTaskCreateAndEditRequestTypePeople: {
                    self.detailModel.personArray = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypePeople];
                    ContactPersonDetailInformationModel *model = [self.detailModel.personArray firstObject];
                    self.detailModel.arrayUser = @[model.show_id];
                    self.detailModel.arrayUserName = @[model.u_true_name];
                }
                    break;
                default:
                    break;
            }
        }
        
        if (self.editCompletionBlock) {
            self.editCompletionBlock();
        }
        
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@NO afterDelay:1.0];
    }
    
    else if ([request isKindOfClass:[ApplicationAttachmentGetRequest class]]) {
        self.detailModel.attachMentArray = [NSMutableArray arrayWithArray:[(id)response arrayAttachments]];
        [self.tableview reloadRowsAtIndexPaths:@[[self indexPathForRealIndex:kNewTaskCellStyleAttach]] withRowAnimation:UITableViewRowAnimationFade];
        [self hideLoading];
    }
    
    else if ([request isKindOfClass:[ProjectDetailRequest class]])
    {
        ProjectDetailResponse *result = (ProjectDetailResponse *)response;
        self.projectMember = result.project.arrayMembers;
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self hideLoading];
    [self postError:errorMessage];
}

#pragma mark - Private Method

- (void)requestProjectDetailWithShowID:(NSString *)showID
{
    ProjectDetailRequest *request = [[ProjectDetailRequest alloc] initWithDelegate:self];
    [request detailShowId:showID];
    [self postLoading];
}

- (NSUInteger)realIndexAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section * 10 + indexPath.row;
}

- (NSIndexPath *)indexPathForRealIndex:(NewTaskCellStyle)realIndex {
    return [NSIndexPath indexPathForItem:realIndex % 10 inSection:realIndex / 10];
}

- (BOOL)checkInformation {
    id tmpObject = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeTitle];
    if (!tmpObject || ![tmpObject length]) {
        [self postError:LOCAL(MEETING_INPUT_TITLE)];
        return NO;
    }
    
    tmpObject = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeProject];
    if (!tmpObject) {
        [self postError:LOCAL(MISSION_SELECTPROJECT)];
        return NO;
    }
    
    return YES;
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
            return self.detailModel.project;
        case kTaskCreateAndEditRequestTypeDeadline:
            return self.detailModel.deadlineDate;
        case kTaskCreateAndEditRequestTypePriority:
            [self.dictModel setObject:@(MissionTaskPriorityLow) forKey:@(kTaskCreateAndEditRequestTypePriority)];
            return @(self.detailModel.priority);
        case kTaskCreateAndEditRequestTypeComment:
            return self.detailModel.comment;
        case kTaskCreateAndEditRequestTypeAttach:
            return self.detailModel.attachMentArray;
        case kTaskCreateAndEditRequestTypePeople:
            return self.detailModel.personArray;
        default:
            return nil;
    }
}

/** 获取tag组成的string */
- (NSString *)tagsString {
    if (!self.detailModel.tagArray) {
        return @"";
    }
    
    NSMutableArray *tagNameArray = [NSMutableArray array];
    for (ProjectModel *tagModel in self.detailModel.tagArray) {
        [tagNameArray addObject:tagModel.name];
    }
    return [tagNameArray componentsJoinedByString:@", "];
}

/** 获取分配组成的string */
- (NSString *)personString {
    NSArray *arrayPeople = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypePeople];
    if (!arrayPeople) {
        return @"";
    }
    
    NSString *string = @"";
    ContactPersonDetailInformationModel *person = [arrayPeople firstObject];
    return person.u_true_name;
}

- (void)reloadRealIndex:(NewTaskCellStyle)realIndex {
    NSIndexPath *indexPathNeedReload = [self indexPathForRealIndex:realIndex];
    [self.tableview reloadRowsAtIndexPaths:@[indexPathNeedReload] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)imagePickerImages:(NSArray *)assets {
    [self postLoading];
    for (ALAsset *asset in assets) {

        UIImage *image = [ApplicationAttachmentModel originalImageFromAsset:asset];
        ApplicationAttachmentModel *attachModel = [[ApplicationAttachmentModel alloc] initWithLocalImage:image];

        [self addAttachment:attachModel];
    }
    [self hideLoading];
    [self reloadRealIndex:kNewTaskCellStyleAttach];
}

- (void)imagePickerImage:(UIImage *)image {
    ApplicationAttachmentModel *attachModel = [[ApplicationAttachmentModel alloc] initWithLocalImage:image];
    [self addAttachment:attachModel];
    [self reloadRealIndex:kNewTaskCellStyleAttach];
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

#pragma mark - Cell Block
/** 优先度Cell点击 */
- (void)selectImportanceAtIndex:(NSUInteger)selectedIndex {
    [self.dictModel setObject:@(selectedIndex) forKey:@(kTaskCreateAndEditRequestTypePriority)];
}
/** 选择Project */
- (void)selectProject:(ProjectModel *)project {
    [self.dictModel setObject:project forKey:@(kTaskCreateAndEditRequestTypeProject)];
    [self reloadRealIndex:kNewTaskCellStyleProject];
}
/** 选择tag */
- (void)selectTags:(NSArray *)tags {
    self.detailModel.tagArray = [NSArray arrayWithArray:tags];
    [self reloadRealIndex:kNewTaskCellStyleTag];
}
/** 选择重复 */
- (void)selectRepeat:(NSInteger)repeatType {
    self.detailModel.repeatType = repeatType;
    [self reloadRealIndex:kNewTaskCellStyleRepeat];
}
/** 选择提醒 */
- (void)selectRemind:(NSInteger)remindType {
//    self.detailModel.remindType = remindType;
//    [self reloadRealIndex:kNewTaskCellStyleRemind];
    [self.dictModel setObject:@(remindType) forKey:@(kTaskCreateAndEditRequestTypeRemind)];
    [self reloadRealIndex:kNewTaskCellStyleRemind];
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
/** 选择人员 */
- (void)selectPeople:(NSArray *)people {
    [self.dictModel setObject:people forKey:@(kTaskCreateAndEditRequestTypePeople)];
    [self reloadRealIndex:kNewTaskCellStylePerson];
}

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
    [self reloadRealIndex:kNewTaskCellStyleAttach];
    
    if (![arrayTmp count]) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - ApplyAddDeadLineActionSheetView Delegate
- (void)ApplyAddDeadlineActionSheetViewDelegateCallBack_date:(NSDate *)date {
    [self.dictModel setObject:date forKey:@(kTaskCreateAndEditRequestTypeDeadline)];
    [self reloadRealIndex:kNewTaskCellStyleTime];
}

#pragma mark - UITableView Delegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {return 10;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {return 0.01;}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger realIndex = [self realIndexAtIndexPath:indexPath];
    if (realIndex == kNewTaskCellStyleComment) {
        return 106;
    }
    
    if (realIndex == kNewTaskCellStyleAttach) {
        return [ApplicationAttachmentTableViewCell heightForCellWithImageCount:[[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeAttach] count] accessoryMode:YES];
    }
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNewTaskCellStyleComment / 10 + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return kNewTaskCellStylePerson % 10 + 1;
        case 1: return kNewTaskCellStyleImportance % 10 + 1;
        case 2: return kNewTaskCellStyleTag % 10;// + 1;
        case 3: return kNewTaskCellStyleRepeat % 10;// + 1;
        case 4: return kNewTaskCellStyleRemind % 10 + 1;
        case 5: return kNewTaskCellStyleComment % 10 + 1;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = nil;
    NSUInteger realIndex = [self realIndexAtIndexPath:indexPath];
    switch (realIndex) {
        case kNewTaskCellStyleTitle:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[TaskOnlyTextFieldTableViewCell identifier]];
            [cell texfFieldTitle].delegate = self;
            
            [cell texfFieldTitle].text = [self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeTitle];
        }
            break;
        case kNewTaskCellStyleProject: // 项目
        case kNewTaskCellStylePerson:  // 分配
        case kNewTaskCellStyleTime:    // 截止时间
        case kNewTaskCellStyleTag:     // tag
        case kNewTaskCellStyleRepeat:  // 重复
        case kNewTaskCellStyleRemind:  // 提醒
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCellID"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"defaultCellID"];
                [cell textLabel].textColor = [UIColor blackColor];
                [cell textLabel].font = [UIFont systemFontOfSize:14];
                [cell detailTextLabel].textColor = [UIColor minorFontColor];
                [cell detailTextLabel].font = [UIFont systemFontOfSize:14];
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            NSString *title = @"";
            NSString *detailTitle = @"";
            switch (realIndex)
            {
                case kNewTaskCellStyleProject:
                    self.projectIndexPath = indexPath;
                    if (self.parentProject || self.detailModel) {
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    }
                    
                    title = LOCAL(MISSION_PROJECT);
                    detailTitle = [[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeProject] name];
                    break;
                case kNewTaskCellStylePerson:
                    title = LOCAL(MISSION_PARTICIPANT);
                    detailTitle = [self personString];
                    break;
                case kNewTaskCellStyleTime:
                    title = LOCAL(MISSION_ENDTIME);
                    detailTitle = [[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeDeadline] mtc_dateFormate];
                    break;
                case kNewTaskCellStyleTag:
                    title = @"tag";
                    detailTitle = [self tagsString];
                    break;
                case kNewTaskCellStyleRepeat:
                    title = LOCAL(MEETING_REMIND);
                    detailTitle = [CalendarLaunchrModel repeatTypeStringAtIndex:self.detailModel.repeatType];
                    break;
                case kNewTaskCellStyleRemind:
                    title = LOCAL(MEETING_NOTIFICATE);
//                    detailTitle = [CalendarLaunchrModel remindTypeStringAtIndex:self.detailModel.remindType];
                    detailTitle = [CalendarLaunchrModel remindTypeStringAtIndex:[[self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeRemind)] integerValue]];
                    break;
            }

            [cell textLabel].text = title;
            [cell detailTextLabel].text = detailTitle;
        }
            break;
        case kNewTaskCellStyleImportance: // 优先度
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[TaskWithSegmentTableViewCell identifier]];
            
            [cell lblTitle].text = LOCAL(MISSION_WHOFIRST);
            [cell setCurrentSelectPriority:[[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypePriority] integerValue]];
            
            [cell segmentDidSelect:^(NSUInteger selectedIndex) {
                [self selectImportanceAtIndex:selectedIndex];
            }];
        }
            break;
        case kNewTaskCellStyleAttach: // 附件
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell titleLabel].text = LOCAL(APPLY_ATTACHMENT_TITLE);

            [cell clickToSeeImage:^(NSUInteger clickedIndex) {
                [self selectShowImageAtIndex:clickedIndex];
            }];
    
            [cell setImages:[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeAttach]];
        }
            break;
        case kNewTaskCellStyleComment: // 备注
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarTextViewTableViewCell identifier]];
            [cell setDelegate:self];
            [cell setContent:[self getComponentFromDictionaryOrModel:kTaskCreateAndEditRequestTypeComment]];
        }
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    NSUInteger realIndex = [self realIndexAtIndexPath:indexPath];
    id VC;

    switch (realIndex) {
        case kNewTaskCellStyleProject:
        {
            if (self.parentProject) {
                break;
            }
            
            if (self.detailModel) {
                break;
            }
            
            VC = [[MissionSelectProjectViewController alloc] initWithSelectProject:^(ProjectModel *project) {
                [self requestProjectDetailWithShowID:project.showId];
                [self selectProject:project];
            }];
        }
            break;
        case kNewTaskCellStyleTag:
        {
            VC = [[MissionSelectTagViewController alloc] initWithSelectTag:^(NSArray *tagArray) {
                [self selectTags:tagArray];
            }];
            
            [VC selectedTags:self.detailModel.tagArray];
        }
            break;
        case kNewTaskCellStyleRepeat:
        {
            VC = [[CalendarNewEventRepeatViewController alloc] initWithRepeatType:^(NSInteger repeatType) {
                [self selectRepeat:repeatType];
            }];
        }
            break;
        case kNewTaskCellStyleRemind:
        {
            VC = [[CalendarNewEventRemindViewController alloc] initWithWholeDayMode:NO RemindType:^(NSInteger remindType) {
                [self selectRemind:remindType];
            }];
        }
            break;
        case kNewTaskCellStylePerson:
        {
            TaskOnlyTextFieldTableViewCell *cell = [tableView cellForRowAtIndexPath:self.projectIndexPath];
            if (cell.detailTextLabel.text.length == 0) {
                [self postError:LOCAL(MISSION_SELECTPROJECT)];
                return;
            } else {
                VC = [[SelectContactBookViewController alloc] initWithSelectedPeople:[self getComponentFromDictionaryOrModel:realIndex] unableSelectPeople:self.projectMember];
                [VC setSingleSelectable:YES];
                [VC setSelfSelectable:YES];
                [VC setIsMission:YES];
                
                __weak typeof(self) weakSelf = self;
                [VC selectedPeople:^(NSArray *selectedPeople) {
                    [weakSelf selectPeople:selectedPeople];
                }];
                
                [self presentViewController:VC animated:YES completion:nil];
                return;
            }
           
        }
            break;
        case kNewTaskCellStyleTime:
        {
            ApplyAddDeadlineActionSheetView *sheetView = [[ApplyAddDeadlineActionSheetView alloc] init];
            [sheetView setShowWholeDayMode:YES];
            sheetView.delegate = self;
            [self.view addSubview:sheetView];
        }
            break;
        case kNewTaskCellStyleAttach:
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark - WZPhotoPickerController Delegate
- (void)wz_imagePickerController:(WZPhotoPickerController *)photoPickerController didSelectAssets:(NSArray *)assets {
    [self imagePickerImages:assets];
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.tableview.frame = CGRectMake(0, self.tableview.frame.origin.y - (self.tableview.contentSize.height - self.view.frame.size.height + 250), self.tableview.frame.size.width, self.tableview.frame.size.height);
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.tableview.frame = CGRectMake(0, self.tableview.frame.origin.y + (self.tableview.contentSize.height - self.view.frame.size.height + 250), self.tableview.frame.size.width, self.tableview.frame.size.height);
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

#pragma mark - Setter
- (void)setParentProject:(ProjectModel *)parentProject {
    _parentProject = parentProject;
    [self.dictModel setObject:_parentProject forKey:@(kTaskCreateAndEditRequestTypeProject)];
    [self.tableview reloadRowsAtIndexPaths:@[[self indexPathForRealIndex:kNewTaskCellStyleProject]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Initializer
- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.backgroundColor = [UIColor mtc_colorWithHex:0xebebeb];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        if ([_tableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableview setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        
        
        [_tableview registerClass:[TaskOnlyTextFieldTableViewCell class]        forCellReuseIdentifier:[TaskOnlyTextFieldTableViewCell identifier]];
        [_tableview registerClass:[TaskTwoLabelsWithArrowTableViewCell class]   forCellReuseIdentifier:[TaskTwoLabelsWithArrowTableViewCell identifier]];
        [_tableview registerClass:[TaskWithSegmentTableViewCell class]          forCellReuseIdentifier:[TaskWithSegmentTableViewCell identifier]];
        [_tableview registerClass:[CalendarTextViewTableViewCell class]         forCellReuseIdentifier:[CalendarTextViewTableViewCell identifier]];
        [_tableview registerClass:[ApplicationAttachmentTableViewCell class]    forCellReuseIdentifier:[ApplicationAttachmentTableViewCell identifier]];
    }
    return _tableview;
}

//- (MissionDetailModel *)detailModel
//{
//    if (!_detailModel)
//    {
//        _detailModel = [[MissionDetailModel alloc] init];
//    }
//    return _detailModel;
//}
@end
