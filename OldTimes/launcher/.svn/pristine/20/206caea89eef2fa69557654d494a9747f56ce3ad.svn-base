//
//  CreateGroupViewController.m
//  launcher
//
//  Created by Lars Chen on 15/9/18.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "ContactSelectTabBarView.h"
#import "CreateGroupRequest.h"
#import "ASIndexSortManager.h"
#import "ASIndexedResultModel.h"
#import <Masonry.h>
#import "SelectContactTableViewCell.h"
#import "GroupViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "ContactPersonDetailInformationModel+UseForSelect.h"
#import "GetSessionUserProfileDAL.h"
#import "MsgSqlMgr.h"
#import "MyDeptRequestManager.h"
#import "Slacker.h"
#import "AddGroupUserRequest.h"
#import "MyDefine.h"

#define H_SEARCHBAR 40                 // 搜索栏高度
#define H_CELL  50                      // 单元格高度
#define H_SECTIONTITLE 27               // 组标题栏高度
#define H_TABBAR 50

@interface CreateGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ContactSelectTabBarViewDelegate,IMBaseRequestDelegate,ContactSelectTabBarViewDelegate,GetSessionUserProfileDALDelegate,MyDeptRequestManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ContactSelectTabBarView *tabBarView;     // 底部栏
@property (nonatomic, strong) GroupViewController *existingGroup;

@property (nonatomic, strong) ASIndexSortManager *sortManager;                   // 索引分组工具
@property (nonatomic, strong) ASIndexedResultModel *modelIndexSorted;            // 索引排序好的数组

@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (IOS_VERSION_7_OR_ABOVE)
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
    }
    
    // 标题
    [self.navigationItem setTitle:LOCAL(CONTACT_ADD)];
    
    // 初始化索引相关
    self.sortManager = [[ASIndexSortManager alloc] init];
    self.modelIndexSorted = [[ASIndexedResultModel alloc] init];
    // 初始化一堆变量和控件
    [self initCompnents];
    
    // 我的部门单例
    [[MyDeptRequestManager share] setDelegate:self];
    [[MyDeptRequestManager share] getMyDeptContacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Private Method
// 初始化一堆变量和控件
- (void)initCompnents
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tabBarView];
    
    [self initConstraints];
}

- (void)initConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.tabBarView.mas_top);
    }];
    
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@H_TABBAR);
    }];
}

#pragma mark -- UITableView Delegate
// 索引加上群
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _modelIndexSorted.arrayIndex.count + 1;
}

// 组标题栏高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    else
    {
        return H_SECTIONTITLE;
    }
}

// footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
// 单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        // 每一组的key
        NSString *key = [_modelIndexSorted.arrayIndex objectAtIndex:(section - 1)];
        // 对应索引的数组
        NSArray *arrayGroup = [NSArray arrayWithArray:[_modelIndexSorted.dictIndexData objectForKey:key]];
        return  arrayGroup.count;
    }
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return H_CELL;
}

// 组标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section > 0)
    {
        return  [_modelIndexSorted.arrayIndex objectAtIndex:(section - 1)];
    }
    else
    {
        return @"";
    }
}

// 索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _modelIndexSorted.arrayIndex;
}

// 设置索引对应关系，没有搜索索引就不用加
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index + 1;
}

// 单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *jumpToVC = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jumpToVC];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jumpToVC];
        }
        [cell.textLabel setText:LOCAL(CHOOSE_GROUP)];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return cell;
    }
    else
    {
        static NSString *identifier = @"cell";
        SelectContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[SelectContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier Height:H_CELL];
        }
        
        // 每一组的key
        NSString *key = [_modelIndexSorted.arrayIndex objectAtIndex:(indexPath.section - 1)];
        // 对应索引的数组
        NSArray *arrayGroup = [NSArray arrayWithArray:[_modelIndexSorted.dictIndexData objectForKey:key]];
        
        ContactPersonDetailInformationModel *model = [arrayGroup objectAtIndex:indexPath.row];
        [cell setData:model];
        return cell;
    }
}

// 点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        [self.navigationController pushViewController:_existingGroup animated:YES];
    }
    else
    {
        // 每一组的key
        NSString *key = [_modelIndexSorted.arrayIndex objectAtIndex:(indexPath.section - 1)];
        // 对应索引的数组
        NSArray *arrayGroup = [NSArray arrayWithArray:[_modelIndexSorted.dictIndexData objectForKey:key]];
        
        ContactPersonDetailInformationModel *model = [arrayGroup objectAtIndex:indexPath.row];
        model._isSelect = !model._isSelect;
        if (model._isSelect)
        {
            // 加入底部栏数组
            [_tabBarView._arrayHeadPics addObject:model];
            // 刷新数据
            [_tabBarView refreshData];
        }
        else
        {
            // 从底部栏数组删除
            for (ContactPersonDetailInformationModel *modelTemp in _tabBarView._arrayHeadPics)
            {
                if ([model.show_id isEqualToString:modelTemp.show_id])
                {
                    [_tabBarView._arrayHeadPics removeObject:modelTemp];
                    break;
                }
            }
            // 刷新数据
            [_tabBarView refreshData];
        }
        [tableView reloadData];
    }
}

#pragma mark -- ContactSelectTabBarView Delegate
// 底部栏确定按钮点击的委托
- (void)ContactSelectTabBarViewDelegateCallBack_ButtonClick
{
    // 判断是否选中了人
    if (_tabBarView._arrayHeadPics.count > 0)
    {
        // 创建群,网络请求
        NSMutableArray *arrayAnotherNameList = [NSMutableArray array];
        for (ContactPersonDetailInformationModel *model in _tabBarView._arrayHeadPics)
        {
            [arrayAnotherNameList addObject:model.show_id];
        }
        
        // 判断是加人还是建群
        if (self.isAddPeople) {
            AddGroupUserRequest *request = [[AddGroupUserRequest alloc] init];
            request.groupUsers = arrayAnotherNameList;
            request.sessionName = self.groupID;
            [request requestWithDelegate:self];
        } else {
            // 把自己加入
            [arrayAnotherNameList insertObject:[[UnifiedUserInfoManager share] userShowID] atIndex:0];
            CreateGroupRequest *request = [CreateGroupRequest new];
            request.arrGroupUsers = arrayAnotherNameList;
            [request requestWithDelegate:self];
        }

        
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    else
    {
//        [SVProgressHUD showErrorWithStatus:LOCAL(GROUP_ADDPROMPT)];
    }
}

#pragma mark - BaseRequestDelegate
- (void)requestSucceed:(IMBaseRequest *)request withResponse:(IMBaseResponse *)response
{
    if ([request isKindOfClass:[CreateGroupRequest class]])
    {
        GetSessionUserProfileDAL *getSessionDAL = [GetSessionUserProfileDAL new];
        getSessionDAL.delegate = self;
        [getSessionDAL startTaskWithUserName:((CreateGroupResponse *)response).groupName];
    } else if ([request isKindOfClass:[AddGroupUserRequest class]]) {
        // 加人
        [self.navigationController popViewControllerAnimated:NO];

    }
    
}

- (void)requestFail:(IMBaseRequest *)request withResponse:(IMBaseResponse *)response
{
    [response showServerErrorMessage];
}

#pragma mark - GetSessionUserProfileDALDelegate
- (void)GetSessionUserProfileDALDelegateCallBack_finishWithUserProfileModel:(UserProfileModel *)model
{
    // 群组信息写入表中
    [[MsgSqlMgr share] updateContactInfoToContactTable:[NSArray arrayWithObject:model]];
    
    // 群成员写入表中（自动去重）
//    [[MsgSqlMgr share] insertBatchData:model.memberList WithTag:table_msgContacts];
    
//    [SVProgressHUD dismiss];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    // 发送委托回调
    if ([self.delegate respondsToSelector:@selector(CreateGroupViewControllerDelegateCallBack_finishCreateGroupWithData:)])
    {
        [self.delegate CreateGroupViewControllerDelegateCallBack_finishCreateGroupWithData:model];
    }
}

#pragma mark - UnifiedMyDeptDALManager Delegate
- (void)myDeptRequestManagerDelegateCallBack_contactList:(NSArray *)contactList
{
    NSArray *newContactList;
    // 如果是群聊加人界面
    if (self.isAddPeople) {
        NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:self.arrayExist.count];
        for (UserProfileModel *model in self.arrayExist) {
            [arrayTemp addObject:model.userName];
        }
        NSPredicate *predicat = [NSPredicate predicateWithFormat:@"NOT(show_id IN %@)",arrayTemp];
        newContactList = [contactList filteredArrayUsingPredicate:predicat];
    } else {
        newContactList = contactList;
    }

    // 得到数据后进行索引排序分组
    NSMutableArray *arraySortName = [NSMutableArray arrayWithCapacity:newContactList.count];
    for (ContactPersonDetailInformationModel *model in newContactList)
    {
        [arraySortName addObject:model.u_true_name];
    }
    // 索引排序分组
    _modelIndexSorted = [_sortManager indexSortWithNameArray:arraySortName FullDataArray:newContactList];
    
    [_tableView reloadData];
}

- (void)myDeptRequestManagerDelegateCallBack_FailWithErrorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - Init UI
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [UITableView new];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_tableView setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
    }
    
    return _tableView;
}

- (ContactSelectTabBarView *)tabBarView
{
    if (!_tabBarView)
    {
        _tabBarView = [[ContactSelectTabBarView alloc] initWithFrame:CGRectMake(-1, [Slacker getValueWithFrame:_tableView.frame WithX:NO], self.view.frame.size.width + 2, H_TABBAR + 1)];
        [_tabBarView setDelegate:self];
        // 初始化_tabBar的数组
        _tabBarView._arrayHeadPics = [NSMutableArray array];
    }
    
    return _tabBarView;
}

- (GroupViewController *)existingGroup
{
    if (!_existingGroup)
    {
        _existingGroup = [GroupViewController new];
    }
    
    return _existingGroup;
}

@end
