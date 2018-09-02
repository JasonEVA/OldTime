//
//  MainStartMessionTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/4/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainStartMessionTableViewCell.h"

@interface MainStartMessionTableViewCell ()

@end

@implementation MainStartMessionTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 21, 21)];
        [self.contentView addSubview:ivIcon];
        
        lbName = [[UILabel alloc]initWithFrame:CGRectMake(39, 9, 260, 17)];
        [self.contentView addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont systemFontOfSize:16]];
        [lbName setTextColor:[UIColor colorWithHexString:@"333333"]];
        
        [self createCommentLable];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [self subviewLayout];
    }
    return self;
}

- (void) createCommentLable
{
    lbComment = [[UILabel alloc]init];
    [self.contentView addSubview:lbComment];
    [lbComment setBackgroundColor:[UIColor clearColor]];
    [lbComment setFont:[UIFont font_26]];
    [lbComment setTextColor:[UIColor colorWithHexString:@"FF6666"]];
}

- (void) setMessionType:(NSString*) type Icon:(UIImage*) icon
{
    [lbName setText:type];
    [ivIcon setImage:icon];
}


- (void) setMessionComment:(NSString*) comment
{
    BOOL showComment = YES;
    if (!comment || 0 == comment.length || comment.integerValue == 0)
    {
        showComment = NO;
    }
    
    [lbComment setText:comment];
    [lbComment setHidden:!showComment];
}

- (void) subviewLayout
{
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10 * kScreenScale);
        make.center.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_left).with.offset(31 * kScreenScale);
        make.height.mas_equalTo(@(21 * kScreenScale));
        //make.size.mas_equalTo(CGSizeMake(21 * kScreenScale, 21 * kScreenScale));
    }];
    
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivIcon.mas_right).with.offset(8);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(17);
        
//        make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-20);
        
    }];
    
    [self layoutConmmentLable];
}

- (void) layoutConmmentLable
{
    [lbComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self).with.offset(-35);
        //        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-8);
    }];
}

@end

@interface MainStartWarningMessionTableViewCell ()
{
    UIView* commentView;
}
@end

@implementation MainStartWarningMessionTableViewCell

- (void) createCommentLable
{
    commentView = [[UIView alloc]init];
    [self.contentView addSubview:commentView];
    [commentView setBackgroundColor:[UIColor colorWithHexString:@"FF6666"]];
    commentView.layer.cornerRadius = 2.5;
    commentView.layer.masksToBounds = YES;
    
    lbComment = [[UILabel alloc]init];
    [commentView addSubview:lbComment];
    [lbComment setBackgroundColor:[UIColor clearColor]];
    [lbComment setFont:[UIFont font_26]];
    [lbComment setTextColor:[UIColor whiteColor]];
}

- (void) layoutConmmentLable
{
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self).with.offset(-35);
        make.height.equalTo(lbComment).with.offset(5);
        make.width.equalTo(lbComment).with.offset(12);
    }];
    
    [lbComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(commentView);
//        make.right.equalTo(ivRightArrow.mas_left).with.offset(-20);
        
    }];
}

- (void) setMessionComment:(NSString*) comment
{
    BOOL showComment = YES;
    if (!comment || 0 == comment.length || comment.integerValue == 0)
    {
        showComment = NO;
    }
    
    [lbComment setText:comment];
    [commentView setHidden:!showComment];
}
@end
