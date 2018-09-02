//
//  AppointmentDetailViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/30.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentDetailViewController.h"
#import "AppointmentInfo.h"
#import "AppointmentDetailTableViewCell.h"
#import "AppointmentDetailImageTableViewCell.h"

@interface AppointmentDetailViewController ()
{
    AppointmentInfo* appointmentInfo;
    AppointmentDetailTableViewController* tvcDetail;
}
@end

@interface AppointmentDetailTableViewController ()
<TaskObserver,
AppointmentDetailImageTableViewCellDelegate>
{
    AppointmentInfo* appointmentInfo;
    AppointmentDetail* appointmentDetail;
    NSMutableArray* imageHeightNumbers;
}

- (id) initWithAppointment:(AppointmentInfo*) appoint;
@end


@implementation AppointmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"约诊详情"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[AppointmentInfo class]])
    {
        appointmentInfo = (AppointmentInfo*) self.paramObject;
        tvcDetail = [[AppointmentDetailTableViewController alloc]initWithAppointment:appointmentInfo];
        [self addChildViewController:tvcDetail];
        [self.view addSubview:tvcDetail.tableView];
        
        [tvcDetail.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.top.and.bottom.equalTo(self.view);
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

typedef enum : NSUInteger {
    AppointmentApplyStatusSection,
    AppointmentDetailInfoSection,
    AppointmentDetailImagheSection,
    AppointmentDetailTableSectionCount,
} AppointmentDetailTableSection;

@implementation AppointmentDetailTableViewController

- (id) initWithAppointment:(AppointmentInfo*) appoint
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        appointmentInfo = appoint;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //获取约诊详情
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", appointmentInfo.appointId] forKey:@"appointId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"AppointmentDetailTask" taskParam:dicPost TaskObserver:self];
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
            if (appointmentDetail)
            {
                return 1;
            }
            
            break;
          case AppointmentDetailImagheSection:
            if (appointmentDetail)
            {
                if (appointmentDetail.images)
                {
                    return appointmentDetail.images.count;
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentDetailTableViewCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat) detailCellHeight
{
    CGFloat cellHeight = 100;
    if (appointmentDetail && 7!= appointmentDetail.status)
    {
        cellHeight += 54;
    }
    NSString* symptomDesc = @"症状描述：";
    if (appointmentDetail && appointmentDetail.symptomDesc)
    {
        symptomDesc = [NSString stringWithFormat:@"%@", appointmentDetail.symptomDesc];
    }
    CGFloat sysptomHeihgt = [symptomDesc heightSystemFont:[UIFont font_28] width:(kScreenWidth - 25)];
    cellHeight += (sysptomHeihgt + 11);
    
    NSString* staffStr = appointmentDetail.staffName;
    NSString* expendStr = [appointmentDetail staffExpendString];
    if (expendStr && 0 < expendStr.length)
    {
        if (!staffStr)
        {
            staffStr = expendStr;
        }
        else
        {
            staffStr = [staffStr stringByAppendingString:expendStr];
        }
    }

    NSString* staffName = @"医生：";
    if (appointmentDetail && appointmentDetail.staffName)
    {
        staffName = [staffName stringByAppendingString:[NSString stringWithFormat:@"%@", staffStr]] ;
    }
    CGFloat staffNameHeihgt = [staffName heightSystemFont:[UIFont font_28] width:(kScreenWidth - 25)];
    cellHeight += staffNameHeihgt;
    return cellHeight;
}

- (UITableViewCell*) appointmentApplyStatusCell
{
    AppointmentApplyStatusTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppointmentApplyStatusTableViewCell"];
    if (!cell)
    {
        cell = [[AppointmentApplyStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentApplyStatusTableViewCell"];
    }
    if (appointmentDetail)
    {
        [cell setAppointmentDetail:appointmentDetail];
    }
    return cell;
}

- (UITableViewCell*) appointmentDetailCell
{
    NSString* cellClassname = @"AppointmentFinishedDetailTableViewCell";
    if (appointmentDetail && 7 == appointmentDetail.status )
    {
        cellClassname = @"AppointmentDetailTableViewCell";
    }
    AppointmentDetailTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellClassname];
    if (!cell)
    {
        cell = [[NSClassFromString(cellClassname) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassname];
    }
    if (appointmentDetail)
    {
        [cell setAppointmentDetail:appointmentDetail];
    }
    
    [cell.cancelButton addTarget:self action:@selector(cancelappointmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UITableViewCell*) appointmentImageCell:(NSInteger) row
{
    AppointmentDetailImageTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AppointmentDetailImageTableViewCell"];
    
    if (!cell)
    {
        cell = [[AppointmentDetailImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentDetailImageTableViewCell"];
    }
    [cell setDelegate:self];
    [cell setTag:(0x400 + row)];
    if (appointmentDetail)
    {
        //[cell setAppointmentDetail:appointmentDetail];
        NSDictionary* dicImage = appointmentDetail.images[row];
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
//    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
//    if (!indexPath)
//    {
//        return;
//    }
    
    NSInteger row = cell.tag - 0x400;
    if (!imageHeightNumbers || imageHeightNumbers.count <= row)
    {
        return;
    }
    NSNumber* numHeihgt = imageHeightNumbers[row];
    if (imageHeihgt == numHeihgt.floatValue)
    {
        return;
    }
    numHeihgt = [NSNumber numberWithFloat:imageHeihgt];
    [imageHeightNumbers replaceObjectAtIndex:row withObject:numHeihgt];
    [self.tableView reloadData];
}

- (void) cancelappointmentButtonClicked:(id) sender
{
    //AppointmentCancelTask
    [self.tableView.superview showWaitView];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", appointmentInfo.appointId] forKey:@"appointId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"AppointmentCancelTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.superview closeWaitView];
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
    
    if ([taskname isEqualToString:@"AppointmentDetailTask"])
    {
        [self.tableView reloadData];
    }
    if([taskname isEqualToString:@"AppointmentCancelTask"])
    {
        //重新获取约诊详情
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:[NSString stringWithFormat:@"%ld", appointmentInfo.appointId] forKey:@"appointId"];
        [self.tableView.superview showWaitView];
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
            appointmentDetail = (AppointmentDetail*) taskResult;
            if (imageHeightNumbers)
            {
                [imageHeightNumbers removeAllObjects];
            }
            
            if (appointmentDetail.images && appointmentDetail.images.count)
            {
                imageHeightNumbers = [NSMutableArray array];
                for (NSInteger index = 0; index < appointmentDetail.images.count; ++index)
                {
                    NSNumber* numHeight = [NSNumber numberWithFloat:155];
                    [imageHeightNumbers addObject:numHeight];
                }
            }
        }
    }
    
    
}
@end
