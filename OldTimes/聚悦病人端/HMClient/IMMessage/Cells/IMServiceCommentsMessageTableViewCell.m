//
//  IMServiceCommentsMessageTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMServiceCommentsMessageTableViewCell.h"

@interface IMServiceCommentsMessageTableViewCell ()
{
    UIImageView* ivComment;
    UILabel* lbMessage;
    UILabel* lbComment;
}
@end

@implementation IMServiceCommentsMessageTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //lbMessage = [[UILabel alloc]init];
        ivComment = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_im_card_evaluate"]];
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
        
        lbComment = [[UILabel alloc]init];
        [msgview addSubview:lbComment];
        [lbComment setTextColor:[UIColor mainThemeColor]];
        [lbComment setFont:[UIFont font_30]];
        [lbComment setText:@"前往评价>>"];
        
        [lbComment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(msgview).with.offset(-6);
            make.top.equalTo(lbMessage.mas_bottom).with.offset(4);
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
    MessageBaseModelRecipePageContent* modelContent = [MessageBaseModelRecipePageContent mj_objectWithKeyValues:dicContent];
    
    [lbMessage setText:modelContent.msg];
    [lbMessage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(msgview).with.offset(-16);
    }];

}
@end
