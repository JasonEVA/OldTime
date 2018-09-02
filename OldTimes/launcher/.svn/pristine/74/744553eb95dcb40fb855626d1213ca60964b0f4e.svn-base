//
//  RelationViewController.m
//  launcher
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "RelationViewController.h"
#import "AddFriendViewController.h"
#import "SearchUserViewController.h"
#import <MintcodeIM/MintcodeIM.h>
#import "RelationListTableViewCell.h"
#import "UnifiedUserInfoManager.h"
#import "BaseNavigationController.h"
#import "UnifiedUserInfoManager.h"
#import "ChatSingleViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "ChatRelationViewController.h"
#import "UINavigationController+CompletionHandle.h"
#import <MintcodeIM/MintcodeIM.h>
#import "MyDefine.h"
#import "NSDate+CalendarTool.h"
#import "SelectContactTabbarView.h"

#define LoadFriendDataNotification @"loadFriendListDataNotification"

@interface RelationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, weak) SelectContactTabbarView *tabbar;

@property (nonatomic,strong) NSMutableArray *friendListArray;
@property(nonatomic, strong) NSMutableArray  *contactModelArray;
@property(nonatomic, strong) MessageRelationInfoModel  *contactModel;
@property (nonatomic,strong) MessageRelationGroupModel * groupModel;

@end


@implementation RelationViewController

- (instancetype)initWithTabbar:(SelectContactTabbarView *)tabbar {
    self = [super init];
    if (self) {
        _tabbar = tabbar;
        [_tabbar addObserver:self forKeyPath:@"arraycount" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LOCAL(CONTACT_MYFRIEND);
    
    if (!self.tabbar) {
        UIBarButtonItem * searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"magnifier"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick)];
        
        UIBarButtonItem * addFriendItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_begin_group"] style:UIBarButtonItemStylePlain target:self action:@selector(addFriendBtnClick)];
        self.navigationItem.rightBarButtonItems = @[addFriendItem,searchItem];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataAction) name:LoadFriendDataNotification object:nil];
    
    [self loadDataAction];
}

- (void)dealloc
{
    [_tabbar removeObserver:self forKeyPath:@"arraycount"];
    //刷新一遍好友列表
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LoadFriendDataNotification object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [self.tableView reloadData];
}

- (void)loadDataAction
{
    //加载数据库中的数据
    [self LoadDataFromDatabase];
    
    //获取增量时间
    [[MessageManager share] loadRelationGroupInfoWithTotalFlag:NO Completion:^(BOOL success) {
        if (success) {
            [self LoadDataFromDatabase];
        }
    }];
}

- (void)LoadDataFromDatabase
{
    //获取所有的分组
    NSArray * groupListArray = [[MessageManager share] queryRelationGroups];
    [self.contactModelArray removeAllObjects];
    //获取所有好友数据
    for (MessageRelationGroupModel *model in groupListArray)
    {
        NSArray *tempArray = [[MessageManager share] queryRelationInfoWithRelationGroup:model.relationGroupId];
        [self.contactModelArray addObjectsFromArray:tempArray];
    }
    [self.tableView reloadData];
}


- (void)setGropuID:(NSString*)ID
{
    NSString * str = [NSString stringWithFormat:@"%@_GROUP_ID",[UnifiedUserInfoManager share].userShowID];
    [[NSUserDefaults standardUserDefaults]setValue:ID forKey:str];
}

- (void)searchBtnClick
{
    SearchUserViewController * searchVC = [[SearchUserViewController alloc] init];
    BaseNavigationController * nvc = [[BaseNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nvc animated:YES completion:nil];
}
- (void)addFriendBtnClick
{
    AddFriendViewController * addFriendVC = [[AddFriendViewController alloc] init];
    addFriendVC.groupId = [NSNumber numberWithLong:self.groupModel.relationGroupId];
    [self.navigationController pushViewController:addFriendVC animated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactModelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"cell";
    RelationListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[RelationListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string cellType:CellType_Define];
    }
    
    MessageRelationInfoModel *model = [self.contactModelArray objectAtIndex:indexPath.row];
    [cell setCellDate:model];
    
    if (self.tabbar) {
        cell.wz_selected = [self.tabbar.dictSelected objectForKey:model.relationName] != nil;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15; }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.contactModel = self.contactModelArray[indexPath.row];
    if (self.tabbar) {
        [self.tabbar addOrDeletePerson:self.contactModel];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    
    [self.navigationController wz_popToRootViewControllerAnimated:NO completion:^{
        [self sendNotify];
    }];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
#pragma mark - privateMethod
- (void)sendNotify {
    NSDictionary *dictContact = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.contactModel.relationName, personDetail_show_id,
                                 ![self.contactModel.remark isEqualToString:@""]?self.contactModel.remark:self.contactModel.nickName, personDetail_u_true_name,
                                 self.contactModel.relationAvatar, personDetail_headPic,
                                 nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTWillShowSingleChatNotification object:nil userInfo:dictContact];
}


#pragma mark - init
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (self.tabbar) {
            _tableView.editing = YES;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)friendListArray
{
    if (!_friendListArray) {
        _friendListArray = [NSMutableArray array];
    }
    return _friendListArray;
}

- (NSMutableArray *)contactModelArray
{
    if (!_contactModelArray)
    {
        _contactModelArray = [NSMutableArray array];
    }
    return _contactModelArray;
}
@end
