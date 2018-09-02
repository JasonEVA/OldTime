//
//  FriendSelectViewController.m
//  HMClient
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "FriendSelectViewController.h"
#import "FriendInfo.h"

@interface FriendSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *friendSelceTableView;
}
@end

@implementation FriendSelectViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    UIControl* closeControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:closeControl];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createfriendSelceTableView];
    
}

+ (FriendSelectViewController*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                                    item:(NSArray *)item
                                                             selectblock:(FriendSelectBlock)block;
{
    if (!parentviewcontroller)
    {
        return nil;
    }
    FriendSelectViewController* vcFrinedSelect = [[FriendSelectViewController alloc]initWithNibName:nil bundle:nil];
    vcFrinedSelect.friendItem = item;
    [parentviewcontroller addChildViewController:vcFrinedSelect];
    [vcFrinedSelect.view setFrame:parentviewcontroller.view.bounds];
    [parentviewcontroller.view addSubview:vcFrinedSelect.view];
    
    [vcFrinedSelect setSelectblock:block];
    
    return vcFrinedSelect;
}


- (void) closeControlClicked:(id) sender
{
    if (_selectblock)
    {
        _selectblock([_friendItem firstObject]);
    }
    [self closeTestTimeView];
}

- (void) closeTestTimeView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_friendItem)
    {
        return _friendItem.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendInfo *friend = [_friendItem objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        
        [cell setBackgroundColor:[UIColor commonBackgroundColor]];
        [cell.textLabel setFont:[UIFont font_28]];
    }
    
    [cell.textLabel setText:friend.relativeFriendName];
    
    return cell;
}
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendInfo *friend = [_friendItem objectAtIndex:indexPath.row];

    if (_selectblock)
    {
        _selectblock(friend);
    }
    
    [self closeTestTimeView];
    
}
- (void) createfriendSelceTableView
{
    if (!_friendItem)
    {
        return;
    }
    float tableheight = _friendItem.count * 44;
    if (tableheight > self.view.height - 50)
    {
        tableheight = self.view.height- 50;
    }
    friendSelceTableView = [[UITableView alloc]init];
    [self.view addSubview:friendSelceTableView];
    [friendSelceTableView setDataSource:self];
    [friendSelceTableView setDelegate:self];
    [friendSelceTableView.layer setCornerRadius:5.0f];
    [friendSelceTableView.layer setMasksToBounds:YES];
    
    [friendSelceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, tableheight));
    }];
}

@end
