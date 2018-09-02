//
//  MultiAndSingleChooseViewController.m
//  launcher
//
//  Created by 马晓波 on 16/4/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MultiAndSingleChooseViewController.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface MultiAndSingleChooseViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, copy) multiAndSingleChooseCompletion completion;

@property (nonatomic, strong) NewApplyFormChooseModel *applyModel;

@end

@implementation MultiAndSingleChooseViewController

- (instancetype)initWithModel:(NewApplyFormChooseModel *)model {
    if (self = [super init]) {
        self.applyModel = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.applyModel.labelText;
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.applyModel.inputType == Form_inputType_multiChoose) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CONFIRM) style:UIBarButtonItemStylePlain target:self action:@selector(clickToSend)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)chooseCompltion:(multiAndSingleChooseCompletion)completion {
    self.completion = completion;
}

#pragma mark - Privite Methods
- (void)clickToSend {
    
    self.applyModel.try_inputDetail = nil;
    self.applyModel.try_inputDetail = [NSMutableArray array];
    
    NSMutableArray <NSIndexPath *>*selectedIndexPaths = [NSMutableArray arrayWithArray:self.tableview.indexPathsForSelectedRows];
    [selectedIndexPaths sortUsingComparator:^NSComparisonResult(NSIndexPath *obj1, NSIndexPath *obj2) {
        return obj1.row > obj2.row;
    }];
    
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        NSDictionary *dict = [self.applyModel chooseArray][indexPath.row];
        [self.applyModel.try_inputDetail addObject:dict[NewForm_value]];
    }
    
    !self.completion ?: self.completion();
    self.completion = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableviewdelegate/datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.applyModel chooseArray].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01; }

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.tintColor = [UIColor themeBlue];
        
        cell.multipleSelectionBackgroundView = [UIView new];
        cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dict = [self.applyModel chooseArray][indexPath.row];
//    NSString *text  = dict[NewForm_value];
//    if (text!= nil && ![text isEqualToString:@""] && self.applyModel.try_inputDetail != nil && [self.applyModel.try_inputDetail count]) {
//        for (NSString *str  in self.applyModel.try_inputDetail) {
//            if ([text isEqualToString:str]) {
//            }
//        }
//    }
    cell.textLabel.text = dict[NewForm_value];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.applyModel.inputType == Form_inputType_singleChoose) {
        [self clickToSend];
        return;
    }
}
#pragma mark - init
- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.backgroundColor = [UIColor grayBackground];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.allowsMultipleSelection = YES;
        _tableview.editing = YES;
    }
    return _tableview;
}

@end
