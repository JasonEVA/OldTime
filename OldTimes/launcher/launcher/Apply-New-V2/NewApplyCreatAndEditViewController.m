//
//  NewApplyCreatAndEditViewController.m
//  launcher
//
//  Created by Dee on 16/8/9.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  用于审批的新建和编辑

#import "NewApplyCreatAndEditViewController.h"
#import "NewApplyGetFormInfoV2Request.h"
#import "NewApplyAllFormModel.h"
#import <Masonry.h>
#import "NewApplyFormBaseModel.h"
#import "NewApplyFormTimeModel.h"
#import "UIFont+Util.h"
#import "NSDate+String.h"
#import "NSDate+Date.h"
#import <NSDate+DateTools.h>
#import "ApplicationAttachmentModel.h"
#import "MyDefine.h"
#import "NSDictionary+SafeManager.h"
#import "AttachmentUploadRequest.h"
//#import "ApplyTextFieldTableViewCell.h"
//#import "ApplyTextViewTableViewCell.h"
//#import "ApplyDetailTableViewCell.h"
//#import "ApplicationAttachmentTableViewCell.h"

#pragma mark - cells
#import "NewApplyAddApplyTitleTableViewCell.h"
#import "ApplyNameRightTableViewCell.h"
#import "NewApplyAtttachmentTableviewCell.h"
#import "NewApplySwitchTableViewCell.h"
#import "NewApplyExpendTxtFieldV2TableViewCell.h"
#import "NewApplyTextViewCell.h"
#import "NewApplyDetailTableViewCell.h"
#import "NewApplyNameRightTableViewCell.h"

#pragma mark - click
#import "MultiAndSingleChooseViewController.h"
#import "ApplyAddPeriodActionSheetView.h"
#import "ApplyAddDeadlineActionSheetView.h"
#import "SelectContactBookViewController.h"

#pragma mark - others
#import "ContactPersonDetailInformationModel.h"
#import "NewApplyFormPeopleModel.h"
#import "NewApplyMakeApplyRequet.h"
#import "NewApplyEditApplyRequest.h"
#import "GetLastApproveMemberRequest.h"

#import "ApplyDetailInformationModel.h"

#import "MWPhotoBrowser.h"
#import "UIActionSheet+Blocks.h"
#import "WZPhotoPickerController.h"
#import <MJExtension.h>

//最多照片数量
static NSInteger const maxImageCount = 9;
typedef NS_ENUM(NSInteger , CurrentActionType) {
    kNew_Apply_Add = 0,
    kNew_Apply_Edit
};

static NSString *const MCApplyListDataDidRefreshNotification = @"isNeedRefresh";

static NSString *const NewForm_deadLine = @"deadline";
static NSString *const NewForm_isDeadLineAllDay = @"isDeadLineAllDay";


@interface NewApplyCreatAndEditViewController ()<BaseRequestDelegate,UITableViewDelegate, UITableViewDataSource>
//表单数据
@property(nonatomic, strong) NewApplyAllFormModel *formModel;

@property(nonatomic, strong) UITableView  *tableview;

@property(nonatomic, strong) NSMutableDictionary  *multiLineInputDictionary;

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
//附件操作相关
@property (nonatomic, strong) NewApplyFormBaseModel *selectedFileModel;

@property (nonatomic, assign) CGFloat canComeCellRowHeight;
@property (nonatomic, assign) CGFloat mustComeCellRowHeight;
//当前操作：编辑／新建
@property(nonatomic, assign) CurrentActionType  currentActionType;
//是否紧急
@property(nonatomic, assign) BOOL  isUrgent;
////存放当前选择的section，switch开关居然表单里没有！！！
//@property(nonatomic, assign) NSInteger  currentSection;
//存放输入框的位置和大小，用于处理键盘遮挡事件
@property(nonatomic, assign) CGRect  currentRect;
//时间空件
@property(nonatomic, strong) ApplyAddPeriodActionSheetView  *actionSheetView;
//截止时间空件
@property(nonatomic, strong) ApplyAddDeadlineActionSheetView  *deadLineView;
//审批人
@property(nonatomic, strong) NSMutableArray  *mustSelectArray;
//抄送人
@property(nonatomic, strong) NSMutableArray  *notMustSelectArray;
//编辑或者新建
@property(nonatomic, assign) ApplyType  applytype;
//至今没发现有什么作用
@property(nonatomic, copy) NSString  *workFlowID;
//上传文件相关
@property (nonatomic, strong) NewApplyFormBaseModel *uploadAttachModel;
//存放编辑时穿过来的数据model
@property(nonatomic, strong) ApplyDetailInformationModel  *editModel;
//存放附件
@property(nonatomic, strong) NSMutableArray  *attachMentModelArray;

@end

@implementation NewApplyCreatAndEditViewController

- (instancetype)initWithFormID:(NSString *)formID WorkFlowID:(NSString *)workflowid ApplyType:(ApplyType)type
{
    if (self = [super init]) {
        if (type == kNewApply_Type_Add) {
            NewApplyGetFormInfoV2Request *request =[[NewApplyGetFormInfoV2Request alloc] initWithDelegate:self];
            [request getFormWithFormID:formID];
            [self postLoading];
        }
        
        self.applytype = type;
        self.workFlowID = workflowid;
        
    }
    return self;
}

- (instancetype)editWithFormID:(NSString *)formID WorkFlowID:(NSString *)workflowID EditModel:(ApplyDetailInformationModel *)editModel attachMentArray:(NSMutableArray *)array
{
    self.editModel = editModel;
    self.isUrgent = editModel.A_IS_URGENT > 0;
    self.attachMentModelArray = array;
    [self handleDataWithDict:editModel];
    return [self initWithFormID:formID WorkFlowID:workflowID ApplyType:kNewApply_Type_Edit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(APPLY_SEND) style:UIBarButtonItemStylePlain target:self action:@selector(clickToSend)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.mustComeCellRowHeight = 47;
    self.canComeCellRowHeight  = 47;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.applytype == kNew_Apply_Edit) {
        [self.view addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.tableview reloadData];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clickToSend {
    [self.view endEditing:YES];
    
    if (self.isLoading) {
        return;
    }
    
    //TODO: 需要重新整理
    __block BOOL checkInfo = YES;
    [self.formModel.arrFormModels enumerateObjectsUsingBlock:^(NewApplyFormBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //处理审批期限，并且审批期限必填 － 别删
        if (obj.inputType == Form_inputType_approvePeriod && self.isUrgent && obj.required) {
            
        }   //warn补丁
        else if (obj.required && [obj.try_inputDetail isKindOfClass:[NSDictionary class]] &&[obj.labelText isEqualToString:@"审批人"]&&[[obj.try_inputDetail valueForKey:@"showingName"] isEqualToString:@""]) {
            *stop = YES;
            checkInfo = NO;
            [self postError:[NSString stringWithFormat:LOCAL(INPUT_ERROR), obj.labelText]];
        }
        else if(obj.required && [obj.try_inputDetail isKindOfClass:[NSDictionary class]] &&[obj.labelText isEqualToString:@"抄送"]&&[[obj.try_inputDetail valueForKey:@"showingName"] isEqualToString:@""])
        {
            *stop = YES;
            checkInfo = NO;
            [self postError:[NSString stringWithFormat:LOCAL(INPUT_ERROR), obj.labelText]];
        }else if(obj.required && [obj.try_inputDetail isKindOfClass:[NSString class]] &&(!obj.try_inputDetail ||[obj.try_inputDetail isEqualToString:@""]))
        {
            *stop = YES;
            checkInfo = NO;
            [self postError:[NSString stringWithFormat:LOCAL(INPUT_ERROR), obj.labelText]];
        }
        else if (obj.required && !obj.try_inputDetail) {
            *stop = YES;
            checkInfo = NO;
            [self postError:[NSString stringWithFormat:LOCAL(INPUT_ERROR), obj.labelText]];
        }
    }];
    
    if (!checkInfo) {
        return;
    }

    __block BOOL attachUpload = NO;
    [self.formModel.arrFormModels enumerateObjectsUsingBlock:^(NewApplyFormBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
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
        [self postLoading];
        return;
    }
    
    [self postLoading];
    switch (self.applytype) {
        case kNewApply_Type_Edit:
        {
            NewApplyEditApplyRequest *request = [[NewApplyEditApplyRequest alloc] initWithDelegate:self];
            [request editApplyWithApplyTypeShowID:self.editModel.T_SHOW_ID
                                       workflowId:self.workFlowID 
                                      ApplyShowID:self.editModel.SHOW_ID 
                                   dateModelArray:self.formModel
                                         isUrgent:self.isUrgent];
            
        }
            break;
        case kNewApply_Type_Add: {
            [self postLoading];
            
            NewApplyMakeApplyRequet *request = [[NewApplyMakeApplyRequet alloc] initWithDelegate:self];
            [request createApplyWithApplyShowID:self.applyTypeShowID
                                     workflowId:self.workFlowID
                                 dateModelArray:self.formModel
                                       isUrgent:self.isUrgent];
        }
            break;
    }
}


#pragma mark - tabeleviewDelegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.formModel.showFormModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //单独处理审批期限
    NSArray*tempArr = self.formModel.showFormModels[section];
    if (tempArr.count == 2) {
        NewApplyFormBaseModel *model = tempArr[1];
        if (model.inputType == Form_inputType_approvePeriod && self.isUrgent) {
            return 1;
        }
    }
    
    return [self.formModel.showFormModels[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view updateConstraints];
    NewApplyFormBaseModel *model = self.formModel.showFormModels[indexPath.section][indexPath.row];
    switch (model.inputType)
    {
        case Form_inputType_textArea:
        {
            if ([model.labelText isEqualToString:@"备注"]) {
                return 90;
            }else
            {
                return 70;
            }
        }
             ;
        case Form_inputType_requiredPeopleChoose: return self.mustComeCellRowHeight;
        case Form_inputType_ccPeopleChoose: return self.canComeCellRowHeight;
        case Form_inputType_file:
        {
            return [NewApplyAtttachmentTableviewCell heightForCellWithImageCount:[[model try_inputDetail] count] accessoryMode:YES];
        }
        case Form_inputType_textInput:
        case Form_inputType_timePoint:
        case Form_inputType_singleChoose:
        case Form_inputType_multiChoose:
        case Form_inputType_timeSlot:
        case Form_inputType_approvePeriod:
        case Coustom_inputtype_Switch:
            return 47;
        case Form_inputType_unknown:
        default: return 0.01;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewApplyFormBaseModel *currentFormModel = self.formModel.showFormModels[indexPath.section][indexPath.row];
    UITableViewCell *cell;
    switch (currentFormModel.inputType) {
        case Form_inputType_textInput:
        {
            NewApplyExpendTxtFieldV2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewApplyExpendTxtFieldV2TableViewCell identifier]];
            if (!cell)
            {
                cell = [[NewApplyExpendTxtFieldV2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewApplyExpendTxtFieldV2TableViewCell identifier] isAccountType:[currentFormModel.labelText isEqualToString:@"金额"]];
            }
            [cell setDataWithModel:currentFormModel];
            [cell getLocationWithBlock:^(CGRect currentRect) {
                self.currentRect = currentRect;
            }];
            return cell;
        }
            break;
        case Form_inputType_textArea:
        {

            NewApplyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewApplyTextViewCell identifier]];
            [cell getLocationWithBlock:^(CGRect currentRect) {
                self.currentRect = currentRect;
            }];
            [cell setDataWithModel:currentFormModel];
            return cell;
        }
            break;
        case Form_inputType_timeSlot:
        case Form_inputType_timePoint:
        case Form_inputType_approvePeriod:
        {
            NewApplyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewApplyDetailTableViewCell identifier]];
            if (!cell)
            {
                cell = [[NewApplyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewApplyDetailTableViewCell identifier]];
                [cell textLabel].textColor  = [UIColor blackColor];
                [cell textLabel].font = [UIFont mtc_font_30];
            }
        
            [cell textLabel].text = currentFormModel.labelText;
            
            if (currentFormModel.inputType == Form_inputType_approvePeriod) {
                if (currentFormModel.try_inputDetail && currentFormModel.try_inputDetail != [NSNull null]) {
                    NSDate *deadline = [currentFormModel.try_inputDetail valueDateForKey:NewForm_deadLine];
                    BOOL isWholeDay  = [currentFormModel.try_inputDetail valueBoolForKey:NewForm_isDeadLineAllDay] ;
                    if (deadline){
                        [cell applyDetailLabel].text = [NSDate mtc_getDateStrWihtDate:deadline
                                                                           isWholeDay:isWholeDay];
                    }
                }
            }
            else if (currentFormModel.inputType == Form_inputType_timePoint){
                if (currentFormModel.try_inputDetail && currentFormModel.try_inputDetail[NewForm_startTime] != [NSNull null]) {
                    NSDate *startTime = [currentFormModel.try_inputDetail valueDateForKey:NewForm_startTime];
                    BOOL isWholeDay  = [currentFormModel.try_inputDetail valueBoolForKey:NewForm_isTimeSlotAllDay] ;
                    if (startTime){
                        [cell applyDetailLabel].text = [NSDate mtc_getDateStrWihtDate:startTime
                                                                           isWholeDay:isWholeDay];
                    }
                }
            }
            else{
                NSDictionary *dict = currentFormModel.try_inputDetail;
                if (dict && dict[NewForm_startTime] != [NSNull null]) {
                    NSDate *start = [dict valueDateForKey:NewForm_startTime];
                    NSDate *end = [dict valueDateForKey:NewForm_endTime];
                    BOOL isWholeday = [dict valueBoolForKey:NewForm_isTimeSlotAllDay];
                    [cell applyDetailLabel].text = [self stringFromStart:start end:end isAllDay:isWholeday];
                }
            }
            return cell;
        }
            break;
        case Form_inputType_requiredPeopleChoose:
        case Form_inputType_ccPeopleChoose:
        {
            NewApplyNameRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewApplyNameRightTableViewCell identifier]];
            if (!cell)
            {
                cell = [[NewApplyNameRightTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NewApplyNameRightTableViewCell identifier]];
                [cell setIsEdit:YES];
                [cell setSeparatorInset:UIEdgeInsetsZero];
                if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            
            [cell myTextLabel].text = currentFormModel.labelText;
            [cell setNameField:[currentFormModel try_inputDetail][NewForm_showingName]];
            NSLog(@"%@",[currentFormModel try_inputDetail][NewForm_showingName]);
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
            cell.textLabel.text = currentFormModel.labelText;
            id value = [currentFormModel try_inputDetail];
            if ([value isKindOfClass:[NSArray class]]) {
                cell.detailTextLabel.text = [value componentsJoinedByString:@","];
            }else if([value isKindOfClass:[NSString class]]) {
                cell.detailTextLabel.text = value;
            }
            
            return cell;
        }
            break;
        case Form_inputType_file:
        {
            NewApplyAtttachmentTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewApplyAtttachmentTableviewCell identifier] forIndexPath:indexPath];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell clickToSeeImage:^(NSUInteger clickedIndex) {
                [self selectShowImageAtIndex:clickedIndex model:currentFormModel];
            }];
            [cell setTitleLabelText:currentFormModel.labelText];
            [cell setImages:[currentFormModel try_inputDetail]];
            return cell;
        }
            break;
        case Coustom_inputtype_Switch: // 自定义开关
        {
            NewApplySwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewApplySwitchTableViewCell identifier]];
            cell.textLabel.text = currentFormModel.labelText;
            cell.textLabel.textColor = [UIColor blackColor];
            [cell setSwitchColor:[UIColor themeRed]];
            [cell isOn:self.isUrgent];
            cell.switchType = CalendarSwitchTypeImportant;
            [cell calendarSwitchDidChange:^(CalendarSwitchType swithType, BOOL isOn) {
                self.isUrgent = isOn;
                currentFormModel.try_inputDetail = @(self.isUrgent);
                [self.tableview reloadData];
            }];
            return cell;
        }

        default:
            break;
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger currentIndex = indexPath.section * 10 + indexPath.row;
    NewApplyFormBaseModel *model = self.formModel.showFormModels[indexPath.section][indexPath.row] ;
    
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
            
            if (dict &&dict[NewForm_startTime] != [NSNull null]) {
                NSDate *start = [NSDate getDate:dict[NewForm_startTime]] ;
                NSDate *end = [NSDate getDate:dict[NewForm_endTime]];
                BOOL isWholeDay = [dict[NewForm_isTimeSlotAllDay] boolValue];
                [self.actionSheetView setStartDate:start endDate:end WholeDay:isWholeDay];
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
            //编辑的时候审批人无法修改
            if (self.applytype == kNew_Apply_Edit) {
                return;
            }
            
            NSArray *selectedArray = model.inputType == Form_inputType_requiredPeopleChoose ? self.mustSelectArray : self.notMustSelectArray;
            NSArray *unableArray = self.mustSelectArray == selectedArray ? self.notMustSelectArray : self.mustSelectArray;
            
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
                
                //保存model
                model.try_inputDetail[NewForm_modelArray]  = array;
                //保存姓名
                model.try_inputDetail[NewForm_showingName] = approveName;
                
                if (model.inputType == Form_inputType_ccPeopleChoose) {
                    strongSelf.canComeCellRowHeight = [strongSelf getRowNumberWithData:[approveName componentsSeparatedByString:@"●"]];
                    strongSelf.notMustSelectArray = array;
                }
                else {
                    strongSelf.mustComeCellRowHeight = [strongSelf getRowNumberWithData:[approveName componentsSeparatedByString:@"●"]];
                    strongSelf.mustSelectArray = array;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15; }

#pragma mark - TimeDelagete
//时间iD
- (void)callBackWithDic:(NSDictionary *)dic {
    NewApplyFormBaseModel *model = self.actionSheetView.identifier;
    NSDate *start = dic[@"StartTime"];
    NSDate *end   = dic[@"EndTime"];
    BOOL iswholeDay = [dic[@"WholeDay"] boolValue];
    NSDictionary *resultDict = @{NewForm_startTime:@([NSDate getTimeStamp:start]),NewForm_endTime:@([NSDate getTimeStamp:end]),NewForm_isTimeSlotAllDay:iswholeDay?@(1):@(0)};
    model.try_inputDetail = resultDict;
    [self.tableview reloadData];
}
#pragma mark - ApplyAddDeadLineActionSheetView Delegate

- (void)ApplyAddDeadlineActionSheetViewDelegateCallBack_date:(NSDate*)date isWholeDay:(BOOL)wholeDay
{
    NewApplyFormBaseModel *model = self.deadLineView.identifier;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (model.inputType == Form_inputType_timePoint) {
        [dict setValue:wholeDay?@(1):@(0) forKey:NewForm_isTimeSlotAllDay];
        long long startTime = [NSDate getTimeStamp:date];
        [dict setValue:@(startTime) forKey:NewForm_startTime];
    }
    else
    {
        [dict setValue:wholeDay?@(1):@(0) forKey:NewForm_isDeadLineAllDay];
        long long deadline = [NSDate getTimeStamp:date];
        [dict setValue:@(deadline) forKey:NewForm_deadLine];
    }
    
    model.try_inputDetail = dict;
    
    [self.tableview reloadData];
}



#pragma mark - BasereeuestDelegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    //get the form detail
    if ([request isKindOfClass:[NewApplyGetFormInfoV2Request class]]) {
        
        self.formModel = [(NewApplyGetFormInfoV2Response *)response formModel];
        [self.view addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.tableview reloadData];
        [self hideLoading];
        
        
        if (self.applytype == kNew_Apply_Add) {
            GetLastApproveMemberRequest *request = [[GetLastApproveMemberRequest alloc] initWithDelegate:self];
            [request getLastApproveMemeberRequest];
            [self postLoading];
        }
        
    }
    else if([response isKindOfClass:[NewApplyMakeApplyResponse class]]) {
        [self hideLoading];
        [self postSuccess:LOCAL(SENDER_SUCCESS)];
        [self RecordToDiary:[NSString stringWithFormat:@"新建审批成功:%@",self.applyTypeShowID]];
        [[NSNotificationCenter defaultCenter] postNotificationName:MCApplyListDataDidRefreshNotification object:nil];
        NSNotification *notification = [NSNotification notificationWithName:MCApplyListDataDidRefreshNotification object:@(1)];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:1.0];
    }else if([request isKindOfClass:[NewApplyEditApplyRequest class]])
    {
        [self hideLoading];
        [self postSuccess:LOCAL(SENDER_SUCCESS)];
        [self RecordToDiary:[NSString stringWithFormat:@"编辑审批成功:%@",self.applyTypeShowID]];
        [[NSNotificationCenter defaultCenter] postNotificationName:MCApplyListDataDidRefreshNotification object:nil];
        NSNotification *notification = [NSNotification notificationWithName:MCApplyListDataDidRefreshNotification object:@(1)];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:1.0];
    }
    else if([request isKindOfClass:[AttachmentUploadRequest class]]){
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
        if (self.applytype == kNewApply_Type_Edit) {
            //  编辑
            NewApplyEditApplyRequest *request = [[NewApplyEditApplyRequest alloc] initWithDelegate:self];
            [request editApplyWithApplyTypeShowID:self.editModel.T_SHOW_ID
                                       workflowId:self.workFlowID
                                      ApplyShowID:self.editModel.SHOW_ID
                                   dateModelArray:self.formModel
                                         isUrgent:self.isUrgent];
        }
        
        else {
            // 新建
            NewApplyMakeApplyRequet *request = [[NewApplyMakeApplyRequet alloc] initWithDelegate:self];
            [request createApplyWithApplyShowID:self.applyTypeShowID
                                     workflowId:self.workFlowID
                                 dateModelArray:self.formModel
                                       isUrgent:self.isUrgent];
        }

    }
    else if([request isKindOfClass:[GetLastApproveMemberRequest class]])
    {
        if ([response isKindOfClass:[NSDictionary class]]) {
            
            ContactPersonDetailInformationModel *contactModel = [[ContactPersonDetailInformationModel alloc] init];
            
            NSDictionary *dict = (NSDictionary *)response;
            
            [self handleDataForlastApplyMemberWithDict:dict];
            
            [self hideLoading];
            [self.tableview reloadData];
        }
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self hideLoading];
    [self postError:errorMessage];
}


- (void)popAction
{
    [self popToDetialApplyViewController];
}

- (void)popToDetialApplyViewController {
    if ([self.navigationController.childViewControllers objectAtIndex:1]) {
        [self.navigationController popToViewController:self.navigationController.childViewControllers [1] animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)handleDataForlastApplyMemberWithDict:(NSDictionary*)dict
{
    NSMutableArray *approveArray = [[dict valueMutableArrayForKey:@"aApprove"] mutableCopy];
    NSMutableArray *ccArray = [[dict valueMutableArrayForKey:@"aCc"] mutableCopy];
    NSMutableArray *approveNameArray = [[dict valueMutableArrayForKey:@"aApproveName"] mutableCopy];
    NSMutableArray *ccNameArray = [[dict valueMutableArrayForKey:@"aCcName"] mutableCopy];

    NSString *approveNameStr = [approveNameArray componentsJoinedByString:@"●"];
    NSString *ccNameStr = [ccNameArray componentsJoinedByString:@"●"];
    
    //抄送人model数组
    NSMutableArray *ccInfoArray = [NSMutableArray array];
    [ccNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ContactPersonDetailInformationModel *ccModel = [[ContactPersonDetailInformationModel alloc] init];
        ccModel.u_true_name = obj;
        ccModel.show_id = ccArray[idx];
        [ccInfoArray addObject:ccModel];
    }];
    self.notMustSelectArray = ccInfoArray;
    self.canComeCellRowHeight = [self getRowNumberWithData:ccNameArray];
    
    //审批人model数组
    NSMutableArray *approveInfoArray = [NSMutableArray array];
    [approveNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ContactPersonDetailInformationModel *approveModel = [[ContactPersonDetailInformationModel alloc] init];
        approveModel.u_true_name = obj;
        approveModel.show_id = approveArray[idx];
        [approveInfoArray addObject:approveModel];
    }];
    self.mustSelectArray = approveInfoArray;
    self.mustComeCellRowHeight = [self getRowNumberWithData:approveNameArray];
    
    [self.formModel.arrFormModels enumerateObjectsUsingBlock:^(NewApplyFormBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //找到对应的model
        
        if (obj.inputType == Form_inputType_requiredPeopleChoose) {
            if (approveArray.count) {
                if (!obj.try_inputDetail) {
                    obj.try_inputDetail = [[NSMutableDictionary alloc] init];;
                }
                obj.try_inputDetail[NewForm_showingName] = approveNameStr;
                obj.try_inputDetail[NewForm_modelArray] = approveInfoArray;
            }
        }else if(obj.inputType == Form_inputType_ccPeopleChoose){
            if (ccArray.count) {
                if (!obj.try_inputDetail) {
                    obj.try_inputDetail = [[NSMutableDictionary alloc] init];;
                }
                obj.try_inputDetail[NewForm_modelArray] = ccInfoArray;
                obj.try_inputDetail[NewForm_showingName] = ccNameStr;
            }
        }
    }];

}

#pragma mark - UIKeyBoardNotification
//根据输入框的位置动态处理处理视图位置
- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *dict = noti.userInfo;
    CGRect endRect = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animtionTime = [dict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (self.currentRect.origin.y > endRect.origin.y) {
        CGFloat transform_Y = self.currentRect.origin.y - endRect.origin.y + self.currentRect.size.height + 10;
        
        [UIView animateWithDuration:animtionTime animations:^{
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -transform_Y);
            self.tableview.transform = transform;
        }];
    }
}



- (void)keyboardWillHide:(NSNotification *)noti
{
    NSDictionary *dict = noti.userInfo;
    CGFloat animtionTime = [dict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animtionTime animations:^{
        self.tableview.transform = CGAffineTransformIdentity;
    }];
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

#pragma mark - keyBoardDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableview) {
        [self.view endEditing:YES];
    }
}

#pragma mark - privateMethod
- (void)handleDataWithDict:(ApplyDetailInformationModel*)model
{
    //从json字符串中获取有用的字段
    NSArray *dataArray = [model.formDataJSONString mj_JSONObject];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj valueForKey:@"value"] != nil && [obj valueForKey:@"key"] != nil) {
            [dict setObject:[obj valueForKey:@"value"] forKey:[obj valueForKey:@"key"]];
        }
        
    }];
    [model.allFormModel.arrFormModels enumerateObjectsUsingBlock:^(NewApplyFormBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.try_inputDetail = [dict valueForKey:obj.key];
    }];
    
    //从其他字段中获取对应的数据
    [model.allFormModel.arrFormModels enumerateObjectsUsingBlock:^(NewApplyFormBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.inputType == Form_inputType_ccPeopleChoose) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSArray *tempNameArray = [model.A_CC_NAME componentsSeparatedByString:@"●"];
            NSArray *tempShowIDArray = [model.A_CC componentsSeparatedByString:@"●"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [tempNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ContactPersonDetailInformationModel *personMolde = [[ContactPersonDetailInformationModel alloc] init];
                personMolde.u_true_name = obj;
                personMolde.show_id = tempShowIDArray[idx];
                [modelArray addObject:personMolde];
            }];
            
            [dict setValue:model.A_CC_NAME forKey:NewForm_showingName];
            [dict setValue:modelArray forKey:NewForm_modelArray];
            obj.try_inputDetail = dict;
        }
        else if (obj.inputType == Form_inputType_approvePeriod) {
            
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            NSMutableArray *tempModelArray = [NSMutableArray array];
            ContactPersonDetailInformationModel *personModel = [[ContactPersonDetailInformationModel alloc] init];
            personModel.show_id = model.A_APPROVE;
            personModel.u_true_name = model.A_APPROVE_NAME;
            [tempModelArray addObject:personModel];
            [dict setObject:tempModelArray forKey:NewForm_modelArray];
            [tempDict setValue:model.A_APPROVE_NAME forKey:NewForm_showingName];
        }
        else if(obj.inputType == Form_inputType_file){
            obj.try_inputDetail = self.attachMentModelArray;
        }
        
    }];
    
    self.formModel = model.allFormModel;
    self.formModel.formStr = model.A_MESSAGE_FORM;
    self.formModel.formId  = model.A_FORM_INSTANCE_ID;
    self.isUrgent = model.try_A_IS_URGENT;
    [self.formModel sortForCreateUI];
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


- (NSString *)stringFromStart:(NSDate *)startDate end:(NSDate *)endDate isAllDay:(BOOL)AllDay
{
    NSString *str;
    if (AllDay) return str = [startDate mtc_startToEndDate:endDate wholeDay:YES];
    str = [startDate mtc_startToEndDate:endDate wholeDay:AllDay];
    
    return str;
}


- (NewApplyAddApplyTitleTableViewCell *)textViewCellFromModel:(NewApplyFormBaseModel *)model {
    NewApplyAddApplyTitleTableViewCell *cell = self.multiLineInputDictionary[model.key];
    if (cell) {
        [cell setDataWithModel:model];
        return cell;
    }
    
    cell = [[NewApplyAddApplyTitleTableViewCell alloc] init];
    [cell setDataWithModel:model];
    cell.delegate = self;
    cell.placeholderLabel.text = [(id)model placeholder];
    cell.tvwTitle.text = [(id)model try_inputDetail];
    self.multiLineInputDictionary[model.key] = cell;
    
    return cell;
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

#pragma mark - setterAndGetter
- (UITableView *)tableview
{
    if (!_tableview)  {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
       [_tableview setSeparatorInset:UIEdgeInsetsZero];
        [_tableview registerClass:[NewApplyAtttachmentTableviewCell class] forCellReuseIdentifier:[NewApplyAtttachmentTableviewCell identifier]];
        [_tableview registerClass:[NewApplySwitchTableViewCell class] forCellReuseIdentifier:[NewApplySwitchTableViewCell identifier]];
        [_tableview registerClass:[NewApplyTextViewCell class] forCellReuseIdentifier:[NewApplyTextViewCell identifier]];
    }
    return _tableview;
}

- (NSMutableDictionary *)multiLineInputDictionary {
    if (!_multiLineInputDictionary) {
        _multiLineInputDictionary = [NSMutableDictionary dictionary];
    }
    return _multiLineInputDictionary;
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
        _deadLineView.showWholeDayMode = YES;
        _deadLineView.delegate = self;
        [_deadLineView showWholeDay:NO];
    }
    return _deadLineView;
}


@end
