//
//  NewApplyAddNewApplyViewController.m
//  launcher
//
//  Created by conanma on 16/1/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyAddNewApplyViewController.h"
#import "NewApplyAddNewApplyV2ViewController.h"
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
#import "MixpanelMananger.h"
#import "ApplyAddExpendTxtFieldTableViewCell.h"
#import "CalendarSwitchTableViewCell.h"
#import "NewApplyRecordTableViewCell.h"
#import <MJExtension/MJExtension.h>
#import "NewApplyAddApplyTitleTableViewCell.h"

//字典中存的key
#define STARTTIME @"StartTime"    //开始时间
#define ENDTIME   @"EndTime"      //终了时间
#define WHOLEDAY  @"WholeDay"     //整天

#define VOCATION  @"vEyVJ7K29qcovp3p"

static NSInteger const maxImageCount = 9;

typedef  enum
{
    cellTitle = 0,                //标题
    cellCommon = 10,              //公用
    cellAccept = 20,              //承认人
    cellCC = 21,                  //抄送
    cellPriority = 30,            //优先级
    cellDeadLine = 31,            //最后期限
    cellAttachment = 40,          //附件
    cellDetil = 41                //详细
}CELLTYPE;

@interface NewApplyAddNewApplyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ApplyAddPeriodActionSheetViewDelegate,ApplyAddDeadlineActionSheetViewDelegate, WZPhotoPickerControllerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, BaseRequestDelegate,UIActionSheetDelegate, MWPhotoBrowserDelegate,NewApplyAddApplyTitleTableViewCellDelegate>
//@property( nonatomic, strong ) UITextField  * txtField;
/**
 *  重要性开关
 */
//@property (nonatomic, strong) UISwitch  * levelSwitch;
///**
// *  最终期限开关
// */
//@property (nonatomic, strong) UISwitch  * deadlineSwitch;
//@property (nonatomic, strong) UITextView  * detailView;

@property (nonatomic, strong) UITableView  * tableView;
@property (nonatomic, strong) ApplyAddPeriodActionSheetView  * actionSheetView;
@property (nonatomic, strong) ApplyAddDeadlineActionSheetView  * deadLineView;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) UITextView *twview;

@property (nonatomic, copy) NSArray *mustArr;    //审批人
@property (nonatomic, copy) NSArray *tryArr;     //CC

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
@property(nonatomic, assign) BOOL  isDeadLineWholeday;

@property (nonatomic) CGFloat mustComeCellRowHieght; //审批人cell行高
@property (nonatomic) CGFloat canComeCellRowHieght;  //CC cell行高
@property (nonatomic, strong) NewApplyAddApplyTitleTableViewCell *mytitlecell;
@end

static NSInteger const photoActionSheetTag = 111;



@implementation NewApplyAddNewApplyViewController

@synthesize  model = _model;
- (instancetype)initWithApplykind:(applykind)kind
{
    if (self = [super init])
    {
        self.applykind = kind;
        self.applytype = New_Apply;
        if (self.applykind == applykind_vocation)
        {
            self.model.T_SHOW_ID = VOCATION;
        }
        else if (self.applykind == applykind_expense)
        {
            self.model.T_SHOW_ID = EXPENSE;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mustComeCellRowHieght = 47;
    self.canComeCellRowHieght = 47;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(clickToBack)];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(APPLY_SEND) style:UIBarButtonItemStylePlain target:self action:@selector(clickToSend)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.model.attachMentArray removeAllObjects];
    [self.model.attachMentArray addObjectsFromArray:self.arrattachment];

//    [self.model removeAllAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)clickToBack {
    [MixpanelMananger track:@"approve/cancel"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
//时间段设置
- (void)callBackWithDic:(NSDictionary *)dic
{
    NSDate *startTime = [dic objectForKey:STARTTIME];
    NSDate *endTime = [dic objectForKey:ENDTIME];
    self.model.try_A_START_TIME = (long long)[startTime timeIntervalSince1970] * 1000;
    self.model.try_A_END_TIME = (long long)[endTime timeIntervalSince1970] * 1000;
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

- (void)selectPeople:(NSArray *)selectedList {
    if (self.apprpoveClicked)
    {
        NSString *approve = @"";
        NSString *apprpveName = @"";
        NSInteger i = 0;
        for (ContactPersonDetailInformationModel *model in selectedList)
        {
            [self.approveNameArr addObject:model.u_true_name];
            approve = [approve stringByAppendingString:model.show_id];
            apprpveName = [apprpveName stringByAppendingString:model.u_true_name];
            if (i != selectedList.count -1)
            {
                approve = [approve stringByAppendingString:@"●"];
                apprpveName = [apprpveName stringByAppendingString:@"●"];
            }
            i++;
        }
        self.mustArr = selectedList;
        self.model.try_A_APPROVE = approve;
        self.model.try_A_APPROVE_NAME = apprpveName;
        self.mustComeCellRowHieght = [self getRowNumberWithData:[apprpveName componentsSeparatedByString:@"●"]];
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
        self.tryArr = selectedList;
        self.model.try_A_CC = CCApprove;
        self.model.try_A_CC_NAME = CCApproveName;
        self.canComeCellRowHieght = [self getRowNumberWithData:[CCApproveName componentsSeparatedByString:@"●"]];
        self.CCApproveClicked  = !self.CCApproveClicked;
        [self.tableView reloadData];
    }
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


#pragma mark - tableViewdelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            if (self.model.try_A_IS_URGENT)
            {
                return 1;
            }
            else
            {
                return 2;
            }
            break;
        case 4:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = nil;
    NSInteger row = indexPath.row;
    NSInteger currentIndex = indexPath.section * 10 + indexPath.row;
    NSArray *arr = [self.arrTitle objectAtIndex:indexPath.section];
    
    switch (currentIndex) {
        case cellTitle:
        {
            if (self.model) [self.mytitlecell setContent:self.model.try_A_TITLE];
            return self.mytitlecell;
            break;
        }
        case  cellAccept:
        case  cellCC:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplyNameRightTableViewCell identifier]];
            if (!cell)
            {
                cell = [[ApplyNameRightTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[ApplyNameRightTableViewCell identifier]];
                [cell setIsEdit:YES];
                [cell setSeparatorInset:UIEdgeInsetsZero];
                if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }
                
            }
            
            if (currentIndex == cellAccept && self.model.try_A_APPROVE_NAME)
            {
                [cell setNameField:self.model.try_A_APPROVE_NAME];
            }else if(currentIndex == cellCC && self.model.try_A_CC_NAME)
            {
                [cell setNameField:self.model.try_A_CC_NAME];
            }
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            break;        }
        case cellPriority:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarSwitchTableViewCell identifier]];
            [cell isOn:(BOOL)self.model.try_A_IS_URGENT];
            [cell setSwitchColor:[UIColor themeRed]];
            [cell calendarSwitchDidChange:^(CalendarSwitchType swithType, BOOL ison) {
                self.model.try_A_IS_URGENT = ison;
                if (ison)
                {
                    self.model.try_A_DEADLINE = 0;
                    self.deadLineTime = @"";
                }
                [self.tableView reloadData];
            }];
            break;
        }
        case cellDeadLine:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplyDeadlineTableViewCell identifier]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
            }
            break;
        }
        case cellCommon:
        {
            if (self.applykind == applykind_vocation)
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
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[ApplyAddExpendTxtFieldTableViewCell identifier]];
                [cell setDelegate:self];
                [((ApplyAddExpendTxtFieldTableViewCell *)cell).expendField addTarget:self action:@selector(TextfieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
                if (self.model.try_A_FEE)
                {
                    NSString *str = [[NSString stringWithFormat:@"%ld",(long)self.model.try_A_FEE] stringByReplacingOccurrencesOfString:@"¥" withString:@""];
                    [cell expendField].text = [NSString stringWithFormat:@"¥%@",str];
                }
                break;
            }
            
            break;
        }
        case cellAttachment:
        {
            ApplicationAttachmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell clickToSeeImage:^(NSUInteger clickedIndex) {
                [self selectShowImageAtIndex:clickedIndex];
            }];
            [cell titleLabel].text = LOCAL(APPLY_ADD_ATTACHMENT_TITLE);
            [cell setImages:self.model.try_attachMentArray];
            return cell;
            break;
        }
        case cellDetil:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplyTextViewTableViewCell identifier]];
            [cell setDelegate:self];
            [cell setTextWithModelStr:self.model.try_A_BACKUP];
            break;
        }
    }
    [cell textLabel].text = [arr objectAtIndex:row];
    [cell textLabel].font = [UIFont mtc_font_30];
    [cell textLabel].textColor  = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger currentIndex = indexPath.section * 10 + indexPath.row;
    
    switch (currentIndex)
    {
        case cellCommon:
        {
            if (self.applykind == applykind_vocation)
            {
                [self.view endEditing:YES];
                [self.view addSubview:self.actionSheetView];
            }
            break;
        }
        case cellAccept:
        {
            SelectContactBookViewController *selectVc = [[SelectContactBookViewController alloc] initWithSelectedPeople:self.mustArr unableSelectPeople:self.tryArr];
            
            [selectVc selectedPeople:^(NSArray *array) {
                self.apprpoveClicked = YES;
                [self selectPeople:array];
            }];
            
            [self presentViewController:selectVc animated:YES completion:nil];
            break;
        }
        case cellCC:
        {
            SelectContactBookViewController *selectVc = [[SelectContactBookViewController alloc] initWithSelectedPeople:self.tryArr unableSelectPeople:self.mustArr];
            
            [selectVc selectedPeople:^(NSArray *array) {
                self.CCApproveClicked = YES;
                [self selectPeople:array];
            }];
            [self presentViewController:selectVc animated:YES completion:nil];
            break;
        }
        case cellAttachment:
        {
            if ([self.model try_attachMentArray].count == maxImageCount)
            {
                return;
            }
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(CAMERA), LOCAL(GALLERY), nil];
            actionSheet.tag = photoActionSheetTag;
            [actionSheet showInView:self.view];
        }
            break;
        case cellDeadLine:
        {
            [self.view endEditing:YES];
            [self.view addSubview:self.deadLineView];
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4 & indexPath.row == 1)
    {
        return 104.0f;
    }
    if (indexPath.section == 4 && indexPath.row == 0)
    {
        return [ApplicationAttachmentTableViewCell heightForCellWithImageCount:[self.model try_attachMentArray].count accessoryMode:YES];
    }
    NSInteger currentIndex = indexPath.section * 10 + indexPath.row;
    switch (currentIndex) {
        case  cellAccept:
            return self.mustComeCellRowHieght;
            break;
        case  cellCC:
            return self.canComeCellRowHieght;
            break;
        case cellTitle:
        {
            return self.mytitlecell.cellheight;
        }
        default:
            break;
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
    if ([self.model.T_SHOW_ID isEqualToString:VOCATION])
    {
        if (!self.model.try_A_START_TIME)
        {
            [self postError:LOCAL(APPLY_INPUT_VOCATION_TIME) duration:1.0];
            return NO;
        }
    }
    else
    {
        if (self.model.try_A_FEE == 0)
        {
            [self postError:LOCAL(APPLY_INPUT_MONEY)];
            return NO;
        }
    }
    return YES;
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
    if (self.applykind == applykind_vocation)
    {
        self.model.T_SHOW_ID = VOCATION;
    }
    else
    {
        self.model.T_SHOW_ID = EXPENSE;
    }

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
    switch (self.applytype) {
        case Edit_Apply: {
            ApplyEditApplyRequest *request = [[ApplyEditApplyRequest alloc] initWithDelegate:self];
//            [request editApplyWithModel:self.model];
        }
            break;
            
        case New_Apply: {
            ApplyAddNewApplyRequest * request = [[ApplyAddNewApplyRequest alloc] initWithDelegate:self];
            [request applyAddNewApplyWithModel:self.model];
        }
            break;
    }
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
        [self RecordToDiary:[NSString stringWithFormat:@"新建审批上传附件成功:%@",self.model.SHOW_ID]];
        [self postLoading];
        if (self.applytype == Edit_Apply) {
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
        [self.model refreshAction];
        [self hideLoading];
        [self postSuccess:LOCAL(APPLY_APPLY_SUCCESS)];
        [self RecordToDiary:[NSString stringWithFormat:@"新建审批成功:%@",self.model.SHOW_ID]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MCApplyListDataDidRefreshNotification object:nil];
        NSNotification *notification = [NSNotification notificationWithName:@"turntosender" object:@(1)];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        //        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([request isKindOfClass:[ApplyEditApplyRequest class]])
    {
        [self hideLoading];
        [self RecordToDiary:[NSString stringWithFormat:@"修改审批成功:%@",self.model.SHOW_ID]];
        [self.model refreshAction];
        [[NSNotificationCenter defaultCenter] postNotificationName:MCApplyListDataDidRefreshNotification object:nil];
        self.takeimgarrback(self.model.try_attachMentArray);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 111)
    {
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, -250);
            self.tableView.transform = transform;
        }];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 111)
    {
        self.model.try_A_BACKUP = textView.text;
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)textViewCell:(NewApplyAddApplyTitleTableViewCell *)cell didChangeText:(NSString *)text needreload:(BOOL)need
{
    self.model.try_A_TITLE = cell.tvwTitle.text;
    if (need)
    {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [cell.tvwTitle becomeFirstResponder];
    }
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


#pragma mark - WZPhotPickerController Delegate
- (void)wz_imagePickerController:(WZPhotoPickerController *)photoPickerController didSelectAssets:(NSArray *)assets {
    for (ALAsset *asset in assets) {
        UIImage *image = [ApplicationAttachmentModel originalImageFromAsset:asset];
        if (self.model.try_attachMentArray == self.model.attachMentArray) {
            self.model.try_attachMentArray = [NSMutableArray array];
        }
        
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
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
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
//        CGAffineTransform tramsform = CGAffineTransformMakeTranslation(0, -100);
//        self.tableView.transform = tramsform;
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
//            self.tableView.transform = CGAffineTransformIdentity;
            return;
        }
        NSString *str = [textField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        self.model.try_A_FEE = [[NSString stringWithFormat:@"%ld",(long)[str integerValue]] integerValue];
//        self.tableView.transform = CGAffineTransformIdentity;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 10) self.model.try_A_TITLE =textField.text;
    if (textField.tag == 11) self.model.try_A_FEE = [textField.text integerValue];
    return YES;
}

- (BOOL)isValidateNum:(NSString *)Num
{
    NSString *regex = @"[1-9]*[0-9][0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    
    NSString *str = [Num stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    return [predicate evaluateWithObject:str];
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [_tableView registerClass:[ApplyTextViewTableViewCell           class] forCellReuseIdentifier:[ApplyTextViewTableViewCell           identifier]];
        [_tableView registerClass:[ApplyTextFieldTableViewCell          class] forCellReuseIdentifier:[ApplyTextFieldTableViewCell          identifier]];
        [_tableView registerClass:[ApplyDetailTableViewCell             class] forCellReuseIdentifier:[ApplyDetailTableViewCell             identifier]];
        [_tableView registerClass:[ApplyDeadlineTableViewCell           class] forCellReuseIdentifier:[ApplyDeadlineTableViewCell           identifier]];
        [_tableView registerClass:[ApplicationAttachmentTableViewCell   class] forCellReuseIdentifier:[ApplicationAttachmentTableViewCell   identifier]];
        [_tableView registerClass:[ApplyAddExpendTxtFieldTableViewCell class] forCellReuseIdentifier:[ApplyAddExpendTxtFieldTableViewCell   identifier]];
        [_tableView registerClass:[CalendarSwitchTableViewCell class] forCellReuseIdentifier:[CalendarSwitchTableViewCell                   identifier]];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
        _tableView.delegate = self;
        _tableView.dataSource  = self;
    }
    return _tableView;
}

- (void)setModel:(ApplyDetailInformationModel *)model
{
    _model = model;
    
    NSArray *dictArray = [model.formDataJSONString mj_JSONObject];
    for (int i = 0; i < dictArray.count; i++) {
        NSDictionary *dict = dictArray[i];
        switch (i) {
            case 0:
                _model.try_A_TITLE = [dict valueStringForKey:@"value"];
                break;
            case 1:
            {
                id valueObject = [dict valueForKey:@"value"];
                if ([valueObject isKindOfClass:[NSDictionary class]]) {
                    _model.A_START_TIME = [[valueObject valueNumberForKey:@"startTime"] floatValue];
                    _model.A_END_TIME   = [[valueObject valueNumberForKey:@"endTime"] floatValue];
                }else if([valueObject isKindOfClass:[NSString class]]){
                    _model.try_A_FEE =  [[dict valueNumberForKey:@"value"] floatValue];
                }
            }
                break;
            case 2:
            {
                _model.try_A_APPROVE_NAME = [self.model.arrAproveNameList  componentsJoinedByString:@"●"];
                NSMutableArray *modelArr = [NSMutableArray array];
                for (int i = 0; i<self.model.arrAproveList.count; i++) {
                    ContactPersonDetailInformationModel *model = [[ContactPersonDetailInformationModel alloc] init];
                    model.show_id = self.model.arrAproveList[i];
                    if (self.model.arrAproveNameList.count) {
                        model.u_true_name = self.model.arrAproveNameList[i];
                    }
                    [modelArr addObject:model];
                }
                
                self.mustArr = modelArr;
            }
                break;
            case 3:
            {
                _model.try_A_CC =  [self.model.arrCCNameList componentsJoinedByString:@"●"];
                NSMutableArray *modelArr = [NSMutableArray array];
                
                for (int i = 0; i<self.model.arrAproveList.count; i++) {
                    ContactPersonDetailInformationModel *model = [[ContactPersonDetailInformationModel alloc] init];
                    if (self.model.arrCCNameList.count) {
                        model.u_true_name = self.model.arrCCNameList[i];
                    }
                    model.show_id = self.model.arrCCList[i];
                    [modelArr addObject:model];
                }

                self.tryArr = modelArr;
            }
                break;
            case 4:
            {
                NSDictionary *dayDict = [dict valueForKey:@"value"];
                _model.try_A_DEADLINE = [[dayDict valueNumberForKey:@"deadline"] longLongValue];
            }
                break;
            case 5:
                _model.try_attachMentArray = ![[dict valueForKey:@"value"] isEqualToString:@""]?[dict valueForKey:@"value"]:[NSMutableArray array];
                break;
            case 6:
                _model.try_A_BACKUP = [dict valueStringForKey:@"value"];
            default:
                break;
        }
    }
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
        NSArray *arr0 = @[@""];
        NSArray *arr1 = @[self.applykind == applykind_vocation?LOCAL(APPLY_ADD_PERIOD_TITLE):LOCAL(APPLY_ADD_EXPENSED_TITLE)];
        NSArray *arr2 = @[LOCAL(APPLY_ADD_ACCEPT_TITLE),LOCAL(APPLY_ADD_ACCEPT_CC_TITLE)];
        NSArray *arr3 = @[LOCAL(APPLY_ADD_PRIORITY_TITLE),LOCAL(APPLY_ADD_DEADLINE_TITLE)];
        NSArray *arr4 = @[@"",@""];
        _arrTitle = @[arr0,arr1,arr2,arr3,arr4];
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

- (NSArray *)mustArr
{
    if (!_mustArr) {
        _mustArr = [[NSArray alloc] init];
    }
    return _mustArr;
}

- (NSArray *)tryArr
{
    if (!_tryArr) {
        _tryArr = [[NSArray alloc] init];
    }
    return _tryArr;
}

- (NewApplyAddApplyTitleTableViewCell *)mytitlecell
{
    if (!_mytitlecell)
    {
        _mytitlecell = [[NewApplyAddApplyTitleTableViewCell alloc] init];
        _mytitlecell.delegate = self;
        if (self.applykind == applykind_vocation)
        {
            _mytitlecell.placeholderLabel.text = LOCAL(APPLY_INPUT_LEAVECONTENT);
        }
        else
        {
            _mytitlecell.placeholderLabel.text = LOCAL(APPLY_INPUT_MONEYCONTENT);
        }
    }
    return _mytitlecell;
}
@end
