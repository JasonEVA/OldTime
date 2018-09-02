//
//  HMWeightHealthClassTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/8/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMWeightHealthClassTableViewCell.h"
#import "HealthEducationItem.h"
#import "HMWeightHealthClassView.h"

#define CARDWIDTH     ((ScreenWidth - (CARDOFFSET * 3)) / 2.0)
#define CARDHEIGHT    (CARDWIDTH + 70)
#define CARDOFFSET    15
@interface HMWeightHealthClassTableViewCell ()
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) HMWeightHealthClassView *lastView;
@property (nonatomic, copy) ClickBlock block;
@end

@implementation HMWeightHealthClassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.titelLb = [UILabel new];
        [self.titelLb setText:@"相关阅读"];
        [self.titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.titelLb setFont:[UIFont systemFontOfSize:16]];
        
        [self.contentView addSubview:self.titelLb];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(15);
        }];
        
    }
    return self;
}

- (void)fillDataWithArray:(NSArray<HealthEducationItem *> *)array {
    if (!array || !array.count || self.contentView.subviews.count > 1) {
        return;
    }
    
    
    __weak typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(HealthEducationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        HMWeightHealthClassView *view = [[HMWeightHealthClassView alloc] initWithFrame:CGRectMake(0 , 0, CARDWIDTH, CARDHEIGHT)];
        [view setTag:idx];
        [view addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];
        [view fillDataWithModel:obj];
        [strongSelf.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@CARDWIDTH);
            make.height.equalTo(@CARDHEIGHT);
            if (idx == 0 || idx == 2) {
                make.left.equalTo(strongSelf.contentView).offset(CARDOFFSET);
            }
            else {
                make.left.equalTo(strongSelf.lastView.mas_right).offset(CARDOFFSET);
            }
            
            if (idx == 0 || idx == 1) {
                make.top.equalTo(strongSelf.titelLb.mas_bottom).offset(15);
            }
            else if (idx == 3) {
                make.top.equalTo(strongSelf.lastView);
            }
            else {
                make.top.equalTo(strongSelf.lastView.mas_bottom).offset(15);
            }
        }];
        
        strongSelf.lastView = view;

    }];
    
    [self.lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-15);
    }];

}

- (void)classClick:(HMWeightHealthClassView *)sender {
    
    if (self.block) {
        self.block(sender.tag);
    }
}

- (void)dealWithClick:(ClickBlock)block {
    self.block = block;
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
