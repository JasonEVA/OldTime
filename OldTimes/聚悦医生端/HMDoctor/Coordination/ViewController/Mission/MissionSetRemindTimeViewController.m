//
//  MissionSetRemindTimeViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionSetRemindTimeViewController.h"
#import <Masonry/Masonry.h>

@interface MissionSetRemindTimeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, copy) MissionSetRemindTimeViewControllerBlock selectBlock;
@end
@implementation MissionSetRemindTimeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提醒时间";
    self.dataList = @[ @(MissionTaskRemindTypeToday), @(MissionTaskRemindType5Min),@(MissionTaskRemindType15Min),@(MissionTaskRemindTypeHalfHour),@(MissionTaskRemindType1Hour),@(MissionTaskRemindType2Hours),@(MissionTaskRemindType1Day),@(MissionTaskRemindType2Days),@(MissionTaskRemindType1Weak)];
    [self configElements];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -private method
- (void)configElements {
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)remineTimeDidSelect:(MissionSetRemindTimeViewControllerBlock)selectBlock
{
    self.selectBlock = selectBlock;
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.dataList.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    NSString *titel;
    if (indexPath.section == 0) {
        titel = [MissionTypeEnum getTitelWithMissionTaskRemindType:MissionTaskRemindTypeNone];
    } else {
        titel = [MissionTypeEnum getTitelWithMissionTaskRemindType:[self.dataList[indexPath.row] integerValue]];
    }
    [cell.textLabel setText:titel];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:[UIColor commonBlackTextColor_333333]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.selectBlock) {
        MissionTaskRemindType remindType;
        if (indexPath.section == 0) {
            remindType = MissionTaskRemindTypeNone;
        } else {
            remindType = [self.dataList[indexPath.row] integerValue];
        }
        self.selectBlock(remindType);
    }
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
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [_tableView setShowsVerticalScrollIndicator:NO];
    }
    return _tableView;
}

@end
