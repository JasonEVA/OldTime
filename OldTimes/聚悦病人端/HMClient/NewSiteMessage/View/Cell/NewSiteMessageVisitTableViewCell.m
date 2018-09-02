//
//  NewSiteMessageVisitTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/7/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewSiteMessageVisitTableViewCell.h"
#import "SiteMessageLastMsgModel.h"
#import "NewSiteMessageRoundsModel.h"

@interface NewSiteMessageVisitTableViewCell ()
@property (nonatomic, strong) UILabel *contentLb;

@end

@implementation NewSiteMessageVisitTableViewCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.cardView setBackgroundColor:[UIColor mainThemeColor]];
        [self.leftTri drawNowWithColor:[UIColor mainThemeColor]];
        UIImageView *doctor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_card"]];
        self.contentLb = [UILabel new];
        [self.contentLb setNumberOfLines:0];
        [self.contentLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [self.contentLb setFont:[UIFont systemFontOfSize:16]];
        UILabel *bottomLb = [UILabel new];
        [bottomLb setText:@"    填写随访表"];
        [bottomLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [bottomLb setFont:[UIFont systemFontOfSize:12]];
        [bottomLb setBackgroundColor:[UIColor whiteColor]];
        [self.cardView addSubview:doctor];
        [self.cardView addSubview:bottomLb];

        [self.cardView addSubview:self.contentLb];
        
        [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nikeNameLb.mas_bottom).offset(2);
            make.left.equalTo(self.imgViewHeadIcon.mas_right).offset(15);
            make.bottom.equalTo(self.contentView);
            make.height.greaterThanOrEqualTo(@95);
            make.right.equalTo(self.contentView).offset(-50);;
            
        }];

        
        [doctor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cardView).offset(12);
            make.left.equalTo(self.cardView).offset(20);
            make.width.equalTo(@35);
        }];
        
        [bottomLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.cardView);
            make.height.equalTo(@25);
        }];
        
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(doctor.mas_right).offset(15);
            make.top.equalTo(doctor);
            make.right.equalTo(self.cardView).offset(-15);
            make.bottom.equalTo(bottomLb.mas_top).offset(-10);
        }];
    }
    return self;
}

- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model {
    NewSiteMessageRoundsModel *tempModel  = [NewSiteMessageRoundsModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.contentLb setText:tempModel.msg];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
    NSURL *urlHead = avatarURL(avatarType_80, [NSString stringWithFormat:@"%ld",tempModel.staffUserId]);
    [self.imgViewHeadIcon sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    NSDictionary *dict = model.doThing.mj_JSONObject;
    [self.nikeNameLb setText:dict[@"nickName"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
