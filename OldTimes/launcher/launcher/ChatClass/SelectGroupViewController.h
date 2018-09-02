//
//  SelectGroupViewController.h
//  Titans
//
//  Created by Andrew Shen on 14-9-9.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  选择群进行群聊天，选择单个联系人则相当于创建群

#import <UIKit/UIKit.h>
#import "ContactDetailModel.h"
#import "ContactSelectTabBarView.h"
//#import "GetFavoriteContactListDAL.h"
#import "GroupViewController.h"
#import "CreateGroupRequest.h"
#import "MyDeptRequestManager.h"
#import "ASIndexSortManager.h"

@protocol SelectGroupViewControllerDelegate <NSObject>

@optional
// 创建完毕群组的委托回调
- (void)SelectGroupViewControllerDelegateCallBack_finishCreateGroupWithData:(GroupContactModel *)model;

@end

@interface SelectGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ContactSelectTabBarViewDelegate,IMBaseRequestDelegate>
{
    UITableView *_tableView;
    UISearchBar *_searchBar;                            // 搜索栏
    ContactSelectTabBarView *_tabBarView;               // 底部栏
    GroupViewController *_existingGroup;                // 已有群界面
    
    CreateGroupDAL *_createGroupDAL;                    // 创建群网络请求
    GetFavoriteContactListDAL *_getFavoriteDAL;         // 请求收藏列表网络请求
    GroupInfoDAL *_groupInfoDAL;                        // 群组信息的网络请求
    
    NSMutableArray *_arrayContacts;                     // 收藏的联系人
    ASIndexSortManager *_sortManager;                   // 索引分组工具
    ASIndexedResultModel *_modelIndexSorted;            // 索引排序好的数组

}

@property (nonatomic,weak) id <SelectGroupViewControllerDelegate> delegate;

@end
