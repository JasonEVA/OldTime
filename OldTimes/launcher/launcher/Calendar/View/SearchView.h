//
//  SearchView.h
//  Launchr
//
//  Created by Conan Ma on 15/7/24.
//  Copyright (c) 2015年 Conan Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol ContactSearchViewDelegate <NSObject>
//
//// 点击单元格
//- (void)ContactSearchViewDelegateCallBack_SelectCellWithModel:(ContactDetailModel *)model;
//
//- (void)ContactSearchViewDelegateCallBack_DidBeginEditing;
//
//// 取消按钮委托
//- (void)ContactSearchViewDelegateCallBack_BtnCancelClicked;
//
//@end

@interface SearchView : UIView
{
    UITableView *_tableView;      // 列表
    UISearchBar *_searchBar;    // 搜索栏
    UIButton *_btnCancel;                   // 取消按钮

    NSMutableArray *_arraySearchResult;       // 搜索结果
    NSInteger _increment;                   // 每次请求的增量
    NSInteger _remain;                      // 剩余条数
}
//@property (nonatomic,weak) id<ContactSearchViewDelegate> delegate;
//
//- (void)setSearchBarFirstResponder;

@end
