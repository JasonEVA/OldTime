//
//  DetectManageSelectViewController.m
//  HMClient
//
//  Created by lkl on 2017/4/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "DetectManageSelectViewController.h"
#import "PersonDevicesItem.h"
#import "PersonDevicesInfo.h"

@interface DetectManageSelectViewController ()<UITableViewDataSource,UITableViewDelegate,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) BOOL isDefault;
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
    [[PersonDevicesInfo getDevicesInfo] enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [footerView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"select_m"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    
    UILabel *lbcontent = [[UILabel alloc] init];
    [lbcontent setText:@"设为默认设备"];
    [lbcontent setFont:[UIFont font_24]];
    [lbcontent setTextColor:[UIColor colorWithHexString:@"666666"]];
    [footerView addSubview:lbcontent];
    
    [lbcontent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footerView);
        make.centerX.equalTo(footerView).offset(10);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbcontent.mas_left).with.offset(-22);
        make.centerY.mas_equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    //如果是血压，选择那种设备直接保存
    if ([self.deviceType isEqualToString:@"XY"]){
        [button setBackgroundImage:[UIImage imageNamed:@"select_s"] forState:UIControlStateNormal];
        [button setSelected:YES];
        _isDefault = YES;
    }
    return footerView;
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
    if (_isDefault)
    {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        deviceDetail.isDefaultNum = indexPath.row;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deviceDetail];
        [userdefault setObject:data forKey:[NSString stringWithFormat:@"%@",_deviceItem.type]];
        [userdefault synchronize];
    }
    
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
    float tableheight = _deviceItem.devices.count * 50 + 60;
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
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(tableheight);
        
    }];
}

- (void)buttonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (!sender.selected)
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"select_m"] forState:UIControlStateNormal];
        _isDefault = NO;
    }else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"select_s"] forState:UIControlStateNormal];
        _isDefault = YES;
    }
}

#pragma mark -- UI init
- (UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setScrollEnabled:NO];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
}

@end
