//
//  ChatSingleManagerViewController.m
//  launcher
//
//  Created by Lars Chen on 15/9/18.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ChatSingleManagerViewController.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "UIButton+DeterReClicked.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChatSingleManagerTableViewCell.h"
#import "ContactBookDetailViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "SelectContactBookViewController.h"
#import "AvatarUtil.h"
#import <MintcodeIM/MintcodeIM.h>

@interface ChatSingleManagerViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnAddGroup;
@property (nonatomic, strong) ChatSingleManagerTableViewCell *singleManagerCell;

@property (nonatomic, strong) NSArray *arrTitle;

@end

@implementation ChatSingleManagerViewController

#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = LOCAL(CHAT_SET);
    self.arrTitle = @[LOCAL(DELETE_MESSAGE)];
    
    [self initComponent];
}

#pragma mark - Private Method
- (void)initComponent
{
    [self.view addSubview:self.tableView];
    
    [self initConstraints];
}

- (void)initConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return self.arrTitle.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 17;
    }
    else
    {
        return 14.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 60;
        }
        else
        {
            return 45;
        }
    }
    else
    {
        return 46;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ChatSingleManagerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }

        if (indexPath.section == 0)
        {
            if (indexPath.row == 1)
            {
                [cell addSubview:self.btnAddGroup];
                [self.btnAddGroup mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(cell);
                }];
            }
        }
    }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            NSURL *urlHead = avatarURL(avatarType_80, self.strUid);
            [self.singleManagerCell.imageView sd_setImageWithURL:urlHead placeholderImage:IMG_DEFAULT_HEAD];
            self.singleManagerCell.textLabel.text = self.strName;
            self.singleManagerCell.textLabel.textColor = [UIColor mtc_colorWithHex:0x000000];
            self.singleManagerCell.lbDepartment.textColor = [UIColor mtc_colorWithHex:0x666666];
            return self.singleManagerCell;
        }
        else
        {
            
        }
    }
    else
    {
        cell.textLabel.text = self.arrTitle[indexPath.row];
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            
        }
        else
        {
            // 查看个人信息
            ContactBookDetailViewController *detailVC = [[ContactBookDetailViewController alloc] initWithUserShowId:self.strUid];
            [detailVC setGetStrName:^(NSString *str) {
                self.strName=str;
                [tableView reloadData];
            }];
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            // 清空聊天记录
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(DELETE_MESSAGE), nil];
            [actionSheet showInView:self.view];
        }
    }
}

- (void)startGroupChat
{
    //按钮暴力点击防御
    [self.btnAddGroup mtc_deterClickedRepeatedly];
    
    ContactPersonDetailInformationModel *person = [ContactPersonDetailInformationModel new];
    person.show_id = self.strUid;
    person.u_true_name = self.strName;
    SelectContactBookViewController *createVC = [[SelectContactBookViewController alloc] initWithSelectedPeople:@[person] unableSelectPeople:@[person]];
    createVC.selectType = selectContact_singleCreateGroup;
    [self presentViewController:createVC animated:YES completion:nil];
}

#pragma mark - Init UI
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView: [[UIView alloc]init]];
        [_tableView setBackgroundColor:[UIColor grayBackground]];
        [_tableView setScrollEnabled:NO];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
    
    return _tableView;
}

- (UIButton *)btnAddGroup
{
    if (!_btnAddGroup)
    {
        _btnAddGroup = [UIButton new];
        [_btnAddGroup setImage:[UIImage imageNamed:@"chat_begin_group"] forState:UIControlStateNormal];
        [_btnAddGroup.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_btnAddGroup setTitle:LOCAL(MESSAGE_STARTGROUP) forState:UIControlStateNormal];
        [_btnAddGroup setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [_btnAddGroup setBackgroundColor:[UIColor whiteColor]];
        [_btnAddGroup addTarget:self action:@selector(startGroupChat) forControlEvents:UIControlEventTouchUpInside];
        [_btnAddGroup setTitleColor:[UIColor mtc_colorWithHex:0x0099ff] forState:UIControlStateNormal];
    }
    
    return _btnAddGroup;
}

- (ChatSingleManagerTableViewCell *)singleManagerCell
{
    if (!_singleManagerCell)
    {
        _singleManagerCell = [ChatSingleManagerTableViewCell new];
//        [_singleManagerCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [_singleManagerCell.textLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    return _singleManagerCell;
}

@end
