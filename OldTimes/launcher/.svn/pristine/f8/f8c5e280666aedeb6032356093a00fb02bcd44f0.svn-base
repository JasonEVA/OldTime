//
//  ChatDropListView.m
//  launcher
//
//  Created by Lars Chen on 15/9/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatDropListView.h"
#import <Masonry.h>
#import "MyDefine.h"

static NSString *ID = @"ChatDropListCell";

@interface ChatDropListView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ChatDropListView

- (instancetype)init
{
    if (self = [super init])
    {
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOpacity = 0.6;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

#pragma mark - UITableView Delegat & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return .01;}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return .01;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    if (indexPath.row == message_history)
    {
        [cell.imageView setImage:[UIImage imageNamed:@"message_history"]];
        cell.textLabel.text = LOCAL(MESSAGE_LOGGING);
    }
    else
    {
        [cell.imageView setImage:[UIImage imageNamed:@"message_set"]];
        cell.textLabel.text = LOCAL(CHAT_SET);
    }
    
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectIndex = indexPath.row;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView performWithoutAnimation:^{
        [cell layoutIfNeeded];
    }];
}

#pragma mark - Initializer
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView: [[UIView alloc]init]];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setScrollEnabled:NO];
        
        _tableView.separatorInset = UIEdgeInsetsZero;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    }
    
    return _tableView;
}

@end
