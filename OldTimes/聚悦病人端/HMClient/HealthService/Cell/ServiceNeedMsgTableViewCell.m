//
//  ServiceNeedMsgTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceNeedMsgTableViewCell.h"

@interface ServiceNeedMsgTableViewCell ()
{
    UILabel* lbMust;
    UILabel* lbName;
    UILabel* lbUnit;
    UIImageView* arrowImage;
    
}
@end

@implementation ServiceNeedMsgTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self)
    {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self)
        {
            
            lbMust = [[UILabel alloc]init];
            [lbMust setTextColor:[UIColor commonRedColor]];
            [lbMust setFont:[UIFont font_22]];
            [self.contentView addSubview:lbMust];
            [lbMust setText:@"*"];
            [lbMust setHidden:YES];
            
            lbName = [[UILabel alloc]init];
            [lbName setTextColor:[UIColor commonGrayTextColor]];
            [lbName setFont:[UIFont font_30]];
            [self.contentView addSubview:lbName];
            
            lbUnit = [[UILabel alloc]init];
            [lbUnit setTextColor:[UIColor commonTextColor]];
            [lbUnit setFont:[UIFont font_30]];
            [self.contentView addSubview:lbUnit];
            
            arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_x_arrows"]];
            [self.contentView addSubview:arrowImage];
            
            _tfValue = [[UITextField alloc]init];
            [_tfValue setTextColor:[UIColor commonTextColor]];
            [_tfValue setFont:[UIFont font_30]];
            [self.contentView addSubview:_tfValue];
            [_tfValue setTextAlignment:NSTextAlignmentRight];
            [self subviewLayout];
        }
        return self;
    }
    return self;
}

- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(12.5);
    }];
    
    [lbMust mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(lbName.mas_left).with.offset(-2);
    }];
    
    [lbUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lbName);
        make.right.equalTo(self.contentView).with.offset(-29);
    }];
    
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(8, 14));
        make.left.equalTo(lbUnit.mas_right).with.offset(8);
    }];
    
    [_tfValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        
        make.left.greaterThanOrEqualTo(lbName.mas_right).with.offset(3);
        make.right.equalTo(lbUnit.mas_left).with.offset(-3);
    }];
}

- (void) setServiceNeedMsg:(ServiceNeedMsg*) needMsg
{
    [lbMust setHidden:!needMsg.isRequired];
    [lbName setText:needMsg.msgItemName];
    [lbUnit setText:needMsg.unitName];
    
    [_tfValue setPlaceholder:[NSString stringWithFormat:@"请输入%@", needMsg.msgItemName]];
    [_tfValue setEnabled:3 != needMsg.msgItemDataType];
    
    switch (needMsg.msgItemDataType)
    {
        case 1:
        {
            //int
            [_tfValue setKeyboardType:UIKeyboardTypeNumberPad];
            
        }
            break;
        case 2:
        {
            //NUMBER
            [_tfValue setKeyboardType:UIKeyboardTypeDecimalPad];
        }
            break;
        case 3:
        {
            //Date
            
        }
            break;
        case 4:
        {
            //Date
            [_tfValue setKeyboardType:UIKeyboardTypeDefault];
        }
            break;
        default:
            break;
    }
}

@end
