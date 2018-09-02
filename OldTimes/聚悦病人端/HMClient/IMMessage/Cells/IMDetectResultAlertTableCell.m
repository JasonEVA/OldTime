//
//  IMDetectResultAlertTableCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMDetectResultAlertTableCell.h"





@interface IMDetectResultAlertTableCell ()
{
    UIImageView* ivDetectResultPage;
    UILabel* lbMessage;
}
@end

@implementation IMDetectResultAlertTableCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //lbMessage = [[UILabel alloc]init];
        ivDetectResultPage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_im_card_warm"]];
        [msgview addSubview:ivDetectResultPage];
        [ivDetectResultPage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(55, 55));
            //make.left.equalTo(msgview).with.offset(10);
            make.top.equalTo(msgview).with.offset(10);
        }];
        
        lbMessage = [[UILabel alloc]init];
        [msgview addSubview:lbMessage];
        [lbMessage setTextColor:[UIColor commonTextColor]];
        [lbMessage setFont:[UIFont font_30]];
        [lbMessage setNumberOfLines:0];
        
        [lbMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivDetectResultPage.mas_right).with.offset(6);
            make.top.equalTo(ivDetectResultPage);
            //make.bottom.equalTo(msgview).with.offset(10);
        }];

    }
    return self;
}

- (void) setMessage:(MessageBaseModel*) message
{
    [super setMessage:message];
    if (message._markFromReceive)
    {
        [lbMessage setTextColor:[UIColor commonTextColor]];
        [ivDetectResultPage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(msgview).with.offset(21);
        }];
        [lbMessage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(msgview).with.offset(10);
        }];
    }
    else
    {
        [lbMessage setTextColor:[UIColor whiteColor]];
        [ivDetectResultPage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(msgview).with.offset(10);
        }];
        [lbMessage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(msgview).with.offset(-16);
        }];
    }
    
    NSString* content = message._content;
    if (!content || 0 == content.length) {
        return;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    MessageBaseModelDetectResultAlertContent* modelContent = [MessageBaseModelDetectResultAlertContent mj_objectWithKeyValues:dicContent];
    
    [lbMessage setText:modelContent.msg];
    [lbMessage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(msgview).with.offset(-16);
    }];

}
@end
