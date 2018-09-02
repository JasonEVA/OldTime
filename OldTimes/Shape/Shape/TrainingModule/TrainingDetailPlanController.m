//
//  TrainingDetailPlanController.m
//  Shape
//
//  Created by jasonwang on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainingDetailPlanController.h"
#import "TrainTitelView.h"
#import "TrainRoundnessProgressBar.h"
#import "UILabel+EX.h"
#import "MyDefine.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "TrainIconNameCell.h"
#import "TrainDayDetailInfoCell.h"
#import "UIButton+EX.h"
#import "TrainRunManView.h"
#import "TrainingStartVideoPlayController.h"
#import "ShopIntroViewController.h"
#import "TrainGetDayTrainInfoRequest.h"
#import "TrainGetDayTrainInfoModel.h"
#import <UIImageView+WebCache.h>
#import "TrainActionListModel.h"
#import <MJExtension.h>
#import "NSString+Manager.h"


#define ACTIONTYPE     0  //动作
#define RUNINGTYPE     1  //跑步


@interface TrainingDetailPlanController()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BaseRequestDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) TrainTitelView *titelView;               //头部标题View
@property (nonatomic, strong) TrainRoundnessProgressBar *round;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *startBtn;
//动作界面
@property (nonatomic, strong) UICollectionView *collectView;
//跑步界面
@property (nonatomic, strong) TrainRunManView *runManView;

@property (nonatomic, strong) TrainGetDayTrainInfoModel *model;
@property (nonatomic, copy) NSArray<TrainActionListModel *> *dataList;
@property (nonatomic, strong) TrainActionListModel *actModel;


@end

@implementation TrainingDetailPlanController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initComponent];
    [self.view needsUpdateConstraints];
    
    
    [self startRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
}
#pragma mark -private method

- (void)initComponent
{
    [self.view addSubview:self.imageView];
    [self.imageView addSubview:self.titelView];
    [self.imageView addSubview:self.backBtn];
    [self.imageView addSubview:self.titelLb];
    [self.imageView addSubview:self.round];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.collectView];
    [self.view addSubview:self.runManView];
}

- (void)startRequest
{
    TrainGetDayTrainInfoRequest *request = [[TrainGetDayTrainInfoRequest alloc]init];
    request.trainID = self.trainID;
    [request requestWithDelegate:self];
    [self postLoading];
}

- (void)setMyData
{
    [self.titelView setDayInfoData:self.model];
    //设置圆形进度条
    NSString *totalStr = [NSString
                          stringWithFormat:@"%ld",self.model.totalTime];
    CGFloat totalFloat = [totalStr floatValue];
    
    NSString *completStr = [NSString
                            stringWithFormat:@"%ld",self.model.daysNo - 1];
    CGFloat completFloat = [completStr floatValue];
    [self.round setMyAngale:completFloat / totalFloat];
    if (self.model.classify == ACTIONTYPE) {
        [self.runManView setHidden:YES];
        [self.collectView setHidden:NO];
        [self.collectView reloadData];
    }else
    {
        [self.runManView setHidden:NO];
        [self.collectView setHidden:YES];
    }
    [self.tableView reloadData];
    
    [self.startBtn setTitle:[NSString stringWithFormat:@"开始第%ld天训练",(long)self.model.daysNo] forState:UIControlStateNormal];

}
#pragma mark - event Response
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startTrainClick
{
    TrainingStartVideoPlayController *videlPlayVC = [[TrainingStartVideoPlayController alloc] init];
    videlPlayVC.arrayActionList = self.dataList;
    videlPlayVC.trainID = self.trainID;
    [self.navigationController pushViewController:videlPlayVC animated:YES];
}

#pragma mark - UIcollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"UICollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"train_action"]];
    self.actModel = self.dataList[indexPath.row];
    
   
    //NSURL *url = [NSURL URLWithString:self.actModel.thumbnailUrl];
    [imageView sd_setImageWithURL:[NSString fullURLWithFileString:self.actModel.thumbnailUrl]];
    [cell.contentView addSubview:imageView];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(156, 100);
}



#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
        [cell setMyData:self.model];
        return cell;
    }
else
{
    static NSString *ID = @"myCell";
    TrainDayDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TrainDayDetailInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell setMyData:self.model];
    return cell;

}
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 49;
    }else{
        return 100;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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
    NSLog(@"请求成功");
    TrainGetDayTrainInfoResponse *result = (TrainGetDayTrainInfoResponse *)response;
    //[self postSuccess:result.message];
    self.model = result.model;
    self.dataList = result.model.actionList;
    [self setMyData];
}
#pragma mark - updateViewConstraints
- (void)updateViewConstraints
{
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.284);
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
        make.top.equalTo(self.titelLb.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(17);
    }];
    [self.round mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(80);
        make.right.equalTo(self.imageView).offset(-20);
        make.bottom.equalTo(self.imageView).offset(-20);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom);
        make.bottom.equalTo(self.collectView.mas_top).offset(-5);
    }];
    
    [self.startBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.collectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.view.frame.size.height * 0.427);
        make.left.equalTo(self.view).offset(26);
        make.right.equalTo(self.view).offset(-26);
        make.bottom.equalTo(self.startBtn.mas_top);
    }];
    
   [self.runManView mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.collectView);
   }];
    [super updateViewConstraints];
}
#pragma mark - init UI

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView setImage:[UIImage imageNamed:@"train_back"]];
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

- (TrainRoundnessProgressBar *)round
{
    if (!_round) {
        _round = [[TrainRoundnessProgressBar alloc]init];
        
    }
    return _round;
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
- (UIButton *)startBtn
{
    if(!_startBtn){
        _startBtn = [UIButton setBntData:_startBtn backColor:nil backImage:[UIColor switchToImageWithColor:[UIColor themeOrange_ff5d2b] size:CGSizeMake(1, 1)] title:@"开始第1天训练" titleColorNormal:[UIColor whiteColor] titleColorSelect:nil font:nil tag:1 isSelect:NO];
        [_startBtn addTarget:self action:@selector(startTrainClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UICollectionView *)collectView
{
    if (!_collectView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectView setDelegate:self];
        [_collectView setDataSource:self];
        [_collectView setBackgroundColor:[UIColor clearColor]];
        [_collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_collectView setShowsVerticalScrollIndicator:NO];
    }
    return _collectView;
}

- (TrainRunManView *)runManView
{
    if (!_runManView) {
        _runManView = [[TrainRunManView alloc]init];
    }
    return _runManView;
}

- (TrainGetDayTrainInfoModel *)model
{
    if (!_model) {
        _model = [[TrainGetDayTrainInfoModel alloc]init];
    }
    return _model;
}

- (NSArray <TrainActionListModel *>*)dataList
{
    if (!_dataList) {
        _dataList = [[NSArray alloc]init];
    }
    return _dataList;
}
- (TrainActionListModel *)actModel
{
    if (!_actModel) {
        _actModel = [[TrainActionListModel alloc]init];
    }
    return _actModel;
}

@end
