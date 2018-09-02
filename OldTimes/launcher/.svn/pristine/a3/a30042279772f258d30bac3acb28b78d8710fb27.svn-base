//
//  AddFriendViewController.m
//  launcher
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  添加好友页面

#import "AddFriendViewController.h"
#import "MyDefine.h"
#import <Masonry/Masonry.h>
#import <MintcodeIM/MintcodeIM.h>
#import "RelationListTableViewCell.h"
#import "FriendValidationViewController.h"
#import <MintcodeIM/MintcodeIM.h>
#import "ContactPersonDetailInformationModel.h"
#import "ContactGetUserInformationRequest.h"
#import "RelationCheckCollectionReuqest.h"
#define LoadFriendDataNotification @"loadFriendListDataNotification"
@interface AddFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate, UISearchDisplayDelegate,BaseRequestDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UISearchBar * searchBar;

@property(nonatomic, strong) UISearchDisplayController  *searchDisplayController;
@property(nonatomic, strong) NSMutableArray  *searchResultModelArray;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.searchBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.8];
    
    self.title = LOCAL(FRIEND_ADDFRIEND);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LoadFriendDataNotification object:nil];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    MessageManager *manager = [MessageManager share];
    [self postLoading];

    [manager searchRelationUserWithRelationValue:searchBar.text completion:^(NSArray<MessageRelationInfoModel *> *array, BOOL success) {
        if (!success) {
            [self postError:LOCAL(ERROROTHER)];
            return;
        }
        
        [self.searchResultModelArray removeAllObjects];
        //保存数据
        MessageRelationInfoModel *model = [array firstObject];
        if (!model)
        {
            [self hideLoading];
            [self.searchDisplayController.searchResultsTableView reloadData];
            return;
        }
        
        [self.searchResultModelArray addObject:model];
        
        RelationCheckCollectionReuqest *request = [[RelationCheckCollectionReuqest alloc] initWithDelegate:self];
        [request checkCollectionWithRelationName:model.relationName];
    }];
}

#pragma mark - baseRequestDelegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[RelationCheckCollectionResponse class]])
    {
        [self hideLoading];
        MessageRelationInfoModel *model = [self.searchResultModelArray firstObject];
        RelationCheckCollectionResponse *resp =  (RelationCheckCollectionResponse *)response;
        model.relation =  resp.isColleague;
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - searchbardisplayController
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{

}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return self.searchResultModelArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView )
    {
        static NSString *identifier  = @"searchCell";
        cell = (RelationListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell =  [[RelationListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier cellType:CellType_userinfo_phone];
        }
        //处理显示问题
        if (self.searchResultModelArray.count)
        {
            MessageRelationInfoModel *model = self.searchResultModelArray[indexPath.row];
			
            [cell setCellDate:model];
            UnifiedUserInfoManager *manager = [UnifiedUserInfoManager share];
            //如果自己搜到自己
            if ([model.relationName isEqualToString:manager.userShowID])
            {
                [cell isAdded:YES];
            }else
            {
                [cell isAdded:model.relation];
            }
        }
        
        //需要从数据库中获取相关信息
		__weak typeof(self) weakSelf = self;
        [cell addOrConnectedwithBlock:^(BOOL isAdded) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
            if (isAdded)
            {
                [strongSelf sendNotify:strongSelf.searchResultModelArray[indexPath.row]];
            }else
            {
                FriendValidationViewController *vc = [[FriendValidationViewController alloc] initWithBlock:^(NSString *remark) {
                }];
                [vc setDataWithModel:strongSelf.searchResultModelArray[indexPath.row]];
                vc.groupID = strongSelf.groupId;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }else
    {
        static NSString * string= @"cell";
        cell = (UITableViewCell * )[tableView dequeueReusableCellWithIdentifier:string];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; };
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 50; };
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15; };
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma parivateMethod
- (void)sendNotify:(MessageRelationInfoModel *)model {
    NSDictionary *dictContact = [NSDictionary dictionaryWithObjectsAndKeys:
                                 model.relationName, personDetail_show_id,
                                 ![model.remark isEqualToString:@""]?model.remark:model.nickName, personDetail_u_true_name,
                                 model.relationAvatar, personDetail_headPic,
                                 nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MTWillShowSingleChatNotification object:nil userInfo:dictContact];
}

#pragma mark - setterAndGetter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.searchBar;
    }
    return _tableView;
}


- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
		[[UnifiedUserInfoManager share] verifyMTVersion];
		NSString *launchrID = [UnifiedUserInfoManager share].isMTVersion ? @"Launchr ID" : @"WorkHub ID";
		_searchBar.placeholder =  [NSString stringWithFormat:@"%@%@", LOCAL(FRIEND_SEARCH), launchrID];
        _searchBar.barTintColor = [UIColor whiteColor];
        //设置取消按钮的文字，iOS7可能会有问题，待测试
        [_searchBar setValue:LOCAL(CANCEL) forKey:@"_cancelButtonText"];
    }
    return _searchBar;
}

- (UISearchDisplayController *)searchDisplayController
{
    if (!_searchDisplayController)
    {
        _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchDisplayController.searchResultsDelegate = self;
        _searchDisplayController.searchResultsDataSource = self;
        _searchDisplayController.delegate = self;
        _searchDisplayController.searchResultsTableView.backgroundColor = [UIColor clearColor];
    }
    return _searchDisplayController;
}

- (NSMutableArray *)searchResultModelArray
{
    if (!_searchResultModelArray)
    {
        _searchResultModelArray = [NSMutableArray array];
    }
    return _searchResultModelArray;
}
@end
