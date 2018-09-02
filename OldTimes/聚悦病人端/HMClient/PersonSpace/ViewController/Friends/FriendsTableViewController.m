//
//  FriendsTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "FriendListTableViewCell.h"

@interface FriendsTableViewController ()
<TaskObserver,
FriendListTableViewCellDelegate>
{
    NSArray* myConcernFriends;
    NSArray* payAttentionToMeFriends;
}
@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFriendList)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadFriendList
{
    myConcernFriends = [NSArray array];
    payAttentionToMeFriends = [NSArray array];
    [[TaskManager shareInstance] createTaskWithTaskName:@"FriendListTask" taskParam:nil TaskObserver:self];
}

- (void) setRelativeType:(NSInteger)relativeType
{
    _relativeType = relativeType;
    [self reloadFriendData];
    
    NSArray* friendList = nil;
    switch (_relativeType)
    {
        case 0:
        {
            friendList = myConcernFriends;
        }
            break;
        case 1:
        {
            friendList = payAttentionToMeFriends;
        }
            break;
        default:
            
            break;
    }

    if (friendList)
    {
        if (0 == friendList.count)
        {
            [self showBlankView];
        }
        else
        {
            [self closeBlankView];
        }
    }
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void) reloadFriendData
{
     [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    switch (_relativeType)
    {
        case 0:
        {
            if (myConcernFriends)
            {
                return myConcernFriends.count;
            }
        }
            break;
        case 1:
        {
            if (payAttentionToMeFriends)
            {
                return payAttentionToMeFriends.count;
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
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListTableViewCell"];
    if (!cell)
    {
        cell = [[FriendListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendListTableViewCell"];
    }
    
    // Configure the cell...
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    NSArray* friendList = nil;
    switch (_relativeType)
    {
        case 0:
        {
            friendList = myConcernFriends;
        }
            break;
        case 1:
        {
            friendList = payAttentionToMeFriends;
        }
            break;
        default:
            
            break;
    }
    
    if (friendList) {
        FriendInfo* friend = friendList[indexPath.row];
        [cell setFriendInfo:friend];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* friendList = nil;
    switch (_relativeType)
    {
        case 0:
        {
            friendList = myConcernFriends;
        }
            break;
        case 1:
        {
            friendList = payAttentionToMeFriends;
        }
            break;
        default:
            
            break;
    }
    
    if (friendList)
    {
        FriendInfo* friend = friendList[indexPath.row];
        //跳转到好友详情界面 FriendDetailStartViewController
        
        [HMViewControllerManager createViewControllerWithControllerName:@"FriendDetailStartViewController" ControllerObject:friend];
    }

}

#pragma mark - FriendListTableViewCellDelegate
- (void) friendDeleteRelativeButtonClicked:(UITableViewCell *)cell
{
    NSIndexPath* indexPath = nil;
    if (cell && [cell isKindOfClass:[UITableViewCell class]] )
    {
        indexPath = [self.tableView indexPathForCell:cell];
        
    }
    
    if (!indexPath)
    {
        return;
    }
    
    NSArray* friendList = nil;
    switch (_relativeType)
    {
        case 0:
        {
            friendList = myConcernFriends;
        }
            break;
        case 1:
        {
            friendList = payAttentionToMeFriends;
        }
            break;
        default:
            
            break;
    }
    
    if (friendList)
    {
        FriendInfo* friend = friendList[indexPath.row];
        //解除好友绑定 
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:[NSString stringWithFormat:@"%ld", friend.relationUserDet.userId] forKey:@"relativeFriendUserId"];
        
        [self.tableView.superview showWaitView];
        [[TaskManager shareInstance] createTaskWithTaskName:@"DeleteUserFriendRelativeTask" taskParam:dicPost TaskObserver:self];
    }

}


#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.superview closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    [self reloadFriendData];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"DeleteUserFriendRelativeTask"])
    {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"FriendListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*)taskResult;
            myConcernFriends = [dicResult valueForKey:@"myConcern"];
            payAttentionToMeFriends = [dicResult valueForKey:@"payAttentionToMe"];
        }
    }
}

@end
