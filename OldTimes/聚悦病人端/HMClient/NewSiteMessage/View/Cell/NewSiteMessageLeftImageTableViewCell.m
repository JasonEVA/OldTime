//
//  NewSiteMessageLeftImageTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/12/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageLeftImageTableViewCell.h"
#import "NewSiteMessageRoundsModel.h"
#import "AvatarUtil.h"

@interface  NewSiteMessageLeftImageTableViewCell  ()
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *toEvaluateLb;
@end
@implementation NewSiteMessageLeftImageTableViewCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.cardView addSubview:self.leftImageView];
        [self.cardView addSubview:self.contentLb];
        
        
        
    [self configElements];
    }
    return self;
}

#pragma mark -private method
- (void)configElements {
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nikeNameLb.mas_bottom).offset(2);
        make.left.equalTo(self.imgViewHeadIcon.mas_right).offset(15);
        make.bottom.equalTo(self.contentView);
        make.height.greaterThanOrEqualTo(@40);
        make.right.equalTo(self.contentView).offset(-50);;
        
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView).offset(15);
        make.left.equalTo(self.cardView).offset(15);
        make.height.width.mas_equalTo(55);
        make.bottom.lessThanOrEqualTo(self.cardView).offset(-15);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView).offset(15);
        make.right.equalTo(self.cardView).offset(-15);
        make.left.equalTo(self.leftImageView.mas_right).offset(8);
        make.bottom.lessThanOrEqualTo(self.cardView).offset(-15);
    }];
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface

- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model {
    NewSiteMessageRoundsModel *tempModel  = [NewSiteMessageRoundsModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.contentLb setText:tempModel.msg];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
    NSURL *urlHead = avatarURL(avatarType_80, [NSString stringWithFormat:@"%ld",tempModel.staffUserId]);
    [self.imgViewHeadIcon sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    NSDictionary *dict = model.doThing.mj_JSONObject;
    [self.nikeNameLb setText:dict[@"nickName"]];
    
    if ([model.msgContent.mj_JSONObject[@"type"] isEqualToString:@"surveyPush"]) {   //随访图标
        [self.leftImageView setImage:[UIImage imageNamed:@"icon_card_follow_up"]];
    }
    if ([model.msgContent.mj_JSONObject[@"type"] isEqualToString:@"serviceComments"]) {  //服务评价
        [self.leftImageView setImage:[UIImage imageNamed:@"icon_card_evaluate"]];

        [self.cardView addSubview:self.toEvaluateLb];
        [self.toEvaluateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentLb);
            make.top.equalTo(self.contentLb.mas_bottom).offset(2);
            make.bottom.lessThanOrEqualTo(self.cardView).offset(-8);
        }];

    }
    else {
        [self.toEvaluateLb removeFromSuperview];
    }
    
}
#pragma mark - init UI
- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"333333"]];
        [_contentLb setNumberOfLines:0];
//        _contentLb.preferredMaxLayoutWidth = W_MAX - 55 - 8;
        
    }
    return _contentLb;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_card_evaluate"]];;
    }
    return _leftImageView;
}

- (UILabel *)toEvaluateLb {
    if (!_toEvaluateLb) {
        _toEvaluateLb = [UILabel new];
        [_toEvaluateLb setText:@"前往评价>>"];
        [_toEvaluateLb setTextColor:[UIColor mainThemeColor]];
        [_toEvaluateLb setFont:[UIFont systemFontOfSize:15]];
    }
    return _toEvaluateLb;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
