//
//  FriendListTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "FriendListTableViewCell.h"

@interface FriendListTableViewCell ()
{
    UIView* friendview;
    UIImageView* ivFriend;
    UILabel* lbFriend;
    UILabel* lbRelation;
    UILabel* lbMobile;
    
    UIButton* deleteRelativeButton;
}
@end

@implementation FriendListTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        
        friendview = [[UIView alloc]init];
        [friendview setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:friendview];
        [friendview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).with.offset(-5);
        }];
        
        ivFriend = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default_photo"]];
        [friendview addSubview:ivFriend];
        ivFriend.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        ivFriend.layer.borderWidth = 0.5;
        [ivFriend.layer setCornerRadius:20];
        [ivFriend.layer setMasksToBounds:YES];
        
        [ivFriend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(friendview).with.offset(12.5);
            make.centerY.equalTo(friendview);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        lbFriend = [[UILabel alloc]init];
        [friendview addSubview:lbFriend];
        [lbFriend setFont:[UIFont font_30]];
        [lbFriend setTextColor:[UIColor commonTextColor]];
        [lbFriend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ivFriend);
            make.left.equalTo(ivFriend.mas_right).with.offset(11);
        }];
        
        lbRelation = [[UILabel alloc]init];
        [friendview addSubview:lbRelation];
        [lbRelation setFont:[UIFont font_24]];
        [lbRelation setTextColor:[UIColor commonTextColor]];
        [lbRelation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lbFriend);
            make.left.equalTo(lbFriend.mas_right).with.offset(2);
        }];
        
        lbMobile = [[UILabel alloc]init];
        [friendview addSubview:lbMobile];
        [lbMobile setFont:[UIFont font_24]];
        [lbMobile setTextColor:[UIColor commonGrayTextColor]];
        [lbMobile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ivFriend);
            make.left.equalTo(ivFriend.mas_right).with.offset(11);
        }];

        deleteRelativeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [friendview addSubview:deleteRelativeButton];
        [deleteRelativeButton setTitle:@"解除绑定" forState:UIControlStateNormal];
        [deleteRelativeButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [deleteRelativeButton.titleLabel setFont:[UIFont font_24]];
        deleteRelativeButton.layer.cornerRadius = 2.5;
        deleteRelativeButton.layer.borderColor = [UIColor mainThemeColor].CGColor;
        deleteRelativeButton.layer.borderWidth = 0.5;
        deleteRelativeButton.layer.masksToBounds = YES;
        
        [deleteRelativeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(friendview);
            make.size.mas_equalTo(CGSizeMake(75, 25));
            make.right.equalTo(friendview).with.offset(-12.5);
        }];
        
        [deleteRelativeButton addTarget:self action:@selector(deleteRelativeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) setFriendInfo:(FriendInfo*) friend
{
    if (friend.relationUserDet.imgUrl)
    {
        [ivFriend sd_setImageWithURL:[NSURL URLWithString:friend.relationUserDet.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_photo"]];
    }
    [lbFriend setText:friend.relativeFriendName];
    [lbRelation setText:[NSString stringWithFormat:@"(%@)", friend.relativeName]];
    [lbMobile setText:@""];
    if (friend.mobile) {
        [lbMobile setText:[NSString stringWithFormat:@"电话:%@", friend.mobile]];
    }
    
}

- (void) deleteRelativeButtonClicked:(id) sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(friendDeleteRelativeButtonClicked:)])
    {
        [_delegate friendDeleteRelativeButtonClicked:self];
    }
}
@end
