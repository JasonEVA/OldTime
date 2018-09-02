//
//  ContactBookGroupViewController.m
//  launcher
//
//  Created by williamzhang on 16/2/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ContactBookGroupViewController.h"
#import "UINavigationController+CompletionHandle.h"
#import "BaseSelectTableViewCell.h"
#import "SelectContactTabbarView.h"
#import <MintcodeIM/MintcodeIM.h>
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"


@interface ContactBookGroupTableViewCell : BaseSelectTableViewCell

+ (NSString *)identifier;
+ (CGFloat)height;

@property (nonatomic, readonly) UIImageView *avatarImageView;
@property (nonatomic, readonly) UILabel *nameLabel;

@end

@interface ContactBookGroupViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *groupArray;

@property (nonatomic, readonly, weak) SelectContactTabbarView *tabbar;

@end

@implementation ContactBookGroupViewController

@synthesize tabbar = _tabbar;

- (instancetype)initWithTabbar:(SelectContactTabbarView *)tabbar {
    self = [super init];
    if (self) {
        _tabbar = tabbar;
        [_tabbar addObserver:self forKeyPath:@"arraycount" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LOCAL(CONTACT_MYGROUP);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

    //不要缓存
    [[MessageManager share] loadGroupListFromCache:NO completion:^(NSArray<UserProfileModel *> *groupList, BOOL success) {
        self.groupArray = groupList;
        [self.tableView reloadData];
    }];
}

- (void)dealloc {
    [self.tabbar removeObserver:self forKeyPath:@"arraycount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.groupArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ContactBookGroupTableViewCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15; }
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactBookGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ContactBookGroupTableViewCell identifier]];
    
    UserProfileModel *model = [self.groupArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = model.nickName;
    
    if (self.tabbar)
    {
        cell.wz_selected = [self.tabbar.dictSelected objectForKey:model.userName] != nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserProfileModel *model = [self.groupArray objectAtIndex:indexPath.row];
    
    if (self.tabbar) {
        // 选人模式
        [self.tabbar addOrDeletePerson:model];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    
    NSDictionary *contactDict = @{
                                  @"UserProfile_userName":model.userName,
                                  @"UserProfile_nickName":model.nickName
                                  };
    [self.navigationController wz_popToRootViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MTWillShowGroupChatNotification object:nil userInfo:contactDict];
    }];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark - Initialzer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 12, 0, 0);
        _tableView.separatorInset = insets;
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:insets];
        }
        
        _tableView.editing = self.tabbar != nil;
        
        [_tableView registerClass:[ContactBookGroupTableViewCell class] forCellReuseIdentifier:[ContactBookGroupTableViewCell identifier]];
    }
    return _tableView;
}

@end

@implementation ContactBookGroupTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self); }
+ (CGFloat)height { return 60; }

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.tintColor = [UIColor themeBlue];
        self.multipleSelectionBackgroundView = [UIView new];
        self.multipleSelectionBackgroundView.backgroundColor = [UIColor grayColor];
        
        [self.wz_contentView addSubview:self.avatarImageView];
        [self.wz_contentView addSubview:self.nameLabel];
		
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wz_contentView).offset(12);
            make.width.height.equalTo(@40);
            make.centerY.equalTo(self.wz_contentView);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.wz_contentView);
            make.left.equalTo(self.avatarImageView.mas_right).offset(8);
            make.right.lessThanOrEqualTo(self.wz_contentView).offset(-12);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.multipleSelectionBackgroundView.backgroundColor = animated ? [UIColor lightGrayColor] : [UIColor whiteColor];
    
}

@synthesize avatarImageView = _avatarImageView, nameLabel = _nameLabel;
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        UIImage *image = [UIImage imageNamed:@"group_defalut_avatar"];
        _avatarImageView = [[UIImageView alloc] initWithImage:image];
        _avatarImageView.layer.cornerRadius = 3;
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont mtc_font_30];
    }
    return _nameLabel;
}

@end