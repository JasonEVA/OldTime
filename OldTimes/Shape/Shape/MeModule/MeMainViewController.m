//
//  MeMainViewController.m
//  Shape
//
//  Created by Andrew Shen on 15/10/14.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeMainViewController.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "MeMessageTableViewCell.h"
#import "MeDetailsViewController.h"
#import "MeGetUserInfoRequest.h"
#import "MeGetUserInfoModel.h"
#import "UIImageView+WebCache.h"
#import "unifiedUserInfoManager.h"
#import "MeSettingViewController.h"
#import "MeMySideListViewController.h"
#import "NSString+Manager.h"
#import "MeTrainHistoryViewController.h"
#import "MeBodilyFormViewController.h"
#import "WeightRecordViewController.h"

@interface MeMainViewController ()<UITableViewDelegate,UITableViewDataSource,BaseRequestDelegate>
@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, copy) NSArray *titelArr;
@property (nonatomic, copy) NSArray *iconArr;
@property (nonatomic, strong) MeGetUserInfoModel *model;
@end

@implementation MeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我"];
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"me_setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingPage)];
    [self.navigationItem setRightBarButtonItem:settingItem];
    
    [self initComponent];
    [self.view needsUpdateConstraints];
    [self setMyDate];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MeGetUserInfoRequest *request = [[MeGetUserInfoRequest alloc]init];
    [request requestWithDelegate:self];
    [self postLoading];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method

- (void)setMyDate
{
    self.titelArr = [NSArray arrayWithObjects:@"训练历史",@"我的体型",@"体重记录",@"我的体测", nil];
    UIImage *image1 = [UIImage imageNamed:@"me_history"];
    UIImage *image2 = [UIImage imageNamed:@"me_bodytype"];
    UIImage *image3 = [UIImage imageNamed:@"me_weight"];
    UIImage *image4 = [UIImage imageNamed:@"me_test"];
    self.iconArr = [NSArray arrayWithObjects:image1,image2,image3,image4, nil];
}

- (void)settingPage {
    MeSettingViewController *settingVC = [[MeSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark - event Response

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    else
    {
        return 44;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *ID = @"Cell";
        MeMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[MeMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            [cell setBackgroundColor:[UIColor themeBackground_373737]];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }

        [cell setMyData:self.model];
        //NSURL *url = [NSURL URLWithString:self.model.headIconUrl];
        [cell.myImageView sd_setImageWithURL:[NSString fullURLWithFileString:self.model.headIconUrl] placeholderImage:[UIImage imageNamed:@"me_icon"]];
        return cell;

    }
    else
    {
        static NSString *ID = @"myCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            [cell setBackgroundColor:[UIColor themeBackground_373737]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        [cell.imageView setImage:self.iconArr[indexPath.row - 1]];
        [cell.textLabel setText:self.titelArr[indexPath.row - 1]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        return cell;

    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![[unifiedUserInfoManager share] loginStatus]) {
        return;
    }
    UIViewController *VC;
    switch (indexPath.row) {
        case 0://个人信息
        {
            MeDetailsViewController *meVC = [[MeDetailsViewController alloc] init];
            VC = meVC;
        }
            break;
            
        case 1://训练历史
        {
            MeTrainHistoryViewController *historyVC = [[MeTrainHistoryViewController alloc] init];
            VC = historyVC;
        }
            break;
        case 2://我的体型
        {
            MeBodilyFormViewController *bodyVC = [[MeBodilyFormViewController alloc] init];
            VC = bodyVC;

        }
            break;
        case 3://体重记录
        {
            WeightRecordViewController *weightVC = [[WeightRecordViewController alloc] init];
            VC = weightVC;
        }
            break;
        case 4://体测
        {
            MeMySideListViewController *sideListVC = [[MeMySideListViewController alloc] init];
            VC = sideListVC;

        }
            break;
        default:
            break;
    }
    [VC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:VC animated:YES];

}

#pragma mark - initConponent
- (void)initComponent
{
    [self.view addSubview:self.myTableView];
}
#pragma mark - updateViewConstraints

- (void)updateViewConstraints
{
    [self.myTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}
#pragma mark - init UI

- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        [_myTableView setDelegate:self];
        [_myTableView setDataSource:self];
        [_myTableView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [_myTableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myTableView setLayoutMargins:UIEdgeInsetsZero];
            [_myTableView setSeparatorColor:[UIColor lineDarkGray_4e4e4e]];
        }
    }
    return _myTableView;
}

- (MeGetUserInfoModel *)model
{
    if (!_model) {
        _model = [[MeGetUserInfoModel alloc] init];
    }
    return _model;
}
#pragma mark - request Delegate

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self hideLoading];
    MeGetUserInfoResponse *result = (MeGetUserInfoResponse *)response;
    self.model = result.userInfoMogdel;
    
    // 保存到本地
    [[unifiedUserInfoManager share] saveUserInfoData:self.model];
    
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"请求成功");
}

- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self hideLoading];
    NSLog(@"请求失败");
}
@end
