//
//  ApplyAddNewUserDefinedViewController.m
//  launcher
//
//  Created by conanma on 15/11/5.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplyAddNewUserDefinedViewController.h"
#import "NewApplyAddNewApplyV2ViewController.h"
#import "ApplyStyleKeyRequest.h"
#import "ApplyTextViewTableViewCell.h"
#import "ApplyTextFieldTableViewCell.h"
#import "ApplyDetailTableViewCell.h"
#import "ApplyDeadlineTableViewCell.h"
#import "MyDefine.h"
#import "Category.h"
#import "UIColor+Hex.h"
#import "ApplyAddPeriodActionSheetView.h"
#import "ApplyAddDeadlineActionSheetView.h"
#import "ApplicationAttachmentTableViewCell.h"
#import "WZPhotoPickerController.h"
#import "ContactPersonDetailInformationModel.h"
#import "ApplyNameRightTableViewCell.h"
#import "ApplyAddNewApplyRequest.h"
#import "ApplyEditApplyRequest.h"
#import <DateTools/DateTools.h>
#import "MWPhotoBrowser.h"
#import "AttachmentUploadRequest.h"
#import "AttachmentUtil.h"
#import "SelectContactBookViewController.h"
#import "ApplicationAttachmentModel.h"
#import <Masonry/Masonry.h>
#import "ApplyAddExpendTxtFieldTableViewCell.h"
#import "MixpanelMananger.h"

//字典中存的key
#define STARTTIME @"StartTime"    //开始时间
#define ENDTIME   @"EndTime"      //终了时间
#define WHOLEDAY  @"WholeDay"     //整天

#define VOCATION  @"vEyVJ7K29qcovp3p"

static NSInteger const maxImageCount = 9;

typedef  enum
{
    cellTitle = 0,                //标题
    cellAccept = 10,              //承认人
    cellCC = 11,                  //抄送
    cellPriority = 20,            //优先级
    cellDeadLine = 21,            //最后期限
    cellPreiod = 30,              //时间段
    cellAttachment = 40,          //附件
    cellDetil = 50                //详细
}CELLTYPE;


#warning "The File Code is never used , Please use NewestApplyAddNewUserDefinedViewController instead"
@interface ApplyAddNewUserDefinedViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ApplyAddPeriodActionSheetViewDelegate,ApplyAddDeadlineActionSheetViewDelegate, WZPhotoPickerControllerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, BaseRequestDelegate,UIActionSheetDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSString *ShowID;
@property (nonatomic, strong) NSMutableArray *arrNeedShow;
@property (nonatomic, strong) UITextField  * txtField;
/**
 *  重要性开关
 */
@property (nonatomic, strong) UISwitch  * levelSwitch;
/**
 *  最终期限开关
 */
@property (nonatomic, strong) UISwitch  * deadlineSwitch;
@property (nonatomic, strong) UITextView  * detailView;
@property (nonatomic, strong) UITableView  * tableView;
@property (nonatomic, strong) ApplyAddPeriodActionSheetView  * actionSheetView;
@property (nonatomic, strong) ApplyAddDeadlineActionSheetView  * deadLineView;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

/**
 *  期间
 */
@property( nonatomic, copy ) NSString  * periodTime;
/**
 *  承认期限
 */
@property( nonatomic, copy ) NSString  * deadLineTime;
/**
 *  标题数组
 */
@property( nonatomic, strong ) NSArray  * arrTitle;
/**
 *  附件照片view
 */
@property( nonatomic, strong ) UIImageView  * imageView;
/**
 *  附件照片数组(image)
 */
@property( nonatomic, strong ) NSMutableArray  * imageArr;
/**
 *  审批人姓名
 */
@property(nonatomic, strong) NSMutableArray  *approveNameArr;
/**
 *  抄送人姓名
 */
@property(nonatomic, strong) NSMutableArray  *CCApproveNameArr;

@property(nonatomic, assign) BOOL  apprpoveClicked;

@property(nonatomic, assign) BOOL  CCApproveClicked;

@property (nonatomic, copy) takebackImgArray takeimgarrback;

@property(nonatomic, assign) applytp applyType;
@property(nonatomic, assign) BOOL  isDeadLineWholeday;

@end

static NSInteger const photoActionSheetTag = 111;

@implementation ApplyAddNewUserDefinedViewController
- (instancetype)initWithShowID:(NSString *)showID type:(applytp)type
{
    if (self = [super init])
    {
        if (showID)
        {
            self.ShowID = showID;
            self.applyType = type;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ApplyStyleKeyRequest *request = [[ApplyStyleKeyRequest alloc] initWithDelegate:self];
    [request getShowID:self.ShowID];
    
    if (![self.model.T_NAME isEqualToString:@""] && self.model.T_NAME)
    {
        self.title = self.model.T_NAME;
    }
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(APPLY_SEND) style:UIBarButtonItemStylePlain target:self action:@selector(clickToSend)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.model.attachMentArray removeAllObjects];
    [self.model.attachMentArray addObjectsFromArray:self.arrattachment];
    
    [self.model removeAllAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - private method
//时间段设置
- (void)callBackWithDic:(NSDictionary *)dic
{
    NSDate *startTime = [dic objectForKey:STARTTIME];
    NSDate *endTime = [dic objectForKey:ENDTIME];
    self.model.try_A_START_TIME = (long)[startTime timeIntervalSince1970] *1000;
    self.model.try_A_END_TIME   = (long)[endTime timeIntervalSince1970] *1000;
    self.model.try_IS_TIMESLOT_ALL_DAY = [(NSNumber *)[dic objectForKey:WHOLEDAY] integerValue];
    
    self.periodTime = [self stringFromStart:startTime end:endTime];
    [self.tableView reloadData];
}

- (NSString*)stringFromStart:(NSDate *)startDate end:(NSDate *)endDate
{
    NSString *str;
    if (startDate.year == endDate.year && startDate.month == endDate.month && startDate.day == endDate.day)
    {
        if ( self.model.try_IS_TIMESLOT_ALL_DAY ) return str = [startDate mtc_startToEndDate:endDate wholeDay:YES];
        str = [startDate mtc_startToEndDate:endDate wholeDay:NO];
    }
    else
    {
        str = [startDate mtc_startToEndDate:endDate wholeDay:YES];
        self.model.try_IS_TIMESLOT_ALL_DAY = 1;
    }
    return str;
}

- (void)takebackarray:(takebackImgArray)takebackImgblock
{
    self.takeimgarrback = takebackImgblock;
}

- (void)clickToSend
{
    [self.view endEditing:YES];
    if (![self checkInfo]) {
        return;
    }
    
    if (self.isLoading) {
        return;
    }
    
    [self postLoading];
    self.model.T_SHOW_ID = self.ShowID;
    
    BOOL attachUpload = NO;
    for (NSInteger i = 0; i < [self.model.try_attachMentArray count]; i ++) {
        ApplicationAttachmentModel *attachment = [self.model.try_attachMentArray objectAtIndex:i];
        if (attachment.showId) {
            continue;
        }
        
        [self postProgress:0];
        AttachmentUploadRequest *uploadRequest = [[AttachmentUploadRequest alloc] initWithDelegate:self identifier:i];
        [uploadRequest uploadImageData:UIImageJPEGRepresentation(attachment.originalImage, 1.0) appShowIdType:kAttachmentAppShowIdApprove];
        attachUpload = YES;
    }
    
    if (attachUpload) {
        return;
    }
    
    [self postLoading];
    switch (self.applyType) {
        case EditApply: {
            ApplyEditApplyRequest *request = [[ApplyEditApplyRequest alloc] initWithDelegate:self];
//            [request editApplyWithModel:self.model];
        }
            break;
            
        case NewApply: {
            ApplyAddNewApplyRequest * request = [[ApplyAddNewApplyRequest alloc] initWithDelegate:self];
            [request applyAddNewApplyWithModel:self.model];
        }
            break;
    }
}

- (BOOL)isValidateNum:(NSString *)Num
{
    NSString *regex = @"[1-9]*[0-9][0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    
    NSString *str = [Num stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    return [predicate evaluateWithObject:str];
}

//设置截至时间
- (void)callBackWithDate:(NSDate *)date
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"MM/dd hh:mm"];
    NSString *deadline = [dateFormate stringFromDate:date];
    self.deadLineTime = deadline;
    self.model.try_A_DEADLINE = (long long)[date timeIntervalSince1970] *1000;
    [self.tableView reloadData];
}

- (void)closeDeadlineSwitch
{
    self.deadlineSwitch.on = NO;
}

- (void)deadLineValueChanged
{
    [self.view endEditing:YES];
    if (self.deadlineSwitch.on) {
        [self.view addSubview:self.deadLineView];
        [self.view endEditing:YES];
    }else
    {
        self.model.try_A_DEADLINE = 0;
        self.deadLineTime = @"";
        [self.tableView reloadData];
    }
}
- (void)levelStatuChanged
{
    self.model.try_A_IS_URGENT = (NSInteger)self.levelSwitch.on;
}

- (void)selectPeople:(NSArray *)selectedList {
    if (self.apprpoveClicked)
    {
        NSString *approve = @"";
        NSString *apprpveName = @"";
        NSInteger i = 0;
        for (ContactPersonDetailInformationModel *model in selectedList)
        {
            [self.approveNameArr addObject:model.u_true_name];
            approve = [approve stringByAppendingString:model.u_name];
            apprpveName = [apprpveName stringByAppendingString:model.u_true_name];
            if (i != selectedList.count -1)
            {
                approve = [approve stringByAppendingString:@"●"];
                apprpveName = [apprpveName stringByAppendingString:@"●"];
            }
            i++;
        }
        self.model.try_A_APPROVE = approve;
        self.model.try_A_APPROVE_NAME = apprpveName;
        self.apprpoveClicked = !self.apprpoveClicked;
        [self.tableView reloadData];
    }
    
    if (self.CCApproveClicked)
    {
        NSString *CCApprove = @"";
        NSString *CCApproveName = @"";
        NSInteger i = 0;
        for (ContactPersonDetailInformationModel *model in selectedList)
        {
            [self.CCApproveNameArr addObject:model.u_true_name];
            CCApprove = [CCApprove stringByAppendingString:model.u_name];
            CCApproveName = [CCApproveName stringByAppendingString:model.u_true_name];
            
            if (i != selectedList.count -1)
            {
                CCApprove = [CCApprove stringByAppendingString:@"●"];
                CCApproveName = [CCApproveName stringByAppendingString:@"●"];
            }
            i++;
        }
        self.model.try_A_CC = CCApprove;
        self.model.try_A_CC_NAME = CCApproveName;
        self.CCApproveClicked  = !self.CCApproveClicked;
        [self.tableView reloadData];
    }
}

#pragma mark - tableViewdelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSInteger s = 0;
//    for (NSMutableArray *arr in self.arrTitle)
//    {
//        if (arr.count > 0 || arr)
//        {
//            s ++;
//        }
//    }
//    return self.arrTitle.count;
    return self.arrTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    switch (section) {
//        case 0:
//        case 3:
//        case 4:
//        case 5:
//        default:
//            return 1;
//        case 1:
//        case 2:
//            return 2;
//    }
    
    return ((NSMutableArray *)[self.arrTitle objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = nil;

    NSArray *arr = [self.arrTitle objectAtIndex:indexPath.section];
    
    if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(MEETING_TITLE)])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[ApplyTextFieldTableViewCell identifier]];
        [cell setDelegate:self];
        if (self.model) [cell setTitle:self.model.try_A_TITLE];
    }else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_ACCEPT_TITLE)])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[ApplyNameRightTableViewCell identifier]];
        if (!cell)
        {
            cell = [[ApplyNameRightTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[ApplyNameRightTableViewCell identifier]];
        }
        if (self.model.try_A_APPROVE_NAME)
        {
            [cell setNameField:self.model.try_A_APPROVE_NAME];
        }
        [cell textLabel].text = [arr objectAtIndex:indexPath.row];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_ACCEPT_CC_TITLE)])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[ApplyNameRightTableViewCell identifier]];
        if (!cell)
        {
            cell = [[ApplyNameRightTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[ApplyNameRightTableViewCell identifier]];
        }
        if (self.model.try_A_CC_NAME)
        {
            [cell setNameField:self.model.try_A_CC_NAME];
        }
        [cell textLabel].text = [arr objectAtIndex:indexPath.row];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_DEADLINE_TITLE)])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[ApplyDeadlineTableViewCell identifier]];
        [cell setAccessoryView:self.deadlineSwitch];
        [cell deadlineLbl].text = self.deadLineTime;
        if (self.model.try_A_DEADLINE)
        {
            NSDate *deadline = [NSDate dateWithTimeIntervalSince1970:self.model.try_A_DEADLINE/1000];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"MM/dd HH:mm"];
            [cell deadlineLbl].text =  [format stringFromDate:deadline];
            if (self.model.try_IS_DEADLINE_ALL_DAY)
            {
                NSString *dateStr = [format stringFromDate:deadline];
                NSArray *strings = [dateStr componentsSeparatedByString: @" "];
                [cell deadlineLbl].text = [NSString stringWithFormat:@"%@%@",strings[0],LOCAL(MISSION_ALLDAY)];
            }
           
            self.deadlineSwitch.on = [cell deadlineLbl].text;
        }
         [cell textLabel].text = [arr objectAtIndex:indexPath.row];
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_PERIOD_TITLE)])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[ApplyDetailTableViewCell identifier]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell applyDetailLbl].text = self.periodTime;
        if (self.model.try_A_START_TIME)
        {
            NSDate *dateStart = [NSDate dateWithTimeIntervalSince1970:self.model.try_A_START_TIME/1000];
            NSDate *dateEnd = [NSDate dateWithTimeIntervalSince1970:self.model.try_A_END_TIME/1000];
            [cell applyDetailLbl].text = [self stringFromStart:dateStart end:dateEnd];
        }
        [cell textLabel].text = [arr objectAtIndex:indexPath.row];
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_EXPENSED_TITLE)])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[ApplyAddExpendTxtFieldTableViewCell identifier]];
        [cell setDelegate:self];
        [((ApplyAddExpendTxtFieldTableViewCell *)cell).expendField addTarget:self action:@selector(TextfieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
        if (self.model.try_A_FEE)
        {
            NSString *str = [[NSString stringWithFormat:@"%ld",(long)self.model.try_A_FEE] stringByReplacingOccurrencesOfString:@"¥" withString:@""];
            [cell expendField].text = [NSString stringWithFormat:@"¥%@",str];
        }
        [cell textLabel].text = [arr objectAtIndex:indexPath.row];
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_ATTACHMENT_TITLE)])
    {
        ApplicationAttachmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell clickToSeeImage:^(NSUInteger clickedIndex) {
            [self selectShowImageAtIndex:clickedIndex];
        }];
        [cell titleLabel].text = LOCAL(APPLY_ADD_ATTACHMENT_TITLE);
        [cell setImages:self.model.try_attachMentArray];
        return cell;
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_DETAIL)])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[ApplyTextViewTableViewCell identifier]];
        [cell setDelegate:self];
        [cell setTextWithModelStr:self.model.try_A_BACKUP];
    }
    
    [cell textLabel].font = [UIFont mtc_font_30];
    [cell textLabel].textColor  = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *arr = [self.arrTitle objectAtIndex:indexPath.section];
    
    if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(MEETING_TITLE)])
    {
       
    }else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_ACCEPT_TITLE)])
    {
        SelectContactBookViewController *selectVc = [[SelectContactBookViewController alloc] initWithSelectedPeople:[self.self.model.try_A_APPROVE componentsSeparatedByString:@"●"] unableSelectPeople:[self.model.try_A_CC componentsSeparatedByString:@"●"]];

        [selectVc selectedPeople:^(NSArray *array) {
            [self selectPeople:array];
        }];
        self.apprpoveClicked = YES;
        self.CCApproveClicked = NO;
        [self presentViewController:selectVc animated:YES completion:nil];
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_ACCEPT_CC_TITLE)])
    {
        SelectContactBookViewController *selectVc = [[SelectContactBookViewController alloc] initWithSelectedPeople:[self.model.try_A_CC componentsSeparatedByString:@"●"] unableSelectPeople:[self.model.try_A_APPROVE componentsSeparatedByString:@"●" ]];

        [selectVc selectedPeople:^(NSArray *array) {
            [self selectPeople:array];
        }];
        self.apprpoveClicked = NO;
        self.CCApproveClicked = YES;
        [self presentViewController:selectVc animated:YES completion:nil];
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_DEADLINE_TITLE)])
    {
        
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_PERIOD_TITLE)])
    {
        [self.view endEditing:YES];
        [self.view addSubview:self.actionSheetView];
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_EXPENSED_TITLE)])
    {
        
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_ATTACHMENT_TITLE)])
    {
        if ([self.model try_attachMentArray].count == maxImageCount)
        {
            return;
        }

        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(CAMERA), LOCAL(GALLERY), nil];
        actionSheet.tag = photoActionSheetTag;
        [actionSheet showInView:self.view];
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_DETAIL)])
    {
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    NSArray *arr = [self.arrTitle objectAtIndex:indexPath.section];
    
    if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_ATTACHMENT_TITLE)])
    {
        return [ApplicationAttachmentTableViewCell heightForCellWithImageCount:[self.model try_attachMentArray].count accessoryMode:YES];
    }
    else if ([[arr objectAtIndex:indexPath.row] isEqualToString:LOCAL(APPLY_ADD_DETAIL)])
    {
       return 104.0f;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (BOOL)checkInfo
{
    [self.view endEditing:YES];
    
    if ([self.model.try_A_TITLE isEqualToString:@""] || self.model.try_A_TITLE == nil)
    {
        [self postError:LOCAL(APPLY_INPUT_TITLE) duration:1.0];
        return NO;
    }
    if(!self.model.try_A_APPROVE)
    {
        [self postError:LOCAL(APPLY_INPUT_APPROLLER) duration:1.0];
        return NO;
    }
    return YES;
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[AttachmentUploadResponse class]]) {
        NSArray *arrayAttach = self.model.try_attachMentArray;
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
        if (self.applyType == EditApply) {
            // 编辑
            ApplyEditApplyRequest *request = [[ApplyEditApplyRequest alloc] initWithDelegate:self];
//            [request editApplyWithModel:self.model];
        }
        
        else {
            // 新建
            ApplyAddNewApplyRequest * request = [[ApplyAddNewApplyRequest alloc] initWithDelegate:self];
            [request applyAddNewApplyWithModel:self.model];
        }
    }
    else if ([response isKindOfClass:[ApplyAddNewApplyResponse class]])
    {
        [self hideLoading];
        [self postSuccess:LOCAL(APPLY_APPLY_SUCCESS)];
        [[NSNotificationCenter defaultCenter] postNotificationName:MCApplyListDataDidRefreshNotification object:nil];
        NSNotification *notification = [NSNotification notificationWithName:@"turntosender" object:@(1)];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([request isKindOfClass:[ApplyEditApplyRequest class]])
    {
        [self hideLoading];
        [self.model refreshAction];
        [[NSNotificationCenter defaultCenter] postNotificationName:MCApplyListDataDidRefreshNotification object:nil];
        self.takeimgarrback(self.model.try_attachMentArray);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([response isKindOfClass:[ApplyStyleKeyResponse class]])
    {
        [self.arrNeedShow addObjectsFromArray:((ApplyStyleKeyResponse *)response).arrModels];
        for (ApplyStyleKeyWordModel *model in self.arrNeedShow)
        {
            if ([model.key isEqualToString:@"title"])
            {
                [(NSMutableArray *)[self.arrTitle objectAtIndex:0] addObject:LOCAL(MEETING_TITLE)];
            }
            if ([model.key isEqualToString:@"approveuser"])
            {
                [(NSMutableArray *)[self.arrTitle objectAtIndex:1] addObject:LOCAL(APPLY_ADD_ACCEPT_TITLE)];
            }
            if ([model.key isEqualToString:@"cc"])
            {
                [(NSMutableArray *)[self.arrTitle objectAtIndex:1] addObject:LOCAL(APPLY_ADD_ACCEPT_CC_TITLE)];
            }
            if ([model.key isEqualToString:@"approveendtime"])
            {
                [(NSMutableArray *)[self.arrTitle objectAtIndex:2] addObject:LOCAL(APPLY_ADD_DEADLINE_TITLE)];
            }
            if ([model.key isEqualToString:@"timeslot"])
            {
                [(NSMutableArray *)[self.arrTitle objectAtIndex:2] addObject:LOCAL(APPLY_ADD_PERIOD_TITLE)];
            }
            if ([model.key isEqualToString:@"fee"])
            {
                [(NSMutableArray *)[self.arrTitle objectAtIndex:2] addObject:LOCAL(APPLY_ADD_EXPENSED_TITLE)];
            }
            if ([model.key isEqualToString:@"annex"])
            {
                [(NSMutableArray *)[self.arrTitle objectAtIndex:3] addObject:LOCAL(APPLY_ADD_ATTACHMENT_TITLE)];
            }
            if ([model.key isEqualToString:@"backup"])
            {
                [(NSMutableArray *)[self.arrTitle objectAtIndex:4] addObject:LOCAL(APPLY_ADD_DETAIL)];
            }
        }
        [self.tableView reloadData];
    }
}

-(void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - UITextFieldDelegate
-(void)TextfieldValueDidChanged:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""])
    {
        textField.text = @"";
        return;
    }else
    {
        if ([textField.text rangeOfString:@"¥"].location != NSNotFound)
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
            textField.text = [@"¥" stringByAppendingString:textField.text];
        }
        else
        {
            textField.text = [@"¥" stringByAppendingString:textField.text];
        }
        
    }
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 11)
    {
        CGAffineTransform tramsform = CGAffineTransformMakeTranslation(0, -100);
        self.tableView.transform = tramsform;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 10)
    {
        self.model.try_A_TITLE =textField.text;
    }
    if (textField.tag == 11)
    {
        if (![self isValidateNum:textField.text])
        {
            [self postError:LOCAL(APPLY_INPUTMONEY) duration:1.0];
            textField.text = @"";
            self.tableView.transform = CGAffineTransformIdentity;
            return;
        }
        NSString *str = [textField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        self.model.try_A_FEE = [[NSString stringWithFormat:@"%ld",(long)[str integerValue]] integerValue];
        self.tableView.transform = CGAffineTransformIdentity;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 10) self.model.try_A_TITLE =textField.text;
    if (textField.tag == 11) self.model.try_A_FEE = [textField.text integerValue];
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateKeyframesWithDuration:0.2 delay:0.3 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -250);
            self.tableView.transform = transform;
        }];
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.model.try_A_BACKUP = textView.text;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
    }];
}


#pragma mark - deadlineViewDelegate
//设置截至时间
-(void)ApplyAddDeadlineActionSheetViewDelegateCallBack_date:(NSDate *)date
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"MM/dd hh:mm"];
    NSString *deadline = [dateFormate stringFromDate:date];
    self.deadLineTime = deadline;
    self.model.try_A_DEADLINE = (long long)[date timeIntervalSince1970] *1000;
    self.model.try_IS_DEADLINE_ALL_DAY = self.isDeadLineWholeday;
    [self.tableView reloadData];
}

-(void)ApplyAddDeadlineActionSheetViewDelegateCallBack_isWholeDay:(BOOL)isWholdDay
{
    self.isDeadLineWholeday = isWholdDay;
}

-(void)ApplyAddDeadlineActionSheetViewDelegateCallBack_closeDeadlineSwitch
{
    self.deadlineSwitch.on = NO;
}



#pragma mark - WZPhotoPickerController Delegate
- (void)wz_imagePickerController:(WZPhotoPickerController *)photoPickerController didSelectAssets:(NSArray *)assets {
    for (ALAsset *asset in assets) {
        if (self.model.try_attachMentArray == self.model.attachMentArray) {
            self.model.try_attachMentArray = [NSMutableArray array];
        }
        
        UIImage *image = [ApplicationAttachmentModel originalImageFromAsset:asset];
        [self.model.try_attachMentArray addObject:[[ApplicationAttachmentModel alloc] initWithLocalImage:image]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        if (self.model.try_attachMentArray == self.model.attachMentArray) {
            self.model.try_attachMentArray = [NSMutableArray array];
        }
        [self.model.try_attachMentArray addObject:[[ApplicationAttachmentModel alloc] initWithLocalImage:image]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.model try_attachMentArray].count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [self.model try_attachMentArray].count)
    {
        ApplicationAttachmentModel *attachment = [self.model.try_attachMentArray objectAtIndex:index];
        if (attachment.localPath) {
            return [MWPhoto photoWithImage:attachment.originalImage];
        }
        
        return [MWPhoto photoWithURL:[NSURL URLWithString:attachment.path]];
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LOCAL(APPLY_DELETE_PICTURE) delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:LOCAL(DELETE) otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma mark - private method
/** 点击查看照片 */
- (void)selectShowImageAtIndex:(NSUInteger)selectedIndex {
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
            WZPhotoPickerController *imagePicker = [[WZPhotoPickerController alloc] init];
            [imagePicker setDelegate:self];
            NSInteger count = maxImageCount - [self.model try_attachMentArray].count;
            [imagePicker setMaximumNumberOfSelection:count];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
        return;
    }
    
    if (buttonIndex == 1) {
        return;
    }
    
    [[self.model try_attachMentArray] removeObjectAtIndex:[self.photoBrowser currentIndex]];
    [self.photoBrowser reloadData];

    [self.tableView reloadData];
    
    if (![self.model try_attachMentArray].count) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark
- (void)keyBoardWillShow:(NSNotification *)info
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = [[info.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.view.transform  = CGAffineTransformMakeTranslation(0, -rect.origin.y*0.5);
    }];
}

- (void)keyBoardWillHide:(NSNotification *)info
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform  = CGAffineTransformIdentity;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [_tableView registerClass:[ApplyTextViewTableViewCell           class] forCellReuseIdentifier:[ApplyTextViewTableViewCell identifier]];
        [_tableView registerClass:[ApplyTextFieldTableViewCell          class] forCellReuseIdentifier:[ApplyTextFieldTableViewCell identifier]];
        [_tableView registerClass:[ApplyDetailTableViewCell             class] forCellReuseIdentifier:[ApplyDetailTableViewCell identifier]];
        [_tableView registerClass:[ApplyDeadlineTableViewCell           class] forCellReuseIdentifier:[ApplyDeadlineTableViewCell identifier]];
        [_tableView registerClass:[ApplicationAttachmentTableViewCell   class] forCellReuseIdentifier:[ApplicationAttachmentTableViewCell identifier]];
        [_tableView registerClass:[ApplyAddExpendTxtFieldTableViewCell  class] forCellReuseIdentifier:[ApplyAddExpendTxtFieldTableViewCell identifier]];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
    }
    return _tableView;
}

- (UITextField *)txtField
{
    if (!_txtField) {
        _txtField = [[UITextField alloc] init];
    }
    return _txtField;
}

- (UISwitch *)levelSwitch
{
    if (!_levelSwitch)
    {
        _levelSwitch = [[UISwitch alloc] init];
        _levelSwitch.onTintColor = [UIColor themeRed];
        [_levelSwitch addTarget:self action:@selector(levelStatuChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _levelSwitch;
}

- (UISwitch *)deadlineSwitch
{
    if (!_deadlineSwitch)
    {
        _deadlineSwitch = [[UISwitch   alloc] init];
        _deadlineSwitch.onTintColor = [UIColor themeBlue];
        [_deadlineSwitch addTarget:self action:@selector(deadLineValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _deadlineSwitch;
}
- (UITextView *)detailView
{
    if (!_detailView)
    {
        _detailView = [[UITextView alloc] init];
    }
    return _detailView;
}

- (ApplyAddPeriodActionSheetView *)actionSheetView
{
    if (!_actionSheetView)
    {
        _actionSheetView = [[ApplyAddPeriodActionSheetView alloc]initWithFrame:self.view.frame];
        _actionSheetView.delegate = self;
    }
    return _actionSheetView;
}
- (ApplyAddDeadlineActionSheetView *)deadLineView
{
    if (!_deadLineView) {
        _deadLineView  = [[ApplyAddDeadlineActionSheetView alloc] initWithFrame:self.view.frame];
        _deadLineView.delegate = self;
    }
    return _deadLineView;
}

- (NSArray *)arrTitle
{
    if (!_arrTitle)
    {
//        NSArray *arr0 = @[@""];
//        NSArray *arr1 = @[LOCAL(APPLY_ADD_ACCEPT_TITLE),LOCAL(APPLY_ADD_ACCEPT_CC_TITLE)];
//        NSArray *arr2 = @[LOCAL(APPLY_ADD_PRIORITY_TITLE),LOCAL(APPLY_ADD_DEADLINE_TITLE)];
//        NSArray *arr3 = @[LOCAL(APPLY_ADD_PERIOD_TITLE)];
//        NSArray *arr4 = @[@""];
//        NSArray *arr5 = @[@""];
//        _arrTitle = @[arr0,arr1,arr2,arr3,arr4,arr5];
        
        NSMutableArray *arr0 = [[NSMutableArray alloc] init];
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        NSMutableArray *arr2 = [[NSMutableArray alloc] init];
        NSMutableArray *arr3 = [[NSMutableArray alloc] init];
        NSMutableArray *arr4 = [[NSMutableArray alloc] init];
        NSMutableArray *arr5 = [[NSMutableArray alloc] init];
        _arrTitle = @[arr0,arr1,arr2,arr3,arr4,arr5];
    }
    return _arrTitle;
}

- (NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (NSMutableArray *)approveNameArr
{
    if (!_approveNameArr)
    {
        _approveNameArr = [[NSMutableArray alloc] init];
    }
    return _approveNameArr;
}

- (NSMutableArray *)CCApproveNameArr
{
    if(!_CCApproveNameArr)
    {
        _CCApproveNameArr = [[NSMutableArray alloc] init];
    }
    return _CCApproveNameArr;
}

- (ApplyDetailInformationModel *)model
{
    if (!_model)
    {
        _model = [[ApplyDetailInformationModel  alloc] init];
    }
    return _model;
}

- (NSMutableArray *)arrattachment
{
    if (!_arrattachment)
    {
        _arrattachment = [[NSMutableArray alloc] init];
    }
    return _arrattachment;
}

- (NSMutableArray *)arrNeedShow
{
    if (!_arrNeedShow)
    {
        _arrNeedShow = [[NSMutableArray alloc] init];
    }
    return _arrNeedShow;
}
@end
