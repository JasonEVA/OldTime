//
//  NewMissionSelectProjectViewController.m
//  launcher
//
//  Created by jasonwang on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionSelectProjectViewController.h"
#import "NewGetProjectListRequest.h"
#import <Masonry/Masonry.h>
#import "ProjectModel.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"

@interface NewMissionSelectProjectViewController () <UITableViewDataSource, UITableViewDelegate, BaseRequestDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *projectArray;

@property (nonatomic, copy) NewMissionSelectProjectBlock selectBlock;
@property (nonatomic, copy) NewMissionSelectProjectDismissBlock dismissBlock;

@end

@implementation NewMissionSelectProjectViewController

- (instancetype)initWithSelectProject:(NewMissionSelectProjectBlock)selectBlock {
    self = [super init];
    if (self) {
        self.selectBlock = selectBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(MISSION_SELECTPROJECT);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self postLoading];
    NewGetProjectListRequest *projectListRequest = [[NewGetProjectListRequest alloc] initWithDelegate:self];
    [projectListRequest getNewList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[NewGetProjectListRequest class]]) {
        [self hideLoading];
        [self RecordToDiary:@"获取任务列表成功"];
        self.projectArray = [NSMutableArray arrayWithArray:[(id)response dataArray]];
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
    
    return [self.projectArray count] + 1;
}

// section＝0 numberOfRow ＝ 0时使用，改变了就删了
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return section ? : 15.0;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.001;}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    NSString *text = LOCAL(NONE);
    if (indexPath.section != 0) {
        if (indexPath.row != 0) {
            ProjectModel *project = [self.projectArray objectAtIndex:indexPath.row - 1];
            text = project.name;
            if (self.selectedProjectShowID.length) {
                if ([self.selectedProjectShowID isEqualToString:project.showId]) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }
        } else {
            if (!self.selectedProjectShowID.length) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }
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
            if (indexPath.row != 0) {
                ProjectModel *project = [self.projectArray objectAtIndex:indexPath.row - 1];
                self.selectBlock(project);
            }
            else {
                self.selectBlock(nil);
            }
            
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

