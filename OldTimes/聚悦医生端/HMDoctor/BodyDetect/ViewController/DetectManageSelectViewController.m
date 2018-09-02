//
//  DetectManageSelectViewController.m
//  HMClient
//
//  Created by lkl on 2017/4/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "DetectManageSelectViewController.h"
#import "PersonDevicesItem.h"
#import "BodyDetectDevicesInfo.h"

@interface DetectManageSelectViewController ()<UITableViewDataSource,UITableViewDelegate,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PersonDevicesItem *deviceItem;

@end

@implementation DetectManageSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9]];
    UIControl* closeControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:closeControl];
    //[closeControl addTarget:self action:@selector(closeControlClicked) forControlEvents:UIControlEventTouchUpInside];
}

//获取数据列表
- (void)getTableDataList
{
    NSMutableArray *dataArray = [NSMutableArray array];
    [[BodyDetectDevicesInfo getDevicesDetailInfo] enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        PersonDevicesItem *deviceItem = [PersonDevicesItem mj_objectWithKeyValues:dic];
        [dataArray addObject:deviceItem];
    }];
    
    if ([self.deviceType isEqualToString:@"XY"]){
        _deviceItem = [dataArray objectAtIndex:0];
    }
    if ([self.deviceType isEqualToString:@"XT"]){
        _deviceItem = [dataArray objectAtIndex:1];
    }
    if ([self.deviceType isEqualToString:@"XD"]){
        _deviceItem = [dataArray objectAtIndex:2];
    }
}

- (void) closeControlClicked
{
    if (_selectblock)
    {
        _selectblock(nil);
    }
    [self closeTestTimeView];
}

- (void) closeTestTimeView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - tableViewDatasouceAndDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deviceItem.devices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbtitle = [[UILabel alloc] init];
    if ([self.deviceType isEqualToString:@"XY"]){
        [lbtitle setText:@"请选择血压计"];
    }
    if ([self.deviceType isEqualToString:@"XT"]){
        [lbtitle setText:@"请选择血糖仪"];
    }
    if ([self.deviceType isEqualToString:@"XD"]){
        [lbtitle setText:@"请选择心电仪"];
    }
    [lbtitle setFont:[UIFont font_26]];
    [lbtitle setTextColor:[UIColor colorWithHexString:@"8f8f8f"]];
    [headerView addSubview:lbtitle];
    
    [lbtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(headerView);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SelectTestDeviceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont font_28]];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"535353"]];
    }
    
    PersonDevicesDetail *deviceDetail = [_deviceItem.devices objectAtIndex:indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:deviceDetail.deviceIcon]];
    [cell.textLabel setText:deviceDetail.deviceName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    PersonDevicesDetail *deviceDetail = [_deviceItem.devices objectAtIndex:indexPath.row];
    if (_selectblock)
    {
        _selectblock(deviceDetail.deviceCode);
    }
    
    [self closeTestTimeView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}

+ (DetectManageSelectViewController *) createWithParentViewController:(UIViewController*) parentviewcontroller deviceType:(NSString *)deviceType selectblock:(TestDeviceSelectBlock)block
{
    if (!parentviewcontroller)
    {
        return nil;
    }
    
    DetectManageSelectViewController *vctestdevice = [[DetectManageSelectViewController alloc]initWithNibName:nil bundle:nil];
    [parentviewcontroller addChildViewController:vctestdevice];
    [vctestdevice.view setFrame:parentviewcontroller.view.bounds];
    [parentviewcontroller.view addSubview:vctestdevice.view];
    
    vctestdevice.deviceType = deviceType;
    
    [vctestdevice createDeviceSelectTableView];
    
    [vctestdevice setSelectblock:block];
    
    return vctestdevice;
}

- (void) createDeviceSelectTableView
{
    //获取数据
    [self getTableDataList];
    
    if (!_deviceItem.devices)
    {
        return;
    }
    float tableheight = _deviceItem.devices.count * 50 + 30;
    if (tableheight > self.view.height - 50)
    {
        tableheight = self.view.height - 50;
    }
    
    [self.view addSubview:self.tableView];
    [_tableView.layer setCornerRadius:10.0f];
    [_tableView.layer setMasksToBounds:YES];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(-50);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(tableheight);
        make.width.mas_equalTo(kScreenWidth - 60);
    }];
}

#pragma mark -- UI init
- (UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setScrollEnabled:NO];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
}

@end
