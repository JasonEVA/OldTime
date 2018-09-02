//
//  MeNotificationViewController.m
//  launcher
//
//  Created by Kyle He on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeNotificationViewController.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"


static NSString * ID = @"Me_NotificationCell";

typedef NS_ENUM(NSInteger, NUMOFCELL) {
    kScheduleCell = 0,
    kMissionCell,
    kApplyCell
};

@interface MeNotificationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView  *tableView;
//存放三个高switch
@property(nonatomic, strong) NSMutableArray  *switchArr;

@property(nonatomic, copy) selectedIndex indexBlock;

@end

@implementation MeNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(ME_MESSAGE_NOTIFICATION);
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    for (NSNumber *index in self.indexArr)
    {
        NSInteger i = [index integerValue];
        UISwitch*tempSwitch = self.switchArr[i];
        tempSwitch.on = YES;
    }
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NSInteger currentIndex = indexPath.row;
    switch (currentIndex){
        case kScheduleCell:
            cell.textLabel.text = LOCAL(Application_Calendar);
            break;
        case kMissionCell:
            cell.textLabel.text = LOCAL(Application_Mission);
            break;
        case kApplyCell:
            cell.textLabel.text = LOCAL(Application_Apply);
            break;
        default:
            break;
    }
    
    cell.textLabel.textColor = [UIColor mtc_colorWithHex:0x707070];
    cell.accessoryView = self.switchArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UISwitch *currentSwitch = (UISwitch *)cell.accessoryView;
    currentSwitch.on = !currentSwitch.on;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}
#pragma mark - InterfaceMethod
- (void)getSelectedIndexWithBlock:(selectedIndex)index
{
    self.indexBlock = index;
}

#pragma mark - PrivateMehod
- (void)switchActions
{
    NSMutableArray *tempArr = [NSMutableArray array];
    NSInteger index = 0;
    for (UISwitch* tempSwitch in self.switchArr)
    {
        if (tempSwitch.on) {
            
            [tempArr addObject:@(index)];
        }
        index ++;
    }
    if (self.indexBlock)
    {
        self.indexBlock(tempArr);
    }
}

#pragma mark - SetterAndGetter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)switchArr
{
    if (!_switchArr)
    {
        _switchArr = [[NSMutableArray alloc] init];
        for (int index = 0; index < 3; index ++)
        {
            UISwitch *selectSwitch = [[UISwitch alloc] init];
            selectSwitch.onTintColor = [UIColor themeBlue];
            [selectSwitch addTarget:self action:@selector(switchActions) forControlEvents:UIControlEventValueChanged];
            [_switchArr addObject:selectSwitch];
        }
    }
    return _switchArr;
}
@end
