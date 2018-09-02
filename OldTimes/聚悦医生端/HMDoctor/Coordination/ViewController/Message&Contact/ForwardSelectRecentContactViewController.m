//
//  ForwardSelectRecentContactViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ForwardSelectRecentContactViewController.h"
#import "ContactCellAdapter.h"
#import "CoordinationContactTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "IMApplicationConfigure.h"
#import "HMBaseNavigationViewController.h"
#import "SelectContactsFromAllContactsViewController.h"

@interface ForwardSelectRecentContactViewController ()<ATTableViewAdapterDelegate>
@property (nonatomic, strong)  UIButton  *button; // <##>
@property (nonatomic, strong)  UIButton *sendItem; // <##>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  ContactCellAdapter  *adapter; // <##>
@property (nonatomic, strong)  NSMutableArray  *dataSource; // <##>
@property (nonatomic, strong)  NSMutableArray  *selectedContacts; // <##>
@end

@implementation ForwardSelectRecentContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    [self.navigationItem setTitle:@"选择"];

    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelForward)];
    [self.navigationItem setLeftBarButtonItem:cancel];
    self.sendItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    [self.sendItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [self.sendItem setTitle:[NSString stringWithFormat:@"发送(%ld)",self.selectedContacts.count] forState:UIControlStateNormal];
    [self.sendItem addTarget:self action:@selector(forwardMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:self.sendItem];
    [self.navigationItem setRightBarButtonItem:right];

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
    // 获取人员列表
    // 去消息数据库刷新
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] getMessageListCompletion:^(NSArray<ContactDetailModel *> *array) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.adapter.adapterArray removeAllObjects];
        NSPredicate *predicateTemp = [NSPredicate predicateWithFormat:@"SELF._isApp = NO && NOT(SELF._target ENDSWITH[c] '@SYS')"];
        NSArray *arrayFiltered = [array filteredArrayUsingPredicate:predicateTemp];
        for (ContactDetailModel *model in arrayFiltered) {
            if (![model._tag isEqualToString:@"DOCTOR_USER_GROUP"]) { //剔除医患群
                ContactInfoModel *newModel = [[ContactInfoModel alloc] initWithContactDetailModel:model];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationInfoModel.relationName == %@", newModel.relationInfoModel.relationName];
                BOOL contain = [strongSelf.selectedContacts filteredArrayUsingPredicate:predicate].count > 0;
                if (contain) {
                    newModel.selected = YES;
                }
                [strongSelf.adapter.adapterArray addObject:newModel];
            }
        }
        [strongSelf.sendItem setTitle:[NSString stringWithFormat:@"发送(%ld)",strongSelf.selectedContacts.count] forState:UIControlStateNormal];
        [strongSelf.tableView reloadData];
    }];

}

#pragma mark - Event Response

// 取消发送
- (void)cancelForward {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 发送
- (void)forwardMessage {
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:self.selectedContacts.count];
    for (ContactInfoModel *model in self.selectedContacts) {
        [arrayTemp addObject:[model convertToContactDetailModel]];
    }
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] forwardMergeMessages:@[self.messageModel] title:@"" toUsers:arrayTemp isMerge:NO completion:^(BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success) {
            NSLog(@"-------------->forward success");
            [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [strongSelf at_postError:@"转发失败"];
        }
    }];
}

- (void)selectFromContacts {
    __weak typeof(self) weakSelf = self;
    SelectContactsFromAllContactsViewController *VC = [[SelectContactsFromAllContactsViewController alloc] initWithSelectedPeople:self.selectedContacts completion:^(NSArray *selectedPeople) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.selectedContacts removeAllObjects];
        [strongSelf.selectedContacts addObjectsFromArray:selectedPeople];
        
        [strongSelf configData];
    }];
    VC.messageModel = self.messageModel;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Delegate

#pragma mark - adapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    ContactInfoModel *model = (ContactInfoModel *)cellData;
    if (model.selected) {
        [self.selectedContacts addObject:model];
    }
    else {
        for (ContactInfoModel *newModel in self.selectedContacts) {
            if ([newModel.relationInfoModel.relationName isEqualToString:model.relationInfoModel.relationName]) {
                [self.selectedContacts removeObject:newModel];
                break;
            }
        }
    }
    [self.sendItem setTitle:[NSString stringWithFormat:@"发送(%ld)",self.selectedContacts.count] forState:UIControlStateNormal];

}

#pragma mark - Override

#pragma mark - Init

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[CoordinationContactTableViewCell class] forCellReuseIdentifier:[CoordinationContactTableViewCell at_identifier]];
        _tableView.tableHeaderView = self.button;
    }
    return _tableView;
}

- (ContactCellAdapter *)adapter {
    if (!_adapter) {
        _adapter = [ContactCellAdapter new];
        _adapter.adapterDelegate = self;
        _adapter.selectable = YES;
        _adapter.adapterArray = self.dataSource;
        _adapter.sectionTitles = @[@"最近聊天"];
    }
    return _adapter;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60)];
        [_button setTitle:@"从联系人选择" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(selectFromContacts) forControlEvents:UIControlEventTouchUpInside];
        [_button setBackgroundImage:[UIImage at_imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_button setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont font_30]];
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, 12.5, 0, 0);
    }
    return _button;
}

- (NSMutableArray *)selectedContacts {
    if (!_selectedContacts) {
        _selectedContacts = [NSMutableArray array];
    }
    return _selectedContacts;
}

@end
