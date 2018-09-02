//
//  TrainingAlltrainViewController.m
//  Shape
//
//  Created by jasonwang on 15/10/30.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainingAlltrainViewController.h"
#import "UIColor+Hex.h"
#import "TrainingTableViewCell.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "TrainingSelectBtn.h"
#import "TrainingIntroduceViewController.h"
#import "TrainGetTrainDataArrayModel.h"
#import "TrainGetTrainListResultModel.h"
#import "TrainGetAllTrainListRequest.h"
#import "unifiedFilePathManager.h"
#import <MJRefresh/MJRefresh.h>

#define ADDNUM      2


typedef NS_ENUM(NSInteger,selectType){
    instrumentBtnTag,
    partBtnTag,
    difficultyBtnTag,
    elseTag
};

@interface TrainingAlltrainViewController()<UITableViewDelegate,UITableViewDataSource,BaseRequestDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *typeSelectView;
@property (nonatomic, strong) TrainingSelectBtn *instrumentBtn;      //器材
@property (nonatomic, strong) TrainingSelectBtn *partBtn;            //部位
@property (nonatomic, strong) TrainingSelectBtn *difficultyBtn;      //难度

@property (nonatomic, strong) TrainingSelectBtn *selectedBtn;       //当前选中项

//@property (nonatomic, strong) UITableView *inputTableView;
@property (nonatomic, strong) UITableView *instrumentTableView;
@property (nonatomic, strong) UITableView *partTableView;
@property (nonatomic, strong) UITableView *difficultyTableView;

@property (nonatomic, copy) NSMutableArray *instrumentArr;
@property (nonatomic, copy) NSMutableArray *partArr;
@property (nonatomic, copy) NSArray *difficultyArr;
@property (nonatomic) BOOL isShow;
@property (nonatomic, strong)  MASConstraint  *instrumentHeight;
@property (nonatomic, strong)  MASConstraint  *partHeight;
@property (nonatomic, strong)  MASConstraint  *difficultyHeight;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic) NSInteger instrumentSelectedCellNum;
@property (nonatomic) NSInteger partSelectedCellNum;
@property (nonatomic) NSInteger difficultySelectedCellNum;

@property (nonatomic, copy) NSString *difficultyString;
@property (nonatomic, copy) NSString *instrumentString;
@property (nonatomic, copy) NSString *partString;
@property (nonatomic) NSInteger page;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation TrainingAlltrainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"全部训练"];
    [self initComponent];
    [self.view needsUpdateConstraints];
    self.page = 0;
    self.instrumentSelectedCellNum = 0;
    self.partSelectedCellNum = 0;
    self.difficultySelectedCellNum = 0;

    self.difficultyArr = [NSArray arrayWithObjects:@"全部难度",@"K1 零基础",@"K2 初学",@"K3 进阶",@"K4 强化",@"K5 挑战", nil];
    self.isShow = NO;
    [self getMyData];
    [self startRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

#pragma mark -private method

//从沙箱中获取数据源
- (void)getMyData
{
    //读取所有内容
    [self.instrumentArr addObject:@"不限器械"];
    [self.partArr addObject:@"不限部位"];
    NSString *path = [[unifiedFilePathManager share] getCurrentUserDirectoryWithFolderName:nil fileName:@"TrainTool.plist"];
    NSArray* arr = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic in arr) {
        [self.instrumentArr addObject:[dic objectForKey:@"name"]];
    }
    NSString *path1 = [[unifiedFilePathManager share] getCurrentUserDirectoryWithFolderName:nil fileName:@"TrainPart.plist"];
    NSArray* arr1 = [NSArray arrayWithContentsOfFile:path1];
    for (NSDictionary *dic in arr1) {
        [self.partArr addObject:[dic objectForKey:@"name"]];
    }
    
    // 初始化设置训练部位
    [self setInitTrainingPart];

}
- (void)initComponent
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.typeSelectView];
    [self.typeSelectView addSubview:self.instrumentBtn];
    [self.typeSelectView addSubview:self.partBtn];
    [self.typeSelectView addSubview:self.difficultyBtn];
    [self.view addSubview:self.blackView];
    [self.view addSubview:self.instrumentTableView];
    [self.view addSubview:self.partTableView];
    [self.view addSubview:self.difficultyTableView];
    
}

//弹出inputView
- (void)showInputView:(BOOL)isShow masHight:(MASConstraint *)masHight dataListArray:(NSArray *)dataListArray button:(TrainingSelectBtn *)button
{
   
    masHight.offset = isShow ? 0 : dataListArray.count * 44;
    if (isShow) {
        [button setState:NO];
        [self.blackView setHidden:YES];
    }
    else{
        [button setState:YES];
        [self.blackView setHidden:NO];
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}
//隐藏inputView
- (void)hideInputView
{
    [self.blackView setHidden:YES];
    [self.selectedBtn setState:NO];
    self.isShow = !self.isShow;
    self.instrumentHeight.offset = 0;
    self.partHeight.offset = 0;
    self.difficultyHeight.offset = 0;
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];

}

// 初始化时设置锻炼部位
- (void)setInitTrainingPart {
    if ([self.partArr containsObject:self.trainingMuscle]) {
        NSInteger index = [self.partArr indexOfObject:self.trainingMuscle];
        self.partSelectedCellNum = index;
        [self.partBtn setMyTitel:self.partArr[index]];
        self.partString = [NSString stringWithFormat:@"%ld",index];
    }

}
- (void)startRequest
{
    self.page = self.page +1;
    TrainGetAllTrainListRequest *request = [[TrainGetAllTrainListRequest alloc]init];
    request.pageSize = ADDNUM;
    request.pageIndex = self.page;
    request.difficulty = [self.difficultyString isEqualToString:@"0"] ? @"" : self.difficultyString;
    request.equipmentId = [self.instrumentString isEqualToString:@"0"] ? @"" : self.instrumentString;
    request.bodyPort = [self.partString isEqualToString:@"0"] ? @"" : self.partString;
    [request requestWithDelegate:self];
    [self postLoading];
}


- (MASConstraint *)getMasHightWithTag:(selectType)tag
{
    MASConstraint *masHight;
    switch (tag) {
        case instrumentBtnTag:
            masHight = self.instrumentHeight;
            break;
        case partBtnTag:
            masHight = self.partHeight;
            break;
        case difficultyBtnTag:
            masHight = self.difficultyHeight;
            break;
            
        default:
            break;
    }
    return masHight;
}

- (NSArray *)getArrayWithTag:(selectType)tag
{
    NSArray *array;
    switch (tag) {
        case instrumentBtnTag:
            array = self.instrumentArr;
            break;
        case partBtnTag:
            array = self.partArr;
            break;
        case difficultyBtnTag:
            array = self.difficultyArr;
            break;
            
        default:
            
            break;
    }
    return array;
}

#pragma mark - event Response


- (void)selectClick:(TrainingSelectBtn *)button
{
    if (self.selectedBtn == nil) {
        self.selectedBtn = button;
    }
    
    if (self.selectedBtn.tag == button.tag) {
        //点击了自己
        [self showInputView:self.isShow masHight:[self getMasHightWithTag:self.selectedBtn.tag] dataListArray:[self getArrayWithTag:self.selectedBtn.tag] button:self.selectedBtn];
        self.isShow = !self.isShow;

    } else {
        //点击了其他按钮
        [self.selectedBtn setState:NO];
        [self getMasHightWithTag:self.selectedBtn.tag].offset = 0;
        [self showInputView:NO masHight:[self getMasHightWithTag:button.tag] dataListArray:[self getArrayWithTag:button.tag] button:button];
        self.selectedBtn = button;
        self.isShow = YES;
        
    }
}

- (void)addMoreClick
{
    [self startRequest];
    
}

#pragma mark - scrollView delegate

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (tableView.tag) {
        case elseTag:
            num = self.dataList.count;
            break;
        case instrumentBtnTag:
            num = self.instrumentArr.count;
            break;
        case partBtnTag:
            num = self.partArr.count;
            break;
        case difficultyBtnTag:
            num = self.difficultyArr.count;
            break;
        default:
            break;
    }
    return num;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        return 155;
    }
    else
    {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        static NSString *ID = @"myCell";
        TrainingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[TrainingTableViewCell alloc]initWithShowStrength:YES reuseIdentifier:ID];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [cell setMyData:self.dataList[indexPath.row]];
        return cell;
    }
    else
    {
        static NSString *ID = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"train_chosed"]]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        switch (tableView.tag) {
            case instrumentBtnTag:
                if (indexPath.row == self.instrumentSelectedCellNum) {
                    [cell.accessoryView setHidden:NO];
                }
                else
                {
                    [cell.accessoryView setHidden:YES];
                    
                }
                [cell.textLabel setText:self.instrumentArr[indexPath.row]];
                break;
            case partBtnTag:
                if (indexPath.row == self.partSelectedCellNum) {
                    [cell.accessoryView setHidden:NO];
                }
                else
                {
                    [cell.accessoryView setHidden:YES];
                    
                }

                [cell.textLabel setText:self.partArr[indexPath.row]];
                break;
            case difficultyBtnTag:
                if (indexPath.row == self.difficultySelectedCellNum) {
                    [cell.accessoryView setHidden:NO];
                }
                else
                {
                    [cell.accessoryView setHidden:YES];
                    
                }

                [cell.textLabel setText:self.difficultyArr[indexPath.row]];
                break;
            default:
                break;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == elseTag) {
        TrainingIntroduceViewController *VC = [[TrainingIntroduceViewController alloc]init];
        TrainGetTrainDataArrayModel *model = self.dataList[indexPath.row];
        VC.trainID = model.trainingId;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        switch (tableView.tag) {
            case instrumentBtnTag:
            {
                self.instrumentSelectedCellNum = indexPath.row;
                [self.instrumentBtn setMyTitel:self.instrumentArr[indexPath.row]];
                self.instrumentString = [NSString stringWithFormat:@"%ld",indexPath.row];
            }
                break;
            case partBtnTag:
            {
                self.partSelectedCellNum = indexPath.row;
                [self.partBtn setMyTitel:self.partArr[indexPath.row]];
                self.partString = [NSString stringWithFormat:@"%ld",indexPath.row];

            }
                break;
            case difficultyBtnTag:
            {
                self.difficultySelectedCellNum = indexPath.row;
                [self.difficultyBtn setMyTitel:self.difficultyArr[indexPath.row]];
                self.difficultyString = [NSString stringWithFormat:@"%ld",indexPath.row];
            }
                break;
                
            default:
                break;
        }
        
        [self startRequest];
        [self hideInputView];
        //更改AccessoryView的位置
        [tableView reloadData];
    }
    
}

#pragma mark - request Delegate

- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self.tableView.mj_footer endRefreshing];
    [self hideLoading];
    NSLog(@"请求失败");
}

-(void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    
    [self hideLoading];
    NSLog(@"请求成功");
    TrainGetAllTrainListResponse *result = (TrainGetAllTrainListResponse *)response;
    if (result.modelArr.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];

    }else
    {
        [self.tableView.mj_footer endRefreshing];
        [self.dataList addObjectsFromArray:result.modelArr];
        [self.tableView reloadData];
       
    }
    
}
#pragma mark - updateViewConstraints

- (void)updateViewConstraints
{
    [self.typeSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(height_49);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.typeSelectView.mas_bottom);
    }];
    
    [self.instrumentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeSelectView);
        make.top.equalTo(self.typeSelectView);
        make.bottom.equalTo(self.typeSelectView);
    }];
    
    [self.partBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.instrumentBtn);
        make.left.equalTo(self.instrumentBtn.mas_right);
        make.width.equalTo(self.instrumentBtn.mas_width);
    }];
    
    [self.difficultyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.instrumentBtn);
        make.left.equalTo(self.partBtn.mas_right);
        make.right.equalTo(self.typeSelectView);
        make.width.equalTo(self.instrumentBtn.mas_width);
    }];
    
    [self.blackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeSelectView.mas_bottom);
        make.bottom.right.left.equalTo(self.view);
    }];
    [self.instrumentTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeSelectView.mas_bottom);
        make.left.right.equalTo(self.view);
        self.instrumentHeight = make.height.mas_equalTo(0);
    }];

    [self.partTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeSelectView.mas_bottom);
        make.left.right.equalTo(self.view);
        self.partHeight = make.height.mas_equalTo(0);
    }];

    [self.difficultyTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeSelectView.mas_bottom);
        make.left.right.equalTo(self.view);
        self.difficultyHeight = make.height.mas_equalTo(0);
    }];

    
    [super updateViewConstraints];
}

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setTag:elseTag];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreClick)];
        [_tableView setTableFooterView:[UIView new]];
        
    }
    return _tableView;
}


- (UIView *)typeSelectView
{
    if (!_typeSelectView) {
        _typeSelectView = [[UIView alloc]init];
    }
    return _typeSelectView;
}

- (TrainingSelectBtn *)instrumentBtn
{
    if (!_instrumentBtn) {
        _instrumentBtn = [[TrainingSelectBtn alloc]initWithTitel:@"不限器械" tag:instrumentBtnTag];
        [_instrumentBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _instrumentBtn;
}


- (TrainingSelectBtn *)partBtn
{
    if (!_partBtn) {
        _partBtn = [[TrainingSelectBtn alloc]initWithTitel:@"不限部位" tag:partBtnTag];
        [_partBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _partBtn;
}

- (TrainingSelectBtn *)difficultyBtn
{
    if (!_difficultyBtn) {
        _difficultyBtn = [[TrainingSelectBtn alloc]initWithTitel:@"全部难度" tag:difficultyBtnTag];
        [_difficultyBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _difficultyBtn;
}


- (UITableView *)instrumentTableView
{
    if (!_instrumentTableView) {
        _instrumentTableView = [[UITableView alloc] init];
        [_instrumentTableView setDelegate:self];
        [_instrumentTableView setDataSource:self];
        [_instrumentTableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_instrumentTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_instrumentTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [_instrumentTableView setTag:instrumentBtnTag];
    }
    return _instrumentTableView;
}

- (UITableView *)partTableView
{
    if (!_partTableView) {
        _partTableView = [[UITableView alloc] init];
        [_partTableView setDelegate:self];
        [_partTableView setDataSource:self];
        [_partTableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_partTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_partTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [_partTableView setTag:partBtnTag];
    }
    return _partTableView;
}

- (UITableView *)difficultyTableView
{
    if (!_difficultyTableView) {
        _difficultyTableView = [[UITableView alloc] init];
        [_difficultyTableView setDelegate:self];
        [_difficultyTableView setDataSource:self];
        [_difficultyTableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_difficultyTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_difficultyTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [_difficultyTableView setTag:difficultyBtnTag];
    }
    return _difficultyTableView;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}

- (NSMutableArray *)instrumentArr
{
    if (!_instrumentArr) {
        _instrumentArr = [[NSMutableArray alloc]init];
    }
    return _instrumentArr;
}

- (NSMutableArray *)partArr
{
    if (!_partArr) {
        _partArr = [[NSMutableArray alloc]init];
    }
    return _partArr;
}

- (UIView *)blackView
{
    if (!_blackView) {
        _blackView = [[UIView alloc]init];
        [_blackView setBackgroundColor:[UIColor blackColor]];
        [_blackView setAlpha:0.5];
        [_blackView setHidden:YES];
        [_blackView addGestureRecognizer:self.tap];
    }
    return _blackView;
}

- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideInputView)];
    }
    return _tap;
}
@end
