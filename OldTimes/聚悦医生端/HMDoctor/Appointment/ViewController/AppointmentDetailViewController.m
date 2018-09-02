//
//  AppointmentDetailViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AppointmentDetailViewController.h"
#import "AppointmentInfo.h"
#import "AppointmentDetailTableViewCell.h"
#import "AppointmentDetailImageTableViewCell.h"

@interface AppointmentDetailViewController ()
<TaskObserver,
UIAlertViewDelegate>
{
    AppointmentInfo* appointInfo;
    UIView* operationview;
    AppointmentDetailTableViewController* tvcAppointmentDetail;
}
@end

@interface AppointmentDetailTableViewController ()
<AppointmentDetailImageTableViewCellDelegate>
{
    NSMutableArray* imageHeightNumbers;
    BOOL enableRefreshImages;
}
@property (nonatomic, retain) AppointmentDetail* detail;
@end

@implementation AppointmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"约诊详情"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[AppointmentInfo class]])
    {
        appointInfo = (AppointmentInfo*) self.paramObject;
    }
    
    operationview = [[UIView alloc]init];
    [self.view addSubview:operationview];
    [operationview setBackgroundColor:[UIColor whiteColor]];
    [operationview showTopLine];
    
    tvcAppointmentDetail = [[AppointmentDetailTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcAppointmentDetail];
    [self.view addSubview:tvcAppointmentDetail.tableView];
    
    [self subviewLayout];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", (long)appointInfo.appointId] forKey:@"appointId"];
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AppointmentDetailTask" taskParam:dicPost TaskObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) subviewLayout
{
    [operationview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.height.mas_equalTo(@75);
    }];
    
    [tvcAppointmentDetail.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.view);
        make.bottom.equalTo(operationview.mas_top);
    }];
}

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname ||  0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"DealUserAppointmetnTask"])
    {
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:[NSString stringWithFormat:@"%ld", appointInfo.appointId] forKey:@"appointId"];
        [self.view showWaitView];
        [[TaskManager shareInstance] createTaskWithTaskName:@"AppointmentDetailTask" taskParam:dicPost TaskObserver:self];
    }

}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname ||  0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"AppointmentDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[AppointmentDetail class]])
        {
            AppointmentDetail* detail = (AppointmentDetail*) taskResult;
            appointInfo = detail;
            [tvcAppointmentDetail setDetail:detail];
            [self setButtomViewWithAppointmentDetail:detail];
        }
    }
    
    }

- (void) setButtomViewWithAppointmentDetail:(AppointmentDetail*) detail
{
    NSArray* subviews = [operationview subviews];
    for (UIView* subview in subviews)
    {
        [subview removeFromSuperview];
    }
    [self.navigationItem setTitle:@"约诊详情"];
    switch (detail.status)
    {
        case 1:
        {
//            NSString* staffRole = [[UserInfoHelper defaultHelper] staffRole];
            BOOL dealPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:detail.status OperateCode:kPrivilegeProcessOperate];
 
            if (dealPrivilege)
            {
                [self.navigationItem setTitle:@"处理约诊"];
                
                UIButton* refusebutton = [UIButton buttonWithType:UIButtonTypeCustom];
                [operationview addSubview:refusebutton];
                [refusebutton setTitle:@"拒绝" forState:UIControlStateNormal];
                [refusebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [refusebutton.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [refusebutton.layer setCornerRadius:2.5];
                [refusebutton.layer setMasksToBounds:YES];
                // [UIImage rectImage:CGSizeMake(320, 64) Color:<#(UIColor *)#>]
                [refusebutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 64) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
                
                [operationview addSubview:refusebutton];
                [refusebutton addTarget:self action:@selector(refuseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [refusebutton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(operationview).with.offset(12.5);
                    //make.right.equalTo(operationview).with.offset(-12.5);
                    make.top.equalTo(operationview).with.offset(15);
                    make.bottom.equalTo(operationview).with.offset(-15);
                }];
                
                UIButton* accecptbutton = [UIButton buttonWithType:UIButtonTypeCustom];
                [operationview addSubview:accecptbutton];
                [accecptbutton setTitle:@"接受" forState:UIControlStateNormal];
                [accecptbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [accecptbutton.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [accecptbutton.layer setCornerRadius:2.5];
                [accecptbutton.layer setMasksToBounds:YES];
                // [UIImage rectImage:CGSizeMake(320, 64) Color:<#(UIColor *)#>]
                [accecptbutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 64) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
                
                [operationview addSubview:accecptbutton];
                [accecptbutton addTarget:self action:@selector(accecptButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [accecptbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(refusebutton.mas_right).with.offset(30);
                    make.right.equalTo(operationview).with.offset(-12.5);
                    make.width.equalTo(refusebutton);
                    make.top.equalTo(operationview).with.offset(15);
                    make.bottom.equalTo(operationview).with.offset(-15);
                }];

            }
            else
            {
                [self hideOperationview];
            }
            break;
        }
            
        case 2:
        {
//            NSString* staffRole = [[UserInfoHelper defaultHelper] staffRole];
            BOOL dealPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:detail.status OperateCode:kPrivilegeConfirmOperate];
            StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
            
            if (dealPrivilege && detail.staffId == staff.staffId)
            {
                UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
                [operationview addSubview:button];
                [button setTitle:@"确认就诊" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
                [button.layer setCornerRadius:2.5];
                [button.layer setMasksToBounds:YES];
                // [UIImage rectImage:CGSizeMake(320, 64) Color:<#(UIColor *)#>]
                [button setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 64) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
                
                [operationview addSubview:button];
                [button addTarget:self action:@selector(appointmentConfirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(operationview).with.offset(12.5);
                    make.right.equalTo(operationview).with.offset(-12.5);
                    make.top.equalTo(operationview).with.offset(15);
                    make.bottom.equalTo(operationview).with.offset(-15);
                }];

            }
            else
            {
                [self createDefaultStatusButton:detail];
            }

        }
            break;
        default:
        {
            [self createDefaultStatusButton:detail];
        }
            break;
    }
}

- (void) hideOperationview
{
    [operationview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@0);
    }];
}

- (void) createDefaultStatusButton:(AppointmentDetail*) detail;
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [operationview addSubview:button];
    [button setTitle:[detail statusString] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button.layer setCornerRadius:2.5];
    [button.layer setMasksToBounds:YES];
    // [UIImage rectImage:CGSizeMake(320, 64) Color:<#(UIColor *)#>]
    [button setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 64) Color:[UIColor commonLightGrayTextColor]] forState:UIControlStateDisabled];
    [button setEnabled:NO];
    [operationview addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(operationview).with.offset(12.5);
        make.right.equalTo(operationview).with.offset(-12.5);
        make.top.equalTo(operationview).with.offset(15);
        make.bottom.equalTo(operationview).with.offset(-15);
    }];
}

- (void) appointmentConfirmButtonClicked:(id) sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"是否确认该用户已就诊？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setTag:0x1000];
    [alert show];
}

- (void) refuseButtonClicked:(id)sender
{
    //拒绝
    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentRefuseViewController" ControllerObject:appointInfo];
}

- (void) accecptButtonClicked:(id)sender
{
    //接受
    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentReceiveViewController" ControllerObject:appointInfo];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0x1000 == alertView.tag) {
        NSLog(@"clickedButtonAtIndex %ld", buttonIndex);
        if (1 == buttonIndex)
        {
            //TODO：确认就诊 DealUserAppointmetnTask
            AppointmentDetail* detail = tvcAppointmentDetail.detail;
            NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
            StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
            [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.userId] forKey:@"doUserId"];
            [dicPost setValue:[NSString stringWithFormat:@"%ld", detail.appointId] forKey:@"appointId"];
            [dicPost setValue:@"Q" forKey:@"status"];
            
            [[TaskManager shareInstance] createTaskWithTaskName:@"DealUserAppointmetnTask" taskParam:dicPost TaskObserver:self];
        }
    }
}

@end

typedef enum : NSUInteger {
    AppointmentApplyStatusSection,
    AppointmentDetailInfoSection,
    AppointmentDetailImagheSection,
    AppointmentDetailTableSectionCount,
} AppointmentDetailTableSection;

@implementation AppointmentDetailTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (void) setDetail:(AppointmentDetail *)detail
{
    _detail = detail;
    if (imageHeightNumbers)
    {
        [imageHeightNumbers removeAllObjects];
    }
    
    if (_detail.images && 0 < _detail.images.count)
    {
        imageHeightNumbers = [NSMutableArray array];
        for (NSInteger index = 0; index < _detail.images.count; ++index)
        {
            NSNumber* numHeight = [NSNumber numberWithFloat:155];
            [imageHeightNumbers addObject:numHeight];
        }
    }

    if (detail)
    {
        [self.tableView reloadData];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return AppointmentDetailTableSectionCount;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case AppointmentApplyStatusSection:
        case AppointmentDetailInfoSection:
            if (_detail)
            {
                return 1;
            }
            
            break;
        case AppointmentDetailImagheSection:
            if (_detail)
            {
                if (_detail.images)
                {
                    return _detail.images.count;
                }
            }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case AppointmentApplyStatusSection:
            return 40;
        case AppointmentDetailInfoSection:
        {
            return [self detailCellHeight];
        }
            break;
        case AppointmentDetailImagheSection:
        {
            if (imageHeightNumbers)
            {
                NSNumber* numHeight = imageHeightNumbers[indexPath.row];
                return numHeight.floatValue;
            }
            return 155;
        }
            break;
        default:
            break;
    }
    return 44;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    switch (indexPath.section)
    {
        case AppointmentApplyStatusSection:
        {
            cell = [self appointmentApplyStatusCell];
        }
            break;
        case AppointmentDetailInfoSection:
        {
            cell = [self appointmentDetailCell];
        }
            break;
        case AppointmentDetailImagheSection:
        {
            cell = [self appointmentImageCell:indexPath.row];
        }
            break;
        default:
            break;
    }
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentDetailDefaultTableViewCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat) detailCellHeight
{
    CGFloat cellHeight = 125;
    NSString* symptomDesc = @"症状描述：";
    if (_detail && _detail.symptomDesc)
    {
        symptomDesc = [NSString stringWithFormat:@"                %@", _detail.symptomDesc];
    }
    CGFloat sysptomHeihgt = [symptomDesc heightSystemFont:[UIFont systemFontOfSize:14] width:(kScreenWidth - 25)];
    cellHeight += (sysptomHeihgt + 11);
    return cellHeight;
}

- (UITableViewCell*) appointmentApplyStatusCell
{
    AppointmentApplyStatusTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppointmentApplyStatusTableViewCell"];
    if (!cell)
    {
        cell = [[AppointmentApplyStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentApplyStatusTableViewCell"];
    }
    if (_detail)
    {
        [cell setAppointmentDetail:_detail];
    }
    return cell;
}

- (UITableViewCell*) appointmentDetailCell
{
    AppointmentDetailTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppointmentDetailTableViewCell"];
    if (!cell)
    {
        cell = [[AppointmentDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentDetailTableViewCell"];
    }
    if (_detail)
    {
        [cell setAppointmentDetail:_detail];
    }
    
    //[cell.cancelButton addTarget:self action:@selector(cancelappointmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UITableViewCell*) appointmentImageCell:(NSInteger) row
{
    AppointmentDetailImageTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppointmentDetailImageTableViewCell"];
    if (!cell)
    {
        cell = [[AppointmentDetailImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentDetailImageTableViewCell"];
    }
    [cell setRow:row];
    
    [cell setDelegate:self];
    if (_detail)
    {
        //[cell setAppointmentDetail:appointmentDetail];
        NSDictionary* dicImage = _detail.images[row];
        NSString* imageUrl = [dicImage valueForKey:@"imageUrl"];
        [cell setImageUrl:imageUrl];
    }
    
    
    return cell;
    
}
- (void) appointmentDetailImageCell:(UITableViewCell*) cell ImageHeihgt:(CGFloat) imageHeihgt
{
    if (!cell)
    {
        return;
    }
    
    if (![cell isKindOfClass:[AppointmentDetailImageTableViewCell class]])
    {
        return;
    }
    AppointmentDetailImageTableViewCell* imageCell = (AppointmentDetailImageTableViewCell*) cell;
    
    if (!imageHeightNumbers || imageHeightNumbers.count <= imageCell.row)
    {
        return;
    }
    NSNumber* numHeihgt = imageHeightNumbers[imageCell.row];
    if (imageHeihgt == numHeihgt.floatValue)
    {
        return;
    }
    numHeihgt = [NSNumber numberWithFloat:imageHeihgt];
    [imageHeightNumbers replaceObjectAtIndex:imageCell.row withObject:numHeihgt];
    enableRefreshImages = YES;
    [self performSelector:@selector(refreshImageHeihgt) withObject:nil afterDelay:0.1];
}

- (void) refreshImageHeihgt
{
    if (!enableRefreshImages) {
        return;
    }
    enableRefreshImages = NO;
    [self.tableView reloadData];
}

@end
