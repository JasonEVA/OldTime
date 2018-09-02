//
//  PersonIntegralRoleViewController.m
//  HMClient
//
//  Created by yinquan on 2017/7/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PersonIntegralRoleViewController.h"
#import "IntegralModel.h"
#import "IntegralLevelRuleTableViewCell.h"

@interface PersonIntegralRoleViewController ()
<UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (nonatomic, strong) UIView* headerView;

@property (nonatomic, strong) UIView* levelLineView;
@property (nonatomic, strong) UILabel* levelLabel;
@property (nonatomic, strong) UIView* numberLineView;
@property (nonatomic, strong) UILabel* numberLabel;
@property (nonatomic, strong) UITableView* levelTableView;


@end

@implementation PersonIntegralRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"会员等级说明"];
    [self configHeaderView];
}

- (void) configHeaderView
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.top.equalTo(self.view).with.offset(20);
        make.height.mas_equalTo(@40);
    }];
    
    [self.levelLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.headerView);
        make.left.equalTo(self.headerView).with.offset(48);
        make.width.mas_equalTo(@0.5);
    }];
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.headerView);
        make.left.equalTo(self.levelLineView).with.offset(15);
        make.width.mas_equalTo(@(124 * kScreenWidth / 375));
    }];
    
    [self.numberLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.headerView);
        make.left.equalTo(self.levelLabel.mas_right);
        make.width.mas_equalTo(@0.5);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.headerView);
        make.left.equalTo(self.numberLineView.mas_right).offset(15);
    }];
    
    [self.levelTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headerView);
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return IntegralVIPLevelCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IntegralLevelRuleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IntegralLevelRuleTableViewCell"];
    if (!cell)
    {
        cell = [[IntegralLevelRuleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntegralLevelRuleTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setIntegralVipLevel:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 0.5)];
    [footerview setBackgroundColor:[UIColor clearColor]];
    
    return footerview;
}

#pragma mark - settingAndGetting
- (UIView*) headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        [self.view addSubview:_headerView];
        
        [_headerView setBackgroundColor:[UIColor commonBackgroundColor]];
        _headerView.layer.borderWidth = 0.5;
        _headerView.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        _headerView.layer.masksToBounds = YES;
    }
    return _headerView;
}

- (UIView*) levelLineView
{
    if (!_levelLineView) {
        _levelLineView = [[UIView alloc] init];
        [self.headerView addSubview:_levelLineView];
        [_levelLineView setBackgroundColor:[UIColor commonControlBorderColor]];
    }
    return _levelLineView;
}

- (UILabel*) levelLabel
{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] init];
        [self.headerView addSubview:_levelLabel];
        
        [_levelLabel setText:@"等级"];
        [_levelLabel setTextColor:[UIColor commonTextColor]];
        [_levelLabel setFont:[UIFont systemFontOfSize:18]];
        
        
    }
    return _levelLabel;
}

- (UIView*) numberLineView
{
    if (!_numberLineView) {
        _numberLineView = [[UIView alloc] init];
        [self.headerView addSubview:_numberLineView];
        [_numberLineView setBackgroundColor:[UIColor commonControlBorderColor]];
    }
    return _numberLineView;
}

- (UILabel*) numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        [self.headerView addSubview:_numberLabel];
        
        [_numberLabel setText:@"升级积分段"];
        [_numberLabel setTextColor:[UIColor commonTextColor]];
        [_numberLabel setFont:[UIFont systemFontOfSize:18]];
    }
    return _numberLabel;
}

- (UITableView*) levelTableView
{
    if (!_levelTableView)
    {
        _levelTableView = [[UITableView alloc] init];
        [self.view addSubview:_levelTableView];
        [_levelTableView setDelegate:self];
        [_levelTableView setDataSource:self];
        [_levelTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _levelTableView;
}
@end
