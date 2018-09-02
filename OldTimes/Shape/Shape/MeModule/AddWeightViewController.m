//
//  AddWeightViewController.m
//  Shape
//
//  Created by Andrew Shen on 15/11/17.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "AddWeightViewController.h"
#import "BaseInputTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import "MeMySideDetailCell.h"
#import "DBUnifiedManager.h"

@interface AddWeightViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  NSArray  *arrayTitles; // <##>
@end

@implementation AddWeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"存储" style:UIBarButtonItemStylePlain target:self action:@selector(saveWeight)];
    [self.navigationItem setRightBarButtonItem:saveItem];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [self.navigationItem setLeftBarButtonItem:cancelItem];
    [self configElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    [self.view addSubview:self.tableView];
    self.arrayTitles = @[@"时间",@"体重(kg)"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)saveWeight {
    MeMySideDetailCell *timeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    MeMySideDetailCell *weightCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [[DBUnifiedManager share] saveWeight:weightCell.txtFd.text.floatValue date:timeCell.birthdayPickView.date];
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *time = @"time";
    static NSString *weight = @"weight";
    if (indexPath.row == 0) {
        MeMySideDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:time];
        if (!cell) {
            cell = [[MeMySideDetailCell alloc] initWithUnit:@"" reuseIdentifier:time];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
            [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
            [cell setDateInputView];

        }
        [cell.textLabel setText:self.arrayTitles[indexPath.row]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        return cell;

    } else {
        MeMySideDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:weight];
        if (!cell) {
            cell = [[MeMySideDetailCell alloc] initWithUnit:@"" reuseIdentifier:weight];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
            [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
        }
        [cell.textLabel setText:self.arrayTitles[indexPath.row]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];

        return cell;

    }
}

#pragma mark - Init

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
            [_tableView setSeparatorColor:[UIColor lineDarkGray_4e4e4e]];
        }
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setTableFooterView:[UIView new]];
    }
    return _tableView;
}

@end
