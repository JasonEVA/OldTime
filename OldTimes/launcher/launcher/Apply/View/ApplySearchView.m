//
//  ApplySearchView.m
//  launcher
//
//  Created by Conan Ma on 15/9/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplySearchView.h"
#import "MyDefine.h"
#import "QuickCreateManager.h"
#import <MJRefresh/MJRefresh.h>
#import "ApplyGetReceiveListModel.h"
#import "ApplySearchRequest.h"
#import "ApplyAcceptTableViewCell.h"
#import "ApplySendTableViewCell.h"
#import "UIColor+Hex.h"
#import "Masonry.h"


#define MARGE_SEARCH_X 9    // 搜索栏距两边的距离
#define H_SEAECHBAR 30      // 搜索框高度
#define W_BTNCANCEL 45      // 取消按钮宽度
#define H_CELL  60                      // 单元格高度
#define H_HEIGHT    60      // searchbar显示高度


#define IMG_SEARCHBAR_BG @"contact_search_bg"   // 顶部搜索栏背景

@interface ApplySearchView()<BaseRequestDelegate>
/** 最大高度 */
@property (nonatomic, assign) CGFloat hieght;
/** 只显示searchbar时的center */
@property (nonatomic, assign) CGPoint centerOrigin;

@property (nonatomic, strong) NSMutableArray *arrWithTtitle;
@property (nonatomic, strong) NSMutableArray *arrWithApprovaller;

@property(nonatomic, strong) TTLoadingView  *loadingView;
@property (nonatomic) BOOL needShowData;

@property(nonatomic, strong) UILabel  *searchResultLbl;

@end

@implementation ApplySearchView
- (id)initWithFrame:(CGRect)frame
{
    // 最大高度
    _hieght = CGRectGetHeight(frame);
    
    self = [super initWithFrame:frame];
    if (self) {
        // 只显示searchbar时的center
        _centerOrigin = self.center;
        // 白色背景
        [self setBackgroundColor:[UIColor grayBackground]];
        
        // 搜索栏灰色背景
        UIImageView *imgViewSearBarBg = [QuickCreateManager creatImageViewWithFrame:CGRectMake(0, 0, frame.size.width, 64) Image:[UIImage imageNamed:IMG_SEARCHBAR_BG]];
        [self addSubview:imgViewSearBarBg];
        
        // 搜索栏
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 25, frame.size.width, H_SEAECHBAR)];
        [_searchBar setDelegate:self];
        [_searchBar setBackgroundImage:IMG_TRANSPARENT];
        [_searchBar setPlaceholder:LOCAL(SEARCH)];
        _searchBar.searchResultsButtonSelected = YES;
        [self addSubview:_searchBar];

        
        // 上拉刷新列表
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgViewSearBarBg.frame), frame.size.width, frame.size.height - HEIGTH_NAVI - HEIGTH_STATUSBAR) style:UITableViewStyleGrouped];
        [_tableView setHidden:YES];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ID"];
//        _tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullToRefreshing)];
        [self addSubview:_tableView];
        
        // 初始化数组
        if (_arraySearchResult == nil) {
            _arraySearchResult = [NSMutableArray array];
        }
        
        
        self.needShowData = NO;
      
        [self createFrame];
    }
    return self;
}

- (void)setSearchBarFirstResponder
{
    [_searchBar becomeFirstResponder];
}


// 销毁页面
- (void)dismissView
{
    [_arraySearchResult removeAllObjects];
    [_searchBar setText:@""];
    // 发送委托
    if ([self.delegate respondsToSelector:@selector(ApplySearchViewDelegateCallBack_BtnCancelClicked)])
    {
        [self.delegate ApplySearchViewDelegateCallBack_BtnCancelClicked];
    }
    [self removeFromSuperview];
    [_tableView reloadData];
}

#pragma mark - createFrame
- (void)createFrame
{
    [self.searchResultLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-100);
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrWithTtitle.count > 0||self.arrWithApprovaller.count >0  ? 2:0;
}
// 几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.needShowData)
        {
           return self.arrWithTtitle.count > 0 ? self.arrWithTtitle.count:1;
        }
        else
        {
            return self.arrWithTtitle.count > 0 ? self.arrWithTtitle.count:0;
        }
    }
    else
    {
        if (self.needShowData)
        {
            return self.arrWithApprovaller.count > 0 ? self.arrWithApprovaller.count:1;
        }
        else
        {
            return self.arrWithApprovaller.count > 0 ? self.arrWithApprovaller.count:0;
        }
        
    }
}

// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return H_CELL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width - 15, 30)];
    [view setBackgroundColor:[UIColor whiteColor]];
    if (section == 0)
    {
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@",LOCAL(APPLY_sp_contain),_searchBar.text,LOCAL(APPLY_SP_ASWORD)];
        
        
        NSMutableAttributedString *AttStr = [[NSMutableAttributedString alloc] initWithString:str
                                                                                        attributes:@{
                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                                     NSForegroundColorAttributeName:[UIColor colorWithRed:172.0/255 green:172.0/255 blue:172.0/255 alpha:1]
                                                                                                     }];
        [AttStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(((LOCAL(APPLY_sp_contain)).length + 1),_searchBar.text.length)];
        
        [lblTitle setAttributedText:AttStr];
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"%@ %@",_searchBar.text,LOCAL(APPLY_AS_APPROVELLER)];
        
        
        NSMutableAttributedString *AttStr = [[NSMutableAttributedString alloc] initWithString:str
                                                                                   attributes:@{
                                                                                                NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                                                                NSForegroundColorAttributeName:[UIColor colorWithRed:172.0/255 green:172.0/255 blue:172.0/255 alpha:1]
                                                                                                }];
        [AttStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0,_searchBar.text.length)];
        
        [lblTitle setAttributedText:AttStr];
    }
    [view addSubview:lblTitle];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    [view setBackgroundColor:[UIColor grayBackground]];
    return view;
}

// 单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* ApplyAcceptTableViewCellDealID = @"ApplyAcceptTableViewCellDeal";
    static NSString * ID = @"luancher";
    
    NSString *myName = [[UnifiedUserInfoManager share] userShowID];
    
    
    if (indexPath.section == 0)
    {
        if (!self.arrWithTtitle.count)
        {
            UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"ID"];
            cell.textLabel.text  = @"No data";
            return cell;
        }

        ApplyGetReceiveListModel *model = (ApplyGetReceiveListModel *)[self.arrWithTtitle objectAtIndex:indexPath.row];
        
        if ([model.CREATE_USER isEqualToString:myName])
        {
            ApplySendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell)
            {
                cell = [[ApplySendTableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
            }
            [cell OnlyUsedInSearch_setCellWithModel:self.arrWithTtitle[indexPath.row]];
            return cell;
        }
        else
        {
            ApplyAcceptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ApplyAcceptTableViewCellDealID];
            if (!cell)
            {
                cell = [[ApplyAcceptTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ApplyAcceptTableViewCellDealID];
            }
            [cell SearchsetDataWithModel:((ApplyGetReceiveListModel *)[self.arrWithTtitle objectAtIndex:indexPath.row])];
            return cell;
        }
    }
    else
    {
        if (!self.arrWithApprovaller.count)
        {
            UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"ID"];
            cell.textLabel.text  = @"No data";
            return cell;
        }
        ApplyGetReceiveListModel *model = (ApplyGetReceiveListModel *)[self.arrWithApprovaller objectAtIndex:indexPath.row];
        if ([model.CREATE_USER isEqualToString:myName])
        {
            ApplySendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell)
            {
                cell = [[ApplySendTableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
            }
            [cell OnlyUsedInSearch_setCellWithModel:self.arrWithApprovaller[indexPath.row]];
            return cell;
        }
        else
        {
            ApplyAcceptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ApplyAcceptTableViewCellDealID];
            if (!cell)
            {
                cell = [[ApplyAcceptTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ApplyAcceptTableViewCellDealID];
            }
            [cell SearchsetDataWithModel:((ApplyGetReceiveListModel *)[self.arrWithApprovaller objectAtIndex:indexPath.row])];
            return cell;
        }
    }
}

// 点击单元格事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 事件
    ApplyGetReceiveListModel *model;
    if (indexPath.section == 0)
    {
        if (!self.arrWithTtitle.count) return;
          model = [self.arrWithTtitle objectAtIndex:indexPath.row];
    }else
    {
        if (!self.arrWithApprovaller.count) return;
        model = [self.arrWithApprovaller objectAtIndex:indexPath.row];
    }
    
    
    // 向上一级传递Model
    if ([self.delegate respondsToSelector:@selector(ApplySearchViewDelegateCallBack_SelectCellWithModel: WithIndex:)])
    {
        [self.delegate ApplySearchViewDelegateCallBack_SelectCellWithModel:model WithIndex:indexPath.section];
        
    }
    
    // 更新状态
    // 更新frame
    CGRect frame = self.frame;
    frame.origin.y = -20;
    frame.size.height = H_HEIGHT;
    self.frame = frame;
    
    [_searchBar resignFirstResponder];
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_tableView setHidden:YES];
    
    // 清除搜索状态
    [_arraySearchResult removeAllObjects];
    [_searchBar setText:@""];
    [_tableView reloadData];
    self.hidden = YES;
//    [self removeFromSuperview];
}

// 用于拉动列表时收起键盘，不加会崩溃
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}


#pragma mark - UISearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 更新frame
    CGRect frame = self.frame;
    frame.origin.y = 0;
    frame.size.height = _hieght;
    self.frame = frame;
    
    [searchBar setShowsCancelButton:YES animated:YES];
    [_tableView setHidden:NO];
    if ([self.delegate respondsToSelector:@selector(ApplySearchViewDelegateCallBack_DidBeginEditing)])
    {
        [self.delegate ApplySearchViewDelegateCallBack_DidBeginEditing];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // 更新frame
    CGRect frame = self.frame;
    frame.origin.y = -20;
    frame.size.height = H_HEIGHT;
    self.frame = frame;
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [_tableView setHidden:YES];
    [self dismissView];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    UIButton *btn = [searchBar valueForKey:@"cancelButton"];
    [btn setEnabled:YES];
}

// 得到第一响应,显示取消按钮
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    UIButton *btn = [searchBar valueForKey:@"cancelButton"];
    [btn setEnabled:YES];
    return YES;
}

#pragma mark - private method
- (void)changeCancleBtn
{
    for(id control in [_searchBar subviews])
    {
        if ([control isKindOfClass:[UIButton class]])
        {
            UIButton * btn =(UIButton *)control;
            btn.enabled=YES;
        }
    }
}


// 搜索按钮点击
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{   
    [_arraySearchResult removeAllObjects];
    
    // 第一次向服务器请求数据
    [self.loadingView postLoading:LOCAL(APPLY_SEARCHING) message:@"" overTime:TipLoadingOverTime];
    
    ApplySearchRequest *request = [[ApplySearchRequest alloc] initWithDelegate:self];
    [request GetKeyWord:_searchBar.text];
    
    self.needShowData = YES;
    
    [_searchBar resignFirstResponder];
    [_tableView reloadData];
    [self changeCancleBtn];
}



// 当搜索框数据为空时
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        [_arraySearchResult removeAllObjects];
        
        // 刷新列表数据和状态
        [_tableView.footer endRefreshing];
        [_tableView reloadData];
    }
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    [self.arrWithApprovaller removeAllObjects];
    [self.arrWithTtitle removeAllObjects];
    
    if ([response isKindOfClass:[ApplySearchResponse class]])
    {
        for (int i = 0; i<((ApplySearchResponse *)response).arrResultTitleList.count; i++)
        {
            ApplyDetailInformationModel *model = [[ApplyDetailInformationModel alloc] initWithDict:[((ApplySearchResponse *)response).arrResultTitleList objectAtIndex:i]];
            model.searchKey = _searchBar.text;
            model.isInSearchView = YES;
            [self.arrWithTtitle addObject:model];
        }
        for (int i = 0; i<((ApplySearchResponse *)response).arrResultApproveList.count; i++)
        {
            ApplyDetailInformationModel *model = [[ApplyDetailInformationModel alloc] initWithDict:[((ApplySearchResponse *)response).arrResultApproveList objectAtIndex:i]];
            model.searchKey = _searchBar.text;
            model.isInSearchView = YES;
            [self.arrWithApprovaller addObject:model];
        }
    }
    [_tableView reloadData];
    [self TTLoadingViewDelgateCallHubWasHidden];
    //底部的提示文字
    if (totalCount == 0)
    {
        self.searchResultLbl.hidden = NO;
        self.searchResultLbl.text = [NSString stringWithFormat:LOCAL(APPLY_NORESULT),_searchBar.text];
    }else
    {
        self.searchResultLbl.hidden = YES;
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
 
}
//isInSearchView
#pragma mark - TTLoadingViewDelegate
- (void)TTLoadingViewDelgateCallHubWasHidden
{
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
    }
}

#pragma mark - init
- (NSMutableArray *)arrWithTtitle
{
    if (!_arrWithTtitle)
    {
        _arrWithTtitle = [[NSMutableArray alloc] init];
    }
    return _arrWithTtitle;
}

- (NSMutableArray *)arrWithApprovaller
{
    if (!_arrWithApprovaller)
    {
        _arrWithApprovaller = [[NSMutableArray alloc] init];
    }
    return _arrWithApprovaller;
}

- (TTLoadingView *)loadingView
{
    if (!_loadingView)
    {
        _loadingView = [[TTLoadingView alloc] initWithFrame:self.bounds];
        [self addSubview:_loadingView];
        [self bringSubviewToFront:_loadingView];
        _loadingView.delegate = self;
    }
    return _loadingView;
}

- (UILabel *)searchResultLbl
{
    if (!_searchResultLbl)
    {
        _searchResultLbl = [[UILabel alloc] init];
        
        [_tableView addSubview:_searchResultLbl];
        _searchResultLbl.textColor = [UIColor grayColor];
    }
    return _searchResultLbl;
}
@end
