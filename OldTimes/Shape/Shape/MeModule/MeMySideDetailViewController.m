//
//  MeMySideDetailViewController.m
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeMySideDetailViewController.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
#import "MeMySideDetailCell.h"

@interface MeMySideDetailViewController()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *rightBtn;
@property (nonatomic, copy) NSArray<NSString *> *titelList;
@property (nonatomic, copy) NSArray<NSString *> *unitList;
@end

@implementation MeMySideDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMyData];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark -private method
- (void)initMyData
{
    [self.navigationItem setTitle:@"2015年5月25日"];
    [self.navigationItem setRightBarButtonItem:self.rightBtn];
    self.titelList = [NSArray arrayWithObjects:@"体测时间",@"骨骼肌",@"体脂肪",@"身体水含量",@"去脂体重",@"身体质量指数",@"体脂百分比",@"腰臀比",@"基础代谢", nil];
    self.unitList = [NSArray arrayWithObjects:@"",@"kg",@"kg",@"kg",@"kg",@"",@"%",@"",@"", nil];
}
#pragma mark - event Response
- (void)addClick
{
    
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titelList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"myCell";
    MeMySideDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MeMySideDetailCell alloc] initWithUnit:self.unitList[indexPath.row] reuseIdentifier:ID];
        [cell setBackgroundColor:[UIColor themeBackground_373737]];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setText:self.titelList[indexPath.row]];
    if (indexPath.row == 0) {
        [cell setDateInputView];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 270;
}
#pragma mark - request Delegate

#pragma mark - updateViewConstraints

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
            [_tableView setSeparatorColor:[UIColor lineDarkGray_4e4e4e]];
        }
        [_tableView setShowsVerticalScrollIndicator:NO];
    }
    return _tableView;
}
- (UIBarButtonItem *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(addClick)];
    }
    return _rightBtn;
}
@end
