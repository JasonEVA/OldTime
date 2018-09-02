//
//  ChatApplicationApplyViewController.m
//  launcher
//
//  Created by rainli on 16/5/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatApplicationApplyViewController.h"
#import "NewApplyMainV2ViewController.h"
#import "NewApplyDetailViewController.h"
#import "NewChatApproveEventTableViewCell.h"
#import "SelectContactBookViewController.h"
#import "ApplyDealWiththeApplyV2Request.h"
#import "ApplyForwardingV2Request.h"
#import "NewApplyDetailV2ViewController.h"
#import "ApplyCommentView.h"
#import "AppApprovalModel.h"
#import "ApplyForwardingRequest.h"
#import "ApplyDealWiththeApplyRequest.h"
#import <MintcodeIM/MintcodeIM.h>
#import "Category.h"
#import "MyDefine.h"
#import "JSONKitUtil.h"
#import "NewCalculateHeightManager.h"
#import "NewApplyDetailV2Request.h"

typedef enum{
    actionSheetTag_normal = 0,
    actionSheetTag_isWorkFlow = 1
}actionSheetTag;

@interface ChatApplicationApplyViewController ()<BaseRequestDelegate,NewChatApproveEventTableViewCellDelegate,ApplyCommentViewDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) ApplyCommentView * appCommentView;
@property (nonatomic,strong) NSString * strReason;
@property (nonatomic,strong) NSString * strNextApprovers;
@property (nonatomic,strong) NSString * strNextApproverNames;
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong) NSString * ShowID;
@end


@implementation ChatApplicationApplyViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self tableViewRegisterClass:[NewChatApproveEventTableViewCell class] forCellReuseIdentifier:NSStringFromClass(NewChatApproveEventTableViewCell.class)];
    
    // Do any additional setup after loading the view.
}
-(NSString *)applicationUid { return im_approval_uid; }

- (NSString *)buttonTitle { return LOCAL(Application_Apply); }
- (UIImage *)buttonImage { return [UIImage imageNamed:@"app_title_approval"]; }
- (UIImage *)buttonHighlightedImage { return [UIImage imageNamed:@"app_title_approvalselected"]; }

- (void)clickedButton {
    NewApplyMainV2ViewController *VC = [[NewApplyMainV2ViewController alloc] init];
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat)heightForMessageModel:(MessageBaseModel *)model {	
    return [NewChatApproveEventTableViewCell cellHeightWithAppModel:model.appModel];
}


- (UITableViewCell *)cellForMessageModel:(MessageBaseModel *)model withRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewChatApproveEventTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(NewChatApproveEventTableViewCell.class)];
    
    [cell setCellData:model];
    [cell setPath_row:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor grayBackground];
    cell.delegate = self;
    
    return cell;
}


- (void)didSelectCellForMessageModel:(MessageBaseModel *)model {
    MessageAppModel *appModel = model.appModel;
    NSString *showId;
    AppApprovalModel *approvalModel = [AppApprovalModel mj_objectWithKeyValues:appModel.applicationDetailDictionary];
    if (approvalModel.id.length != 0)
    {
        showId = approvalModel.id;
    }
    else
    {
        // 审批系统消息
        showId = appModel.msgRMShowID;
    }
	
	NewApplyDetailV2Request *request = [[NewApplyDetailV2Request alloc] initWithDelegate:self];
	[request detailWithShowId:showId];
	[self postLoading];
}






#pragma mark － NewChatApproveEventTableViewCell Delegate

- (void)approvalCellButtonClick:(NSString *)type path_row:(NSInteger)row
{
    [self setApplicationType:type path_row:row];
}

- (void)approvalCellButtonClick:(NSString *)type path_row:(NSInteger)row isWorkFlow:(BOOL)workflow
{
    self.status = type;
    MessageBaseModel * model = self.arrayDisplay[row];
    MessageAppModel * appModel = model.appModel;
    AppApprovalModel * approvalModel = [AppApprovalModel mj_objectWithKeyValues:appModel.applicationDetailDictionary];
    self.ShowID = approvalModel.id;
    
    if ([type isEqualToString:@"APPROVE"])
    {
        if (workflow)
        {
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(APPLY_MAKESURE), nil];
            actionSheet.tag = actionSheetTag_isWorkFlow;
            [actionSheet showInView:self.view];
        }
        else
        {
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(APPLY_MAKESURE),LOCAL(APPLY_MAKESURE_FORWARD), nil];
            actionSheet.tag = actionSheetTag_normal;
            [actionSheet showInView:self.view];
        }
        
    }
    else
    {
        [self ApplyCommentViewType:kNoApprover];
    }
}

- (void)setApplicationType:(NSString *)type path_row:(NSInteger)row
{
    self.status = type;
    
    MessageBaseModel * model = self.arrayDisplay[row];
    MessageAppModel * appModel = model.appModel;
    AppApprovalModel * approvalModel = [AppApprovalModel mj_objectWithKeyValues:appModel.applicationDetailDictionary];
    self.ShowID = approvalModel.id;
    
    if ([type isEqualToString:@"APPROVE"]) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(APPLY_MAKESURE),LOCAL(APPLY_MAKESURE_FORWARD), nil];
        [actionSheet showInView:self.view];
    } else {
        [self ApplyCommentViewType:kNoApprover];
    }
}

- (void)ApplyCommentViewType:(COMMENTSTATUS)type
{
    _appCommentView = [[ApplyCommentView alloc] initWithFrame:[UIScreen mainScreen].bounds withType:type];
    _appCommentView.delegate = self;
    [self.view addSubview:_appCommentView];
    [_appCommentView showKeyBoard];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == actionSheetTag_isWorkFlow)
    {
        switch (buttonIndex) {
            case 0:
            {
                ApplyDealWiththeApplyV2Request *request = [[ApplyDealWiththeApplyV2Request alloc] initWithDelegate:self];
                [request GetShowID:self.ShowID WithStatus:self.status WithReason:@""];
                [self postLoading];
                
            }
                break;
            case 1:
            case 2:
            {
                
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (buttonIndex) {
            case 0:
            {
                ApplyDealWiththeApplyV2Request *request = [[ApplyDealWiththeApplyV2Request alloc] initWithDelegate:self];
                [request GetShowID:self.ShowID WithStatus:self.status WithReason:@""];
                [self postLoading];
                
            }
                break;
                
            case 1:
            {
                [self ApplyCommentViewType:kAddApprover];
                //
            }
                break;
                
            case 2:
            {
                return;
            }
                break;
                
            default:
                break;
        }
    }
    
}


#pragma mark - ApplyCommentViewDelegate
- (void)ApplyCommentViewDelegateCallBack_SendTheTxt:(NSString *)text
{
    self.strReason = text;
    
    if ([self.status isEqualToString:@"APPROVE"])//同意
    {
        if ([text isEqualToString:@""] || !self.strNextApprovers || [self.strNextApprovers isEqualToString:@""])
        {
            if ([text isEqualToString:@""])   //审批意见是否为空
            {
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:LOCAL(APPLY_INPUT_APPLY_SUGGEST) message:nil delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil];
                [view show];
            }
            else
            {
                // 转发 - 是否选择转发人
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
- (void)ApplyCommentViewDelegateCallBack_PresentAnotherVC
{
    SelectContactBookViewController *VC = [[SelectContactBookViewController alloc] init];
    VC.singleSelectable = YES;
    
    __weak typeof(self) weakSelf = self;
    [VC selectedPeople:^(NSArray *array) {
        ContactPersonDetailInformationModel *model = [array firstObject];
        if (!model) {
            return;
        }
        
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) return ;


        strongSelf.strNextApprovers = model.show_id;
        strongSelf.strNextApproverNames = model.u_true_name;
        [strongSelf.appCommentView setCommentViewStatus:kNextApprover];
        [strongSelf.appCommentView setHeadNameWithModel:model];
    }];
    
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)ApplyCommentViewDelegateCallBack_CancleAction {
    self.strNextApprovers = nil;
}

#pragma mark -Request Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    [self hideLoading];
	if ([request isKindOfClass:[NewApplyDetailV2Request class]])
	{
		ApplyDetailInformationModel *model = (ApplyDetailInformationModel *)[(id)response infomodel];
		NewApplyDetailV2ViewController *detailVc = [[NewApplyDetailV2ViewController alloc] initWithShowID:model.SHOW_ID];
    
		[self.navigationController pushViewController:detailVc animated:YES];
	}
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
	[self hideLoading];
    [self postError:errorMessage];
}




@end

