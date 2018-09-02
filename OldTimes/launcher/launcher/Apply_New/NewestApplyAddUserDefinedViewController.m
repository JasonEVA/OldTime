//
//  NewestApplyAddUserDefinedViewController.m
//  launcher
//
//  Created by 马晓波 on 16/4/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewestApplyAddUserDefinedViewController.h"
#import "NewApplyAddNewApplyV2ViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import <Masonry/Masonry.h>
#import "NewApplyGetFormInfoRequest.h"
#import "NewApplyFormBaseModel.h"
#import "NewApplyAllFormModel.h"
#import "MWPhotoBrowser.h"
#import <DateTools/DateTools.h>
#import "AttachmentUploadRequest.h"
#import "WZPhotoPickerController.h"
#import "ApplicationAttachmentModel.h"
#import "SelectContactBookViewController.h"
#import "ApplyTextFieldTableViewCell.h"
#import "NewApplyAddApplyTitleTableViewCell.h"
#import "ApplyDeadlineTableViewCell.h"
#import "ApplyDetailTableViewCell.h"
#import "ApplicationAttachmentTableViewCell.h"
#import "ApplyNameRightTableViewCell.h"
#import "MyDefine.h"
#import "MultiAndSingleChooseViewController.h"
#import "NewApplyFormTextInputModel.h"
#import "ApplyAddPeriodActionSheetView.h"
#import "NewApplyFormTimeModel.h"
#import "NewApplyFormPeopleModel.h"
#import "ApplyAddDeadlineActionSheetView.h"
#import <UIActionSheet+Blocks/UIActionSheet+Blocks.h>
#import "NewApplyCreateV2Request.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>

static NSInteger const maxImageCount = 9;

@interface NewestApplyAddUserDefinedViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,BaseRequestDelegate,MWPhotoBrowserDelegate,NewApplyAddApplyTitleTableViewCellDelegate, UIActionSheetDelegate, ApplyAddPeriodActionSheetViewDelegate, ApplyAddDeadlineActionSheetViewDelegate, WZPhotoPickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSString *strApplyShowID;
@property (nonatomic, strong) NSString *formId;
@property (nonatomic, strong) NewApplyAllFormModel *model;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) ApplyAddPeriodActionSheetView *actionSheetView;
@property (nonatomic, strong) ApplyAddDeadlineActionSheetView *deadLineView;

@property (nonatomic, strong) NewApplyFormBaseModel *selectedFileModel;
/// 多行输入记录字典
@property (nonatomic, strong) NSMutableDictionary *multiLineInputDictionary;

@property (nonatomic, strong) NSArray *mustArr;
@property (nonatomic, strong) NSArray *tryArr;

@property (nonatomic, assign) CGFloat canComeCellRowHeight;
@property (nonatomic, assign) CGFloat mustComeCellRowHeight;

@property (nonatomic, strong) NewApplyFormBaseModel *uploadAttachModel;


@end

@implementation NewestApplyAddUserDefinedViewController
- (instancetype)initWithApplyStyle:(newapplyuserdefined_type)type WithApplyShowID:(NSString *)strID WithFormId:(NSString *)formid
{
    if (self = [super init])
    {
        self.applytype = type;
        self.strApplyShowID = strID;
        self.formId = formid;
        NewApplyGetFormInfoRequest *request = [[NewApplyGetFormInfoRequest alloc] initWithDelegate:self];
        [request getFormId:formid];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.strNavTitle;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(APPLY_SEND) style:UIBarButtonItemStylePlain target:self action:@selector(clickToSend)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.mustComeCellRowHeight = 47;
    self.canComeCellRowHeight  = 47;
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.model.arrFormModels enumerateObjectsUsingBlock:^(NewApplyFormBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeTryAction];
    }];
    [self postLoading];
}

#pragma mark - Button Click
- (void)clickToSend {
    [self.view endEditing:YES];
    
    if (self.isLoading) {
        return;
    }
    
    __block BOOL checkInfo = YES;
    [self.model.arrFormModels enumerateObjectsUsingBlock:^(NewApplyFormBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.required && !obj.try_inputDetail) {
            *stop = YES;
            checkInfo = NO;
            
            [self postError:[NSString stringWithFormat:LOCAL(INPUT_ERROR), obj.labelText]];
        }
    }];
    
    if (!checkInfo) {
        return;
    }
    
    __block BOOL attachUpload = NO;
    [self.model.arrFormModels enumerateObjectsUsingBlock:^(NewApplyFormBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (obj.inputType == Form_inputType_file) {
            *stop = YES;
            
            self.uploadAttachModel = obj;
            
            for (NSInteger i = 0; i < [obj.try_inputDetail count]; i ++) {
                ApplicationAttachmentModel *attachment = [obj.try_inputDetail objectAtIndex:i];
                if (attachment.showId) {
                    continue;
                }
                
                [self postProgress:0];
                AttachmentUploadRequest *uploadRequest = [[AttachmentUploadRequest alloc] initWithDelegate:self identifier:i];
                [uploadRequest uploadImageData:UIImageJPEGRepresentation(attachment.originalImage, 1.0) appShowIdType:kAttachmentAppShowIdApprove];
                
                attachUpload = YES;
            }
        }
    }];
    
    if (attachUpload) {
        return;
    }
    
    [self postLoading];
    switch (self.applytype) {
        case newapply_type_edit:
            
            break;
        
        case newapply_type_new: {
            NewApplyCreateV2Request *request = [[NewApplyCreateV2Request alloc] initWithDelegate:self];
            [request approveNewWithApproveShowId:self.strApplyShowID workflowId:self.strworkflowID formId:self.formId model:self.model ];
        }
            break;
    }
}

#pragma mark - Private Methods
- (NSString *)stringFromStart:(NSDate *)startDate end:(NSDate *)endDate isAllDay:(BOOL)AllDay
{
    NSString *str;
    if (startDate.year == endDate.year && startDate.month == endDate.month && startDate.day == endDate.day)
    {
        if (AllDay) return str = [startDate mtc_startToEndDate:endDate wholeDay:YES];
        str = [startDate mtc_startToEndDate:endDate wholeDay:NO];
    }
    else
    {
        str = [startDate mtc_startToEndDate:endDate wholeDay:YES];
    }
    return str;
}

- (NewApplyAddApplyTitleTableViewCell *)textViewCellFromModel:(NewApplyFormBaseModel *)model {
    NewApplyAddApplyTitleTableViewCell *cell = self.multiLineInputDictionary[model.key];
    if (cell) {
        return cell;
    }
    
    cell = [[NewApplyAddApplyTitleTableViewCell alloc] init];
    cell.delegate = self;
    cell.placeholderLabel.text = [(id)model placeholder];
    cell.tvwTitle.text = [(id)model try_inputDetail];
    self.multiLineInputDictionary[model.key] = cell;
    
    return cell;
}

//根据取得选中人数，返回行数
- (NSInteger)getRowNumberWithData:(NSArray *)array {
    NSString *labelText = [[NSString alloc] init];;
    NSString *labelTextTest = [[NSString alloc] init];
    for (int i = 0; i < array.count; i++) {
        if (i == 0)
        {
            labelText = [labelText stringByAppendingString:array[i]];
            labelTextTest = labelText;
        } else {
            labelText = [labelText stringByAppendingString:@"、"];
            labelText = [labelText stringByAppendingString:array[i]];
            labelTextTest = labelText;
        }
    }
    if ((self.view.frame.size.width - 110) / 10 >= labelTextTest.length)
    {
        return 47;
    } else if ((self.view.frame.size.width - 110) / 15 < labelTextTest.length && (self.view.frame.size.width - 110) / 7 >= labelTextTest.length)
    {
        return 60;
        
    } else
    {
        return 80;
    }
}

/** 点击查看照片 */
- (void)selectShowImageAtIndex:(NSUInteger)selectedIndex model:(NewApplyFormBaseModel *)model {
    self.selectedFileModel = model;
    self.photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.photoBrowser.displayTrashButton = YES;
    self.photoBrowser.alwaysShowControls = YES;
    self.photoBrowser.zoomPhotosToFill = YES;
    self.photoBrowser.enableGrid = NO;
    self.photoBrowser.gridButton.hidden = YES;
    self.photoBrowser.enableSwipeToDismiss = NO;
    [self.photoBrowser showNextPhotoAnimated:YES];
    [self.photoBrowser showPreviousPhotoAnimated:YES];
    self.photoBrowser.showNavigationBar = YES;
    [self.navigationController pushViewController:self.photoBrowser animated:YES];
    [self.photoBrowser setCurrentPhotoIndex:selectedIndex];
}

#pragma mark - tableviewdelegate/datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.arrFormModels.count;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15; }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewApplyFormBaseModel *model = [self.model.arrFormModels objectAtIndex:indexPath.row];
    switch (model.inputType)
    {
        case Form_inputType_textArea:  return [self textViewCellFromModel:model].cellheight;
        case Form_inputType_requiredPeopleChoose: return self.mustComeCellRowHeight;
        case Form_inputType_ccPeopleChoose: return self.canComeCellRowHeight;
        case Form_inputType_file:
        {
            return [ApplicationAttachmentTableViewCell heightForCellWithImageCount:[[model try_inputDetail] count] accessoryMode:YES];
        }
        case Form_inputType_textInput:
        case Form_inputType_timePoint:
        case Form_inputType_singleChoose:
        case Form_inputType_multiChoose:
        case Form_inputType_timeSlot:
        case Form_inputType_approvePeriod:
            return 47;
        case Form_inputType_unknown:
        default: return 0.01;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewApplyFormBaseModel *model = [self.model.arrFormModels objectAtIndex:indexPath.row];
    switch (model.inputType)
    {
        case Form_inputType_textInput:
        {
            ApplyTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplyTextFieldTableViewCell identifier]];
            if (!cell)
            {
                cell = [[ApplyTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ApplyTextFieldTableViewCell identifier]];
            }
            [cell settextfieldPlaceHolder:[(id)model placeholder]];
            [cell setTitle:model.try_inputDetail];
            [cell textEndEdting:^(NSString *text) {
                model.try_inputDetail = text;
            }];
            return cell;
        }
            break;
        case Form_inputType_textArea:
        {
            return [self textViewCellFromModel:model];
        }
            break;
        case Form_inputType_timeSlot:
        case Form_inputType_timePoint:
        case Form_inputType_approvePeriod:
        {
            ApplyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplyDetailTableViewCell identifier]];
            if (!cell)
            {
                cell = [[ApplyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ApplyDetailTableViewCell identifier]];
                [cell textLabel].textColor  = [UIColor blackColor];
                [cell textLabel].font = [UIFont mtc_font_30];
            }
            
            [cell textLabel].text = model.labelText;
            
            if (model.inputType == Form_inputType_timePoint || model.inputType == Form_inputType_approvePeriod) {
                NSDate *deadline = model.try_inputDetail;
                if (deadline)
                {
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@"MM/dd HH:mm"];
                    [cell applyDetailLbl].text = [format stringFromDate:deadline];
                }
            }
            else {
                NSDictionary *dict = model.try_inputDetail;
                if (dict) {
                    NSDate *start = dict[NewForm_startTime];
                    NSDate *end = dict[NewForm_endTime];
                    [cell applyDetailLbl].text = [self stringFromStart:start end:end isAllDay:[NewApplyFormTimeModel isAllDayWithStartTime:start endTime:end]];
                }
            }
            return cell;
        }
            break;
        case Form_inputType_requiredPeopleChoose:
        case Form_inputType_ccPeopleChoose:
        {
            ApplyNameRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplyNameRightTableViewCell identifier]];
            if (!cell)
            {
                cell = [[ApplyNameRightTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[ApplyNameRightTableViewCell identifier]];
                [cell setIsEdit:YES];
                [cell setSeparatorInset:UIEdgeInsetsZero];
                if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            
            [cell myTextLabel].text = model.labelText;
            [cell setNameField:[model try_inputDetail][NewForm_showingName]];
           
            return cell;
        }
            break;
        case Form_inputType_multiChoose:
        case Form_inputType_singleChoose:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellID"];
                cell.textLabel.font = [UIFont mtc_font_30];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = model.labelText;
            
            NSArray <NSString *>*valueArray = [model try_inputDetail];
            cell.detailTextLabel.text = [valueArray componentsJoinedByString:@","];
            return cell;
        }
            break;
        case Form_inputType_file:
        {
            ApplicationAttachmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell clickToSeeImage:^(NSUInteger clickedIndex) {
                [self selectShowImageAtIndex:clickedIndex model:model];
            }];
            [cell titleLabel].text = model.labelText;
            
            [cell setImages:[model try_inputDetail]];
            return cell;
        }
            break;
        default:break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nilCell"];
    if (!cell) {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nilCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewApplyFormBaseModel *model = [self.model.arrFormModels objectAtIndex:indexPath.row];
    switch (model.inputType) {
        case Form_inputType_singleChoose:
        case Form_inputType_multiChoose:
        {
            MultiAndSingleChooseViewController *VC = [[MultiAndSingleChooseViewController alloc] initWithModel:(NewApplyFormChooseModel *)model];
            [VC chooseCompltion:^{
                [self.tableview reloadData];
            }];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        
        case Form_inputType_timeSlot:
        {
            [self.view addSubview:self.actionSheetView];
            self.actionSheetView.identifier = model;
            NSDictionary *dict = model.try_inputDetail;
            if (dict) {
                NSDate *start = dict[NewForm_startTime];
                NSDate *end = dict[NewForm_endTime];
                [self.actionSheetView setStartDate:start endDate:end WholeDay:[NewApplyFormTimeModel isAllDayWithStartTime:start endTime:end]];
            }
        }
            break;
        case Form_inputType_timePoint:
        case Form_inputType_approvePeriod:
        {
            [self.view addSubview:self.deadLineView];
            self.deadLineView.identifier = model;
        }
            break;
        case Form_inputType_file:
        {
            self.selectedFileModel = model;
            
            [UIActionSheet showInView:self.view
                            withTitle:nil
                    cancelButtonTitle:LOCAL(CANCEL)
               destructiveButtonTitle:nil
                    otherButtonTitles:@[LOCAL(CAMERA), LOCAL(GALLERY)]
                             tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex)
            {
                if ( buttonIndex == 1) {
                    WZPhotoPickerController *VC = [[WZPhotoPickerController alloc] init];
                    VC.delegate = self;
                    
                    NSInteger count = maxImageCount - [[model try_inputDetail] count];
                    [VC setMaximumNumberOfSelection:count];
                    [self presentViewController:VC animated:YES completion:nil];
                }
                else if (buttonIndex == 0)
                {
                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        [self postError:LOCAL(ERROR_NOCAMERA)];
                        return ;
                    }
                    
                    UIImagePickerController *imagePickerController = [UIImagePickerController new];
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePickerController.delegate = self;
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                }
            }];
        }
            break;
        case Form_inputType_ccPeopleChoose:
        case Form_inputType_requiredPeopleChoose:
        {
            NSArray *selectedArray = model.inputType == Form_inputType_requiredPeopleChoose ? self.mustArr : self.tryArr;
            NSArray *unableArray = self.mustArr == selectedArray ? self.tryArr : self.mustArr;
            
            SelectContactBookViewController *selectVC = [[SelectContactBookViewController alloc] initWithSelectedPeople:selectedArray unableSelectPeople:unableArray];
            
            __weak typeof(self) weakSelf = self;
            [selectVC selectedPeople:^(NSArray *array) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                if (model.try_inputDetail == model.inputDetail) {
                    model.try_inputDetail = [NSMutableDictionary dictionary];
                }
                
                NSString *approveName = @"";
                for (NSInteger i = 0; i < [array count]; i ++) {
                    ContactPersonDetailInformationModel *model = array[i];
                    approveName = [approveName stringByAppendingString:model.u_true_name];
                    if (i != [array count] - 1)
                    {
                        approveName = [approveName stringByAppendingString:@"●"];
                    }
                }
                
                
                model.try_inputDetail[NewForm_modelArray]  = array;
                model.try_inputDetail[NewForm_showingName] = approveName;
                
                if (model.inputType == Form_inputType_ccPeopleChoose) {
                    strongSelf.canComeCellRowHeight = [strongSelf getRowNumberWithData:[approveName componentsSeparatedByString:@"●"]];
                    strongSelf.tryArr = array;
                }
                else {
                    strongSelf.mustComeCellRowHeight = [strongSelf getRowNumberWithData:[approveName componentsSeparatedByString:@"●"]];
                    strongSelf.mustArr = array;
                }
                
                [strongSelf.tableview reloadData];
            }];
            
            [self presentViewController:selectVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - WZPhotPickerController Delegate
- (void)wz_imagePickerController:(WZPhotoPickerController *)photoPickerController didSelectAssets:(NSArray *)assets {
    
    for (ALAsset *asset in assets)
    {
        UIImage *image = [ApplicationAttachmentModel originalImageFromAsset:asset];
        if (self.selectedFileModel.try_inputDetail == self.selectedFileModel.inputDetail) {
            self.selectedFileModel.try_inputDetail = [NSMutableArray array];
        }
        
        [self.selectedFileModel.try_inputDetail addObject:[[ApplicationAttachmentModel alloc] initWithLocalImage:image]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableview reloadData];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image)
    {
        if (self.selectedFileModel.try_inputDetail == self.selectedFileModel.inputDetail) {
            self.selectedFileModel.try_inputDetail = [NSMutableArray array];
        }
        
        [self.selectedFileModel.try_inputDetail addObject:[[ApplicationAttachmentModel alloc] initWithLocalImage:image]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableview reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NewApplyAddApplyTitleTableViewCell Delegate
- (void)textViewCell:(NewApplyAddApplyTitleTableViewCell *)cell didChangeText:(NSString *)text needreload:(BOOL)need
{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    NewApplyFormBaseModel *model = [self.model.arrFormModels objectAtIndex:indexPath.row];
    model.try_inputDetail = text;
    
    if (need)
    {
        [self.tableview beginUpdates];
        [self.tableview endUpdates];
    }
}

#pragma mark - Time Delegate
- (void)callBackWithDic:(NSDictionary *)dic {
    NewApplyFormBaseModel *model = self.actionSheetView.identifier;
    
    NSDate *start = dic[@"StartTime"];
    NSDate *end   = dic[@"EndTime"];
    
    if ([dic[@"WholeDay"] boolValue]) {
        start = [NSDate dateWithYear:start.year month:start.month day:start.day];
        end   = [NSDate dateWithYear:end.year month:end.month day:end.day];
    }
    
    NSDictionary *resultDict = @{NewForm_startTime:start,NewForm_endTime:end};
    model.try_inputDetail = resultDict;
    [self.tableview reloadData];
}

#pragma mark - ApplyAddDeadLineActionSheetView Delegate
- (void)ApplyAddDeadlineActionSheetViewDelegateCallBack_date:(NSDate *)date {
    NewApplyFormBaseModel *model = self.deadLineView.identifier;
    model.try_inputDetail = date;
    [self.tableview reloadData];
}

#pragma mark - MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [[self.selectedFileModel try_inputDetail] count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [self numberOfPhotosInPhotoBrowser:photoBrowser])
    {
        ApplicationAttachmentModel *attachment = [[self.selectedFileModel try_inputDetail] objectAtIndex:index];
        if (attachment.localPath)
        {
            return [MWPhoto photoWithImage:attachment.originalImage];
        }
        
        return [MWPhoto photoWithURL:[NSURL URLWithString:attachment.path]];
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    [UIActionSheet showInView:self.view
                    withTitle:LOCAL(APPLY_DELETE_PICTURE)
            cancelButtonTitle:LOCAL(CANCEL)
       destructiveButtonTitle:LOCAL(DELETE)
            otherButtonTitles:nil
                     tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex)
    {
        if (buttonIndex != 0) {
            return;
        }
        
        if ([self.selectedFileModel try_inputDetail] == [self.selectedFileModel inputDetail]) {
            self.selectedFileModel.try_inputDetail = [NSMutableArray arrayWithArray:[self.selectedFileModel inputDetail]];
        }
        
        [self.selectedFileModel.try_inputDetail removeObjectAtIndex:index];
        [photoBrowser reloadData];
        [self.tableview reloadData];
        
        if (![[self.selectedFileModel try_inputDetail] count]) {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
}


#pragma mark - RequestDelegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[NewApplyGetFormInfoResponse class]])
    {
        [self hideLoading];
        NewApplyGetFormInfoResponse *InfoResponse = (NewApplyGetFormInfoResponse *)response;
        self.model = InfoResponse.model;
        self.model.formStr = InfoResponse.formStr;
        self.formId = InfoResponse.strFormID;
        [self.tableview reloadData];
    }
    
    else if ([request isKindOfClass:[AttachmentUploadRequest class]])
    {
        NSArray *arrayAttach = self.uploadAttachModel.try_inputDetail;
        ApplicationAttachmentModel *attachModel = [arrayAttach objectAtIndex:[(AttachmentUploadResponse *)response identifier]];
        attachModel.showId = [(id)response attachmentShowId];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"showId != nil && showId.length > 0"];
        NSArray *arrayUploaded = [arrayAttach filteredArrayUsingPredicate:predicate];
        
        BOOL isSuccess = [arrayUploaded count] == [arrayAttach count];
        [self postProgress:(1.0 * [arrayUploaded count] / [arrayAttach count])];
        
        if (!isSuccess) {
            return;
        }
        
        [self postLoading];
        if (self.applytype == newapply_type_edit) {
            // TODO: 编辑
            
        }
        
        else {
            // 新建
            NewApplyCreateV2Request *request = [[NewApplyCreateV2Request alloc] initWithDelegate:self];
            [request approveNewWithApproveShowId:self.strApplyShowID workflowId:self.strworkflowID formId:self.formId model:self.model];
        }
    }
    
    else if ([request isKindOfClass:[NewApplyCreateV2Request class]])
    {
        [self hideLoading];
        [self postSuccess:LOCAL(APPLY_APPLY_SUCCESS)];

        [[NSNotificationCenter defaultCenter] postNotificationName:MCApplyListDataDidRefreshNotification object:nil];
        NSNotification *notification = [NSNotification notificationWithName:@"turntosender" object:@(1)];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - init
- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.backgroundColor = [UIColor grayBackground];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
        _tableview.separatorInset = UIEdgeInsetsMake(0, 13, 0, 0);
        if ([_tableview respondsToSelector:@selector(setLayoutMargins:)]) {
            _tableview.layoutMargins = UIEdgeInsetsMake(0, 13, 0, 0);
        }
        
        [_tableview registerClass:[ApplyDeadlineTableViewCell class] forCellReuseIdentifier:[ApplyDeadlineTableViewCell identifier]];
        [_tableview registerClass:[ApplicationAttachmentTableViewCell class] forCellReuseIdentifier:[ApplicationAttachmentTableViewCell identifier]];
    }
    return _tableview;
}

- (ApplyAddPeriodActionSheetView *)actionSheetView {
    if (!_actionSheetView) {
        _actionSheetView = [[ApplyAddPeriodActionSheetView alloc] initWithFrame:self.view.frame];
        _actionSheetView.delegate = self;
    }
    return _actionSheetView;
}

- (ApplyAddDeadlineActionSheetView *)deadLineView {
    if (!_deadLineView) {
        _deadLineView = [[ApplyAddDeadlineActionSheetView alloc] initWithFrame:self.view.frame];
        _deadLineView.showWholeDayMode = NO;
        _deadLineView.delegate = self;
        [_deadLineView showWholeDay:NO];
    }
    return _deadLineView;
}

- (NSMutableDictionary *)multiLineInputDictionary {
    if (!_multiLineInputDictionary) {
        _multiLineInputDictionary = [NSMutableDictionary dictionary];
    }
    return _multiLineInputDictionary;
}

@end
