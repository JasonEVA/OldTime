//
//  TeamDetailDescTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "TeamDetailDescTableViewCell.h"

@interface TeamDetailDescTableViewCell ()
{
    UILabel* lbDesc;
}


@end

@implementation TeamDetailDescTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        lbDesc = [[UILabel alloc]init];
        [self.contentView addSubview:lbDesc];
        [lbDesc setTextColor:[UIColor commonTextColor]];
        [lbDesc setFont:[UIFont font_24]];
        [lbDesc setNumberOfLines:0];
        [lbDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(self.contentView).with.offset(11);
            make.bottom.equalTo(self.contentView).with.offset(-26);
        }];
        
        _expendbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_expendbutton];
        [_expendbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.top.equalTo(lbDesc.mas_bottom);
        }];
        
        [_expendbutton setImage:[UIImage imageNamed:@"icon_down_list_arrow"] forState:UIControlStateNormal];
    }
    return self;
}

- (void) setTeamDesc:(NSString*) teamdesc
{
    [lbDesc setText:teamdesc];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setExtendStyle:(NSInteger) style
{
    [_expendbutton setHidden:NO];
    switch (style)
    {
        case 0:
        {
            [_expendbutton setHidden:YES];
        }
            break;
        case 1:
        {
            [_expendbutton setImage:[UIImage imageNamed:@"icon_down_list_arrow"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [_expendbutton setImage:[UIImage imageNamed:@"icon_arrows_up"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

@end
