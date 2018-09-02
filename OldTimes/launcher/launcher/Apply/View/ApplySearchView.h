//
//  ApplySearchView.h
//  launcher
//
//  Created by Conan Ma on 15/9/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyDetailInformationModel.h"
#import "ApplyGetReceiveListModel.h"
#import "TTLoadingView.h"
@protocol ApplySearchViewDelegate <NSObject>

- (void)ApplySearchViewDelegateCallBack_SelectCellWithModel:(ApplyGetReceiveListModel *)model WithIndex:(NSInteger)index;

- (void)ApplySearchViewDelegateCallBack_DidBeginEditing;

- (void)ApplySearchViewDelegateCallBack_BtnCancelClicked;

@end

@interface ApplySearchView : UIView<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, TTLoadingViewDelegate>
{
    UITableView *_tableView;        // 列表
    UISearchBar *_searchBar;        // 搜索栏
    NSMutableArray *_arraySearchResult;       // 搜索结果
}
@property (nonatomic, weak) id<ApplySearchViewDelegate>delegate;
- (void)setSearchBarFirstResponder;
@end
