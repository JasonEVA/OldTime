//
//  NewFriendRequestViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewFriendRequestViewController.h"
#import "NewFriendAdapter.h"
#import "ContactDoctorInfoTableViewCell.h"
#import "DoctorContactDetailModel.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "IMApplicationConfigure.h"

@interface NewFriendRequestViewController ()<ATTableViewAdapterDelegate>

@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  NewFriendAdapter  *adapter; // <##>


@end

@implementation NewFriendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"新朋友"];
    [self configElements];
    [self configData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 设置已读
    [[MessageManager share] sendReadedRequestWithUid:self.target messages:@[]];
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

// 设置约束
- (void)configConstraints {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

// 设置数据
- (void)configData {
    //获取好友申请列表
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] loadServerRelationValidateListCompletion:^(NSArray<MessageRelationValidateModel *> *validlist, BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.adapter.adapterArray = [NSMutableArray arrayWithArray:validlist];
        [strongSelf.tableView reloadData];
    }];
}


#pragma mark - Event Response

#pragma mark - Delegate


#pragma mark - Adapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
}

#pragma mark - Override

#pragma mark - Init


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.allowsSelection = NO;
        _tableView.rowHeight = 90;
        [_tableView registerClass:[ContactDoctorInfoTableViewCell class] forCellReuseIdentifier:[ContactDoctorInfoTableViewCell at_identifier]];
    }
    return _tableView;
}

- (NewFriendAdapter *)adapter {
    if (!_adapter) {
        _adapter = [NewFriendAdapter new];
//        _adapter.adapterArray = [@[[DoctorContactDetailModel new],[DoctorContactDetailModel new]] mutableCopy];
        _adapter.adapterDelegate = self;
    }
    return _adapter;
}

@end
