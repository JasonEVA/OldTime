//
//  DeviceManagerViewController.m
//  HMClient
//
//  Created by lkl on 2017/10/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "DeviceManagerViewController.h"
#import "PersonDevicesInfo.h"
#import "PersonDevicesItem.h"
#import "PersonDeviceManagerTableViewCell.h"
#import "DeviceSelectTableViewController.h"

@interface DeviceManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation DeviceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"我的设备"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getTableDataList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

//获取数据列表
- (void)getTableDataList
{
    _dataArray = [NSMutableArray array];
    [[PersonDevicesInfo getDevicesInfo] enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        PersonDevicesItem *deviceItem = [PersonDevicesItem mj_objectWithKeyValues:dic];
        [_dataArray addObject:deviceItem];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45 * kScreenScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PersonDeviceManagerTableViewCell";
    PersonDeviceManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[PersonDeviceManagerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    PersonDevicesItem *devicesItem = [_dataArray objectAtIndex:indexPath.row];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    
    if ([userdefault objectForKey:[NSString stringWithFormat:@"%@",devicesItem.type]])
    {
        PersonDevicesDetail *deviceDetail = (PersonDevicesDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:[userdefault objectForKey:[NSString stringWithFormat:@"%@",devicesItem.type]]];
        [cell setDeviceImage:deviceDetail.deviceIcon deviceName:[NSString stringWithFormat:@"%@%@",devicesItem.typeName,deviceDetail.deviceName]];
    }
    else{
        
        [cell setDeviceImage:devicesItem.defaultIcon deviceName:devicesItem.defaultName];
        [cell setdeviceSelectStatus:NO];
        //可选：至少有两种设备
        if (devicesItem.devices.count > 0) {
            [cell setdeviceSelectStatus:YES];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果点击的手环，看看是否已绑定，绑定的话直接跳转手环界面
    PersonDevicesItem *deviceItem = [_dataArray objectAtIndex:indexPath.row];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([deviceItem.type isEqualToString:@"SH"] && [userdefault objectForKey:@"SH"]) {
        
        [HMViewControllerManager createViewControllerWithControllerName:@"BraceletConnectedViewController" ControllerObject:nil];
        return;
    }
    
    if (deviceItem.devices.count == 0){
        return;
    }
    
    [HMViewControllerManager createViewControllerWithControllerName:@"DeviceSelectDeviceViewController" ControllerObject:deviceItem];
}


#pragma mark - init
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setBackgroundColor:[UIColor commonBackgroundColor]];
        [_tableView setSeparatorColor:[UIColor colorWithHexString:@"E2E2E2"]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

@end
