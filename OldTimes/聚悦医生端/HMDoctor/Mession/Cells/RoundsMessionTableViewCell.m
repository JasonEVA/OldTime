//
//  RoundsMessionTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 16/9/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsMessionTableViewCell.h"

@interface RoundsMessionModel (RoundsMessionTableViewCell)

- (NSString*) userInfoString;
@end

@implementation RoundsMessionModel (RoundsMessionTableViewCell)

- (NSString*) userInfoString
{
    NSString* userInfoStr;
    if (kStringIsEmpty(self.mainIll)) {
        userInfoStr = [NSString stringWithFormat:@"(%@|%ld)", self.sex, self.age];
    }
    else{
        userInfoStr = [NSString stringWithFormat:@"(%@|%ld %@)", self.sex, self.age, self.mainIll];
    }
    return userInfoStr;
}

@end

@interface RoundsMessionTableViewCell ()
{
    UIView* roundsView;
    UIImageView* ivPartrait;
    UILabel* usernameLable;
    UILabel* userInfoLable;
    UILabel* plandateLable;
    UILabel* roundsNameLable;
    UILabel* filldateLabel;
    
    UIView* statusView;
    UILabel* statusLable;
}
@end


@implementation RoundsMessionTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        
        roundsView = [[UIView alloc]init];
        [self.contentView addSubview:roundsView];
        [roundsView setBackgroundColor:[UIColor whiteColor]];
        roundsView.layer.cornerRadius = 5;
        roundsView.layer.masksToBounds = YES;
        [roundsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.bottom.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(11);
        }];
        
        ivPartrait = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default_user"]];
        [self addSubview:ivPartrait];
        ivPartrait.layer.cornerRadius = 2.5;
        ivPartrait.layer.masksToBounds = YES;
        
        [ivPartrait mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(roundsView).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(roundsView).with.offset(13);
        }];
        
        usernameLable = [[UILabel alloc]init];
        [roundsView addSubview:usernameLable];
        [usernameLable setFont:[UIFont font_30]];
        [usernameLable setTextColor:[UIColor commonTextColor]];
        
        [usernameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivPartrait.mas_right).with.offset(6);
            make.top.equalTo(roundsView).with.offset(10);

        }];
        
        _archiveButton = [[UIButton alloc] init];
        [self addSubview:_archiveButton];
        [_archiveButton setTitle:@"档案详情 >" forState:UIControlStateNormal];
        [_archiveButton setTitleColor:[UIColor commonLightGrayTextColor] forState:UIControlStateNormal];
        [_archiveButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_archiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(roundsView).offset(-8);
            make.top.equalTo(usernameLable).offset(-5);;
        }];
        
        userInfoLable = [[UILabel alloc]init];
        [roundsView addSubview:userInfoLable];
        [userInfoLable setFont:[UIFont font_30]];
        [userInfoLable setTextColor:[UIColor commonTextColor]];
        
        [userInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(usernameLable.mas_right);
            make.top.equalTo(usernameLable);
            make.right.lessThanOrEqualTo(roundsView).with.offset(-75);
        }];
        
        UILabel* roundsNameTitleLable = [[UILabel alloc]init];
        [roundsView addSubview:roundsNameTitleLable];
        [roundsNameTitleLable setFont:[UIFont font_24]];
        [roundsNameTitleLable setTextColor:[UIColor commonGrayTextColor]];
        [roundsNameTitleLable setText:@"查房内容: "];
        [roundsNameTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(usernameLable);
            make.top.equalTo(usernameLable.mas_bottom).with.offset(10);
        }];
        
        roundsNameLable = [[UILabel alloc]init];
        [roundsView addSubview:roundsNameLable];
        [roundsNameLable setFont:[UIFont font_24]];
        [roundsNameLable setTextColor:[UIColor commonGrayTextColor]];
        
        [roundsNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(roundsNameTitleLable.mas_right);
            make.top.equalTo(roundsNameTitleLable);
        }];
        
        plandateLable = [[UILabel alloc]init];
        [roundsView addSubview:plandateLable];
        [plandateLable setFont:[UIFont font_24]];
        [plandateLable setTextColor:[UIColor commonGrayTextColor]];
        
        [plandateLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(usernameLable);
            make.top.equalTo(roundsNameTitleLable.mas_bottom).with.offset(5);
        }];
        
        filldateLabel = [[UILabel alloc]init];
        [roundsView addSubview:filldateLabel];
        [filldateLabel setFont:[UIFont font_24]];
        [filldateLabel setTextColor:[UIColor commonGrayTextColor]];
        
        [filldateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(usernameLable);
            make.top.equalTo(plandateLable.mas_bottom).with.offset(5);
        }];
        
        statusView = [[UIView alloc]init];
        [roundsView addSubview:statusView];
        [statusView setBackgroundColor:[UIColor whiteColor]];
        [statusView showTopLine];
        [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.bottom.equalTo(roundsView);
            make.height.mas_equalTo(42);
        }];

        statusLable = [[UILabel alloc]init];
        [statusView addSubview:statusLable];
        [statusLable setFont:[UIFont font_24]];
        [statusLable setTextColor:[UIColor commonGrayTextColor]];
        
        [statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusView).with.offset(7.5);
            make.centerY.equalTo(statusView);
        }];
        
        _roundsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [statusView addSubview:_roundsButton];
        [_roundsButton setBackgroundImage:[UIImage rectImage:CGSizeMake(60, 30) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_roundsButton setTitle:@"查房" forState:UIControlStateNormal];
        [_roundsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_roundsButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _roundsButton.layer.cornerRadius = 2.5;
        _roundsButton.layer.masksToBounds = YES;
        
        [_roundsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(statusView);
            make.right.equalTo(statusView).with.offset(-9);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        [_roundsButton setHidden:YES];
    }
    return self;
}

- (void) setRoundsMessionModel:(RoundsMessionModel*) mession
{
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [ivPartrait sd_setImageWithURL:[NSURL URLWithString:mession.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
    
    [usernameLable setText:mession.userName];
    [userInfoLable setText:[mession userInfoString]];
    [plandateLable setText:mession.createTime];
    
    NSDate* plandate = [NSDate dateWithString:mession.createTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    [plandateLable setText:@""];
    if (plandate)
    {
        [plandateLable setText:[NSString stringWithFormat:@"发送时间:%@",[plandate formattedDateWithFormat:@"yyyy-MM-dd HH:mm"]]];
    }
    
    if (!kStringIsEmpty(mession.fillTime)) {
        NSDate* filldate = [NSDate dateWithString:mession.createTime formatString:@"yyyy-MM-dd HH:mm:ss"];
        [filldateLabel setText:[NSString stringWithFormat:@"填写时间:%@",[filldate formattedDateWithFormat:@"yyyy-MM-dd HH:mm"]]];
    }
    else{
        [filldateLabel setHidden:YES];
    }
    
    [roundsNameLable setText:[NSString stringWithFormat:@"%@",mession.moudleName]];
    [statusLable setText:mession.statusName];
    
    [_roundsButton setHidden:YES];
    
    BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeRoundsMode Status:0 OperateCode:kPrivilegeEditOperate];
    if (editPrivilege)
    {
        [_roundsButton setHidden:(mession.status != 0)];
    }
    
    
}


@end
