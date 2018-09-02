//
//  NewSiteMessageHealthClassTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/2/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMessageHealthClassTableViewCell.h"
#import "NewSiteMessageHealthClassModel.h"

@interface NewSiteMessageHealthClassTableViewCell ()
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *titelLb;
@end

@implementation NewSiteMessageHealthClassTableViewCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.cardView addSubview:self.leftImageView];
        [self.cardView addSubview:self.contentLb];
        [self.cardView addSubview:self.titelLb];
        
        
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
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardView).offset(15);
        make.left.equalTo(self.cardView).offset(15);
        make.right.lessThanOrEqualTo(self.cardView).offset(-15);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titelLb.mas_bottom).offset(5);
        make.left.equalTo(self.cardView).offset(15);
        make.height.width.mas_equalTo(55);
        make.bottom.lessThanOrEqualTo(self.cardView).offset(-15);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titelLb.mas_bottom).offset(5);
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
    NewSiteMessageHealthClassModel *tempModel  = [NewSiteMessageHealthClassModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.contentLb setText:tempModel.healthClassDescription];
    [self.titelLb setText:tempModel.msg];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
    NSURL *urlHead = avatarURL(avatarType_80, tempModel.staffId);
    [self.imgViewHeadIcon sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    NSDictionary *dict = model.doThing.mj_JSONObject;
    
    [self.nikeNameLb setText:dict[@"nickName"]];
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.picUrl] placeholderImage:[UIImage imageNamed:@"ic_xuanjiao"]];
    
}
#pragma mark - init UI
- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"999999"]];
        [_contentLb setNumberOfLines:0];
    }
    return _contentLb;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_card_evaluate"]];;
    }
    return _leftImageView;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setFont:[UIFont systemFontOfSize:16]];
        [_contentLb setNumberOfLines:0];

    }
    return _titelLb;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
