//
//  MeSuggestViewController.m
//  launcher
//
//  Created by Kyle He on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeSuggestViewController.h"
#import "MeSuggestEditTitleTableViewCell.h"
#import "MeSuggestEditContentTableViewCell.h"
#import "MeMyRequestTableViewCell.h"
#import "MyDefine.h"

@interface MeSuggestViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView  *tableView;

@property(nonatomic, strong) UILabel  *titlePlaceHolder;

@property(nonatomic, strong) UILabel  *contentPlaceHolder;

@end

@implementation MeSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(ME_SUGGEST_BACK);
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:LOCAL(APPLY_SEND) style:UIBarButtonItemStylePlain target:self action:@selector(senderAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.tableView registerClass:[MeSuggestEditTitleTableViewCell class] forCellReuseIdentifier:[MeSuggestEditTitleTableViewCell identifier]];
    [self.tableView registerClass:[MeSuggestEditContentTableViewCell class] forCellReuseIdentifier:[MeSuggestEditContentTableViewCell identifier]];
    [self.tableView registerClass:[MeMyRequestTableViewCell class] forCellReuseIdentifier:[MeMyRequestTableViewCell identifier]];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = nil;
    if (indexPath.section == 0)
    {
        if(indexPath.row )
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[MeSuggestEditContentTableViewCell identifier]];
            return  cell ;
        }
         cell = [tableView dequeueReusableCellWithIdentifier:[MeSuggestEditTitleTableViewCell identifier]];
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[MeMyRequestTableViewCell identifier]];
        //测试部分，可以删除
        if (indexPath.row == 0)
        {
            [cell setDate];
        }else
        {
            [cell setDate1];
        }
        
        return cell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   static MeMyRequestTableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1) return 115.0f;
        return 40.0f;
    }
    if (indexPath.section == 1)
    {   //  1.创建cell
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cell = [tableView dequeueReusableCellWithIdentifier:[MeMyRequestTableViewCell identifier]];
        });
        // 设置数据，后期待改进
        if (indexPath.row == 0)
        {
            [cell setDate];
        }else
        {
            [cell setDate1];
        }
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        //得到高度
        return  [cell getHeight];
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) return LOCAL(ME_BACK_RECORDS);
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 55.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - EventRespond
- (void)senderAction
{
    
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


@end
