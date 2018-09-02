//
//  SelectGroupViewController.m
//  Titans
//
//  Created by Andrew Shen on 14-9-9.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "SelectGroupViewController.h"
#import "TitansDefine.h"
#import "Slacker.h"
#import "SelectContactTableViewCell.h"
#import "UnifiedSqlManager.h"
#import "SVProgressHUD.h"

#define H_SEARCHBAR 40                 // 搜索栏高度
#define H_CELL  50                      // 单元格高度
#define H_SECTIONTITLE 27               // 组标题栏高度
#define H_TABBAR 50

@implementation SelectGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (IOS_VERSION_7_OR_ABOVE)
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
    }
    
    // 标题
    [self.navigationItem setTitle:LOCAL(CONTACT_ADD)];
    // 设置默认返回按钮文字为空
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 初始化一堆变量和控件
    [self initCompnents];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Private Method
// 初始化一堆变量和控件
- (void)initCompnents
{
    // tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HEIGTH_NAVI - HEIGTH_STATUSBAR - H_TABBAR) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
    
    // 搜索栏
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, H_SEARCHBAR)];
    [_searchBar setPlaceholder:LOCAL(SEARCH)];
    [_searchBar setDelegate:self];
    
    // TODO:下城去掉搜索
//    [_tableView setTableHeaderView:_searchBar];
    
    // 初始化底部栏
    _tabBarView = [[ContactSelectTabBarView alloc] initWithFrame:CGRectMake(-1, [Slacker getValueWithFrame:_tableView.frame WithX:NO], self.view.frame.size.width + 2, H_TABBAR + 1)];
    [_tabBarView setDelegate:self];
    [self.view addSubview:_tabBarView];
    
    // 初始化群页面
    _existingGroup = [[GroupViewController alloc] init];
    
    // 初始化_tabBar的数组
    _tabBarView._arrayHeadPics = [NSMutableArray array];
    
    // 初始化收藏联系人数组
    _arrayContacts = [NSMutableArray array];
    
    // 初始化索引相关
    _sortManager = [[ASIndexSortManager alloc] init];
    _modelIndexSorted = [[ASIndexedResultModel alloc] init];

    // 请求收藏列表
    _getFavoriteDAL = [[GetFavoriteContactListDAL alloc] init];
    [_getFavoriteDAL setDelegate:self];

    // 加入我的部门联系人
    // 我的部门单例
    [[UnifiedMyDeptDALManager share] setDelegate:self];
//    [[UnifiedMyDeptDALManager share] getMyDeptContacts];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
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

        ContactDetailModel *model = [arrayGroup objectAtIndex:indexPath.row];
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

        ContactDetailModel *model = [arrayGroup objectAtIndex:indexPath.row];
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
            for (ContactDetailModel *modelTemp in _tabBarView._arrayHeadPics)
            {
                if ([model._anotherName isEqualToString:modelTemp._anotherName])
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

#pragma mark -- SelectMyDeptContactViewController Delegate
// 选中单元格存入底部栏数组
- (void)SelectMyDeptContactViewControllerDelegateCallBack_SelectWithModel:(ContactDetailModel *)model
{
    // 加入底部栏数组
    [_tabBarView._arrayHeadPics addObject:model];
    // 刷新数据
    [_tabBarView refreshData];
}

// 取消选中单元格向上一级返回
- (void)SelectMyDeptContactViewControllerDelegateCallBack_DeselectWithModel:(ContactDetailModel *)model
{
    // 从底部栏数组删除
    for (ContactDetailModel *modelTemp in _tabBarView._arrayHeadPics)
    {
        if ([model._anotherName isEqualToString:modelTemp._anotherName])
        {
            [_tabBarView._arrayHeadPics removeObject:modelTemp];
            break;
        }
    }
    // 刷新数据
    [_tabBarView refreshData];
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
        for (ContactDetailModel *model in _tabBarView._arrayHeadPics)
        {
            [arrayAnotherNameList addObject:model._anotherName];
        }
        
        _createGroupDAL = [[CreateGroupDAL alloc] initWithGroupUsers:arrayAnotherNameList];
        [_createGroupDAL setDelegate:self];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:LOCAL(GROUP_ADDPROMPT)];
    }
}

#pragma mark -- GetFavoriteContactListDAL Delegate
// 请求成功
- (void)GetFavoriteContactListDALDelegateCallBack_SuccessWithContactList:(NSArray *)contactList
{
    // 因为首先执行，_arrayContacts无数据，因此不用去重
/*    // 我的部门与我的收藏去重
    for (ContactDetailModel *modelTemp in contactList)
    {
        for (ContactDetailModel *modelExisted in _arrayContacts)
        {
            if ([modelTemp._anotherName isEqualToString:modelExisted._anotherName])
            {
                [_arrayContacts removeObject:modelExisted];
                break;
            }
            
        }
    }
*/
    // 加入我的收藏联系人到数组
    [_arrayContacts addObjectsFromArray:contactList];
    
    // 请求我的部门联系人
    [[UnifiedMyDeptDALManager share] getMyDeptContacts];

    [_tableView reloadData];
}

// 失败
- (void)GetFavoriteContactListDALDelegateCallBack_FaildWithReason:(NSInteger)reason
{
    [SVProgressHUD showErrorWithStatus:[Slacker getPostError:reason]];
}

#pragma mark - CreateGroupDAL Delegate
// 创建群组成功的委托回调
- (void)CreateGroupDALDelegateCallBack_SuccessWithGroupLoginName:(NSString *)fromLoginName
{
    // 获取群信息
    _groupInfoDAL = [[GroupInfoDAL alloc] init];
    [_groupInfoDAL setDelegate:self];
    [_groupInfoDAL getGroupInfoWith:fromLoginName];
}

// 失败
- (void)CreateGroupDALDelegateCallBack_FaildWithReason:(NSInteger)reason
{
    [SVProgressHUD showErrorWithStatus:[Slacker getPostError:reason]];
}

#pragma mark - UnifiedMyDeptDALManager Delegate
// 成功
- (void)UnifiedMyDeptDALManagerDelegateCallBack_SuccessWithContactList:(NSArray *)contactList
{
    // 我的部门与我的收藏去重
    for (ContactDetailModel *modelTemp in contactList)
    {
        for (ContactDetailModel *modelExisted in _arrayContacts)
        {
            if ([modelTemp._anotherName isEqualToString:modelExisted._anotherName])
            {
                [_arrayContacts removeObject:modelExisted];
                break;
            }

        }
    }

    [_arrayContacts addObjectsFromArray:contactList];
    [SVProgressHUD dismissWithSuccess:LOCAL(UPDATE_SUCCESSFUL)];
    
    // 得到数据后进行索引排序分组
    NSMutableArray *arraySortName = [NSMutableArray arrayWithCapacity:_arrayContacts.count];
    for (ContactDetailModel *model in _arrayContacts)
    {
        [arraySortName addObject:model._realName];
    }
    // 索引排序分组
    _modelIndexSorted = [_sortManager indexSortWithNameArray:arraySortName FullDataArray:_arrayContacts];

    [_tableView reloadData];
}

// 失败
- (void)UnifiedMyDeptDALManagerDelegateCallBack_FailWithResult:(NSInteger)result
{
    [SVProgressHUD showErrorWithStatus:[Slacker getPostError:result]];
}

#pragma mark - GroupInfoDAL Delegate
// 获取群信息成功的委托回调
- (void)GroupInfoDALDelegateCallBack_FinishWithData:(GroupContactModel *)model
{
    // 群组信息写入表中
    [[UnifiedSqlManager share] insertBatchData:[NSArray arrayWithObject:model] WithTag:class_tag_group];
    
    // 群成员写入表中（自动去重）
    [[UnifiedSqlManager share] insertBatchData:model._arrMember WithTag:class_tag_allContacts];
    
    [SVProgressHUD dismiss];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    // 发送委托回调
    if ([self.delegate respondsToSelector:@selector(SelectGroupViewControllerDelegateCallBack_finishCreateGroupWithData:)])
    {
        [self.delegate SelectGroupViewControllerDelegateCallBack_finishCreateGroupWithData:model];
    }
}

// 获取群信息失败的委托回调
- (void)GroupInfoDALDelegateCallBack_FailWithFromLoginName:(NSString *)fromLoginName Result:(NSInteger)result
{
    [SVProgressHUD dismissWithError:[Slacker getPostError:result]];
}

@end
