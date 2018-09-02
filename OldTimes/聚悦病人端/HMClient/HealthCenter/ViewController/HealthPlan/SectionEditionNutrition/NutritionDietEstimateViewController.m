//
//  NutritionDietEstimateViewController.m
//  HMClient
//
//  Created by lkl on 2017/8/16.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NutritionDietEstimateViewController.h"
#import "NutritionDietEstimateLeftTableViewCell.h"
#import "NutritionDietEstimateRightTableViewCell.h"
#import "NutritionDietEstimateDataInfo.h"

@interface NutritionDietEstimateViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *foodData;
@end

@implementation NutritionDietEstimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"估算食物重量"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configElements];
}
#pragma mark - Interface Method

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置数据
- (void)configData {

    [[NutritionDietEstimateDataInfo getFoodsInfo] enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        NutritionDietEstimateDataModel *foodModel = [NutritionDietEstimateDataModel mj_objectWithKeyValues:dic];
        [self.dataArray addObject:foodModel];
    }];
}

// 设置约束
- (void)configConstraints {
    
    _selectIndex = 0;
    _isScrollDown = YES;
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.mas_equalTo(90 * kScreenScale);
    }];
    
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.view);
        make.left.equalTo(self.leftTableView.mas_right);
    }];
    
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - TableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_leftTableView == tableView){
        return 1;
    }
    else{
        return self.dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_leftTableView == tableView){
        return self.dataArray.count;
    }
    else{
        NutritionDietEstimateDataModel *model = self.dataArray[section];
        return [model.foodContent count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView){
        return 30;
    }
    return 0.00001f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_rightTableView == tableView) {
        NutritionDietEstimateDataModel *model = self.dataArray[section];
        return model.foodName;
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTableView == tableView){
        NutritionDietEstimateLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NutritionDietEstimateLeftTableViewCell at_identifier] forIndexPath:indexPath];
        NutritionDietEstimateDataModel *model = self.dataArray[indexPath.row];
        cell.name.text = model.foodName;
        return cell;
    }
    else{
        NutritionDietEstimateRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NutritionDietEstimateRightTableViewCell at_identifier] forIndexPath:indexPath];
        NutritionDietEstimateDataModel *model = self.dataArray[indexPath.section];
        NutritionFoodContentModel *foodModel = model.foodContent[indexPath.row];
        [cell setNutritionDietEstimateDataInfo:foodModel];
        return cell;
    }
}

// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor mainThemeColor];
    header.textLabel.font = [UIFont font_28];
    header.contentView.backgroundColor = [UIColor commonBackgroundColor];
    
    // 当前的tableView是RightTableView，RightTableView滚动的方向向上，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView) && !_isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section];
    }
}

// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向下，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView) && _isScrollDown && _rightTableView.dragging)
    {
        [self selectRowAtIndexPath:section + 1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        _selectIndex = indexPath.row;
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

// 当拖动右边TableView的时候，处理左边TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - UISrcollViewDelegate
// 标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;
    
    UITableView *tableView = (UITableView *) scrollView;
    if (_rightTableView == tableView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

#pragma mark - Init
- (UITableView *)leftTableView{
    if (!_leftTableView){
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 80;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor clearColor];
        [_leftTableView registerClass:[NutritionDietEstimateLeftTableViewCell class] forCellReuseIdentifier:[NutritionDietEstimateLeftTableViewCell at_identifier]];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{
    if (!_rightTableView){
        _rightTableView = [[UITableView alloc] init];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 180 * kScreenScale;
        _rightTableView.showsVerticalScrollIndicator = NO;
        [_rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_rightTableView registerClass:[NutritionDietEstimateRightTableViewCell class] forCellReuseIdentifier:[NutritionDietEstimateRightTableViewCell at_identifier]];
    }
    return _rightTableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)foodData{
    if (!_foodData) {
        _foodData = [[NSMutableArray alloc] init];
    }
    return _foodData;
}
@end
