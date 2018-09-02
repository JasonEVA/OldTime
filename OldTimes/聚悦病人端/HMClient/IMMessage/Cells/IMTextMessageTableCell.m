//
//  IMTextMessageTableCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMTextMessageTableCell.h"



@interface IMTextMessageTableCell ()
{
    UILabel* lbMessage;
    
}
@end

@implementation IMTextMessageTableCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbMessage = [[UILabel alloc]init];
        [msgview addSubview:lbMessage];
        [lbMessage setTextColor:[UIColor commonTextColor]];
        [lbMessage setFont:[UIFont font_30]];
        [lbMessage setNumberOfLines:0];
        
        [lbMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(msgview).with.offset(11);
            make.bottom.equalTo(msgview).with.offset(-12);
        }];
        
    }
    return self;
}

- (void) setMessage:(MessageBaseModel*) message
{
    [super setMessage:message];
    [lbMessage setText:message._content];
    
    if (message._markFromReceive)
    {
        [lbMessage setTextColor:[UIColor commonTextColor]];
    }
    else
    {
        [lbMessage setTextColor:[UIColor whiteColor]];
    }
    
    
    [lbMessage mas_updateConstraints:^(MASConstraintMaker *make) {
        if (message._markFromReceive)
        {
            make.left.equalTo(msgview).with.offset(16);
            make.right.equalTo(msgview).with.offset(-11);
        }
        else
        {
            make.left.equalTo(msgview).with.offset(11);
            make.right.equalTo(msgview).with.offset(-16);
        }
    }];
     
}

@end
