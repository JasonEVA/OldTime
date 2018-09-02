//
//  NewApplyDetailV2ViewController.m
//  launcher
//
//  Created by williamzhang on 16/4/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyDetailV2ViewController.h"
#import "Masonry.h"
#import "Category.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import "NSDate+String.h"
#import "DateTools.h"
#import "ApplyTotalDetail_headTableViewCell.h"
#import "ApplyTotalDetail_CenterLbelTableViewCell.h"
#import "ApplyTotalDetail_RightTableViewCell.h"
#import "ApplicationAttachmentTableViewCell.h"
#import "ApplyDetail_ReviewTableViewCell.h"
#import "MeetingTwoBtnsTableViewCell.h"
#import "NewApplyDetailV2Request.h"
#import "ApplyDetailInformationModel.h"
#import "ApplyDealWiththeApplyV2Request.h"
#import "NewApplyDeleteV2Request.h"
#import "ApplyAddViewController.h"
#import "ApplyCommentView.h"
#import "ApplyAddForExpenseViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "ApplyForwardingV2Request.h"
#import "ApplicationAttachmentGetRequest.h"
#import "NewApplyChangeCommentV2Request.h"
#import "SelectContactBookViewController.h"
#import "ApplicationAttachmentModel.h"
#import "CalendarMakeSureDetailTableViewCell.h"
#import "ApplicationCommentNewRequest.h"
#import "NomarlDealWithEventView.h"
#import "ApplyNameRightTableViewCell.h"


#pragma new
#import "NewApplyDetailEventTableViewCell.h"
#import "NewApplyDetailTitleTableViewCell.h"
#import "NewApplyBtnsTableViewCell.h"
#import "NewApplyApplyNameListTableViewCell.h"
#import "NewApplyNameListWithArrowTableViewCell.h"
#import "NewApplyTotalDetail_RightTableViewCell.h"
#import "NewApplycommentbtnsView.h"
#import "NewApplyAddNewApplyViewController.h"
#import "NewApplyRecordTableViewCell.h"
#import "NewApplyAddNewUserDefindedApplyViewController.h"
#import "NewApplyFormBaseModel.h"
#import "NewApplyFormTimeModel.h"
#import "NewApplyFormPeopleModel.h"
#import "NewApplyGetFormInfoRequest.h"
#import "WebViewController.h"
#import "AttachmentUtil.h"
#import "NewApplyAddNewApplyV2ViewController.h"
#import "NSString+ApplyFeeHandle.h"
#import "NSDictionary+SafeManager.h"
#import "NSDate+Date.h"
#import <UIActionSheet+Blocks.h>

#import "NewApplyCreatAndEditViewController.h"
typedef enum
{
    kTitleCell = 0,
    kDetailCell = 1,
    kApplyBtns = 2,
    kMixCell = 10,
    kMixCellMoney = 11,
    kApplyName = 20,
    kApplyCC = 21,
    kAttachmentCell = 22,  //添附
    kLinkCell = 23,        //链接cell
}CELLTYPE;

typedef NS_ENUM(NSInteger, ACTIONSHEETTYPE) {
    kActionSheetDealBar = 101,
};

static NSInteger MWPhotoTag = 100;
static NSString *const kNewFormIsDeadLineAllDay = @"isDeadLineAllDay";
static NSString *const kNewFormDeadLine = @"deadline";
@interface NewApplyDetailV2ViewController ()<UIAlertViewDelegate ,ApplyDetail_ReviewTableViewCellBtnDelegate, ApplyCommentViewDelegate, ApplyNameRightTableViewCellDelegate, NewApplyRecordTableViewCellDelegate>

//判断来自哪里

@property (nonatomic, strong) NSString *ShowID;
@property (nonatomic, strong) NSString *workflowId;
@property (nonatomic, strong) ApplyDetailInformationModel *model;
@property (nonatomic, strong) ApplyCommentView *commentView;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *strNextApproverNames;
@property (nonatomic, strong) NSString *strNextApprovers;
@property (nonatomic, strong) NSString *strReason;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@property (nonatomic, copy) clickToRemoveItem  removeItemBlock;
@property (nonatomic, strong)NomarlDealWithEventView *DealWithEventview;

@property (nonatomic) CGFloat mustComeCellRowHieght; //审批人cell行高
@property (nonatomic) CGFloat canComeCellRowHieght;  //CC cell行高

@property (nonatomic) BOOL needmore;
@property (nonatomic) BOOL needmorecc;

@end

@implementation NewApplyDetailV2ViewController

- (instancetype)initWithShowID:(NSString *)ShowID {
    self = [super initWithAppShowIdType:kAttachmentAppShowIdApprove rmShowID:ShowID];
    if (self) {
        _ShowID = ShowID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mustComeCellRowHieght = 47;
    self.canComeCellRowHieght = 47;
    self.needmore = NO;
    self.needmorecc = NO;
    
    self.navigationItem.title = LOCAL(APPLY_CONFIRM_TITLE);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[CalendarMakeSureDetailTableViewCell class] forCellReuseIdentifier:[CalendarMakeSureDetailTableViewCell identifier]];
    
    [self postLoading];
    //好吧，他是先请求表单内部的数据，然后在请求表单的
    NewApplyDetailV2Request *request = [[NewApplyDetailV2Request alloc] initWithDelegate:self];
    [request detailWithShowId:self.ShowID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)backblock:(backblock)backblock {
    self.backblock = backblock;
}

- (void)configCreateComment {
    [self.createRequest setRmShowId:self.model.SHOW_ID];
    
    NSMutableArray *toUserArray = [self GetUsersWithApproveNames:self.model.arrAproveList CCNames:self.model.arrCCList WithCreater:self.model.CREATE_USER];
    NSMutableArray *toUserNameArray = [self GetUsersWithApproveNames:self.model.arrAproveNameList CCNames:self.model.arrCCNameList WithCreater:self.model.CREATE_USER_NAME];
    
    //检查内部是否有数据 －－ 修复通过状态下的评论推送问题
    if (self.model.A_APPROVE_PATH.count) {
        for (NSDictionary *dict in self.model.A_APPROVE_PATH) {
            if (![toUserArray containsObject:[dict valueStringForKey:@"USER"]]) { //修复打回状态下的评论推送问题
                [toUserArray addObject:[dict valueStringForKey:@"USER"]];
                [toUserNameArray addObject:[dict valueStringForKey:@"USER_NAME"]];
            }
        }
    }
    

    [self.createRequest setToUser:toUserArray
					   toUserName:toUserNameArray
							title:self.model.A_TITLE];
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
		__weak typeof(self) weakSelf = self;
        [self.DealWithEventview setpassbackBlock:^(NSInteger index) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
			if (!strongSelf) return ;

			
            if (strongSelf.model.IS_CAN_MODIFY)
            {

				if ([strongSelf.model.A_STATUS isEqualToString:@"WAITING"] || index){
					UIAlertView *view = [[UIAlertView alloc] initWithTitle:LOCAL(APPLY_MAKESURE_DELETE) message:nil delegate:strongSelf cancelButtonTitle:LOCAL(CANCEL) otherButtonTitles:LOCAL(CERTAIN), nil];
					view.tag = 1;
					[view show];
				
                } else {
                    //进入编辑状态
                        [strongSelf gotoEditVc];
                  
                }
            }
            else
            {
                switch (index)
                {
                    case 0:
                        strongSelf.status = @"CALL_BACK";
                        [strongSelf setUpCommentView];
                        
                        
                        break;
                    case 1:
                    {
                        strongSelf.status = @"DENY";
                        [strongSelf setUpCommentView];
                        break;
                    }
                    case 2:
                    {
                        strongSelf.status = @"APPROVE";
                        [strongSelf.view endEditing:YES];
                        UIActionSheet *actionview = [[UIActionSheet alloc] initWithTitle:nil delegate:strongSelf cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(APPLY_MAKESURE),LOCAL(APPLY_MAKESURE_FORWARD), nil];
                        actionview.tag = kActionSheetDealBar;
                        [actionview showInView:strongSelf.view];
                        break;
                    }
                    default:
                        break;
                }
            }
            
            
            [strongSelf.DealWithEventview tapdismess];
        }];
        [self.view addSubview:self.DealWithEventview];
        [self.DealWithEventview appear];
        
    }
    
}

#pragma mark - Interface Method
- (void)clickToRemoveWithBlock:(clickToRemoveItem)removeBlock
{
    self.removeItemBlock = removeBlock;
}

#pragma mark - Privite Methods
//根据取得选中人数，返回行数
- (NSInteger)getRowNumberWithData:(NSArray *)array isMore:(BOOL)isMore{
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
    if (isMore) {
        if ((self.view.frame.size.width - 110) / 10 >= labelTextTest.length)
        {
            return 45;
        } else {
            return (labelTextTest.length / ((self.view.frame.size.width - 110) / 10) + 1) * 15 + 45;
        }
        
    } else {
        if ((self.view.frame.size.width - 110) / 10 >= labelTextTest.length)
        {
            return 45;
        }
        else if ((self.view.frame.size.width - 110) / 15 < labelTextTest.length && (self.view.frame.size.width - 110) / 7 >= labelTextTest.length)
        {
            return 60;
            
        } else
        {
            return 75;
        }
    }
    
}

- (NSMutableArray *)GetUsersWithApproveNames:(NSMutableArray *)ApproveName CCNames:(NSMutableArray *)CCNames
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:ApproveName];
    BOOL needAdd;
    for (NSString *str in CCNames)
    {
        needAdd = YES;
        for (NSString *str2 in ApproveName)
        {
            if ([str isEqualToString:str2])
            {
                needAdd = NO;
            }
        }
        if (needAdd)
        {
            [arr addObject:str];
        }
    }
    return arr;
}

- (NSMutableArray *)GetUsersWithApproveNames:(NSMutableArray *)ApproveName CCNames:(NSMutableArray *)CCNames WithCreater:(NSString *)creater
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:ApproveName];
    BOOL needAdd;
    for (NSString *str in CCNames)
    {
        needAdd = YES;
        for (NSString *str2 in ApproveName)
        {
            if ([str isEqualToString:str2])
            {
                needAdd = NO;
            }
        }
        if (needAdd)
        {
            [arr addObject:str];
        }
    }
    BOOL needAddCreater = YES;
    for (NSString *str in arr)
    {
        if ([str isEqualToString:creater])
        {
            needAddCreater = NO;
        }
    }
    if (needAddCreater)
    {
        if ([creater length]) {
            [arr addObject:creater];
        }
    }
    return arr;
}

- (NSString *)getDeadLineTime:(long long)time
{
    NSString *str;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDate *today = [NSDate date];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"",LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY),nil];
    
    if (date.year == today.year && date.month == today.month && date.day == today.day)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        str = [NSString stringWithFormat:@"%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[df stringFromDate:date]];
    }
    else if (date.year == today.year)
    {
        str = [NSString stringWithFormat:@"%ld/%ld(%@)%ld:%ld",date.month,date.day,[arr objectAtIndex:date.weekday -1],date.hour,date.minute];
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy/MM/dd HH:mm"];
        str = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
    }
    if ([str hasPrefix:@"1970"]) return nil;
    return str;
}

- (void)setUpCommentView
{
    if ([self.status isEqualToString:@"CALL_BACK"] || [self.status isEqualToString:@"DENY"])
    {
        self.commentView = [[ApplyCommentView alloc] initWithFrame:[UIScreen mainScreen].bounds withType:kNoApprover];
    }else
    {
        self.commentView = [[ApplyCommentView alloc] initWithFrame:[UIScreen mainScreen].bounds withType:kAddApprover];
    }
    self.commentView.delegate = self;
    [self.view addSubview:self.commentView];
    [self.commentView showKeyBoard];
}

#pragma mark - NewApplyRecordTableViewCellDelegate
- (void)newApplyRecordTableViewCellDidClickRichText:(NSString *)text textType:(RichTextType)textType {
	switch (textType) {
		case RichTextNumber: {
			NSString *title = [NSString stringWithFormat:LOCAL(CHAT_CALL_NUMBER), text];
			[UIActionSheet showInView:self.view withTitle:title cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:@[LOCAL(CHAT_CALL), LOCAL(MESSAGE_COPY)] tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
				if(buttonIndex == 0){
					NSString *callPhone =[NSString stringWithFormat:@"tel:%@", text];
					NSURL *url = [NSURL URLWithString:callPhone];
					[[UIApplication sharedApplication] openURL:url];
				}
				
				if(buttonIndex == 1){
					UIPasteboard *pboard = [UIPasteboard generalPasteboard];
					pboard.string = text;
				}
				
			}];
			
			break;
		}
			
		case RichTextNone:
		case RichTextURL:
		case RichTextEmail:
			break;
	}
	
}
#pragma mark - ApplyNameRightTableViewCellDelegate

- (void)ApplyNameRightTableViewCellDelegateCallBack_moreClick:(NSIndexPath *)indexPath
{
    ApplyNameRightTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 1) {
        self.mustComeCellRowHieght = [self getRowNumberWithData:[self.model.A_APPROVE_NAME  componentsSeparatedByString:@"●"] isMore:YES];
    } else if (indexPath.row == 2) {
        self.canComeCellRowHieght = [self getRowNumberWithData:[self.model.A_CC_NAME  componentsSeparatedByString:@"●"] isMore:YES];
        
    }
    [self.tableView reloadData];
    cell.isMore = YES;
    NSString *stringTmp = indexPath.row == 1 ? self.model.A_APPROVE_NAME : self.model.A_CC_NAME;
    NSArray *array = [stringTmp componentsSeparatedByString:@"●"];
    [cell setDataWithNameArr:array];
}

#pragma mark - MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if (photoBrowser.identifier == MWPhotoTag) {
        return self.arrattachments.count;
    }
    
    return [super numberOfPhotosInPhotoBrowser:photoBrowser];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (photoBrowser.identifier == MWPhotoTag)
    {
        if (index >= self.arrattachments.count) {
            return nil;
        }
        
        ApplicationAttachmentModel *model = [self.arrattachments objectAtIndex:index];
        if (model.localPath) {
            return [MWPhoto photoWithImage:model.originalImage];
        }
        return [MWPhoto photoWithURL:[NSURL URLWithString:model.path]];
    }
    
    return [super photoBrowser:photoBrowser photoAtIndex:index];
}

/// 选择点击的附件
- (void)selectedAttchmentAtIndex:(NSUInteger)selectedIndex {
	ApplicationAttachmentModel *model = self.arrattachments[selectedIndex];
	if (![AttachmentUtil isImage: model.title]) {
		[self selectedShowFileWithModel:model];
	} else {
		[self selectShowImageAtIndex:selectedIndex];
	}
}

/// 查看文件
- (void)selectedShowFileWithModel:(ApplicationAttachmentModel *)model {
	WebViewController *webVC = [[WebViewController alloc] initWithURL:model.path shouldDownload:YES];
	webVC.title = model.title;
	[self.navigationController pushViewController:webVC animated:YES];
}

/** 点击查看照片 */
- (void)selectShowImageAtIndex:(NSUInteger)selectedIndex {
    self.photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.photoBrowser.identifier = MWPhotoTag;
    self.photoBrowser.displayTrashButton = NO;
    self.photoBrowser.alwaysShowControls = YES;
    self.photoBrowser.zoomPhotosToFill = YES;
    self.photoBrowser.enableGrid = NO;
    self.photoBrowser.gridButton.hidden = YES;
    self.photoBrowser.enableSwipeToDismiss = NO;
    [self.photoBrowser showNextPhotoAnimated:YES];
    [self.photoBrowser showPreviousPhotoAnimated:YES];
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
	navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:navigationController animated:YES completion:nil];
    [self.photoBrowser setCurrentPhotoIndex:selectedIndex];
}

#pragma mark - applyCommetViewDelegate
- (void)ApplyCommentViewDelegateCallBack_SendTheTxt:(NSString *)text
{
    self.strReason = text;
    
    if ([self.status isEqualToString:@"APPROVE"])
    {
        if ([text isEqualToString:@""] || !self.strNextApprovers)
        {
            if ([text isEqualToString:@""])
            {
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:LOCAL(APPLY_INPUT_APPLY_SUGGEST) message:nil delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil];
                [view show];
            }
            else
            {
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:LOCAL(APPLY_INPUT_NEXT_APPRALLER) message:nil delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil];
                [view show];
            }
        }
        else
        {
            ApplyForwardingV2Request *request = [[ApplyForwardingV2Request alloc] initWithDelegate:self];
            [request GetShowID:self.ShowID WithApprove:self.strNextApprovers WithApproveName:self.strNextApproverNames WithReason:self.strReason];
            [self postLoading];
        }
    }
    else
    {
        ApplyDealWiththeApplyV2Request *request = [[ApplyDealWiththeApplyV2Request alloc] initWithDelegate:self];
        [request GetShowID:self.ShowID WithStatus:self.status WithReason:self.strReason];
        [self postLoading];
    }
}

- (void)ApplyCommentViewDelegateCallBack_PresentAnotherVC {
    SelectContactBookViewController *selectVc = [[SelectContactBookViewController alloc] init];
    selectVc.singleSelectable = YES;
	
	__weak typeof(self) weakSelf = self;
    [selectVc selectedPeople:^(NSArray *array) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
        ContactPersonDetailInformationModel *model = [array firstObject];
        if (!model) {
            return;
        }
        strongSelf.strNextApprovers = model.show_id;
        strongSelf.strNextApproverNames = model.u_true_name;
        [strongSelf.commentView setCommentViewStatus:kNextApprover];
        [strongSelf.commentView setHeadNameWithModel:model];
    }];
    [self presentViewController:selectVc animated:YES completion:nil];
}

#pragma mark - actionsheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag != kActionSheetDealBar) {
        [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
        return;
    }
    
    if (buttonIndex == 0)
    {
        ApplyDealWiththeApplyV2Request *request = [[ApplyDealWiththeApplyV2Request alloc] initWithDelegate:self];
        [request GetShowID:self.model.SHOW_ID WithStatus:self.status WithReason:LOCAL(APPLY_ACCEPT)];
    }
    else if (buttonIndex == 2)
    {
        
    }
    
    else if (buttonIndex == 1)
    {
        [self setUpCommentView];
    }
}

#pragma mark - UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	__weak typeof(self) weakSelf = self;
	
    if (indexPath.section >= [self.model.allFormModel.showFormModels count]) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }

    //section == 0
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                NewApplyDetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewApplyDetailTitleTableViewCellID"];
                if (!cell)
                {
                    cell = [[NewApplyDetailTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyDetailTitleTableViewCellID"];
                }
                [cell setCCCellWithModel:self.model];
                return cell;
            }
                break;
            case 1:
            {
                NewApplyDetailEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewApplyDetailEventTableViewCellID"];
                if (!cell)
                {
                    cell = [[NewApplyDetailEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyDetailEventTableViewCellID'"];
                }
                [cell setmodel:self.model];
                return cell;
            }
                break;
            case 2:
            {
                NewApplyBtnsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewApplyBtnsTableViewCellID"];
                if (!cell)
                {
                    cell = [[NewApplyBtnsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyBtnsTableViewCellID"];
                }
                [cell setblock:^(NSInteger index)
                 {
					 __strong typeof(weakSelf) strongSelf = weakSelf;
					 if (!strongSelf) return ;

                     //0.拒绝   1.退回  2.同意
                     switch (index)
                     {
                         case 0:
                             strongSelf.status = @"DENY";
                             [strongSelf setUpCommentView];
                             break;
                         case 1:
                         {
                             strongSelf.status = @"CALL_BACK";
                             [strongSelf setUpCommentView];
                             break;
                         }
                         case 2:
                         {
                             strongSelf.status = @"APPROVE";
                             [strongSelf.view endEditing:YES];
                             UIActionSheet *actionview = [[UIActionSheet alloc] initWithTitle:nil delegate:strongSelf cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(APPLY_MAKESURE),LOCAL(APPLY_MAKESURE_FORWARD), nil];
                             actionview.tag = kActionSheetDealBar;
                             [actionview showInView:strongSelf.view];
                             break;
                         }
                         default:
                             break;
                     }
                     
                 }];
                return cell;
            }
                break;
            default: return [UITableViewCell new];
                break;
        }
    }
    

    NewApplyFormBaseModel *model = [self.model.allFormModel.showFormModels objectAtIndex:indexPath.section][indexPath.row];

    switch (model.inputType) {
        case Form_inputType_textInput:
        case Form_inputType_textArea:
        {
             NewApplyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewApplyRecordTableViewCell identifier]];
            if (!cell)
            {
                cell = [[NewApplyRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewApplyRecordTableViewCell identifier]];
            }
			
			cell.delegate = self;
            cell.lblTitle.text = model.labelText;
			[cell setDetailText:model.inputDetail];
            [cell setHidden:![model.inputDetail length]];
            return cell;
        }
            break;
        case Form_inputType_singleChoose:
        case Form_inputType_multiChoose:
        case Form_inputType_timeSlot:
        case Form_inputType_timePoint:
        case Form_inputType_approvePeriod:
        {
            NewApplyTotalDetail_RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewApplyTotalDetail_RightTableViewCell identifier]];
            if (!cell) {
                cell = [[NewApplyTotalDetail_RightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewApplyTotalDetail_RightTableViewCell identifier]];
            }
            
            [cell setItemName:model.labelText];
            if (model.inputType == Form_inputType_singleChoose) {
                [cell setDetailText:model.inputDetail];
            }
            else if (model.inputType == Form_inputType_multiChoose) {
                [cell setDetailText:[model.inputDetail componentsJoinedByString:@","]];
            }
            else if (model.inputType == Form_inputType_timePoint ||
                     model.inputType == Form_inputType_approvePeriod)
            {
                if (model.try_inputDetail[NewForm_startTime] == [NSNull null]) {
                    return cell;
                }
                if (model.inputType == Form_inputType_timePoint)
                {
                    //对应三种数据类型
                    if ([model.try_inputDetail isKindOfClass:[NSDictionary class]])
                    {
                        if ([model.inputDetail count] > 1)
                        {
                            //新的数据结构有两个字段
                            id obj = model.try_inputDetail[NewForm_startTime];
                            if (obj != NULL && ![obj isKindOfClass:[NSNumber class]] && obj != [NSNull null]) {
                                BOOL isWholeDay = [model.inputDetail valueBoolForKey:NewForm_isTimeSlotAllDay];
                                NSDate *date = [NSDate getDate:model.inputDetail[NewForm_startTime]];
                                [cell setDetailText:[NSDate mtc_getDateStrWihtDate:date isWholeDay:isWholeDay]];
                            }
                            
                         }else
                         {
                             if (model.try_inputDetail[NewForm_startTime] != [NSNull null]) {
                                [cell setDetailText:[NSDate mtc_getDateStrWihtDate:[NSDate getDate:model.inputDetail[NewForm_startTime]]isWholeDay:NO]];
                             }
                         }
                    }
                    else if ([model.try_inputDetail isKindOfClass:[NSDate class]])//兼容旧数据
                    {
                        NSDate *date = [NSDate getDate:model.inputDetail];
                        [cell setDetailText:[NSDate mtc_getDateStrWihtDate:date isWholeDay:NO]];
                    
                    }
                    else if([model.try_inputDetail isKindOfClass:[NSNumber class]])
                    {
                        if ([model.try_inputDetail integerValue] != 0)
                        {
                            NSDate *date = [NSDate getDate:model.inputDetail];
                            [cell setDetailText:[NSDate mtc_getDateStrWihtDate:date isWholeDay:NO]];
                        }
                    }
                }else if(model.inputType == Form_inputType_approvePeriod)
                {
                    if ([model.inputDetail isKindOfClass:[NSDictionary class]])
                    {
                        if ([model.inputDetail count] > 1)
                        {
                            //新的数据结构有两个字段
                            id obj = model.try_inputDetail[kNewFormDeadLine];
                            if (obj != NULL && [obj isKindOfClass:[NSNumber class]]) {
                                if ([obj integerValue] != 0) {
                                    BOOL isWholeDay = [model.inputDetail valueBoolForKey:kNewFormIsDeadLineAllDay];
                                    NSDate *date = [NSDate getDate:model.inputDetail[kNewFormDeadLine]];
                                    [cell setDetailText:[NSDate mtc_getDateStrWihtDate:date isWholeDay:isWholeDay]];
                                }
                            }
                        }else
                        {
                            [cell setDetailText:[NSDate mtc_getDateStrWihtDate:[NSDate getDate:model.inputDetail[NewForm_startTime]]isWholeDay:NO]];
                        }
                    }
                }
            }
            else if (model.inputType == Form_inputType_timeSlot)
            {
                if (model.try_inputDetail[NewForm_startTime] == [NSNull null]) {
                    return cell;
                }
                BOOL isWholeDay = [model.inputDetail valueBoolForKey:NewForm_isTimeSlotAllDay];
                [cell setDetailText:[model.inputDetail[NewForm_startTime] mtc_startToEndDate:model.inputDetail[NewForm_endTime] wholeDay:isWholeDay]];
            }
            return cell;
        }
            break;
        case Form_inputType_requiredPeopleChoose:
        case Form_inputType_ccPeopleChoose:
        {
            BOOL requiredPeople = model.inputType == Form_inputType_requiredPeopleChoose;
            if (requiredPeople && self.model.A_APPROVE_PATH.count) {
                NewApplyNameListWithArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewApplyNameListWithArrowTableViewCellID"];
                if (!cell)
                {
                    cell = [[NewApplyNameListWithArrowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyNameListWithArrowTableViewCellID"];
                }
                [cell.lblTitle setText:model.labelText];
                if (self.model.A_APPROVE_NAME.length > 0)
                {
                    [cell getdataWithArray:self.model.A_APPROVE_PATH With:self.model.A_APPROVE_NAME];
                }
                else
                {
                    [cell getdataWithArray:self.model.A_APPROVE_PATH];
                }
                return cell;
            }
            
            NewApplyApplyNameListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(NewApplyApplyNameListTableViewCell.class)];
            if (!cell) {
                cell = [[NewApplyApplyNameListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(NewApplyApplyNameListTableViewCell.class)];
            }
            
            [cell.lblTitle setText:model.labelText];
            NSString *showingName = [model.inputDetail objectForKey:NewForm_showingName];
            [cell setDataWithAllNameArr:[showingName componentsSeparatedByString:@"●"] needmorelines:(requiredPeople ? self.needmore : self.needmorecc)];
            BOOL hide = ![showingName length];
            cell.hidden = hide;
            
            return cell;
        }
        case Form_inputType_file:
        {
            ApplicationAttachmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
            if (!cell) {
                cell = [[ApplicationAttachmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ApplicationAttachmentTableViewCell identifier]];
            }
            cell.hidden = NO;
            [cell clickToSeeImage:^(NSUInteger clickedIndex) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
				[strongSelf selectedAttchmentAtIndex:clickedIndex];
            }];
            [cell titleLabel].text = LOCAL(APPLY_ATTACHMENT_TITLE);
            if (self.arrattachments.count >0)
            {
                [cell setImages:self.arrattachments];
            }
            else
            {
                cell.hidden = YES;
            }
            return cell;
        }
        default:
            break;
    }
    
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= [self.model.allFormModel.showFormModels count]) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    NSInteger row = indexPath.row;
    NSInteger currentIndex = indexPath.section * 10 + row;
    
    if (currentIndex == kTitleCell) {
        if (![self.model.A_TITLE length]) {
            return 0;
        }
        static NewApplyDetailTitleTableViewCell *cell;
        if (!cell) {
            cell = [[NewApplyDetailTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        [cell setCCCellWithModel:self.model];
        return [cell getheight];
    }
    if (currentIndex == kDetailCell)
    {
        return 50;
    }
    else if (currentIndex == kApplyBtns)
    {
        return 60;
    }
    
    NewApplyFormBaseModel *model = [self.model.allFormModel.showFormModels objectAtIndex:indexPath.section][indexPath.row];
   
    switch (model.inputType) {
        case Form_inputType_textArea:
        case Form_inputType_textInput:
            return [NewApplyRecordTableViewCell heightForCell:model.inputDetail];
        case Form_inputType_multiChoose:
        case Form_inputType_singleChoose:
        case Form_inputType_approvePeriod:
        case Form_inputType_timeSlot:
        case Form_inputType_timePoint:
            return 45;
        case Form_inputType_requiredPeopleChoose:
        {
            if (self.model.A_APPROVE_PATH.count) {
                static NewApplyNameListWithArrowTableViewCell *cell;
                if (!cell) cell = [[NewApplyNameListWithArrowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                if (self.model.A_APPROVE_NAME.length) {
                    [cell getdataWithArray:self.model.A_APPROVE_PATH With:self.model.A_APPROVE_NAME];
                }
                else {
                    [cell getdataWithArray:self.model.A_APPROVE_PATH];
                }
                return [cell getHeight];
            }
            // fallthrough
        }
        case Form_inputType_ccPeopleChoose:
        {
            NSString *showingName = [model.inputDetail objectForKey:NewForm_showingName];
            
            BOOL requiredPeople = model.inputType == Form_inputType_requiredPeopleChoose;
            BOOL needMore = requiredPeople ? self.needmore : self.needmorecc;
            if (!needMore) {
                return [showingName length] ? 45 : 0;
            }
            
            static NewApplyApplyNameListTableViewCell *cell;
            if (!cell) cell = [[NewApplyApplyNameListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            [cell setDataWithAllNameArr:[showingName componentsSeparatedByString:@"●"] needmorelines:needMore];
            return [cell getHeight];
        }
        case Form_inputType_file:
            return [self.arrattachments count] ? [ApplicationAttachmentTableViewCell heightForCellWithImages:self.arrattachments] : 0;
        case Form_inputType_unknown:
        default: return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.model.allFormModel.showFormModels count] + [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= [self.model.allFormModel.showFormModels count]) {
        return [super tableView:tableView numberOfRowsInSection:section];
        
    }
    
    if (section == 0) {
        return (self.model.IS_CAN_APPROVE ? 3 : 2);
    }
    
    return [[self.model.allFormModel.showFormModels objectAtIndex:section] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    if (indexPath.section >= [self.model.allFormModel.showFormModels count]) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    if (indexPath.section == 0) {
        // 自定义的不需要点击事件
        return;
    }
    
    NewApplyFormBaseModel *model = [self.model.allFormModel.showFormModels objectAtIndex:indexPath.section][indexPath.row];
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	
	if ([selectedCell isKindOfClass:[NewApplyApplyNameListTableViewCell class]]) {
		if (model.inputType == Form_inputType_requiredPeopleChoose) {
			self.needmore = ![(NewApplyApplyNameListTableViewCell *)selectedCell needmore];
			if (!self.needmore) {
				self.needmore = YES;
				[tableView reloadData];
			}
		} else if (model.inputType == Form_inputType_ccPeopleChoose) {
			self.needmorecc = ![(NewApplyApplyNameListTableViewCell *)selectedCell needmore];
			if (!self.needmorecc) {
				self.needmorecc = YES;
				[tableView reloadData];
			}
		}
		
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < [self.model.allFormModel.showFormModels count]) {
        if (section == 1) {
            
        }
        return 15;
    }
    
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == [self.model.allFormModel.showFormModels count])
    {
        return [super tableView:tableView viewForHeaderInSection:section];
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}

#pragma mark - BaseRequest Delegate
- (void)setCanAtUserMembersWithDetialModel:(ApplyDetailInformationModel *)model {
	
	NSMutableArray *membersKey = [NSMutableArray array];
	if (model.A_APPROVE && ![model.A_APPROVE isEqualToString:@""]) {
		NSArray *approvers = [model.A_APPROVE componentsSeparatedByString:@"●"];
		[membersKey addObjectsFromArray:approvers];
	}
	
	if (model.A_CC && ![model.A_CC isEqualToString:@""]) {
		NSArray *ccers = [model.A_CC componentsSeparatedByString:@"●"];
		[membersKey addObjectsFromArray:ccers];
	}
	
	NSMutableArray *names = [NSMutableArray array];
	if (model.A_APPROVE_NAME && ![model.A_APPROVE_NAME isEqualToString:@""]) {
		NSArray *approverNames = [model.A_APPROVE_NAME componentsSeparatedByString:@"●"];
		[names addObjectsFromArray:approverNames];
	}
	
	if (model.A_CC_NAME && ![model.A_CC_NAME isEqualToString:@""]) {
		NSArray *ccNames = [model.A_CC_NAME componentsSeparatedByString:@"●"];
		[names addObjectsFromArray:ccNames];
	}
	
	if ((model.CREATE_USER && ![model.CREATE_USER isEqualToString:@""])) {
		[membersKey addObject:model.CREATE_USER];
		[names addObject:model.CREATE_USER_NAME];
	}
	
	if (model.A_APPROVE_PATH && model.A_APPROVE_PATH.count > 0) {
		
		[model.A_APPROVE_PATH enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull memeberDic, NSUInteger idx, BOOL * _Nonnull stop) {
		
			__block BOOL isContained = NO;
			NSString *userId = memeberDic[@"USER"];
			NSString *userName = memeberDic[@"USER_NAME"];
			[membersKey enumerateObjectsUsingBlock:^(NSString *  _Nonnull existUserID, NSUInteger idx, BOOL * _Nonnull stop) {
				if ([existUserID isEqualToString:userId]) {
					isContained = YES;
					*stop = YES;
				}
			}];
			
			if (!isContained) {
				[membersKey addObject:userId];
				[names addObject:userName];
			}
		}];
		
	}
	
	[self setAllowAtUserMemberIDs:membersKey memeberNames:names];
	
}

- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[NewApplyGetFormInfoRequest class]]) {
        
        
        self.model.allFormModel = (NewApplyAllFormModel *)[(id)response model];
        [self.model handleValues];
        [self hideLoading];
        [self.tableView reloadData];
    }
    
    else if ([request isKindOfClass:[NewApplyDetailV2Request class]])
    {
        self.model = (ApplyDetailInformationModel *)[(id)response infomodel];
        
		[self setCanAtUserMembersWithDetialModel:self.model];
        NewApplyGetFormInfoRequest *request = [[NewApplyGetFormInfoRequest alloc] initWithDelegate:self];
        [request getFormId:self.model.A_FORM_INSTANCE_ID];
        
        if (self.model.has_files == 1)
        {
            ApplicationAttachmentGetRequest *requestAttachment = [[ApplicationAttachmentGetRequest alloc] initWithDelegate:self];
            [requestAttachment getAppShowId:kAttachmentAppShowIdApprove mainShowId:self.ShowID];
        }
        self.mustComeCellRowHieght = [self getRowNumberWithData:[self.model.A_APPROVE_NAME  componentsSeparatedByString:@"●"] isMore:NO];
        self.canComeCellRowHieght = [self getRowNumberWithData:[self.model.A_CC_NAME  componentsSeparatedByString:@"●"] isMore:NO];
        
        
        if (self.model.IS_CAN_MODIFY)
        {

            if ([self.model.A_STATUS isEqualToString:@"WAITING"]){//待审批 只能删除
                self.DealWithEventview = [[NomarlDealWithEventView alloc] initWithArrayLogos:@[[UIImage imageNamed:@"delete_new"]] arrayTitles:@[LOCAL(MEETING_DELETE)]];
            }else if([self.model.A_STATUS isEqualToString:@"CALL_BACK"]){ //打回  能删除和编辑
                self.DealWithEventview = [[NomarlDealWithEventView alloc] initWithArrayLogos:@[[UIImage imageNamed:@"edit_new"],[UIImage imageNamed:@"delete_new"]] arrayTitles:@[LOCAL(CALENDAR_CONFIRM_EDIT),LOCAL(MEETING_DELETE)]];
            }
            self.DealWithEventview.canappear = YES;
            
            UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cyclecyclecycle"] style:UIBarButtonItemStyleDone target:self action:@selector(dealwithEvent)];
            [self.navigationItem setRightBarButtonItem:barbtn];
        }
    }
    else if ([request isKindOfClass:[ApplyDealWiththeApplyV2Request class]])
    {
        if (self.removeItemBlock)
        {
            self.removeItemBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([request isKindOfClass:[NewApplyDeleteV2Request class]])
    {
        [self postSuccess:LOCAL(APPLY_DELETE_SUCCESS)];
    
        if (self.removeItemBlock)
        {
            self.removeItemBlock();
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    else if ([response isKindOfClass:[ApplicationAttachmentGetResponse class]])
    {
        [self.arrattachments addObjectsFromArray:[(id)response arrayAttachments]];
        self.model.try_attachMentArray = self.arrattachments;
        [self.tableView reloadData];
    }
    
    else if ([request isKindOfClass:[ApplyForwardingV2Request class]])
    {
        [self postSuccess];

        if (self.removeItemBlock)
        {
            self.removeItemBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else if ([request isKindOfClass:[ApplicationCommentNewRequest class]]){
        if (!self.model.IS_HAVECOMMENT) {
            [NewApplyChangeCommentV2Request changeCommentShowId:self.model.SHOW_ID];
        }
        
        self.model.IS_HAVECOMMENT = 1;
        [super requestSucceeded:request response:response totalCount:totalCount];
    }
    else {
        [super requestSucceeded:request response:response totalCount:totalCount];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    if (alertView.tag == 1)
    {
        NSString *ShowID = self.model.SHOW_ID;
        NewApplyDeleteV2Request *deleteRequest = [[NewApplyDeleteV2Request alloc] initWithDelegate:self];
        [deleteRequest ApplyDeleteRequestWithShowId:ShowID];
    }
}

- (void)gotoEditVc
{
    //参数好多T.T
    NewApplyCreatAndEditViewController *editVc = [[NewApplyCreatAndEditViewController alloc]
                                                  editWithFormID:self.model.A_FORM_INSTANCE_ID
                                                  WorkFlowID:self.workflowId
                                                  EditModel:self.model
                                                  attachMentArray:self.arrattachments];
    
    [self.navigationController pushViewController:editVc animated:YES];
    
}

//    ApplyContentType currentkind = [self.model.T_SHOW_ID isEqualToString:VOCATION]?ApplyContentTypeVocation:ApplyContentTypeExpense;
//    NewApplyAddNewApplyV2ViewController *editVc =[[NewApplyAddNewApplyV2ViewController alloc]         initWithEditModel:self.model appKind:currentkind];
//    editVc.applytype = ApplyActionTypeEdit;
//    editVc.model = self.model;
//    editVc.arrattachment = self.arrattachments;
//
//    __weak typeof(self) weakSelf = self;
//
//    [editVc takebackarray:^(NSMutableArray *arr) {
//        [weakSelf.arrattachments removeAllObjects];
//        [weakSelf.arrattachments addObjectsFromArray:arr];
//        [weakSelf.tableView reloadData];
//    }];

#pragma mark - ApplyDetail_ReviewTableViewCellPassdelegate;
#pragma mark - ApplyDetail_ReviewTableViewCellPassdelegate  Unused-----;
- (void)ApplyDetail_ReviewTableViewCellPassTheBtn:(UIButton *)btn
{
    if (self.model.IS_CAN_MODIFY)
    {
        switch (btn.tag)
        {
            case 1:
                NSLog(@"share");
                
                break;
            case 2:
            {
				__weak typeof(self) weakSelf = self;
                if ([self.model.T_SHOW_ID isEqualToString:VOCATION])
                {
                    ApplyAddViewController *vc = [[ApplyAddViewController alloc] initWithFrom:kEditApply];
                    vc.model = self.model;
                    vc.arrattachment = self.arrattachments;
                    [vc takebackarray:^(NSMutableArray *arr) {
                        [weakSelf.arrattachments removeAllObjects];
                        [weakSelf.arrattachments addObjectsFromArray:arr];
                        [weakSelf.tableView reloadData];
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }else
                {
                    ApplyAddForExpenseViewController *vc = [[ApplyAddForExpenseViewController alloc] init];
                    vc.model = self.model;
                    vc.arrattachment = self.arrattachments;
                    [vc takebackarray:^(NSMutableArray *arr) {
                        [weakSelf.arrattachments removeAllObjects];
                        [weakSelf.arrattachments addObjectsFromArray:arr];
                        [weakSelf.tableView reloadData];
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                break;
            }
            case 3:
            {
                if ([self.model.A_STATUS isEqualToString:@"WAITING"])
                {
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:LOCAL(APPLY_MAKESURE_DELETE) message:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) otherButtonTitles:LOCAL(CERTAIN), nil];
                    view.tag = 1;
                    [view show];
                }
                else
                {
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:LOCAL(APPLY_CANNOT_DELETE_APPLY) message:nil delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles: nil];
                    view.tag = 2;
                    [view show];
                }
                
                break;
            }
            default:
                break;
        }
    }
    else
    {
        switch (btn.tag)
        {
            case 1:
                self.status = @"CALL_BACK";
                [self setUpCommentView];
                
                
                break;
            case 2:
            {
                self.status = @"DENY";
                [self setUpCommentView];
                break;
            }
            case 3:
            {
                self.status = @"APPROVE";
                [self.view endEditing:YES];
                UIActionSheet *actionview = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(APPLY_MAKESURE),LOCAL(APPLY_MAKESURE_FORWARD), nil];
                actionview.tag = kActionSheetDealBar;
                [actionview showInView:self.view];
                break;
            }
            default:
                break;
        }
    }
}


#pragma mark - initilizer
- (ApplyDetailInformationModel *)model
{
    if (!_model)
    {
        _model = [[ApplyDetailInformationModel alloc] init];
    }
    return _model;
}

- (NSMutableArray *)arrattachments
{
    if (!_arrattachments)
    {
        _arrattachments = [[NSMutableArray alloc] init];
    }
    return _arrattachments;
}

@synthesize createRequest = _createRequest;
- (ApplicationCommentNewRequest *)createRequest {
    if (!_createRequest) {
        _createRequest = [[ApplicationCommentNewRequest alloc] initWithDelegate:self appShowID:self.appShowId commentType:ApplicationMsgType_approvalComment];
    }
    return _createRequest;
}

@end
