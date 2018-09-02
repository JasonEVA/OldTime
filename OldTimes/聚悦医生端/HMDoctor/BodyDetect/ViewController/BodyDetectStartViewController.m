//
//  BodyDetectStartViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/8/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "BodyDetectStartViewController.h"
#import "BodyDetectDevicesInfo.h"
#import "BloodOxygenDetectStartViewController.h"
#import "HMBaseNavigationViewController.h"
#import "BodyDetetBaseViewController.h"

@interface BodyDetectStartViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *detectItems;
@property (nonatomic, copy) NSString *userId;
@end

@implementation BodyDetectStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"添加监测数据"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]]) {
        self.userId = (NSString *)self.paramObject;
    }
    
    [self configElements];
}

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    
    // 设置数据
    [self getTableDataList];
    
    // 设置约束
    [self configConstraints];
}

//获取数据列表
- (void)getTableDataList
{
    _detectItems = [NSMutableArray array];
    [[BodyDetectDevicesInfo getDevicesInfo] enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        DeviceDetectRecord *deviceItem = [DeviceDetectRecord mj_objectWithKeyValues:dic];
        [_detectItems addObject:deviceItem];
    }];
}

// 设置约束
- (void)configConstraints {
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _detectItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell at_identifier]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    DeviceDetectRecord *deviceItem = [_detectItems objectAtIndex:indexPath.row];
    [cell.textLabel setText:deviceItem.kpiName];
    [cell.imageView setImage:[UIImage imageNamed:deviceItem.deviceImg]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceDetectRecord *deviceItem = [_detectItems objectAtIndex:indexPath.row];
    NSString *kpiCode = deviceItem.kpiCode;
    
    if (kStringIsEmpty(self.userId)) {
        return;
    }
    
    NSString *controllerName = nil;
    if ([kpiCode isEqualToString:@"XY"]){
        //测血压
        controllerName = @"BodyPressureDetectStartViewController";
    }
    else if([kpiCode isEqualToString:@"XD"]){
        //测心电
        controllerName = @"ECGDetectStartViewController";
    }
    else if([kpiCode isEqualToString:@"XL"]){
        //测心率
        controllerName = @"HeartRateDetectStartViewController";
    }
    else if([kpiCode isEqualToString:@"OXY"]){
        //测血氧
        controllerName = @"BloodOxygenDetectStartViewController";
    }
    else if([kpiCode isEqualToString:@"XT"]){
        //测血糖
        controllerName = @"BloodSugarDetectStartViewController";
    }
    else{
        controllerName = @"";
    }
    BodyDetetBaseViewController *detectBaseVC = [[NSClassFromString(controllerName) alloc] init];
    detectBaseVC.userId = self.userId;
    HMBaseNavigationViewController *baseNav = [[HMBaseNavigationViewController alloc] initWithRootViewController:detectBaseVC];
    [self presentViewController:baseNav animated:YES completion:nil];
}

#pragma mark -- init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell at_identifier]];
    }
    return _tableView;
}

@end
