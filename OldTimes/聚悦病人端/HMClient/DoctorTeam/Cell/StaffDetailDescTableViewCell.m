//
//  StaffDetailDescTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "StaffDetailDescTableViewCell.h"

@interface StaffDetailDescTableViewCell ()
{
    UILabel* lbDesc;
}


@end

@implementation StaffDetailDescTableViewCell

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

- (void) setStaffDesc:(NSString*) teamdesc
{
    [lbDesc setText:teamdesc];
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
