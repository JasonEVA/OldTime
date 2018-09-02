//
//  MissionAddNewMissionViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionAddNewMissionViewController.h"
#import "MissionAddNewMissionAdapter.h"
#import <Masonry/Masonry.h>
#import "HMDoctorEnum.h"
#import "ApplicationAttachmentModel.h"
#import <MWPhotoBrowser-ADS/MWPhotoBrowser.h>
#import "ATModuleInteractor+MissionInteractor.h"
#import "GetTaskTitlesTask.h"

#import "ServiceGroupMemberModel.h"
#import "MissionDetailModel.h"
#import "PatientInfo.h"
#import "NSDate+String.h"
#import "AddMissionTask.h"
#import "DateUtil.h"
#import "TaskUploadImageTask.h"
#import "WZPhotoPickerController.h"
#import "NSString+TaskStringFormat.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

static NSInteger const maxImageCount = 9;
static NSInteger const photoActionSheetTag = 11;

@interface MissionAddNewMissionViewController ()<ATTableViewAdapterDelegate,MissionAddNewMissionAdapterDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate,TaskObserver>
@property (nonatomic, strong) MissionAddNewMissionAdapter *adapter;
@property (nonatomic, copy) NSArray *titelTypeArr;  //标题类型数组
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, copy)  NSString  *staffID; // 参与者staffID
@property (nonatomic, strong)  NSMutableArray  *arraySelected; // <##>

@property (nonatomic, strong)  NSMutableArray<UIImage *>  *arrayUploadImage; // 要上传的图片
@property (nonatomic, strong)  NSMutableArray<NSString *>  *arrayUploadedImagePath; // 已上传成功图片地址
@end

@implementation MissionAddNewMissionViewController


- (instancetype)initEditMissionWithModel:(MissionDetailModel *)model
{
    if (self = [super init]) {
        self.title = @"新建草稿";
        self.adapter.detailModel = model;
    }
    return self;
}
- (instancetype)initAddNewMission
{
    if (self = [super init]) {
        self.title = @"新建任务";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configElements];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

#pragma mark - private method

// 设置元素控件
- (void)configElements {
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置数据
- (void)configData {
    
    
    [self requestTaskTitles];
}

// 设置约束
- (void)configConstraints {
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}


// 根据indexpath获取type
- (NSUInteger)realIndexAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section * 10 + indexPath.row;
}

// 根据type获取indexPath
- (NSIndexPath *)indexPathForRealIndex:(NSInteger)realIndex {
    return [NSIndexPath indexPathForItem:realIndex % 10 inSection:realIndex / 10];
}

- (void)imagePickerImage:(UIImage *)image {
    [self.arrayUploadImage addObject:image];
    self.adapter.uploadOriImages = self.arrayUploadImage;
    [self reloadRealIndex:CellType_Accessory];
}

/** 点击查看照片 */
- (void)selectShowImageAtIndex:(NSUInteger)selectedIndex {
    self.photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.photoBrowser.displayActionButton = YES;
    self.photoBrowser.alwaysShowControls = NO;
    self.photoBrowser.zoomPhotosToFill = YES;
    self.photoBrowser.enableGrid = NO;
    self.photoBrowser.enableSwipeToDismiss = YES;
    [self.photoBrowser showNextPhotoAnimated:YES];
    [self.photoBrowser showPreviousPhotoAnimated:YES];
    [self.navigationController pushViewController:self.photoBrowser animated:YES];
    [self.photoBrowser setCurrentPhotoIndex:selectedIndex];
}

- (void)reloadRealIndex:(NSInteger)realIndex {
    NSIndexPath *indexPathNeedReload = [self indexPathForRealIndex:realIndex];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathNeedReload] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)setRemineTimeWithType:(MissionTaskRemindType )type
{
    self.adapter.detailModel.remindType = type;
    [self reloadRealIndex:CellType_Alert];
}

- (void)setTitelWithTitel:(NSString *)titel
{
    self.adapter.detailModel.taskTitle = titel;
    [self reloadRealIndex:CellType_Title];
}

- (void)configPatientInfoWithPatients:(NSArray<PatientInfo *> *)patients {
    NSMutableArray *arrayPatientName = [NSMutableArray arrayWithCapacity:patients.count];
    NSMutableArray *arrayPatientID = [NSMutableArray arrayWithCapacity:patients.count];
    for (PatientInfo *model in patients) {
        [arrayPatientName addObject:model.userName];
        [arrayPatientID addObject:[NSString stringWithFormat:@"%ld",(long)model.userId]];
    }
    self.adapter.detailModel.patientsName = [arrayPatientName componentsJoinedByString:@"|"];
    self.adapter.detailModel.patientsID = [arrayPatientID componentsJoinedByString:@"|"];
}

// 获取任务标题列表
- (void)requestTaskTitles {
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetTaskTitlesTask class]) taskParam:nil TaskObserver:self];
    [self at_postLoading];
}

// 新建任务
- (void)addTaskRequest {
    
    if ([self makeCheckWithString:self.adapter.detailModel.taskTitle])
    {
        [self at_postError:@"请选择或输入任务标题"];
        return;
    }
    
    if ([self makeCheckWithString:self.adapter.detailModel.participatorID])
    {
        [self at_postError:@"请选择参与者"];
        return;
    }
    
//    if ([self makeCheckWithString:self.adapter.detailModel.patientsID])
//    {
//        [self at_postError:@"请选择患者"];
//        return;
//    }
    
    if ([self makeCheckWithString:self.adapter.detailModel.startTime])
    {
        [self at_postError:@"请选择开始时间"];
        return;
    }
    
    if ([self makeCheckWithString:self.adapter.detailModel.endTime])
    {
        [self at_postError:@"请选择结束时间"];
        return;
    }
    
    if (![self compareLengthStart:[self handleTimeWithDateStr:self.adapter.detailModel.startTime] endStr:[self handleTimeWithDateStr:self.adapter.detailModel.endTime]])
    {
        [self at_postError:@"开始时间应早于结束时间"];
        return;
    }
    
    UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;
    NSDictionary *dict = @{
                           @"taskType":  @(self.adapter.detailModel.taskType),
                           @"taskTitle":  self.adapter.detailModel.taskTitle,
                           @"participantId":  [NSString stringWithFormat:@"%@",self.adapter.detailModel.participatorID],
                           @"patientIds":  [NSString stringWithFormat:@"%@",self.adapter.detailModel.patientsID?:@""],
                           @"startTime":  self.adapter.detailModel.startTime,
                           @"endTime":  self.adapter.detailModel.endTime,
                           @"remark":  self.adapter.detailModel.remark,
                           @"teamId":  [NSString stringWithFormat:@"%@",self.adapter.detailModel.teamID],
                           @"priority":  [NSString stringWithFormat:@"%ld",self.adapter.detailModel.taskPriority],
                           @"remindType": @(self.adapter.detailModel.remindType),
                           @"isStartTimeAll": [NSString stringWithFormat:@"%@",@(self.adapter.detailModel.isStartAllDay)],
                           @"isEndTimeAll": [NSString stringWithFormat:@"%@",@(self.adapter.detailModel.isEndAllDay)],
                           @"isMemberAccess": self.adapter.detailModel.isMemberAccess ? @1 : @0,
                           @"accessoriesUrls": self.adapter.detailModel.attachmentsPath,
                           @"p_show_ids":self.adapter.detailModel.p_show_ids,
                           @"t_user": [NSString stringWithFormat:@"%ld",(long)info.userId]
                            };
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([AddMissionTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];

}

- (BOOL)makeCheckWithString:(NSString *)str
{
    return ([str isEqualToString:@""] || str == nil);
}

- (NSString *)handleTimeWithDateStr:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
    return str;
}

- (BOOL)compareLengthStart:(NSString *)start endStr:(NSString *)end
{
    if (start.length != end.length)
    {
        if (start.length > end.length)
        {
            end = [NSString stringWithFormat:@"%@235959",end];
        }else
        {
            start = [NSString stringWithFormat:@"%@235959",start];
        }
        
        return [end longLongValue] / [start longLongValue];
    }else
    {
        return [end longLongValue] / [start longLongValue];
    }
    return NO;
}

- (void)uploadImageWithImage:(UIImage *)image {
    //上传图片
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([TaskUploadImageTask class]) taskParam:nil extParam:imageData TaskObserver:self];
    [self at_postLoading];
}

// 整理已选医生
- (NSArray *)formatPersonModelWithID:(NSString *)ID name:(NSString *)name patient:(BOOL)patient {
    if (ID.length == 0) {
        return @[];
    }
    NSArray *arrayIDs = [[ID hm_formatCuttingLineStringSeparatedByPeriodString] componentsSeparatedByString:@"、"];
    NSArray *arrayNames = [[ID hm_formatCuttingLineStringSeparatedByPeriodString] componentsSeparatedByString:@"、"];
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:arrayIDs.count];

    for (NSString *ID in arrayIDs) {
        if (patient) {
            PatientInfo *model = [PatientInfo new];
            model.userId = ID.integerValue;
            model.userName = arrayNames[arrayTemp.count];
            [arrayTemp addObject:model];
        }
        else {
            ServiceGroupMemberModel *model = [ServiceGroupMemberModel new];
            model.userId = ID.integerValue;
            model.staffName = arrayNames[arrayTemp.count];
            [arrayTemp addObject:model];
        }
    }
    return arrayTemp;
}


#pragma mark - event Response
- (void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightClick
{
    [self.view endEditing:YES];
    
    // 上传第一张图片
    if (self.arrayUploadedImagePath.count < self.arrayUploadImage.count) {
        // 上传图片
        [self uploadImageWithImage:self.arrayUploadImage[self.arrayUploadedImagePath.count]];
    }
    else {
        // 新建任务
        [self addTaskRequest];
    }
}

#pragma mark - MissionAddNewMissionAdapterDelegate
//标题类型选择弹出收起回调
- (void)MissionAddNewMissionAdapterDelegateCallBack_insterRow
{
    if (!self.titelTypeArr) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    for (int i = 0; i < self.titelTypeArr.count - 1; i++) {
        __weak typeof(self) weakSelf = self;
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:self.titelTypeArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSString *titel = @"";
            if ([action.title isEqualToString:@"自定义"]) {
                titel = @"";
            }
            else {
                titel = action.title;
            }
            [strongSelf setTitelWithTitel:titel];
        }];
        [alert addAction:alertAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

//附件点击图片查看大图回调
- (void)MissionAddNewMissionAdapterDelegateCallBack_accessoryClickImageIndex:(NSUInteger)clickedIndex
{
    [self selectShowImageAtIndex:clickedIndex];
}
//收起时间选择器
- (void)MissionAddNewMissionAdapterDelegateCallBack_startTimeSelectHideAtIndexPath:(NSIndexPath *)indexPath date:(NSDate *)date isWholeDay:(BOOL)isWholeDay isNone:(BOOL)isNone
{
    Cell_Type cellType = [self realIndexAtIndexPath:indexPath];
    Cell_Type dataCellType;
    if (cellType == CellType_StartTimePicker) {
        dataCellType = CellType_StartTime;
        self.adapter.startTimeCellIsopen ^= 1;
        if (isNone) {
            self.adapter.detailModel.startTime = @"";
        }
        else {
            if (date) {
                self.adapter.detailModel.isStartAllDay = isWholeDay;
                self.adapter.detailModel.startTime = [DateUtil stringDateWithDate:date dateFormat:self.adapter.detailModel.isStartAllDay ? @"yyyy-MM-dd" : @"yyyy-MM-dd HH:mm:ss"];
            }
        }
    }
    else if (cellType == CellType_DeadlineTimePicker) {
        self.adapter.endTimeCellIsopen ^= 1;
        dataCellType = CellType_Deadline;
        if (isNone) {
            self.adapter.detailModel.endTime = @"";
        }
        else {
            if (date) {
                self.adapter.detailModel.isEndAllDay = isWholeDay;
                self.adapter.detailModel.endTime = [DateUtil stringDateWithDate:date dateFormat:self.adapter.detailModel.isEndAllDay ? @"yyyy-MM-dd" : @"yyyy-MM-dd HH:mm:ss"];
            }
        }

    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self reloadRealIndex:dataCellType];   
}

// 标题，备注输入回调
- (void)MissionAddNewMissionAdapterDelegateCallBack_textFieldEndEditWithText:(NSString *)text cellType:(Cell_Type)cellType {
    if (cellType == CellType_Title) {
        self.adapter.detailModel.taskTitle = text ? : @"";
    }
    else if (cellType == CellType_Details) {
        self.adapter.detailModel.remark = text ? : @"";
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == photoActionSheetTag) {
        // 附件上传照片
        if (buttonIndex == 1) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self at_postError:@"无摄像头或者不可用"];
                return;
            }
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
        else if (buttonIndex == 0) {
            WZPhotoPickerController *imagePicker = [[WZPhotoPickerController alloc] init];
            NSInteger count = maxImageCount - self.arrayUploadImage.count;
            [imagePicker setMaximumNumberOfSelection:count];
            __weak typeof(self) weakSelf = self;
            [imagePicker addPhotoPickerHandlerNoti:^(NSArray<UIImage *> *arrayImages) {
            __strong typeof(weakSelf) strongSelf = weakSelf;

            [strongSelf.arrayUploadImage addObjectsFromArray:arrayImages];
             strongSelf.adapter.uploadOriImages = strongSelf.arrayUploadImage;
             [strongSelf reloadRealIndex:CellType_Accessory];

            }];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
        return;
    }
    
    // 附件删除
    if (buttonIndex == 1) {
        return;
    }
    
//    NSMutableArray *arrayTmp = [self.dictModel objectForKey:@(kTaskCreateAndEditRequestTypeAttach)];
//    if (!arrayTmp) {
//        arrayTmp = [NSMutableArray arrayWithArray:self.detailModel.attachMentArray];
//        [self.dictModel setObject:arrayTmp forKeyedSubscript:@(kTaskCreateAndEditRequestTypeAttach)];
//    }
//    
//    
//    [arrayTmp removeObjectAtIndex:[self.photoBrowser currentIndex]];
//    [self.photoBrowser reloadData];
//    [self reloadRealIndex:CellType_Accessory];
//    
//    if (![arrayTmp count]) {
//        [self.navigationController popViewControllerAnimated:NO];
//    }

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
    return self.arrayUploadImage.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.arrayUploadImage.count) {
        return [MWPhoto photoWithImage:self.arrayUploadImage[index]];
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LOCAL(APPLY_DELETE_PICTURE) delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:LOCAL(DELETE) otherButtonTitles:nil];
//    [actionSheet showInView:self.view];
}

#pragma mark - UITableViewDelegate
- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath
{
    [self.tableView endEditing:YES];
    NSUInteger realIndex = [self realIndexAtIndexPath:indexPath];
    switch (realIndex) {
        case CellType_Accessory:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片", @"拍照", nil];
            actionSheet.tag = photoActionSheetTag;
            [actionSheet showInView:self.view];

        }
            break;
            case CellType_StartTime:
        {
            self.adapter.startTimeCellIsopen ^= 1;
            [self reloadRealIndex:CellType_StartTimePicker];
        }
            break;
        case CellType_Deadline:
        {
            self.adapter.endTimeCellIsopen ^= 1;
            [self reloadRealIndex:CellType_DeadlineTimePicker];
        }
            break;
            case CellType_Alert:
        {
            __weak typeof(self) weakSelf = self;
            [[ATModuleInteractor sharedInstance] goToSelectRemineTimeVCWithRemindType:^(MissionTaskRemindType remindType) {
                [weakSelf setRemineTimeWithType:remindType];
            }];
        }
            break;
            
        case CellType_Member: {
            __weak typeof(self) weakSelf = self;
            [[ATModuleInteractor sharedInstance] goToSelectParticipatorVCWithSelectedPeople:[self formatPersonModelWithID:self.adapter.detailModel.participatorID name:self.adapter.detailModel.participatorName patient:NO] completionSelectedPeople:^(NSArray *selectedPeople,NSString *teamIDs) {
                if (selectedPeople.count > 0) {
                    ServiceGroupMemberModel *model = selectedPeople.firstObject;
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    strongSelf.adapter.detailModel.participatorID = [NSString stringWithFormat:@"%ld",model.userId];
                    strongSelf.adapter.detailModel.participatorName = model.staffName;
                    strongSelf.adapter.detailModel.teamID = [NSString stringWithFormat:@"%ld",model.teamId];
                    strongSelf.adapter.detailModel.p_show_ids = teamIDs;
                    strongSelf.staffID = [NSString stringWithFormat:@"%ld",model.staffId];
                    // 患者置空
                    strongSelf.adapter.detailModel.patientsName = nil;
                    strongSelf.adapter.detailModel.patientsID = nil;
                    [strongSelf reloadRealIndex:CellType_Member];
                    [strongSelf reloadRealIndex:CellType_Patient];

                }
            }];
            break;
        }
        case CellType_Patient: {
            __weak typeof(self) weakSelf = self;
            NSString *participatorName = [self.adapter getComponentFromDictionaryOrModel:CellType_Member];
        if (participatorName.length > 0) {
            [[ATModuleInteractor sharedInstance] goToSelectPatientVCWithSelectedPeople:[self formatPersonModelWithID:self.adapter.detailModel.patientsID name:self.adapter.detailModel.patientsName patient:YES] staffID:self.staffID completionSelectedPeople:^(NSArray *selectedPeople,NSString *teamIDs) {
                __strong typeof(weakSelf) strongSelf = weakSelf;

                [strongSelf configPatientInfoWithPatients:selectedPeople];
                [strongSelf reloadRealIndex:CellType_Patient];

            }];
        } else {
            [self at_postError:@"请先选择参与人"];
        }
        
        break;
    }
        default:
            break;
    }
    
}


#pragma mark - request Delegate

- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError == StepError_None) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];

    if ([taskname isEqualToString:NSStringFromClass([GetTaskTitlesTask class])]) {
        [self at_postError:@"获取任务标题失败"];
    }
    else if ([taskname isEqualToString:NSStringFromClass([AddMissionTask class])]) {
        [self at_postError:@"新建任务失败"];
    }
    else if ([taskname isEqualToString:NSStringFromClass([TaskUploadImageTask class])]) {
        [self at_postError:@"上传图片失败"];
    }
    else {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {    [self at_hideLoading];

        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {    [self at_hideLoading];

        return;
    }
    
    if ([taskname isEqualToString:NSStringFromClass([GetTaskTitlesTask class])]) {
        NSMutableArray *temp = [@[@"自定义"] mutableCopy];
        if ([taskResult isKindOfClass:[NSArray class]]) {
            [temp addObjectsFromArray:taskResult];
        }
        self.titelTypeArr = temp;
        [self at_hideLoading];
    }
    else if ([taskname isEqualToString:NSStringFromClass([AddMissionTask class])]) {
        [self at_hideLoading];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([taskname isEqualToString:NSStringFromClass([TaskUploadImageTask class])]) {
        if ([taskResult isKindOfClass:[NSString class]]) {
            [self.arrayUploadedImagePath addObject:taskResult];
            if (self.arrayUploadedImagePath.count < self.arrayUploadImage.count) {
                [self performSelector:@selector(uploadImageWithImage:) withObject:self.arrayUploadImage[self.arrayUploadedImagePath.count] afterDelay:0.5];
            }
            else {
                // 格式化上传图片地址
                self.adapter.detailModel.attachmentsPath = [self.arrayUploadedImagePath componentsJoinedByString:@"|"];
                // 新建任务
                [self addTaskRequest];
            }
        }
    }
}

#pragma mark - updateViewConstraints

#pragma mark - init UI

- (MissionAddNewMissionAdapter *)adapter
{
    if (!_adapter) {
        _adapter = [MissionAddNewMissionAdapter new];
        _adapter.adapterDelegate = self;
        [_adapter setDelegate:self];
        _adapter.baseVC = self;
        _adapter.adapterArray = [@[@[@"任务标题",@"加急",@"参与者",@"用户"],@[@"开始时间",@"",@"结束时间",@"",@"设置提醒时间"],@[@"项目组任务",@"附件"],@[@"添加备注"]] mutableCopy];

    }
    return _adapter;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.estimatedRowHeight = 60;
    }
    return _tableView;
}

- (NSMutableArray<UIImage *> *)arrayUploadImage {
    if (!_arrayUploadImage) {
        _arrayUploadImage = [NSMutableArray array];
    }
    return _arrayUploadImage;
}

- (NSMutableArray<NSString *> *)arrayUploadedImagePath {
    if (!_arrayUploadedImagePath) {
        _arrayUploadedImagePath = [NSMutableArray array];
    }
    return _arrayUploadedImagePath;
}
@end
