//
//  SearchView.m
//  Launchr
//
//  Created by Conan Ma on 15/7/24.
//  Copyright (c) 2015年 Conan Ma. All rights reserved.
//

#import "SearchView.h"


#define MARGE_SEARCH_X 9    // 搜索栏距两边的距离
#define H_SEAECHBAR 30      // 搜索框高度
#define W_BTNCANCEL 45      // 取消按钮宽度
#define H_CELL  50                      // 单元格高度
#define H_HEIGHT    60      // searchbar显示高度


#define IMG_SEARCHBAR_BG @"search_bg"   // 顶部搜索栏背景
#define IMG_BTNEMPTY @"contact_search_btnEmpty" // 清空历史记录按钮背景
#define IMG_TRANSPARENT      [UIImage imageNamed:@"img_transparent"]
#define HEIGTH_NAVI  44                               // 导航栏高度
#define HEIGTH_STATUSBAR 20                           // 状态栏高度

@interface SearchView()

/** 最大高度 */
@property (nonatomic, assign) CGFloat hieght;
/** 只显示searchbar时的center */
@property (nonatomic, assign) CGPoint centerOrigin;

@end

@implementation SearchView

- (id)initWithFrame:(CGRect)frame
{
    // 最大高度
    _hieght = CGRectGetHeight(frame);
    
    self = [super initWithFrame:frame];
    if (self) {
        // 只显示searchbar时的center
        _centerOrigin = self.center;
        // 白色背景
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // 搜索栏灰色背景
        UIImageView *imgViewSearBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEARCHBAR_BG]];
        imgViewSearBarBg.frame = CGRectMake(0, 20, self.frame.size.width, 40);
        [self addSubview:imgViewSearBarBg];
        
        // 搜索栏
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 25, frame.size.width, H_SEAECHBAR)];
//        [_searchBar setDelegate:self];
        [_searchBar setBackgroundImage:IMG_TRANSPARENT];
        [_searchBar setPlaceholder:@"搜索"];
        [self addSubview:_searchBar];
        
//        // 上拉刷新列表
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgViewSearBarBg.frame), frame.size.width, frame.size.height - HEIGTH_NAVI - HEIGTH_STATUSBAR) style:UITableViewStylePlain];
//        [_tableView setHidden:YES];
//        [_tableView setDelegate:self];
//        [_tableView setDataSource:self];
//        [self addSubview:_tableView];
        
        // 初始化数组
        if (_arraySearchResult == nil) {
            _arraySearchResult = [NSMutableArray array];
        }
        _increment = 20;
        
        // 只显示searchbar时的frame
        frame.origin.y -= 20;
        frame.size.height = 60;
        self.frame = frame;
        
    }
    return self;
}

- (void)pullToRefreshing
{

    [_tableView reloadData];
    
}

@end
