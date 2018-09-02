//
//  MeAlertSetViewController.m
//  launcher
//
//  Created by TabLiu on 16/1/28.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MeAlertSetViewController.h"
#import "SystemSoundList.h"
#import "UnifiedUserInfoManager.h"
#import "MyDefine.h"

@interface MeAlertSetViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic) PlaySystemKind systemType;

@property (nonatomic,copy) changeAlertType  type;

@end

@implementation MeAlertSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self setTitle:LOCAL(ME_PROMPT_TYPE)];
    
    _systemType = (PlaySystemKind)[[UnifiedUserInfoManager share] getPlaySystemKindType];;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

- (void)changeAlertType:(changeAlertType)change
{
    _type = change;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = LOCAL(OPENNOTIFY);

       // cell.textLabel.text = @"仅声音";
            break;
         
        case 1:
            cell.textLabel.text = LOCAL(CLOSENOTIFY);

            //cell.textLabel.text = @"仅震动";
            break;
            
        case 2:
            //cell.textLabel.text = @"声音并震动";
            break;
            
        case 3:
            //cell.textLabel.text = @"不提醒";
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSInteger row = indexPath.row;
    row += 2;

    if (row == _systemType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    row += 2;
    
    if (_systemType == row) {
        return;
    }
    _systemType = (PlaySystemKind)row;
    [_tableView reloadData];
    [[UnifiedUserInfoManager share] setPlaySystemKindType:row];
    if (_type) {
        _type();
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
