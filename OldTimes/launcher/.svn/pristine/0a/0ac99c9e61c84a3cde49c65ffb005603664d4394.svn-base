//
//  ChatGroupmanagerCollectionViewCell.m
//  launcher
//
//  Created by Andrew Shen on 15/9/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatGroupManagerCollectionViewCell.h"
#import <MintcodeIM/MintcodeIM.h>
#import "IMNickNameManager.h"
#import <Masonry/Masonry.h>

@interface ChatGroupManagerCollectionViewCell()

@property (nonatomic, strong)  ChatManagerAvatarView  *avatarView;
@property (nonatomic, strong)  UILabel  *lbName;
@property (nonatomic, strong)  deletePersonWithIndex  deletePersonWithIndex;
@end

@implementation ChatGroupManagerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.lbName];
        [self.avatarView setEditTarget:self event:@selector(deletePerson)];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.equalTo(self.avatarView.mas_width);
    }];
    [self.lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_bottom).offset(2);
        make.centerX.equalTo(self.contentView);
        make.width.lessThanOrEqualTo(self.contentView);
    }];

    [super updateConstraints];
}

// 删除按钮点击
- (void)deletePerson {
    self.deletePersonWithIndex(self.indexPath);
}

#pragma mark - Interface Method
/**
 *  是否编辑头像
 *
 *  @param edit 是否编辑
 */
- (void)avatarEdit:(BOOL)edit {
    ChatGroupAvatarTag currentTag = (ChatGroupAvatarTag)self.tag;
    if (currentTag == avatar_others) {
        [self.avatarView avatarEdit:edit];
    }
}

/**
 *   设置tag类型
 *
 *  @param tag 类型
 */
- (void)setTag:(NSInteger)tag {
    [super setTag:(ChatGroupAvatarTag)tag];
    self.avatarView.tag = (ChatGroupAvatarTag)tag;
}

// 设置数据
- (void)setAvatarData:(UserProfileModel *)model {
    if (self.tag < avatar_add) {
        [self.lbName setText:[IMNickNameManager showNickNameWithOriginNickName:model.nickName userId:model.userName]];
        [self.avatarView setAvatar:model.userName];
        [self.avatarView setAvatarHaveCorners:2.5];
    } else {
        [self.lbName setText:nil];
        [self.avatarView setAvatar:@""];
        [self.avatarView setAvatarHaveCorners:0];
    }

}

// 监听删除事件
- (void)deserveDeleteEvent:(deletePersonWithIndex)deletePerson {
    self.deletePersonWithIndex = deletePerson;
}

#pragma mark - Init
- (ChatManagerAvatarView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[ChatManagerAvatarView alloc] init];
    }
    return _avatarView;
}

- (UILabel *)lbName {
    if (!_lbName) {
        _lbName = [[UILabel alloc] init];
        [_lbName setTextAlignment:NSTextAlignmentCenter];
        [_lbName setLineBreakMode:NSLineBreakByTruncatingTail];
        [_lbName setFont:[UIFont systemFontOfSize:12]];
    }
    return _lbName;
}

@end


