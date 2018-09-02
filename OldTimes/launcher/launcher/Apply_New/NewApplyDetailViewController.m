//
//  NewApplyDetailViewController.m
//  launcher
//
//  Created by conanma on 16/1/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyDetailViewController.h"
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
#import "ApplyGetApplyDetailRequest.h"
#import "ApplyDetailInformationModel.h"
#import "ApplyDealWiththeApplyRequest.h"
#import "ApplyDeleteApplyRequest.h"
#import "ApplyAddViewController.h"
#import "ApplyCommentView.h"
#import "ApplyAddForExpenseViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "ApplyForwardingRequest.h"
#import "ApplicationAttachmentGetRequest.h"
#import "ApplyChangeCommentWordRequest.h"
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
typedef enum
{
//    kheaderCell  = 0, //头部cell ， 申请人和审批人不同
//    kAcceptCell = 1,      //承认者
//    kCCCell = 2,          //CC
//    kDeadlinCell = 3,     //最后期限
//    kMixCell = 4,         //休假期间,费用申请
//    kAttachmentCell = 5,  //添附
//    kLinkCell = 6,        //链接cell
//    kDealCell = 7,        //处理部分 ，申请人和审批人不同
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

@interface NewApplyDetailViewController ()<UIAlertViewDelegate ,ApplyDetail_ReviewTableViewCellBtnDelegate, ApplyCommentViewDelegate, ApplyNameRightTableViewCellDelegate>

//判断来自哪里

@property (nonatomic, strong) NSString *ShowID;
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

@implementation NewApplyDetailViewController
- (instancetype)initWithShowID:(NSString *)showid
{
    if (self = [super initWithAppShowIdType:kAttachmentAppShowIdApprove rmShowID:showid])
    {
        self.ShowID = showid;
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
    ApplyGetApplyDetailRequest *request = [[ApplyGetApplyDetailRequest alloc] initWithDelegate:self];
    [request GetShowID:self.ShowID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)backblock:(backblock)backblock {
    self.backblock = backblock;
}

- (void)configCreateComment {
    [self.createRequest setRmShowId:self.model.SHOW_ID];
    [self.createRequest setToUser:[self GetUsersWithApproveNames:self.model.arrAproveList CCNames:self.model.arrCCList WithCreater:self.model.CREATE_USER] toUserName:[self GetUsersWithApproveNames:self.model.arrAproveNameList CCNames:self.model.arrCCNameList WithCreater:self.model.CREATE_USER_NAME] title:self.model.A_TITLE];
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
            
            if (self.model.IS_CAN_MODIFY)
            {
                switch (index)
                {
                    case 2:
                        NSLog(@"share");
                        
                        break;
                    case 0:
                    {
                        if ([self.model.T_SHOW_ID isEqualToString:VOCATION])
                        {
                            //            ApplyAddViewController *vc = [[ApplyAddViewController alloc] initWithFrom:kEditApply];
                            NewApplyAddNewApplyViewController *vc = [[NewApplyAddNewApplyViewController alloc] initWithApplykind:applykind_vocation];
                            vc.applytype = Edit_Apply;
                            vc.model = self.model;
                            vc.arrattachment = self.arrattachments;
                            [vc takebackarray:^(NSMutableArray *arr) {
                                [self.arrattachments removeAllObjects];
                                [self.arrattachments addObjectsFromArray:arr];
                                [self.tableView reloadData];
                            }];
                            [self.navigationController pushViewController:vc animated:YES];
                        }else if ([self.model.T_SHOW_ID isEqualToString:EXPENSE])
                        {
                            //            ApplyAddForExpenseViewController *vc = [[ApplyAddForExpenseViewController alloc] init];
                            NewApplyAddNewApplyViewController *vc = [[NewApplyAddNewApplyViewController alloc] initWithApplykind:applykind_expense];
                            vc.applytype = Edit_Apply;
                            vc.model = self.model;
                            vc.arrattachment = self.arrattachments;
                            [vc takebackarray:^(NSMutableArray *arr) {
                                [self.arrattachments removeAllObjects];
                                [self.arrattachments addObjectsFromArray:arr];
                                [self.tableView reloadData];
                            }];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        else
                        {
                            NewApplyAddNewUserDefindedApplyViewController *vc = [[NewApplyAddNewUserDefindedApplyViewController alloc] initWithApplyStyle:apply_type_edit WithApplyShowID:self.model.T_SHOW_ID];;
                             vc.model = self.model;
                            vc.arrattachment = self.arrattachments;
                            [vc takebackarray:^(NSMutableArray *arr) {
                                [self.arrattachments removeAllObjects];
                                [self.arrattachments addObjectsFromArray:arr];
                                [self.tableView reloadData];
                            }];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        break;
                    }
                    case 1:
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
                switch (index)
                {
                    case 0:
                        self.status = @"CALL_BACK";
                        [self setUpCommentView];
                        
                        
                        break;
                    case 1:
                    {
                        self.status = @"DENY";
                        [self setUpCommentView];
                        break;
                    }
                    case 2:
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
            
            
            [self.DealWithEventview tapdismess];
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
        [arr addObject:creater];
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
    [self.navigationController pushViewController:self.photoBrowser animated:YES];
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
            ApplyForwardingRequest *request = [[ApplyForwardingRequest alloc] initWithDelegate:self];
            [request GetShowID:self.ShowID WithApprove:self.strNextApprovers WithApproveName:self.strNextApproverNames WithReason:self.strReason];
            [self postLoading];
        }
    }
    else
    {
        ApplyDealWiththeApplyRequest *request = [[ApplyDealWiththeApplyRequest alloc] initWithDelegate:self];
        [request GetShowID:self.ShowID WithStatus:self.status WithReason:self.strReason];
        [self postLoading];
    }
}

- (void)ApplyCommentViewDelegateCallBack_PresentAnotherVC {
    SelectContactBookViewController *selectVc = [[SelectContactBookViewController alloc] init];
    selectVc.singleSelectable = YES;
    
    [selectVc selectedPeople:^(NSArray *array) {
        ContactPersonDetailInformationModel *model = [array firstObject];
        if (!model) {
            return;
        }
        self.strNextApprovers = model.u_name;
        self.strNextApproverNames = model.u_true_name;
        [self.commentView setCommentViewStatus:kNextApprover];
        [self.commentView setHeadNameWithModel:model];
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
        ApplyDealWiththeApplyRequest *request = [[ApplyDealWiththeApplyRequest alloc] initWithDelegate:self];
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
                    //0.拒绝   1.退回  2.同意
                    switch (index)
                    {
                        case 0:
                            self.status = @"CALL_BACK";
                            [self setUpCommentView];
                            
                            
                            break;
                        case 1:
                        {
                            self.status = @"DENY";
                            [self setUpCommentView];
                            break;
                        }
                        case 2:
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

                }];
                return cell;
            }
                break;
            default: return nil;
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            NewApplyTotalDetail_RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewApplyTotalDetail_RightTableViewCell identifier]];
            if (!cell)
            {
                cell = [[NewApplyTotalDetail_RightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewApplyTotalDetail_RightTableViewCell identifier]];
            }
            if ([self.model.T_SHOW_ID isEqualToString:VOCATION])
            {
                [cell setItemName:LOCAL(APPLY_VOCATION_TITLE)];
                NSDate *dateStart = [NSDate dateWithTimeIntervalSince1970:self.model.A_START_TIME/1000];
                NSDate *dateEnd = [NSDate dateWithTimeIntervalSince1970:self.model.A_END_TIME/1000];
                if (dateStart.year == dateEnd.year && dateStart.month == dateEnd.month && dateStart.day == dateEnd.day)
                {
                    [cell  setDetailText:[dateStart mtc_startToEndDate:dateEnd wholeDay:NO]];
                }
                else
                {
                    [cell setDetailText:[dateStart mtc_startToEndDate:dateEnd wholeDay:YES]];
                }
            }
            else if ([self.model.T_SHOW_ID isEqualToString:EXPENSE])
            {
                [cell setItemName:LOCAL(APPLY_ADD_EXPENSED_TITLE)];
                [cell setDetailText:[NSString stringWithFormat:@"¥%d",(int)self.model.A_FEE]];
            }
            else
            {
                if (self.model.A_START_TIME> 0)
                {
                    [cell setItemName:LOCAL(APPLY_VOCATION_TITLE)];
                    NSDate *dateStart = [NSDate dateWithTimeIntervalSince1970:self.model.A_START_TIME/1000];
                    NSDate *dateEnd = [NSDate dateWithTimeIntervalSince1970:self.model.A_END_TIME/1000];
                    if (dateStart.year == dateEnd.year && dateStart.month == dateEnd.month && dateStart.day == dateEnd.day)
                    {
                        [cell  setDetailText:[dateStart mtc_startToEndDate:dateEnd wholeDay:NO]];
                    }
                    else
                    {
                        [cell setDetailText:[dateStart mtc_startToEndDate:dateEnd wholeDay:YES]];
                    }
                }
                else
                {
                    [cell setItemName:LOCAL(APPLY_ADD_EXPENSED_TITLE)];
                    [cell setDetailText:[NSString stringWithFormat:@"¥%d",(int)self.model.A_FEE]];
                }
            }
            return cell;
        }
        else
        {
            NewApplyTotalDetail_RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewApplyTotalDetail_RightTableViewCell identifier]];
            if (!cell)
            {
                cell = [[NewApplyTotalDetail_RightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewApplyTotalDetail_RightTableViewCell identifier]];
            }
            [cell setItemName:LOCAL(APPLY_ADD_EXPENSED_TITLE)];
            [cell setDetailText:[NSString stringWithFormat:@"¥%d",(int)self.model.A_FEE]];
            return cell;
        }
    }
    else if (indexPath.section == 2)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                if (self.model.A_APPROVE_PATH.count > 0)
                {
                    NewApplyNameListWithArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewApplyNameListWithArrowTableViewCellID"];
                    if (!cell)
                    {
                        cell = [[NewApplyNameListWithArrowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyNameListWithArrowTableViewCellID"];
                    }
                    [cell.lblTitle setText:LOCAL(APPLY_ADD_ACCEPT_TITLE)];
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
                else
                {
                    NewApplyApplyNameListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewApplyApplyNameListTableViewCellID"];
                    if (!cell)
                    {
                        cell = [[NewApplyApplyNameListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyApplyNameListTableViewCellID"];
                    }
                    [cell.lblTitle setText:LOCAL(APPLY_ADD_ACCEPT_TITLE)];
                    [cell setDataWithAllNameArr:[self.model.A_APPROVE_NAME componentsSeparatedByString:@"●"] needmorelines:self.needmore];
                    BOOL hide = [self.model.A_APPROVE_NAME isEqualToString:@""] || self.model.A_APPROVE_NAME == nil;
                    cell.hidden = hide;
                    return cell;
                }
            }
                break;
            case 1:
            {
                NewApplyApplyNameListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewApplyApplyNameListTableViewCellID"];
                if (!cell)
                {
                    cell = [[NewApplyApplyNameListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyApplyNameListTableViewCellID"];
                }
                [cell.lblTitle setText:LOCAL(APPLY_ADD_ACCEPT_CC_TITLE)];
                [cell setDataWithAllNameArr:[self.model.A_CC_NAME componentsSeparatedByString:@"●"] needmorelines:self.needmorecc];
                BOOL hide = [self.model.A_CC_NAME isEqualToString:@""] || self.model.A_CC_NAME == nil;
                cell.hidden = hide;
                return cell;
            }
                break;
            case 2:
            {
                ApplicationAttachmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
                if (!cell) {
                    cell = [[ApplicationAttachmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ApplicationAttachmentTableViewCell identifier]];
                }
                cell.hidden = NO;
                [cell clickToSeeImage:^(NSUInteger clickedIndex) {
                    [self selectShowImageAtIndex:clickedIndex];
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
                break;
            case 3:
            {
//                CalendarMakeSureDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CalendarMakeSureDetailTableViewCell identifier]];
//                [cell setDetailText:self.model.A_BACKUP];
                NewApplyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewApplyRecordTableViewCell identifier]];
                if (!cell)
                {
                    cell = [[NewApplyRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewApplyRecordTableViewCell identifier]];
                }
                [cell setDetailText:self.model.A_BACKUP];
                return cell;
            }
                break;
            default: return nil;
                break;
        }

    }
    else
    {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    
//    if (indexPath.section == 0)
//    {
//        switch (indexPath.row)
//        {
//            case 0:
//            {
//                ApplyTotalDetail_headTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplyTotalDetail_headTableViewCell identifier]];
//                if (!cell) {
//                    cell = [[ApplyTotalDetail_headTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ApplyTotalDetail_headTableViewCell identifier] from:(self.VCComeFrom ? theCharger : thePropose)];
//                }
//                
//                [cell SetDataWithModel:self.model];
//                return cell;
//            }
//                break;
//            case 1:
//            {
//                ApplyNameRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplyNameRightTableViewCell identifier]];
//                if (!cell)
//                {
//                    cell = [[ApplyNameRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ApplyNameRightTableViewCell identifier]];
//                    [cell.myTextLabel setText:LOCAL(APPLY_ADD_ACCEPT_TITLE)];
//                    
//                }
//                [cell setDelegate:self];
//                cell.indexPath = indexPath;
//                cell.isEdit = NO;
//                [cell setDataWithNameArr:[self.model.A_APPROVE_NAME componentsSeparatedByString:@"●"]];
//                
//                BOOL hide = [self.model.A_APPROVE_NAME isEqualToString:@""] || self.model.A_APPROVE_NAME == nil;
//                cell.hidden = hide;
//                return cell;
//            }
//                break;
//            case 2:
//            {
//                ApplyNameRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplyNameRightTableViewCell identifier]];
//                if (!cell) {
//                    cell = [[ApplyNameRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ApplyNameRightTableViewCell identifier]];
//                    [cell.myTextLabel setText:LOCAL(APPLY_ADD_ACCEPT_CC_TITLE)];
//                    [cell setDelegate:self];
//                    [cell setMyIndexPath:indexPath];
//                    [cell setMyIsEdit:NO];
//                }
//                [cell setDataWithNameArr:[self.model.A_CC_NAME componentsSeparatedByString:@"●"]];
//                BOOL hide = [self.model.A_CC_NAME isEqualToString:@""] || self.model.A_CC_NAME == nil;
//                cell.hidden = hide;
//                return cell;
//            }
//                break;
//            case 3:
//            {
//                ApplyTotalDetail_RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplyTotalDetail_RightTableViewCell identifier]];
//                if (!cell)
//                {
//                    cell = [[ApplyTotalDetail_RightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ApplyTotalDetail_RightTableViewCell identifier]];
//                    [cell setItemName:LOCAL(APPLY_DEADLINE_TITLE)];
//                }
//                [cell setDetailText:[self getDeadLineTime:self.model.A_DEADLINE]];
//                cell.hidden = self.model.A_DEADLINE <= 0;
//                return cell;
//            }
//                break;
//            case 4:
//            {
//                ApplyTotalDetail_RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplyTotalDetail_RightTableViewCell identifier]];
//                if (!cell)
//                {
//                    cell = [[ApplyTotalDetail_RightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ApplyTotalDetail_RightTableViewCell identifier]];
//                }
//                if ([self.model.T_SHOW_ID isEqualToString:@"vEyVJ7K29qcovp3p"])
//                {
//                    [cell setItemName:LOCAL(APPLY_VOCATION_TITLE)];
//                    NSDate *dateStart = [NSDate dateWithTimeIntervalSince1970:self.model.A_START_TIME/1000];
//                    NSDate *dateEnd = [NSDate dateWithTimeIntervalSince1970:self.model.A_END_TIME/1000];
//                    if (dateStart.year == dateEnd.year && dateStart.month == dateEnd.month && dateStart.day == dateEnd.day)
//                    {
//                        [cell  setDetailText:[dateStart mtc_startToEndDate:dateEnd wholeDay:NO]];
//                    }
//                    else
//                    {
//                        [cell setDetailText:[dateStart mtc_startToEndDate:dateEnd wholeDay:YES]];
//                    }
//                }
//                else
//                {
//                    [cell setItemName:LOCAL(APPLY_ADD_EXPENSED_TITLE)];
//                    [cell setDetailText:[NSString stringWithFormat:@"¥%d",(int)self.model.A_FEE]];
//                }
//                return cell;
//            }
//                break;
//            case 5:
//            {
//                ApplicationAttachmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
//                if (!cell) {
//                    cell = [[ApplicationAttachmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ApplicationAttachmentTableViewCell identifier]];
//                }
//                cell.hidden = NO;
//                [cell clickToSeeImage:^(NSUInteger clickedIndex) {
//                    [self selectShowImageAtIndex:clickedIndex];
//                }];
//                [cell titleLabel].text = LOCAL(APPLY_ATTACHMENT_TITLE);
//                if (self.arrattachments.count >0)
//                {
//                    [cell setImages:self.arrattachments];
//                }
//                else
//                {
//                    cell.hidden = YES;
//                }
//                return cell;
//            }
//                break;
//            case 6:
//            {
//                CalendarMakeSureDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CalendarMakeSureDetailTableViewCell identifier]];
//                [cell setDetailText:self.model.A_BACKUP];
//                return cell;
//            }
//                break;
//            case 7:
//            {
//                ApplyDetail_ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplyDetail_ReviewTableViewCell identifier]];
//                if (!cell) {
//                    cell = [[ApplyDetail_ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ApplyDetail_ReviewTableViewCell identifier]];
//                    cell.delegate = self;
//                }
//                
//                [cell setIconWithType:self.VCComeFrom ? kFromSender : kFromReciver];
//                cell.hidden = YES;
//                return cell;
//                break;
//            }
//            default: return nil;
//                break;
//        }
//    }
//    else
//    {
//        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger currentIndex = indexPath.section * 10 + row;
    if (currentIndex == kTitleCell)
    {
        NewApplyDetailTitleTableViewCell *cell = [[NewApplyDetailTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyDetailTitleTableViewCellID"];
        [cell setCCCellWithModel:self.model];
        return [cell getheight];
    }
    else if (currentIndex == kDetailCell)
    {
        return 50;
    }
    else if (currentIndex == kApplyBtns)
    {
        return 60;
    }
    else if (currentIndex == kApplyName)
    {
        if (self.model.A_APPROVE_PATH.count > 0)
        {
            NewApplyNameListWithArrowTableViewCell *cell = [[NewApplyNameListWithArrowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyNameListWithArrowTableViewCellID"];
            if (self.model.A_APPROVE_NAME.length > 0)
            {
                [cell getdataWithArray:self.model.A_APPROVE_PATH With:self.model.A_APPROVE_NAME];
            }
            else
            {
                [cell getdataWithArray:self.model.A_APPROVE_PATH];
            }
            return [cell getHeight];
        }
        else
        {
            if (self.needmore)
            {
                NewApplyApplyNameListTableViewCell *cell = [[NewApplyApplyNameListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyApplyNameListTableViewCellID"];
                [cell setDataWithAllNameArr:[self.model.A_APPROVE_NAME componentsSeparatedByString:@"●"] needmorelines:self.needmore];
                NSLog(@"%f",[cell getHeight]);
                return [cell getHeight];
            }
            else
            {
                if ([self.model.A_APPROVE_NAME isEqualToString:@""] || self.model.A_APPROVE_NAME == nil)
                {
                    return 0.01;
                }
                else
                {
                    return 45;
                }
                
            }
            
        }
    }
    else if (currentIndex == kApplyCC)
    {
        if (self.needmorecc)
        {
            NewApplyApplyNameListTableViewCell *cell = [[NewApplyApplyNameListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyApplyNameListTableViewCellID"];
            [cell setDataWithAllNameArr:[self.model.A_CC_NAME componentsSeparatedByString:@"●"] needmorelines:self.needmorecc];
            NSLog(@"%f",[cell getHeight]);
            return [cell getHeight];
        }
        else
        {
            if ([self.model.A_CC_NAME isEqualToString:@""] || self.model.A_CC_NAME == nil)
            {
                return 0.01;
            }
            else
            {
                return 45;
            }
        }
    }
    else if (currentIndex == kMixCell)
    {
        return 45;
    }
    else if (currentIndex == kMixCellMoney)
    {
        return 45;
    }
    else if (currentIndex == kAttachmentCell)
    {
        if (self.arrattachments.count >0)
        {
            return [ApplicationAttachmentTableViewCell heightForCellWithImages:self.arrattachments];
        }
        else
        {
            return 0.01f;
        }
    }
    else if (currentIndex == kLinkCell)
    {
//        NewApplyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewApplyRecordTableViewCell identifier]];
//        if (!cell)
//        {
//            cell = [[NewApplyRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewApplyRecordTableViewCell identifier]];
//        }
        
        return [NewApplyRecordTableViewCell heightForCell:self.model.A_BACKUP];
//        [cell setDetailText:self.model.A_BACKUP];
        
//        return [CalendarMakeSureDetailTableViewCell heightForCell:self.model.A_BACKUP];
    }
    else
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
//    if (self.VCComeFrom)
//    {
//        if (currentIndex == kheaderCell)
//        {
//            return 60.0f;
//        }
//        
//    }else
//    {
//        if (currentIndex == kheaderCell)
//        {
//            return 115.0f;
//        }
//    }
//    
//    if (currentIndex  == kAttachmentCell)
//    {
//        if (self.arrattachments.count >0)
//        {
//            return [ApplicationAttachmentTableViewCell heightForCellWithImageCount:self.arrattachments.count];
//        }
//        else
//        {
//            return 0.01f;
//        }
//        
//    }
//    if (currentIndex == kLinkCell)
//    {
//        return [CalendarMakeSureDetailTableViewCell heightForCell:self.model.A_BACKUP];
//    }
//    if (indexPath.section == 2 || indexPath.section == 1)
//    {
//        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
//    }
//    
//    if (currentIndex == kAcceptCell)
//    {
//        if ([self.model.A_APPROVE_NAME isEqualToString:@""] || self.model.A_APPROVE_NAME == nil)
//        {
//            return 0.01;
//        } else {
//            return self.mustComeCellRowHieght;
//        }
//    }else if (currentIndex == kCCCell)
//    {
//        if ([self.model.A_CC_NAME isEqualToString:@""] || self.model.A_CC_NAME == nil)
//        {
//            return 0.01;
//        } else {
//            return self.canComeCellRowHieght;
//        }
//    }else if (currentIndex == kDeadlinCell)
//    {
//        if (self.model.A_DEADLINE <= 0)
//        {
//            return 0.01;
//        }
//    }
//    if (currentIndex == kDealCell)
//    {
//        return 0.01;
//    }
//    
//    return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3 + [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.model.IS_CAN_APPROVE)
        {
            return 3;
        }
        else
        {
            return 2;
        }
//        if (self.VCComeFrom == FromReceiver)
//        {
//            if (self.Comefrom == Pass_From_Receiver)
//            {
//                if (([self.model.A_STATUS isEqualToString:@"WAITING"] || [self.model.A_STATUS isEqualToString:@"IN_PROGRESS"]) && self.disappearapprel == NO)
//                {
//                    //                    return 8;
//                    return 7;
//                }
//            }
//            else if (self.Comefrom == Pass_From_CC)
//            {
//                return 7;
//            }
//        }
//        else if (self.VCComeFrom == FromSender)
//        {
//            if ([self.model.A_STATUS isEqualToString:@"WAITING"] || [self.model.A_STATUS isEqualToString:@"CALL_BACK"])
//            {
//                //                return 8;
//                return 7;
//            }
//        }
//        return 7;
    }
    else if (section == 1)
    {
        if (self.model.A_START_TIME> 0 && self.model.A_FEE > 0)
        {
            return 2;
        }
        else if (self.model.A_START_TIME> 0)
        {
            return 1;
        }
        else if (self.model.A_FEE > 0)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else if (section == 2)
    {
        return 4;
    }
    else
    {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        if (!self.needmore)
        {
            self.needmore = YES;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    if (indexPath.section == 2 && indexPath.row == 1)
    {
        if (!self.needmorecc)
        {
            self.needmorecc = YES;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    if (indexPath.section == 3)
    {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2)
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
    if (section == 3)
    {
        return [super tableView:tableView viewForHeaderInSection:section];
    }
    else
    {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[ApplyGetApplyDetailRequest class]])
    {
        self.model = [(ApplyGetApplyDetailResponse *)response model];
        if (self.model.has_files == 1)
        {
            ApplicationAttachmentGetRequest *requestAttachment = [[ApplicationAttachmentGetRequest alloc] initWithDelegate:self];
            [requestAttachment getAppShowId:kAttachmentAppShowIdApprove mainShowId:self.ShowID];
            [self RecordToDiary:[NSString stringWithFormat:@"获取审批详情成功:%@",self.ShowID]];
        }
        else
        {
            [self hideLoading];
        }
        if (self.model.IS_CAN_APPROVE)
        {
//            self.Comefrom = Pass_From_Receiver;
        }
        self.mustComeCellRowHieght = [self getRowNumberWithData:[self.model.A_APPROVE_NAME  componentsSeparatedByString:@"●"] isMore:NO];
        self.canComeCellRowHieght = [self getRowNumberWithData:[self.model.A_CC_NAME  componentsSeparatedByString:@"●"] isMore:NO];
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
        if (self.model.IS_CAN_APPROVE)
        {
            self.DealWithEventview = [[NomarlDealWithEventView alloc] initWithArrayLogos:@[[UIImage imageNamed:@"backward-gray"],[UIImage imageNamed:@"X_gray"],[UIImage imageNamed:@"Accept"]] arrayTitles:@[LOCAL(APPLY_SENDER_BACKWARD_TITLE),LOCAL(APPLY_SENDER_UNACCEPT_TITLE),LOCAL(APPLY_SENDER_ACCEPT_TITLE)]];
            self.DealWithEventview.canappear = YES;
            
//            UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cyclecyclecycle"] style:UIBarButtonItemStyleDone target:self action:@selector(dealwithEvent)];
//            [self.navigationItem setRightBarButtonItem:barbtn];
        }
        else if (self.model.IS_CAN_MODIFY)
        {
//            self.DealWithEventview = [[NomarlDealWithEventView alloc] initWithArrayLogos:@[[UIImage imageNamed:@"edit_new"],[UIImage imageNamed:@"delete_new"]] arrayTitles:@[LOCAL(EDIT),LOCAL(MEETING_DELETE)]];
        //暂时去除编辑部分
              self.DealWithEventview = [[NomarlDealWithEventView alloc] initWithArrayLogos:@[[UIImage imageNamed:@"edit_new"]] arrayTitles:@[LOCAL(MEETING_DELETE)]];
            self.DealWithEventview.canappear = YES;
            
            UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cyclecyclecycle"] style:UIBarButtonItemStyleDone target:self action:@selector(dealwithEvent)];
            [self.navigationItem setRightBarButtonItem:barbtn];
        }
    }
    else if ([response isKindOfClass:[ApplyDealWiththeApplyResponse class]])
    {
        if (self.removeItemBlock)
        {
            self.removeItemBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([request isKindOfClass:[ApplyDeleteApplyRequest class]])
    {
        [self postSuccess:LOCAL(APPLY_DELETE_SUCCESS)];
        [self RecordToDiary:[NSString stringWithFormat:@"审批处理成功:%@",self.ShowID]];
        if (self.removeItemBlock)
        {
            self.removeItemBlock();
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    else if ([response isKindOfClass:[ApplicationAttachmentGetResponse class]])
    {
        [self RecordToDiary:[NSString stringWithFormat:@"获取审批附件成功成功:%@",self.ShowID]];
        [self.arrattachments addObjectsFromArray:[(id)response arrayAttachments]];
        NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:2];
        
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self hideLoading];
    }
    
    else if ([response isKindOfClass:[ApplyForwardingResponse class]])
    {
        [self postSuccess];
        [self RecordToDiary:[NSString stringWithFormat:@"审批抄送成功成功:%@",self.ShowID]];
        if (self.removeItemBlock)
        {
            self.removeItemBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else if ([request isKindOfClass:[ApplicationCommentNewRequest class]]){
        if (!self.model.IS_HAVECOMMENT) {
            ApplyChangeCommentWordRequest *request = [[ApplyChangeCommentWordRequest alloc] initWithDelegate:self];
            [request GetShowID:self.model.SHOW_ID];
            [self RecordToDiary:[NSString stringWithFormat:@"修改评论成功:%@",self.ShowID]];
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
    [self RecordToDiary:[NSString stringWithFormat:@"详情获取失败:%@",errorMessage]];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    if (alertView.tag == 0)
    {
        if ([self.model.T_SHOW_ID isEqualToString:VOCATION])
        {
//            ApplyAddViewController *vc = [[ApplyAddViewController alloc] initWithFrom:kEditApply];
            NewApplyAddNewApplyViewController *vc = [[NewApplyAddNewApplyViewController alloc] initWithApplykind:applykind_vocation];
            vc.applytype = Edit_Apply;
            vc.model = self.model;
            vc.arrattachment = self.arrattachments;
            [vc takebackarray:^(NSMutableArray *arr) {
                [self.arrattachments removeAllObjects];
                [self.arrattachments addObjectsFromArray:arr];
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
//            ApplyAddForExpenseViewController *vc = [[ApplyAddForExpenseViewController alloc] init];
            NewApplyAddNewApplyViewController *vc = [[NewApplyAddNewApplyViewController alloc] initWithApplykind:applykind_expense];
            vc.applytype = Edit_Apply;
            vc.model = self.model;
            vc.arrattachment = self.arrattachments;
            [vc takebackarray:^(NSMutableArray *arr) {
                [self.arrattachments removeAllObjects];
                [self.arrattachments addObjectsFromArray:arr];
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (alertView.tag == 1)
    {
        NSString *ShowID = self.model.SHOW_ID;
        ApplyDeleteApplyRequest *deleteRequest = [[ApplyDeleteApplyRequest alloc] initWithDelegate:self];
        [deleteRequest deleteApplyWithShowID:ShowID];
    }
}

#pragma mark - ApplyDetail_ReviewTableViewCellPassdelegate;
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
                if ([self.model.T_SHOW_ID isEqualToString:VOCATION])
                {
                    ApplyAddViewController *vc = [[ApplyAddViewController alloc] initWithFrom:kEditApply];
                    vc.model = self.model;
                    vc.arrattachment = self.arrattachments;
                    [vc takebackarray:^(NSMutableArray *arr) {
                        [self.arrattachments removeAllObjects];
                        [self.arrattachments addObjectsFromArray:arr];
                        [self.tableView reloadData];
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }else
                {
                    ApplyAddForExpenseViewController *vc = [[ApplyAddForExpenseViewController alloc] init];
                    vc.model = self.model;
                    vc.arrattachment = self.arrattachments;
                    [vc takebackarray:^(NSMutableArray *arr) {
                        [self.arrattachments removeAllObjects];
                        [self.arrattachments addObjectsFromArray:arr];
                        [self.tableView reloadData];
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
