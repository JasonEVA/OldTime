//
//  MissionSelectProjectViewController.m
//  launcher
//
//  Created by William Zhang on 15/9/9.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionSelectProjectViewController.h"
#import "GetProjectListRequest.h"
#import <Masonry/Masonry.h>
#import "ProjectModel.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"

@interface MissionSelectProjectViewController () <UITableViewDataSource, UITableViewDelegate, BaseRequestDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *projectArray;

@property (nonatomic, copy) MissionSelectProjectBlock selectBlock;
@property (nonatomic, copy) MissionSelectProjectDismissBlock dismissBlock;

@end

@implementation MissionSelectProjectViewController

- (instancetype)initWithSelectProject:(MissionSelectProjectBlock)selectBlock {
    self = [super init];
    if (self) {
        self.selectBlock = selectBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self postLoading];
    GetProjectListRequest *projectListRequest = [[GetProjectListRequest alloc] initWithDelegate:self];
    [projectListRequest getNewList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[GetProjectListRequest class]]) {
        [self hideLoading];
        [self RecordToDiary:@"获取任务列表成功"];
        self.projectArray = [NSMutableArray arrayWithArray:[(id)response arrayProjects]];
        [self.tableView reloadData];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
    [self RecordToDiary:[NSString stringWithFormat:@"获取任务列表成功:%@",errorMessage]];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return [self.projectArray count];
}

// section＝0 numberOfRow ＝ 0时使用，改变了就删了
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 17.0;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    NSString *text = LOCAL(NONE);
    if (indexPath.section != 0) {
        ProjectModel *project = [self.projectArray objectAtIndex:indexPath.row];
        text = project.name;
    }
    
    [cell textLabel].text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBlock) {
        if (!indexPath.section) {
            self.selectBlock(nil);
        }
        else {
            ProjectModel *project = [self.projectArray objectAtIndex:indexPath.row];
            self.selectBlock(project);
        }
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor grayBackground];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

- (NSMutableArray *)projectArray {
    if (!_projectArray) {
        _projectArray = [NSMutableArray array];
    }
    return _projectArray;
}

@end
