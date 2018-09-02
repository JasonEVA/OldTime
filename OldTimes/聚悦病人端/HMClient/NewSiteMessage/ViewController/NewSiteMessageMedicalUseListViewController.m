//
//  NewSiteMessageMedicalUseListViewController.m
//  HMClient
//
//  Created by jasonwang on 2016/11/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageMedicalUseListViewController.h"
#import "NewSiteMessageMedicalListTableViewCell.h"
#import "ATModuleInteractor+NewSiteMessage.h"
#import "NewSiteMessageDrugModel.h"
@interface NewSiteMessageMedicalUseListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NewSiteMessageMedicalUseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用药详情";
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"myCell";
    NewSiteMessageDrugModel *model = self.dataList[indexPath.row];
    NewSiteMessageMedicalListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NewSiteMessageMedicalListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    [cell fillDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return;//暂时不可点击
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [[ATModuleInteractor sharedInstance] gotoMedicalDetailVC];
}
#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        _tableView.rowHeight = 75;
    }
    return _tableView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
