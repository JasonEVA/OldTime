//
//  HMCheckItemView.m
//  HMDoctor
//
//  Created by lkl on 2017/3/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMCheckItemView.h"

@interface HMCheckItemView ()<TaskObserver,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *admissionId;
@property (nonatomic, strong) NSArray *dateList;

@end

@implementation HMCheckItemView

- (instancetype)initWithadmissionId:(NSString *)admissionId{
    self = [super init];
    if (self) {
        self.admissionId = admissionId;
        
        UIControl* closeControl = [[UIControl alloc]init];
        [self addSubview:closeControl];
        [closeControl setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
        [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [closeControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self requestDataList];
        [self createTableView];
    }
    return self;
}

- (void)createTableView
{
    if (!_dateList)
    {
        return;
    }
    float tableheight = _dateList.count * 44;
    if (tableheight > ScreenWidth / 2)
    {
        tableheight = ScreenWidth / 2;
    }
    
    [self addSubview:self.tableView];
    [_tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        //make.top.equalTo(self).offset(39);
        //make.right.equalTo(self).offset(-12);
        make.size.mas_equalTo(CGSizeMake(200 * kScreenScale, tableheight));
    }];
}

- (void)requestDataList
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.admissionId forKey:@"admissionId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"getCheckItemTypeTask" taskParam:dic TaskObserver:self];
}

- (void) closeControlClicked:(id) sender
{
    [self removeFromSuperview];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dateList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont font_28]];
        [cell.textLabel setTextColor:[UIColor mainThemeColor]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    CheckItemTypeModel *model = [_dateList objectAtIndex:indexPath.row];
    [cell.textLabel setText:model.itemTypeName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CheckItemTypeModel *model = [_dateList objectAtIndex:indexPath.row];
    if (self.itemSelectBlock) {
        self.itemSelectBlock(model);
    }
    [self removeFromSuperview];
}

#pragma mark - init UI

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView.layer setBorderColor:[[UIColor mainThemeColor] CGColor]];
        [_tableView.layer setBorderWidth:1.0f];
        [_tableView setSeparatorColor:[UIColor mainThemeColor]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"getCheckItemTypeTask"])
    {
        if ([taskResult isKindOfClass:[NSArray class]]) {
            _dateList = (NSArray *)taskResult;
            [self createTableView];
        }
        
    }
}

@end
