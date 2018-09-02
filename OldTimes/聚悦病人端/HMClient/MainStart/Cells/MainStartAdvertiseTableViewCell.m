//
//  MainStartAdvertiseTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartAdvertiseTableViewCell.h"

@interface MainStartAdvertiseTableViewCell ()
{
    UIView* vAdvertise;
}
@end

@implementation MainStartAdvertiseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setAdvertiseView:(UIView*) advertiseview
{
    if (vAdvertise)
    {
        if (vAdvertise == advertiseview)
        {
            return;
        }
        
        [vAdvertise removeFromSuperview];
    }
    
    vAdvertise = advertiseview;
    [self.contentView addSubview:vAdvertise];
    [vAdvertise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.top.and.bottom.equalTo(self.contentView);
    }];
}

@end

@interface MainStartTeamTableViewCell ()
{
    UIView* vTeam;
}
@end

@implementation MainStartTeamTableViewCell

- (void) setTeamView:(UIView *)teamview
{
    if (vTeam)
    {
        if (vTeam == teamview)
        {
            return;
        }
        [vTeam removeFromSuperview];
    }
    
    vTeam = teamview;
    [self.contentView addSubview:vTeam];
    [vTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.top.and.bottom.equalTo(self.contentView);
    }];
}

@end
