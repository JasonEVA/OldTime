//
//  ChatApplicationTaskViewController.m
//  launcher
//
//  Created by rainli on 16/5/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatApplicationTaskViewController.h"
#import "NewMissionContainViewController.h"
#import "MeetingConfirmMeetingRequest.h"
#import "ChatEventMissionTableViewCell.h"
#import "NewDetailMissionViewController.h"
#import "AppTaskModel.h"
#import "TaskListModel.h"
#import "NewMissionGetMissionDetailRequest.h"
#import "NewChatEventMissionTableViewCell.h"
#import "MissionDetailViewController.h"
#import <MintcodeIM/MintcodeIM.h>
#import "Category.h"
#import "MyDefine.h"

@interface ChatApplicationTaskViewController ()<BaseRequestDelegate>

@end

@implementation ChatApplicationTaskViewController
-(NSString *)applicationUid { return im_task_uid; }

- (NSString *)buttonTitle { return LOCAL(Application_Mission); }
- (UIImage *)buttonImage { return [UIImage imageNamed:@"app_title_task"]; }
- (UIImage *)buttonHighlightedImage { return [UIImage imageNamed:@"app_title_taskselected"]; }

- (void)clickedButton {
    NewMissionContainViewController *VC = [[NewMissionContainViewController alloc] init];
    [VC selectAtIndex:2];
    [VC presentedByViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewRegisterClass:[NewChatEventMissionTableViewCell class] forCellReuseIdentifier:NSStringFromClass(NewChatEventMissionTableViewCell.class)];
    // Do any additional setup after loading the view.
}
-(CGFloat)heightForMessageModel:(MessageBaseModel *)model
{
    MessageAppModel *appModel = model.appModel;
    AppTaskModel *taskTodel = [AppTaskModel mj_objectWithKeyValues:appModel.applicationDetailDictionary];
    if (taskTodel.projectName.length == 0 && taskTodel.end <= 0)
    {
        return 97.5 + 35 + 15;
    }
    else
    {
        return 97.5 + 35 * 2 + 15;
    }
}

-(UITableViewCell*)cellForMessageModel:(MessageBaseModel *)model withRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewChatEventMissionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(NewChatEventMissionTableViewCell.class)];
    [cell setCellData:model];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor grayBackground]];
    return cell;
    
}
- (void)didSelectCellForMessageModel:(MessageBaseModel *)model
{
    MessageAppModel *appModel = model.appModel;
    [self hideLoading];
    TaskListModel *taskListModel = [TaskListModel new];
    AppTaskModel *taskModel = [AppTaskModel mj_objectWithKeyValues:appModel.applicationDetailDictionary];
    if (taskModel.id.length != 0)
    {
        taskListModel.showId = taskModel.id;
    }
    else
    {
        // 任务系统消息
        taskListModel.showId = appModel.msgRMShowID;
    }
    NewMissionGetMissionDetailRequest *request = [[NewMissionGetMissionDetailRequest alloc] initWithDelegate:self];
    [request getDetailTaskWithId:taskListModel.showId];
    [self postLoading];
}

#pragma mark - Request Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[NewMissionGetMissionDetailRequest class]])
    {
        NewMissionGetMissionDetailResponse *result = (NewMissionGetMissionDetailResponse *)response;
        
        NewDetailMissionViewController *VC = [[NewDetailMissionViewController alloc] initWithOnlyShowID:result.detailModel.showId];
        VC.isFirstVC = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
    [self hideLoading];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

@end
