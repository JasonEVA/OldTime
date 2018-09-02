//
//  MeLanguageViewController.m
//  launcher
//
//  Created by Kyle He on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeLanguageViewController.h"
#import "AppDelegate.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"

@interface MeLanguageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView  *tableView;
//存放三个按钮
@property(nonatomic, strong) NSMutableArray  *btnArr;

@property (nonatomic, strong) NSArray *arrLanguages;

@property (nonatomic) NSInteger selectedrow;

@end

@implementation MeLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(ME_LANGUAGE);
    
    UIColor * color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    self.arrLanguages = @[
                          LOCAL(LANGUAGE_SYSTEM),
                          LOCAL(LANGUAGE_JAPANESE),
//                          LOCAL(LANGUAGE_ENGLISH),
                          LOCAL(LANGUAGE_SPCHINESE)];
    _currLanguageSetting = [[UnifiedUserInfoManager share] getLanguageUserSetting];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrLanguages.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.detailTextLabel.textColor = [UIColor mtc_colorWithHex:0xc5c5c5];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    
    NSInteger currentCell = indexPath.row;
    cell.textLabel.text = [self.arrLanguages objectAtIndex:currentCell];
    
    LanguageEnum lang = language_system;
    switch (indexPath.row) {
        case 1:
            lang = language_japanese;
            break;
        case 2:
            lang = language_chinese;
            break;
    }
    
    UIButton *button = self.btnArr[indexPath.row];
    cell.accessoryView = button;
    
    [button setSelected:lang == _currLanguageSetting];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL needJump = NO;
    self.selectedrow = indexPath.row;
    for (int index = 0; index < self.btnArr.count; index ++ )
    {
        UIButton *btn = self.btnArr[index];
        if (!btn.selected)
        {
            if (indexPath.row == index)
            {
                needJump = YES;
            }
        }
        if (indexPath.row == index)
        {
            btn.selected = YES;
            continue;
        }
        btn.selected = NO;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (needJump)
    {
        _currLanguageSetting = (LanguageEnum)indexPath.row;
        switch (indexPath.row) {
            case 1:
                _currLanguageSetting = language_japanese;
                break;
            case 2:
                _currLanguageSetting = language_chinese;
                break;
            default:
                break;
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL(PROMPT) message:[NSString stringWithFormat:LOCAL(LANGUAGE_CHANGETITLE), [self.arrLanguages objectAtIndex:indexPath.row]] delegate:self cancelButtonTitle:LOCAL(CANCEL) otherButtonTitles:LOCAL(CONFIRM), nil];
        [alertView show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        _currLanguageSetting = [[UnifiedUserInfoManager share] getLanguageUserSetting];
        [self.tableView reloadData];
        return;
    }
    
    // 保存
    [[UnifiedUserInfoManager share] saveLanguageUserSetting:_currLanguageSetting];
    [self.tableView reloadData];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.controllerManager changeStatus];
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

- (NSMutableArray *)btnArr
{
    if (!_btnArr)
    {
        _btnArr = [NSMutableArray array];
        //添加三个按钮
        for (int index = 0 ;index < self.arrLanguages.count; index ++)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            [btn setImage:[UIImage imageNamed:@"Me_uncheck"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"Me_check"] forState:UIControlStateSelected];
            [_btnArr addObject:btn];
        }
    }
    return _btnArr;
}

- (NSArray *)arrLanguages
{
    if (!_arrLanguages)
    {
        _arrLanguages = [[NSArray alloc] init];
    }
    return _arrLanguages;
}
@end
