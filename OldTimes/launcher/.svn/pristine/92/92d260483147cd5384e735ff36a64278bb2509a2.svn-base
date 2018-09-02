//
//  NewApplyAddNewApplyV2ViewController.m
//  launcher
//
//  Created by williamzhang on 16/4/28.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyAddNewApplyV2ViewController.h"
#import "ApplyTextViewTableViewCell.h"
#import "ApplyTextFieldTableViewCell.h"
#import "ApplyDetailTableViewCell.h"
#import "ApplyDeadlineTableViewCell.h"
#import "MyDefine.h"
#import "Category.h"
#import <NSDate+DateTools.h>
#import "NSDate+String.h"
#import "UIColor+Hex.h"
#import "ApplyAddPeriodActionSheetView.h"
#import "ApplyAddDeadlineActionSheetView.h"
#import "ApplicationAttachmentTableViewCell.h"
#import "WZPhotoPickerController.h"
#import "ContactPersonDetailInformationModel.h"
#import "ApplyNameRightTableViewCell.h"
#import "NewApplyCreateV2Request.h"
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
#import "NewApplyGetFormInfoRequest.h"
#import "NewApplyAddApplyTitleTableViewCell.h"
#import "NewApplyFormBaseModel.h"
#import "NewApplyFormTimeModel.h"
#import "NewApplyFormPeopleModel.h"
#import "NewApplyFormPeriodModel.h"
#import "NSString+ApplyFeeHandle.h"
#import "NSString+HandleEmoji.h"
#import "GetLastApproveMemberRequest.h"
#import "NSDictionary+SafeManager.h"
//字典中存的key
#define STARTTIME @"StartTime"    //开始时间
#define ENDTIME   @"EndTime"      //终了时间
#define WHOLEDAY  @"WholeDay"     //整天

#define VOCATION  @"vEyVJ7K29qcovp3p"

NSString *const MCApplyListDataDidRefreshNotification = @"isNeedRefresh";

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


@interface NewApplyAddNewApplyV2ViewController ()
 <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ApplyAddPeriodActionSheetViewDelegate,ApplyAddDeadlineActionSheetViewDelegate, WZPhotoPickerControllerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, BaseRequestDelegate,UIActionSheetDelegate, MWPhotoBrowserDelegate,NewApplyAddApplyTitleTableViewCellDelegate>

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

@property(nonatomic, assign) BOOL  apprpoveClicked;

@property(nonatomic, assign) BOOL  CCApproveClicked;

@property (nonatomic, copy) takebackImgArray takeimgarrback;
@property(nonatomic, assign) BOOL  isDeadLineWholeday;

@property (nonatomic) CGFloat mustComeCellRowHieght; //审批人cell行高
@property (nonatomic) CGFloat canComeCellRowHieght;  //CC cell行高
@property (nonatomic, strong) NewApplyAddApplyTitleTableViewCell *mytitlecell;

@property (nonatomic, strong) NSString *workflowId;
@property (nonatomic, strong) NSString *formId;

@property (nonatomic, strong) NewApplyAllFormModel *allFormModel;
//用于判断输入的字符是否正确
@property(nonatomic, copy) NSString  *regex;
@property(nonatomic, strong) NSIndexPath *detailTextIndexPath;
@property (nonatomic, assign) BOOL avoidResign;

@end

static NSInteger const photoActionSheetTag = 111;

@implementation NewApplyAddNewApplyV2ViewController



- (instancetype)initWithApplykind:(ApplyContentType)kind workflowId:(NSString *)workflowId formId:(NSString *)formId;
{
    if (self = [super init])
    {
        
        _workflowId = workflowId;
        _formId = formId;
        self.applytype = ApplyActionTypeAdd;
        self.applykind = kind;
        
        
        if (self.applykind == ApplyContentTypeVocation)
        {
            self.model.T_SHOW_ID = VOCATION;
        }
        else if (self.applykind == ApplyContentTypeExpense)
        {
            self.model.T_SHOW_ID = EXPENSE;
        }
        NewApplyGetFormInfoRequest *request = [[NewApplyGetFormInfoRequest alloc] initWithDelegate:self];
        [request getFormId:self.formId];
        [self postLoading];
    }
    return self;
}

- (instancetype)initWithEditModel:(ApplyDetailInformationModel *)model appKind:(ApplyContentType)kind
{
    self.model = model;

    
    self.allFormModel = self.model.allFormModel;
    self.applytype = ApplyActionTypeEdit;
    self.applykind = kind;

    [self hanleSelectPersonForEdit];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(clickToBack)];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(APPLY_SEND) style:UIBarButtonItemStylePlain target:self action:@selector(clickToSend)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.mustComeCellRowHieght = 47;
    self.canComeCellRowHieght = 47;
    
    [self.tableView reloadData];
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
    if ([startTime isLaterThanOrEqualTo:endTime])
    {
        [self postError:@"结束时间必须晚于开始时间"];
        return;
    }
    
    self.model.try_IS_TIMESLOT_ALL_DAY = [[dic valueNumberForKey:WHOLEDAY] integerValue];
    self.model.IS_DEADLINE_ALL_DAY  = self.model.try_IS_TIMESLOT_ALL_DAY;
    //设时间显示
    if (self.model.try_IS_TIMESLOT_ALL_DAY)
    {
        self.periodTime = [startTime mtc_startToEndDate:endTime wholeDay:YES ];
    }else
    {
        self.periodTime = [startTime mtc_startToEndDate:endTime wholeDay:NO];
    }
    //记录准确时间
    self.model.try_A_START_TIME = (long long)[startTime timeIntervalSince1970] * 1000;
    self.model.try_A_END_TIME = (long long)[endTime timeIntervalSince1970] * 1000;
    [self.tableView reloadData];
}

- (NSString*)stringFromStart:(NSDate *)startDate end:(NSDate *)endDate
{
    NSString *str;
    if (startDate.year == endDate.year && startDate.month == endDate.month && startDate.day == endDate.day)
    {
        if (self.model.try_IS_TIMESLOT_ALL_DAY ) return str = [startDate mtc_startToEndDate:endDate wholeDay:YES];
        str = [startDate mtc_startToEndDate:endDate wholeDay:NO];
    }
    else
    {
		if (!self.model.try_IS_TIMESLOT_ALL_DAY ) return str = [startDate mtc_startToEndDate:endDate wholeDay:NO];
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

//- (void)closeDeadlineSwitch
//{
//    self.deadlineSwitch.on = NO;
//}
//
//- (void)deadLineValueChanged
//{   [self.view endEditing:YES];
//    if (self.deadlineSwitch.on) {
//        [self.view addSubview:self.deadLineView];
//        [self.view endEditing:YES];
//    }else
//    {
//        self.model.try_A_DEADLINE = 0;
//        self.deadLineTime = @"";
//        [self.tableView reloadData];
//    }
//}

- (void)selectPeople:(NSArray *)selectedList {
	
    if (self.apprpoveClicked)
    {
		
		NSString *approve = @"";
		NSString *apprpveName = @"";
		NSInteger i = 0;
		for (ContactPersonDetailInformationModel *model in selectedList)
		{
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
            CCApprove = [CCApprove stringByAppendingString:model.show_id];
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

- (BOOL)checkFeeHasDecimals:(double)fee {
	return (long)fee - fee != 0;
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
            if (self.model.try_A_IS_URGENT){
                return 1;
            }
            else{
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
//    return view;
//}

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
            
            break;
        }
        case cellPriority:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[CalendarSwitchTableViewCell identifier]];
            [cell isOn:(BOOL)self.model.try_A_IS_URGENT];
            [cell setSwitchColor:[UIColor themeRed]];
            [cell calendarSwitchDidChange:^(CalendarSwitchType swithType, BOOL ison) {
                self.model.try_A_IS_URGENT = ison;
				self.model.A_IS_URGENT = ison;
                if (ison)
                {
                    self.model.try_A_DEADLINE = 0;
					self.model.try_IS_DEADLINE_ALL_DAY = 0;
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
                if (self.model.try_IS_DEADLINE_ALL_DAY || self.model.IS_DEADLINE_ALL_DAY)
                {
                    NSString *dateStr = [format stringFromDate:deadline];
                    NSArray *strings = [dateStr componentsSeparatedByString: @" "];
                    [cell deadlineLbl].text = [NSString stringWithFormat:@"%@%@",strings[0],LOCAL(MISSION_ALLDAY)];
                }
            }
            break;
        }
        case cellCommon: //就是这里。。。。
        {
            if (self.applykind == ApplyContentTypeVocation)
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
                
                if (self.model.try_A_FEE == 0 && self.applytype == ApplyActionTypeEdit) {
                    for (NewApplyFormBaseModel*model in  self.model.allFormModel.arrFormModels) {
                        if (model.inputType == Form_inputType_textInput) {
							if ([model.inputDetail hasPrefix:@"¥"]) {
								model.inputDetail = [model.inputDetail stringByReplacingOccurrencesOfString:@"¥" withString:@"￥"];
							}
                            [cell expendField].text = model.inputDetail;
                            self.model.try_A_FEE = [NSString generateMoneyWithCustomeMoneyText:model.inputDetail];
                        }
                    }
                }else if (self.model.try_A_FEE)
                {
					NSMutableString *feeText = [@"￥" mutableCopy];
					if ([self checkFeeHasDecimals:self.model.try_A_FEE]) {
						[feeText appendFormat:@"%0.2f", self.model.try_A_FEE];
					} else {
						[feeText appendFormat:@"%ld", (long)self.model.try_A_FEE];
					}
					
					[cell expendField].text = [NSString generateCustomeMoneyTextWithCurrentText:feeText];
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
            if (self.model.try_attachMentArray) {
                [cell setImages:self.model.try_attachMentArray];
            }
            
            return cell;
            break;
        }
        case cellDetil:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplyTextViewTableViewCell identifier]];
            [cell setDelegate:self];
            [cell setTextWithModelStr:self.model.try_A_BACKUP];
			self.detailTextIndexPath = indexPath;
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
            if (self.applykind == ApplyContentTypeVocation)
            {
                [self.view endEditing:YES];
                [self.view addSubview:self.actionSheetView];
            }
            break;
        }
        case cellAccept:
        {
            //编辑状态下，审批的人和抄送人不能修改
            if (self.applytype == ApplyActionTypeEdit) {
                return;
            }
            SelectContactBookViewController *selectVc = [[SelectContactBookViewController alloc] initWithSelectedPeople:self.mustArr unableSelectPeople:self.tryArr];
			
			__weak typeof(self) weakSelf = self;
            [selectVc selectedPeople:^(NSArray *array) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
				if (!strongSelf) return ;
				
                strongSelf.apprpoveClicked = YES;
                [strongSelf selectPeople:array];
            }];
            
            [self presentViewController:selectVc animated:YES completion:nil];
            break;
        }
        case cellCC:
        {
            if (self.applytype == ApplyActionTypeEdit) {
                return;
            }
            SelectContactBookViewController *selectVc = [[SelectContactBookViewController alloc] initWithSelectedPeople:self.tryArr unableSelectPeople:self.mustArr];
			
			__weak typeof(self) weakSelf = self;
            [selectVc selectedPeople:^(NSArray *array) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
				if (!strongSelf) return ;
				
                strongSelf.CCApproveClicked = YES;
                [strongSelf selectPeople:array];
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
            return [self.mytitlecell getHeight];
//            return 45;

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
    
    if(!self.model.try_A_APPROVE || [self.model.try_A_APPROVE isEqualToString:@""] || !self.model.try_A_APPROVE_NAME || [self.model.try_A_APPROVE_NAME isEqualToString:@""])
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
    
    [self hideLoading];
    return YES;
}

- (BOOL)checkInputNumStr:(NSString *)num
{
    if ([num hasPrefix:@"￥"]) {
        num = [num substringFromIndex:1];
		num = [num stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",self.regex];
    if ([predicate evaluateWithObject:num]) {
        return  YES;
    }
    return NO;
}

- (void)clickToSend
{
    [self.view endEditing:YES];
    
    [self.tableView endEditing:YES];
    if (![self checkInfo]) {
        return;
    }
    
    if (self.isLoading) {
        return;
    }
    
    
    [self postLoading];
    if (self.applykind == ApplyContentTypeVocation)
    {
        self.model.T_SHOW_ID = VOCATION;
    }
    else
    {
        self.model.T_SHOW_ID = EXPENSE;
    }
    
    [self handleFormModel];
    
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
        case ApplyActionTypeEdit: {
            ApplyEditApplyRequest *request = [[ApplyEditApplyRequest alloc] initWithDelegate:self];
            if (self.applykind == ApplyContentTypeVocation) {
                [request editApplyWithModel:self.model applyType:k_Apply_Vocapation];
            }else if(self.applykind == ApplyContentTypeExpense)
            {
                [request editApplyWithModel:_model applyType:k_Apply_Expense];
            }
            
        }
            break;
            
        case ApplyActionTypeAdd: {
            NewApplyCreateV2Request *request = [[NewApplyCreateV2Request alloc] initWithDelegate:self];
			[request configureApproveDeadlineTime:self.model.A_DEADLINE isWholeDay:self.model.IS_DEADLINE_ALL_DAY];
            [request approveNewWithApproveShowId:self.model.T_SHOW_ID workflowId:self.workflowId formId:self.formId  model:self.allFormModel isUrgent:self.model.try_A_IS_URGENT];
        }
            break;
    }
}


- (void)handleFormModel {
    [self.allFormModel.arrFormModels enumerateObjectsUsingBlock:^(NewApplyFormBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.key isEqualToString:@"key0"] ) {
            obj.try_inputDetail = self.model.try_A_TITLE;
        }
        
        else if ([obj.key isEqualToString:@"key1"]) {
            
            if (self.applykind == ApplyContentTypeExpense) {
				
				if ([self checkFeeHasDecimals:self.model.try_A_FEE]) {
					obj.try_inputDetail = [NSString generateCustomeMoneyTextWithCurrentText:[NSString stringWithFormat:@"%0.2f", self.model.try_A_FEE]];
				} else {
					obj.try_inputDetail = [NSString generateCustomeMoneyTextWithCurrentText:[NSString stringWithFormat:@"%ld",(long)self.model.try_A_FEE]];
				}
				
            }
            else {
                NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.model.try_A_START_TIME / 1000];
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.model.try_A_END_TIME / 1000];
                if (self.model.try_IS_TIMESLOT_ALL_DAY)
                {
                    startDate = [NSDate dateWithYear:[startDate year] month:[startDate month] day:[startDate day] hour:0 minute:0 second:0];
                    endDate = [NSDate dateWithYear:[endDate year] month:[endDate month] day:[endDate day] hour:0 minute:0 second:0];
                }
                obj.try_inputDetail = @{NewForm_startTime:startDate, NewForm_endTime:endDate,NewForm_isTimeSlotAllDay:@(self.model.try_IS_TIMESLOT_ALL_DAY)};
            }
        }
        
        else if ([obj.key isEqualToString:@"key2"]) {
            NSArray *require = [self.model.try_A_APPROVE componentsSeparatedByString:@"●"];
            NSArray *requireName = [self.model.try_A_APPROVE_NAME componentsSeparatedByString:@"●"];
            NSMutableArray *userLists = [NSMutableArray array];
            
            for (NSInteger i = 0; i < require.count; i ++) {
                ContactPersonDetailInformationModel *model = [ContactPersonDetailInformationModel new];
                model.u_true_name = requireName[i];
                model.show_id = require[i];
                [userLists addObject:model];
            }
            
            obj.try_inputDetail = @{NewForm_modelArray:userLists};
        }
        
        else if ([obj.key isEqualToString:@"key3"]) {
            NSArray *cc     = [self.model.try_A_CC componentsSeparatedByString:@"●"];
            NSArray *ccName = [self.model.try_A_CC_NAME componentsSeparatedByString:@"●"];

            NSMutableArray *userLists = [NSMutableArray array];
            for (NSInteger i = 0; i < cc.count; i ++) {
                ContactPersonDetailInformationModel *model = [ContactPersonDetailInformationModel new];
                model.u_true_name = ccName[i];
                model.show_id = cc[i];
                [userLists addObject:model];
            }
            
            obj.try_inputDetail = @{NewForm_modelArray:userLists};
        }
        
        else if ([obj.key isEqualToString:@"key4"]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:[NSDate dateWithTimeIntervalSince1970:self.model.try_A_DEADLINE / 1000] forKey:@"deadline"];
			[dict setValue:@(self.isDeadLineWholeday ? 1 : 0) forKey:@"isDeadLineAllDay"];
            obj.try_inputDetail = dict;
        }
        
        else if ([obj.key isEqualToString:@"key5"]) {
            obj.try_inputDetail = self.model.try_attachMentArray;
        }
        
        else if ([obj.key isEqualToString:@"key6"]) {
            obj.try_inputDetail = self.model.try_A_BACKUP;
        }
    }];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[NewApplyGetFormInfoRequest class]]) {
        
        [self hideLoading];
        self.allFormModel = (NewApplyAllFormModel *)[(id)response model];
        self.allFormModel.formStr = [(NewApplyGetFormInfoResponse *)response formStr];
        self.formId =  [(NewApplyGetFormInfoResponse *)response strFormID];
        [self.view addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [self.model.attachMentArray removeAllObjects];
        [self.model.attachMentArray addObjectsFromArray:self.arrattachment];
        //保证1能取到
        if (self.allFormModel.arrFormModels.count >= 2) {
        NewApplyFormBaseModel *model = self.allFormModel.arrFormModels[1];
            if (model.rule != nil && ![model.rule isEqualToString:@""]) {
                self.regex = model.rule;
            }
        }
        if (self.applytype == ApplyActionTypeAdd) {
          [self.model removeAllAction];
        }
        
        if (self.applytype == ApplyActionTypeAdd) {
            GetLastApproveMemberRequest *request = [[GetLastApproveMemberRequest alloc] initWithDelegate:self];
            [request getLastApproveMemeberRequest];
            [self postLoading];
        }
    }
    
    else if ([request isKindOfClass:[AttachmentUploadRequest class]]) {
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
        if (self.applytype == ApplyActionTypeEdit) {
            // 编辑
            ApplyEditApplyRequest *request = [[ApplyEditApplyRequest alloc] initWithDelegate:self];
            if (self.applykind == ApplyContentTypeVocation) {
                [request editApplyWithModel:self.model applyType:k_Apply_Vocapation];
            }else if(self.applykind == ApplyContentTypeExpense)
            {
                [request editApplyWithModel:self.model applyType:k_Apply_Expense];
            }
        }
        
        else {
            // 新建
            NewApplyCreateV2Request *request = [[NewApplyCreateV2Request alloc] initWithDelegate:self];
			[request configureApproveDeadlineTime:self.model.A_DEADLINE isWholeDay:self.model.IS_DEADLINE_ALL_DAY];
            [request approveNewWithApproveShowId:self.model.T_SHOW_ID workflowId:self.workflowId formId:self.formId model:self.allFormModel isUrgent:self.model.try_A_IS_URGENT];
        }
    }
    else if ([request isKindOfClass:[NewApplyCreateV2Request class]])
    {
        [self.model refreshAction];
        [self hideLoading];
        [self postSuccess:LOCAL(SENDER_SUCCESS)];
        [self RecordToDiary:[NSString stringWithFormat:@"新建审批成功:%@",self.model.SHOW_ID]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MCApplyListDataDidRefreshNotification object:nil];
        NSNotification *notification = [NSNotification notificationWithName:MCApplyListDataDidRefreshNotification object:@(1)];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:1.0];
    }
    else if ([request isKindOfClass:[ApplyEditApplyRequest class]])
    {
        [self hideLoading];
        [self RecordToDiary:[NSString stringWithFormat:@"修改审批成功:%@",self.model.SHOW_ID]];
        [self.model refreshAction];
        [[NSNotificationCenter defaultCenter] postNotificationName:MCApplyListDataDidRefreshNotification object:nil];
        self.takeimgarrback(self.model.try_attachMentArray);
        [self postSuccess:LOCAL(SENDER_SUCCESS)];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:1.0];
    }else if([request isKindOfClass:[GetLastApproveMemberRequest class]])
    {
        
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary * responseDic = (NSDictionary *)response;
            self.model.arrCCList = [[responseDic valueMutableArrayForKey:@"aCc"] mutableCopy];
            self.model.arrCCNameList  = [[responseDic valueMutableArrayForKey:@"aCcName"] mutableCopy];
            self.model.arrAproveList  = [[responseDic valueMutableArrayForKey:@"aApprove"] mutableCopy];
            self.model.arrAproveNameList = [[responseDic valueMutableArrayForKey:@"aApproveName"] mutableCopy];
            [self hanleSelectPersonForEdit];
            [self.tableView reloadData];
        }

        [self hideLoading];
    }
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

-(void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 111)
    {
		[self.tableView scrollToRowAtIndexPath:self.detailTextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, -250);
            self.view.transform = transform;
        }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    //判断加上输入的字符，是否超过界限
    if (str.length > 200)
    {
        textView.text = [str substringToIndex:200];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 111)
    {
        self.model.try_A_BACKUP = textView.text;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 111) {
        // 禁止系统表情的输入
        if (textView.text.length > 0) {
			NSString *text = [textView.text stringByRemovingEmoji];
            if (![text isEqualToString:textView.text]) {
                textView.text = text;
            }
        }
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

- (void)ApplyAddDeadlineActionSheetViewDelegateCallBack_date:(NSDate *)date isWholeDay:(BOOL)wholeDay
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    if (wholeDay)
    {
        date = [NSDate dateWithYear:[date year] month:[date month] day:[date day]];
    }
   
    NSString *deadline = [dateFormate stringFromDate:date];
    self.deadLineTime = deadline;
    self.model.try_A_DEADLINE = (long long)[date timeIntervalSince1970] *1000;
	self.model.A_DEADLINE = self.model.try_A_DEADLINE;
    self.isDeadLineWholeday = wholeDay;
    self.model.try_IS_DEADLINE_ALL_DAY = self.isDeadLineWholeday;
	self.model.IS_DEADLINE_ALL_DAY = wholeDay;
    [self.tableView reloadData];
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

- (void)hanleSelectPersonForEdit
{
    NSMutableArray *ccmodelArr = [NSMutableArray array];
    NSString *tempCCNameStr = @"";
    NSString *tempCCStr = @"";
    for (int i = 0; i<self.model.arrCCList.count; i++) {
        ContactPersonDetailInformationModel *ccmodel = [[ContactPersonDetailInformationModel alloc] init];
        if (self.model.arrCCNameList.count) {
            ccmodel.u_true_name = self.model.arrCCNameList[i];
            tempCCNameStr = [tempCCNameStr stringByAppendingString:ccmodel.u_true_name];
            if (i != self.model.arrCCNameList.count - 1) {
             tempCCNameStr = [tempCCNameStr stringByAppendingString:@"●"];
            }
        }
        
        ccmodel.show_id = self.model.arrCCList[i];
        tempCCStr = [tempCCStr stringByAppendingString:ccmodel.show_id];
        if (i != self.model.arrCCList.count -1) {
          tempCCStr = [tempCCStr stringByAppendingString:@"●"];
        }
        [ccmodelArr addObject:ccmodel];
    }
    self.model.try_A_CC = tempCCStr;
    self.model.try_A_CC_NAME = tempCCNameStr;
    self.tryArr = ccmodelArr;
    
    
    NSMutableArray *approveModelArr = [NSMutableArray array];
    NSString *tempApproveNameStr = @"";
    NSString *tempApprove = @"";
    for (int i = 0; i<self.model.arrAproveList.count; i++) {
        ContactPersonDetailInformationModel *approvemodel = [[ContactPersonDetailInformationModel alloc] init];
        approvemodel.show_id = self.model.arrAproveList[i];
        
        tempApprove =  [tempApprove stringByAppendingString:approvemodel.show_id];
        if (i != self.model.arrAproveList.count - 1) {
            tempApprove = [tempApprove stringByAppendingString:@"●"];
        }
            
        if (self.model.arrAproveNameList.count) {
            approvemodel.u_true_name = self.model.arrAproveNameList[i];
            tempApproveNameStr = [tempApproveNameStr stringByAppendingString:approvemodel.u_true_name];
            if (i != self.model.arrAproveNameList.count - 1) {
               tempApproveNameStr = [tempApproveNameStr stringByAppendingString:@"●"];
            }
        }
        
        
        [approveModelArr addObject:approvemodel];
    }
    self.model.try_A_APPROVE = tempApprove;
    self.mustArr = approveModelArr;
    self.model.try_A_APPROVE_NAME = tempApproveNameStr;
    [self.tableView reloadData];
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
        self.view.transform  = CGAffineTransformMakeTranslation(0, -rect.size.height);
    }];
}

- (void)keyBoardWillHide:(NSNotification *)info
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform  = CGAffineTransformIdentity;
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if (scrollView == self.tableView) {
		[self.view endEditing:YES];
	}
}

#pragma mark - UITextFieldDelegate
-(void)TextfieldValueDidChanged:(UITextField *)textField
{
	
	if ([textField.text isEqualToString:@""]) {
        textField.text = @"";
        return;
    } else {
        if ([textField.text rangeOfString:@"￥"].location != NSNotFound) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
            textField.text = [@"￥" stringByAppendingString:textField.text];
		} else {
            textField.text = [@"￥" stringByAppendingString:textField.text];
        }
		
		NSString *str = [textField.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
		NSString *result = [NSString generateCustomeMoneyTextWithCurrentText:str];
		textField.text = result;
		self.model.try_A_FEE = [NSString generateMoneyWithCustomeMoneyText:result];
		
		NSLog(@"%@ - %f", textField.text, self.model.try_A_FEE);
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSRange oldDotRange = [textField.text rangeOfString:@"."];
	NSRange newDotRange = [string rangeOfString:@"."];
	
    if (oldDotRange.location != NSNotFound && newDotRange.location != NSNotFound) {
        return NO;
    }
	
	if (textField.text.length <= 1  && ([string isEqualToString:@"0"] || newDotRange.location != NSNotFound)) {
		textField.text = @"￥0.";
		return NO;
	}
	
    if (oldDotRange.location != NSNotFound) {
        NSArray *numArr = [textField.text componentsSeparatedByString:@"."];
        NSString *str = [numArr lastObject];
        //按减号的时候，允许删除
        if ([string isEqualToString:@""]) {
            return YES;
        }else if (str.length >= 2 ) {
            return NO;
        }
    }

	if ((oldDotRange.location == NSNotFound) && textField.text.length == 16 && ![string isEqualToString:@""] && ![string isEqualToString:@"."]) {
		return NO;
	}
	
	if (textField.text.length >= 19 && ![string isEqualToString:@""]) {
		return NO;
	}
	
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 10){self.model.try_A_TITLE =textField.text;}
    
    if (textField.tag == 11)
    {
        if (textField.text.length > 0)
        {
			if ([textField.text hasSuffix:@"."]) {
				textField.text = [textField.text stringByAppendingString:@"0"];
			}
			
            if (![self checkInputNumStr:textField.text])
            {
                [self postError:LOCAL(APPLY_INPUTMONEY) duration:1.0];
                textField.text = @"";
				self.model.try_A_FEE = 0;
                return;
            }
			
			self.model.try_A_FEE = [NSString generateMoneyWithCustomeMoneyText:textField.text];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField.tag == 10) {
		self.model.try_A_TITLE =textField.text;
	} else if (textField.tag == 11) {
		self.model.try_A_FEE = [NSString generateMoneyWithCustomeMoneyText:textField.text];
	}
	
    return YES;
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
        NSArray *arr1 = @[self.applykind == ApplyContentTypeVocation?LOCAL(APPLY_ADD_PERIOD_TITLE):LOCAL(APPLY_ADD_EXPENSED_TITLE)];
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
        if (self.applykind == ApplyContentTypeVocation)
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

- (NSString *)regex {
	if (!_regex) {
		_regex = @"^(([1-9]\\d{0,12})|0)(\\.\\d{1,2})?$";
	}
	
	return _regex;
}

@end
