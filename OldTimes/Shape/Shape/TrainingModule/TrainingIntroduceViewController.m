//
//  TrainingIntroduceViewController.m
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainingIntroduceViewController.h"
#import "UIColor+Hex.h"
#import "TrainTitelView.h"
#import "UILabel+EX.h"
#import "MyDefine.h"
#import <Masonry.h>
#import "TrainTimeView.h"
#import "TrainEffectOnEachPartView.h"
#import "UIButton+EX.h"
#import "TrainIconNameCell.h"
#import "TrainEachDayContentCell.h"
#import "TrainGetTrainInfoRequest.h"
#import "TrainGetTrainInfoModel.h"
#import <UIImageView+WebCache.h>
#import "TrainAddTrainPlanRequest.h"
#import "ShopIntroViewController.h"
#import "NSString+Manager.h"



@interface TrainingIntroduceViewController()<UITableViewDelegate,UITableViewDataSource,BaseRequestDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) TrainTitelView *titelView;               //头部标题View
@property (nonatomic, strong) TrainTimeView *timeView;                 //时间的View
@property (nonatomic, strong) TrainEffectOnEachPartView *effectView;  //中部部位锻炼情况View
@property (nonatomic, strong) UIButton *button;                      //确定参加按钮

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TrainGetTrainInfoModel *model;
@property (nonatomic, copy) NSMutableArray *dataList;
@end

@implementation TrainingIntroduceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponent];
    [self.view needsUpdateConstraints];
    [self startRequest];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
    [super viewWillAppear:animated];

}

#pragma mark -private method
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)addTrainClick
{
    TrainAddTrainPlanRequest *request = [[TrainAddTrainPlanRequest alloc]init];
    request.myID = self.model.trainingId;
    [request requestWithDelegate:self];
    [self postLoading];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popToRootViewControllerAnimated:NO];
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.trainID,@"trainID", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:n_pushToStartTraining object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)initComponent
{
    [self.view addSubview:self.imageView];
    [self.imageView addSubview:self.titelView];
    [self.imageView addSubview:self.backBtn];
    [self.imageView addSubview:self.titelLb];
    [self.imageView addSubview:self.timeView];
    [self.imageView addSubview:self.effectView];
    [self.view addSubview:self.button];
    [self.view addSubview:self.tableView];
    
}

- (void)startRequest
{
    TrainGetTrainInfoRequest *request = [[TrainGetTrainInfoRequest alloc]init];
    request.myId = self.trainID;
    [request requestWithDelegate:self];
    [self postLoading];
}

- (void)setMyData:(TrainGetTrainInfoModel *)model
{
    [self.titelView setMyData:model];
    [self.timeView setMyData:model];
    [self.effectView setMyData:model];
    //NSURL *url = [NSURL URLWithString:model.backgroundUrl];
    [self.imageView sd_setImageWithURL:[NSString fullURLWithFileString:model.backgroundUrl]];  //placeholderImage:[UIImage imageNamed:@"train_back"]];
}
#pragma mark - event Response

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count + 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        static NSString *ID = @"cell";
        TrainIconNameCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[TrainIconNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
                [cell.textLabel setTextColor:[UIColor whiteColor]];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
        }
        return cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *ID1 = @"mycell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
                [cell.textLabel setText:@"训练明细"];
                [cell.textLabel setTextColor:[UIColor whiteColor]];
            }    }
        return cell;
    }
    else
    {
        static NSString *ID2 = @"Cell";
        TrainEachDayContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        if (!cell) {
            cell = [[TrainEachDayContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID2];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        
        }
        [cell setMyData:self.dataList[indexPath.row - 2] day:indexPath.row - 1];
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        // 进入商店介绍页
        ShopIntroViewController *shopIntroVC = [[ShopIntroViewController alloc] init];
        [self.navigationController pushViewController:shopIntroVC animated:YES];
    }
}
#pragma mark - request Delegate
- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self hideLoading];

    NSLog(@"请求失败");

}

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self hideLoading];
    if ([response isKindOfClass:[TrainAddTrainPlanResponse class]]) {
        
        
    }
    else if ([response isKindOfClass:[TrainGetTrainInfoResponse class]])
    {
        TrainGetTrainInfoResponse *result = (TrainGetTrainInfoResponse *)response;
        self.model = result.model;
        self.dataList = [NSMutableArray arrayWithArray:result.modelArr];
        [self setMyData:self.model];
        [self.tableView reloadData];
    }

   
    NSLog(@"请求成功");
}
#pragma mark - updateViewConstraints

- (void)updateViewConstraints
{
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_centerY);
    }];
    [self.titelLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(33);
        make.centerX.equalTo(self.view);
    }];
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.centerY.equalTo(self.titelLb.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    [self.titelView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titelLb.mas_bottom).offset(36);
        make.left.equalTo(self.view).offset(17);
    }];
    
    [self.timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView).offset(25);
        make.right.equalTo(self.imageView).offset(-25);
        make.bottom.equalTo(self.effectView.mas_top).offset(-26);
        make.height.mas_equalTo(51);
    }];
    
    [self.effectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.imageView);
        make.height.mas_equalTo(57);
    }];
    
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.button.mas_top);
    }];
    
    [super updateViewConstraints];
}
#pragma mark - init UI

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [_imageView setUserInteractionEnabled:YES];
    }
    return _imageView;
}

- (UILabel*)titelLb
{
    if (!_titelLb) {
        _titelLb = [UILabel setLabel:_titelLb text:@"训练计划" font:[UIFont systemFontOfSize:fontSize_18] textColor:[UIColor whiteColor]];
    }
    return _titelLb;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]init];
        [_backBtn setImage:[UIImage imageNamed:@"train_backimg"] forState:UIControlStateNormal];
        //[_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (TrainTitelView *)titelView
{
    if (!_titelView) {
        _titelView = [[TrainTitelView alloc]init];
    }
    return _titelView;
}

- (TrainTimeView *)timeView
{
    if (!_timeView) {
        _timeView = [[TrainTimeView alloc]init];
    }
    return _timeView;
}

- (TrainEffectOnEachPartView *)effectView
{
    if (!_effectView) {
        _effectView = [[TrainEffectOnEachPartView alloc]init];
    }
    return _effectView;
}
- (UIButton *)button
{
    if(!_button){
        _button = [UIButton setBntData:_button backColor:nil backImage:[UIColor switchToImageWithColor:[UIColor themeOrange_ff5d2b] size:CGSizeMake(1, 1)] title:@"参加训练" titleColorNormal:[UIColor whiteColor] titleColorSelect:nil font:nil tag:1 isSelect:NO];
        
        [_button addTarget:self action:@selector(addTrainClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

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

- (TrainGetTrainInfoModel *)model
{
    if (!_model) {
        _model = [[TrainGetTrainInfoModel alloc]init];
    }
    return _model;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}
@end
