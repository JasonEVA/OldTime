//
//  MissionMainListInputView.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务分类弹出View

#import "MissionMainListInputView.h"
#import <Masonry/Masonry.h>
#import "LiftDrawerTableViewCell.h"
#import "TaskTypeTitleAndCountModel.h"

#define ROWHEIGHT  44
@interface MissionMainListInputView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, copy) NSArray *imageList;
@property (nonatomic, copy) MissionMainListInputViewBlock selectBlock;
@property (nonatomic, copy)  void (^closeView)(); // <##>
@end

@implementation MissionMainListInputView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.closeView) {
        self.closeView();
    }
}

#pragma mark - Interface

- (void)reloadInputViewWithData:(NSArray<TaskTypeTitleAndCountModel *> *)dataSource selectIndexBlock:(MissionMainListInputViewBlock)selectBlock {
    self.selectBlock = selectBlock;
    self.dataList = dataSource ?: @[];
    [self configElements];
}

- (void)closeInputViewNoti:(void(^)())closeView {
    self.closeView = closeView;
}


#pragma mark - private method

// 设置元素控件
- (void)configElements {
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置数据
- (void)configData {
    self.imageList = @[@"Mission_Today",@"Mission_Tommory",@"Mission_AllMission",@"Mission_Refuse",@"Mission_SendFromMe",@"Mission_Down"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tabInd == 2"];
    NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
    if (!array) {
        return;
    }
    self.selectBlock(array.firstObject);
}

// 设置约束
- (void)configConstraints {
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.height.mas_equalTo(self.dataList.count * ROWHEIGHT);
        make.width.equalTo(@209);
    }];

}


#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"myCell";
    LiftDrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LiftDrawerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    TaskTypeTitleAndCountModel *model = self.dataList[indexPath.row];
    [cell configCellDataWithModel:model iconName:self.imageList[model.tabInd]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 不要选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.closeView) {
        self.closeView();
    }

    if (self.selectBlock) {
        self.selectBlock(self.dataList[indexPath.row]);
    }

}

#pragma mark - request Delegate

#pragma mark - updateViewConstraints

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setScrollEnabled:NO];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}
@end
