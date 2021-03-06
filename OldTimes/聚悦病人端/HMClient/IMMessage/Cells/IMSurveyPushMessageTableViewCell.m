//
//  IMSurveyPushMessageTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMSurveyPushMessageTableViewCell.h"

@interface IMSurveyPushMessageTableViewCell ()
{
    UIImageView* ivComment;
    UILabel* lbMessage;
    UIView* statusview;
    UILabel* lbStatus;
}
@end

@implementation IMSurveyPushMessageTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //lbMessage = [[UILabel alloc]init];
        ivComment = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_im_card_survey"]];
        [msgview addSubview:ivComment];
        [ivComment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(55, 55));
            make.top.equalTo(msgview).with.offset(10);
        }];
        
        lbMessage = [[UILabel alloc]init];
        [msgview addSubview:lbMessage];
        [lbMessage setTextColor:[UIColor commonTextColor]];
        [lbMessage setFont:[UIFont font_30]];
        [lbMessage setNumberOfLines:0];
        
        [lbMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivComment.mas_right).with.offset(6);
            make.top.equalTo(ivComment);
        }];
    
        statusview = [[UIView alloc]init];
        [self.contentView addSubview:statusview];
        statusview.layer.cornerRadius = 2.5;
        statusview.layer.masksToBounds = YES;
        [statusview setBackgroundColor:[UIColor commonLightGrayTextColor]];
        
        [statusview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(msgview.mas_bottom).with.offset(2);
            make.left.equalTo(msgview).with.offset(6);
            make.height.mas_equalTo(@20);
        }];
        
        lbStatus = [[UILabel alloc]init];
        [statusview addSubview:lbStatus];
        [lbStatus setTextColor:[UIColor whiteColor]];
        [lbStatus setFont:[UIFont font_22]];
        [lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusview).with.offset(3);
            make.right.equalTo(statusview).with.offset(-3);
            make.centerY.equalTo(statusview);
        }];
        
        [statusview setHidden:YES];
    }
    return self;
}

- (void) setMessage:(MessageBaseModel*) message
{
    [super setMessage:message];
    if (message._markFromReceive)
    {
        [lbMessage setTextColor:[UIColor commonTextColor]];
        [ivComment mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(msgview).with.offset(21);
        }];
        [lbMessage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(msgview).with.offset(10);
        }];
    }
    else
    {
        [lbMessage setTextColor:[UIColor whiteColor]];
        [ivComment mas_updateConstraints:^(MASConstraintMaker *make) {
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
    MessageBaseModelSurveyContent* modelContent = [MessageBaseModelSurveyContent mj_objectWithKeyValues:dicContent];
    
    [lbMessage setText:modelContent.msg];
    [lbMessage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(msgview).with.offset(-16);
    }];
    
    if ([modelContent.type isEqualToString:@"surveyPush"])
    {
        [lbStatus setText:@"随访待填写"];
    }
    if ([modelContent.type isEqualToString:@"survey"])
    {
        [lbStatus setText:@"随访待填写"];
    }
    if ([modelContent.type isEqualToString:@"surveyFilled"])
    {
        [lbStatus setText:@"随访已填写"];
    }
    if ([modelContent.type isEqualToString:@"surveyReply"])
    {
        [lbStatus setText:@"医生已回复"];
    }
}
@end
