//
//  NewSiteMessageTextTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/12/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageTextTableViewCell.h"
#import "NewSiteMessageDoctorCareModel.h"

@interface NewSiteMessageTextTableViewCell ()
@property (nonatomic, strong) UILabel *contentLb;

@end
@implementation NewSiteMessageTextTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.cardView addSubview:self.contentLb];
        
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.cardView).offset(15);
            make.right.equalTo(self.cardView).offset(-15);
            make.bottom.equalTo(self.cardView).offset(-15);
        }];
    }
    return self;
}

- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model {
    NewSiteMessageDoctorCareModel *tempModel  = [NewSiteMessageDoctorCareModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.contentLb setText:tempModel.msg];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
    NSDictionary *dict = model.doThing.mj_JSONObject;
    [self.nikeNameLb setText:dict[@"nickName"]];
    
}

- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"333333"]];
        [_contentLb setNumberOfLines:0];
        _contentLb.preferredMaxLayoutWidth = W_MAX;

    }
    return _contentLb;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
