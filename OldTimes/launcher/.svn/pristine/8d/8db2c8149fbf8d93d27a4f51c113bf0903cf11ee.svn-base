//
//  ATManagerClockController.m
//  Clock
//
//  Created by SimonMiao on 16/7/21.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATManagerClockController.h"
#import "ATManagerClockView.h"
#import "ATManagerClockAdapter.h"

#import "ATCommonCellModel.h"
#import "ATManagerClockTimeCellModel.h"

@interface ATManagerClockController () <ATTableViewAdapterDelegate>

@property (nonatomic, strong) ATManagerClockView    *managerView;
@property (nonatomic, strong) ATManagerClockAdapter *adapter;

@end

@implementation ATManagerClockController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"编辑考勤";
    
    self.managerView = [[ATManagerClockView alloc] initWithFrame:self.view.bounds];
    self.view = self.managerView;
    
    self.adapter = [[ATManagerClockAdapter alloc] init];
    self.adapter.adapterDelegate = self;
    [self.managerView setTableViewAdapter:self.adapter];
    
    [self loadDataSource];
}

- (void)loadDataSource {
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:0];
    ATEmptyCellModel *emptyModel = [[ATEmptyCellModel alloc] init];
    [dataSource addObject:emptyModel];
    
    NSArray *titleArr = @[@"上班时间",@"下班时间"];
    for (NSInteger i = 0; i < titleArr.count; i ++) {
        
        ATManagerClockTimeCellModel *model = [[ATManagerClockTimeCellModel alloc] init];
        model.titleStr = titleArr[i];
        model.timeStr = @"09:00";
        [dataSource addObject:model];
    }
    self.adapter.adapterArray = dataSource;
    [self.managerView refreshTableView];
}


#pragma mark - ATTableViewAdapterDelegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath
{
    if ([cellData isKindOfClass:[ATManagerClockTimeCellModel class]]) {
        //
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
