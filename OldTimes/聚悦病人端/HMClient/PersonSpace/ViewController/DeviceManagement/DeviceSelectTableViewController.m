//
//  DeviceSelectTableViewController.m
//  HMClient
//
//  Created by lkl on 2017/4/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "DeviceSelectTableViewController.h"
#import "PersonDevicesItem.h"
#import "PersonDeviceManagerTableViewCell.h"

@interface DeviceSelectDeviceViewController ()
{
    DeviceSelectTableViewController* tvDeviceSelect;
}
@property (nonatomic, strong) PersonDevicesItem* deviceItem;
@end

@implementation DeviceSelectDeviceViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[PersonDevicesItem class]]) {
        self.deviceItem = self.paramObject;
    }
    
    if ([_deviceItem.type isEqualToString:@"XY"]) {
        [self.navigationItem setTitle:@"血压计"];
    }
    else if ([_deviceItem.type isEqualToString:@"XT"]){
        [self.navigationItem setTitle:@"血糖仪"];
    }
    else if ([_deviceItem.type isEqualToString:@"XD"]){
        [self.navigationItem setTitle:@"心电仪"];
    }
    else if ([_deviceItem.type isEqualToString:@"OXY"]){
        [self.navigationItem setTitle:@"血氧仪"];
    }
    else if ([_deviceItem.type isEqualToString:@"XZ"]){
        [self.navigationItem setTitle:@"血脂计"];
    }
    else if ([_deviceItem.type isEqualToString:@"SH"]){
        [self.navigationItem setTitle:@"手环"];
    }
    else{
        [self.navigationItem setTitle:nil];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!tvDeviceSelect)
    {
        tvDeviceSelect = [[DeviceSelectTableViewController alloc] initWithStyle:UITableViewStylePlain];
        tvDeviceSelect.deviceItem = self.deviceItem;
        [self addChildViewController:tvDeviceSelect];
        [tvDeviceSelect.tableView setFrame:self.view.bounds];
        [self.view addSubview:tvDeviceSelect.tableView];
    }
}
@end


@interface DeviceSelectTableViewController ()
{
    PersonDevicesDetail *detailItem;
}
@end

@implementation DeviceSelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (![_deviceItem.type isEqualToString:@"SH"]){

        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        if([userdefault objectForKey:[NSString stringWithFormat:@"%@",_deviceItem.type]])
        {
            detailItem = (PersonDevicesDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:[userdefault objectForKey:[NSString stringWithFormat:@"%@",_deviceItem.type]]];
            
            PersonSelectDefaultDeviceTableViewCell *cell = (PersonSelectDefaultDeviceTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:detailItem.isDefaultNum inSection:0]];
            
            [cell setSelectDeviceStatus];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deviceItem.devices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45 * kScreenScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonDevicesDetail *deviceDetail = [_deviceItem.devices objectAtIndex:indexPath.row];
    
    if ([_deviceItem.type isEqualToString:@"SH"]){
        //手环设备
        
        static NSString *identifier = @"PersonDeviceManagerTableViewCell";
        PersonDeviceManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[PersonDeviceManagerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [cell setBraceletDeviceImage:deviceDetail.deviceIcon deviceName:deviceDetail.deviceName selectStatusStr:@"立即绑定"];
        return cell;

    }
    else{
        static NSString *identifier = @"PersonSelectDefaultDeviceTableViewCell";
        PersonSelectDefaultDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[PersonSelectDefaultDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        [cell setDeviceImage:deviceDetail.deviceIcon deviceName:deviceDetail.deviceName];
        
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_deviceItem.type isEqualToString:@"SH"]){
        //手环设备
        [HMViewControllerManager createViewControllerWithControllerName:@"BraceletScanViewController" ControllerObject:nil];
    }
    else{
        //其他监测项
        PersonSelectDefaultDeviceTableViewCell *cell = (PersonSelectDefaultDeviceTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        //[cell setSelectDeviceStatus];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        if([userDefault objectForKey:[NSString stringWithFormat:@"%@",_deviceItem.type]])
        {
            PersonSelectDefaultDeviceTableViewCell *selectCell = (PersonSelectDefaultDeviceTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:detailItem.isDefaultNum inSection:0]];
            if (detailItem.isDefaultNum != indexPath.row)
            {
                [cell setSelectDeviceStatus];
                [selectCell setDidDeselectDeviceStatus];
                
                detailItem = [_deviceItem.devices objectAtIndex:indexPath.row];
                detailItem.isDefaultNum = indexPath.row;
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:detailItem];
                [userDefault setObject:data forKey:[NSString stringWithFormat:@"%@",_deviceItem.type]];
                [userDefault synchronize];
            }
            else{
                
                [selectCell setDidDeselectDeviceStatus];
                [userDefault removeObjectForKey:[NSString stringWithFormat:@"%@",_deviceItem.type]];
                [userDefault synchronize];
            }
            
        }else{
            [cell setSelectDeviceStatus];
            
            detailItem = [_deviceItem.devices objectAtIndex:indexPath.row];
            detailItem.isDefaultNum = indexPath.row;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:detailItem];
            [userDefault setObject:data forKey:[NSString stringWithFormat:@"%@",_deviceItem.type]];
            [userDefault synchronize];
        }
    }

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_deviceItem.type isEqualToString:@"SH"]){
        
        PersonSelectDefaultDeviceTableViewCell *cell = (PersonSelectDefaultDeviceTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        [cell setDidDeselectDeviceStatus];
    }
}

@end
