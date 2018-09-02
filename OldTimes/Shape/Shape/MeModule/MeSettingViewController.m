//
//  MeSettingViewController.m
//  Shape
//
//  Created by Andrew Shen on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeSettingViewController.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
#import "MyDefine.h"

@interface MeSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy)  NSArray  *arrayTitle; // <##>
@end

@implementation MeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置"];
    self.arrayTitle = @[@[@"提醒设置"],@[@"关于Shape",@"联系客服"]];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrayRows = self.arrayTitle[section];
    return arrayRows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else {
        return 20;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor themeBackground_373737]];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        [cell.textLabel setTextColor:[UIColor whiteColor]];
//        [cell.textLabel setFont:[UIFont systemFontOfSize:fontSize_15]];
    }
    [cell.textLabel setText:self.arrayTitle[indexPath.section][indexPath.row]];
    if (indexPath.section == 0) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - init
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
            [_tableView setSeparatorColor:[UIColor lineDarkGray_4e4e4e]];
        }
        [_tableView setShowsVerticalScrollIndicator:NO];
    }
    return _tableView;
}

@end
