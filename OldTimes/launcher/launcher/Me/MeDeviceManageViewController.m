//
//  MeDeviceManageViewController.m
//  launcher
//
//  Created by Kyle He on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeDeviceManageViewController.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"

static NSString *ID = @"Me_DeviceManager";
typedef NS_ENUM(NSInteger, NUMOFCELL) {
    kMobileVersionCell = 0,
    kChormeVerisonCell
};
@interface MeDeviceManageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView  *tabelview;

@property(nonatomic, copy) quitActionBlock quiteBlock;

@end

@implementation MeDeviceManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(ME_DEVISE_MANAGE);
    [self.view addSubview:self.tabelview];
    [self.tabelview registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    switch (indexPath.row) {
        case kMobileVersionCell:
        {
            cell.textLabel.text = @"iPhone6s";
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
            lbl.textColor = [UIColor themeBlue];
            lbl.text = @"正在使用";
            lbl.textAlignment = NSTextAlignmentRight;
            cell.accessoryView = lbl;
            break;
        }
        case kChormeVerisonCell:
        {
            cell.textLabel.text = @"Chorme 32.0.1.28";
            UIButton *quiteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            [quiteBtn setImage:[UIImage imageNamed:@"Me_quit"] forState:UIControlStateNormal];
            [quiteBtn addTarget:self action:@selector(quiteAction) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = quiteBtn;
            break;
        }
        default:
            break;
    }
    cell.textLabel.textColor = [UIColor mtc_colorWithHex:0x707070];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 215.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 217)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 115,90)];
    imgView.image = [UIImage imageNamed:@"Me_img"];
    imgView.center = contentView.center;
    [contentView addSubview:imgView];
    return contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - InterfaceMethod
- (void)quiteActionsWithBlock:(quitActionBlock)quit
{
    self.quiteBlock = quit;
}

#pragma mark - EventRespond
- (void)quiteAction
{
    if (self.quiteBlock)
    {
        self.quiteBlock();
    }
}

#pragma mark - SetterAndGetter
- (UITableView *)tabelview
{
    if (!_tabelview)
    {
        _tabelview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tabelview.delegate = self;
        _tabelview.dataSource = self;
    }
   return  _tabelview;
}
@end
