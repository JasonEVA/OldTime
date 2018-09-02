//
//  HMConsultingrecordsTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/4/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMConsultingrecordsTableViewCell.h"
#import "HMConsultingRecordsModel.h"

@interface HMConsultingrecordsTableViewCell ()
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *subTitelLb;
@property (nonatomic, strong) UILabel *onitLb;

@end

@implementation HMConsultingrecordsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.onitLb];
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.subTitelLb];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.subTitelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.contentView.mas_centerY).offset(10);
            make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        }];
        
        [self.onitLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.titelLb);
            make.width.equalTo(@60);
            make.height.equalTo(@23);
        }];
    }
    return self;
}

- (void)fillDataWithModel:(HMConsultingRecordsModel *)model {
    if ([model.status isEqualToString:@"2"]) {
        // 进行中
        [self.titelLb setText:@"当前服务"];

    }
    else {
        // 历史群
        NSDate *begindate = [NSDate dateWithTimeIntervalSince1970:model.beginTime];
        NSDate *canceldate = [NSDate dateWithTimeIntervalSince1970:model.cancelTime];
        NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
        dateFor.dateFormat = @"yyyy-MM-dd";
        
        [self.titelLb setText:[NSString stringWithFormat:@"%@至%@",[dateFor stringFromDate:begindate],[dateFor stringFromDate:canceldate]]];
    }
    
    [self.subTitelLb setText:[NSString stringWithFormat:@"服务团队：%@",model.teamName]];
    [self.onitLb setHidden:![model.status isEqualToString:@"2"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setFont:[UIFont systemFontOfSize:16]];
    }
    return _titelLb;
}

- (UILabel *)subTitelLb {
    if (!_subTitelLb) {
        _subTitelLb = [UILabel new];
        [_subTitelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_subTitelLb setFont:[UIFont systemFontOfSize:14]];
    }
    return _subTitelLb;
}


- (UILabel *)onitLb {
    if (!_onitLb) {
        _onitLb = [UILabel new];
        [_onitLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_onitLb.layer setBackgroundColor:[UIColor mainThemeColor].CGColor];
        [_onitLb setTextAlignment:NSTextAlignmentCenter];
        [_onitLb setFont:[UIFont systemFontOfSize:14]];
        [_onitLb.layer setCornerRadius:2];
        [_onitLb setClipsToBounds:YES];
        [_onitLb setText:@"进行中"];
        
    }
    return _onitLb;
}
@end
