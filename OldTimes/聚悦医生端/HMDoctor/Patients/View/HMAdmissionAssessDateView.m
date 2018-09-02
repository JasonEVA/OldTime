//
//  HMAdmissionAssessDateView.m
//  HMDoctor
//
//  Created by lkl on 2017/3/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMAdmissionAssessDateView.h"

@interface HMAdmissionAssessDateView ()<TaskObserver,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) NSArray *dateList;

@end

@implementation HMAdmissionAssessDateView

- (instancetype)initWithUserID:(NSString *)userID dateList:(NSArray *)dateList{
    self = [super init];
    if (self) {
        _userId = userID;
        self.dateList = dateList;
        
        UIControl* closeControl = [[UIControl alloc]init];
        [self addSubview:closeControl];
        [closeControl setBackgroundColor:[UIColor clearColor]];
        [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [closeControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        //[self requestDataList];
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
    
    //    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time_box"]];
    //    [_tableView setBackgroundView:bgImageView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(self).offset(60);
        make.size.mas_equalTo(CGSizeMake(120, tableheight));
    }];
}

//- (void)requestDataList
//{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:self.userId forKey:@"userId"];
//    
//    [[TaskManager shareInstance] createTaskWithTaskName:@"getAdmissionAssessDateListTask" taskParam:dic TaskObserver:self];
//}

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
    }
    HMAdmissionAssessDateListModel *dateList = [_dateList objectAtIndex:indexPath.row];
    [cell.textLabel setText:dateList.CREATE_DATE];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    HMAdmissionAssessDateListModel *dateList = [_dateList objectAtIndex:indexPath.row];
    if (self.dateSelectBlock) {
        self.dateSelectBlock(dateList);
    }
    [self removeFromSuperview];
}

#pragma mark - init UI

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

//#pragma mark - TaskObserver
//- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
//{
//    if (StepError_None != taskError)
//    {
//        [self showAlertMessage:errorMessage];
//        return;
//    }
//}
//
//- (void) task:(NSString *)taskId Result:(id) taskResult
//{
//    if (!taskId || 0 == taskId.length)
//    {
//        return;
//    }
//    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
//    if (!taskname || 0 == taskname.length)
//    {
//        return;
//    }
//    
//    if ([taskname isEqualToString:@"getAdmissionAssessDateListTask"])
//    {
//        if ([taskResult isKindOfClass:[NSArray class]]) {
//            _dateList = (NSArray *)taskResult;
//            [self createTableView];
//        }
//
//    }
//}

@end
