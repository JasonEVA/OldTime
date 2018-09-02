//
//  HMNewDoctorCareAlterEditionTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/6/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMNewDoctorCareAlterEditionTableViewCell.h"
#import "HMConcernHealthEditionView.h"

@interface HMNewDoctorCareAlterEditionTableViewCell ()
@property (nonatomic, strong) HMConcernHealthEditionView *editionView;
@end

@implementation HMNewDoctorCareAlterEditionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        self.editionView = [HMConcernHealthEditionView new];
        [self.contentView addSubview:self.editionView];
        
        [self.editionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.bottom.equalTo(self.contentView);
            make.height.equalTo(@50);
        }];
    }
    return self;
}

- (void)fillDataWithModel:(HealthEducationItem *)model {
    [self.editionView fillDataWithModel:model];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
