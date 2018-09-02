//
//  HMStepHistoryTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/8/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMStepHistoryTableViewCell.h"
#import "HMStepHistoryModel.h"

@interface HMStepHistoryTableViewCell ()
@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *vauelLb;
@end

@implementation HMStepHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.pointView = [UIView new];
        [self.pointView setBackgroundColor:[UIColor colorWithHexString:@"f79453"]];
        [self.pointView.layer setCornerRadius:3];
        [self.pointView setClipsToBounds:YES];
        [self.contentView addSubview:self.pointView];
        [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.width.height.equalTo(@6);
        }];
        
        self.titelLb = [UILabel new];
        [self.titelLb setText:@"节省汽油"];
        [self.titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.titelLb setFont:[UIFont systemFontOfSize:14]];
        
        [self.contentView addSubview:self.titelLb];
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.pointView.mas_right).offset(15);
        }];
        
        self.vauelLb = [UILabel new];
        [self.vauelLb setText:@"12斤"];
        [self.vauelLb setTextColor:[UIColor colorWithHexString:@"31c9ba"]];
        [self.vauelLb setFont:[UIFont systemFontOfSize:16]];
        
        [self.contentView addSubview:self.vauelLb];
        [self.vauelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
        }];

    }
    return self;
}

- (void)fillDataWithModel:(HMStepHistoryModel *)model cellType:(HMGroupPKTableType)type PKScreening:(HMGroupPKScreening)PKScreening{
    if (!model) {
        return;
    }
    UIColor *pointColor = [UIColor whiteColor];
    NSString *titelStr = @"";
    NSString *targetStr = @"";
    CGFloat distance = model.stepCount * 0.0006;
    CGFloat time = distance / 3.0;
    CGFloat kaluli = 60 * 3.1 * time;
    
    switch (type) {
        case HMGroupPKTableType_gas:
        {
            pointColor = [UIColor colorWithHexString:@"F79453"];
            titelStr = @"节省汽油";
            CGFloat distance = model.stepCount * 0.0006;

            targetStr = [NSString stringWithFormat:@"%.1fL",distance * 0.1];
            break;
        }
        case HMGroupPKTableType_heat:
        {
            pointColor = [UIColor colorWithHexString:@"5CAFF3"];
            titelStr = @"消耗热量";
            
            targetStr = [self configWithKaluli:kaluli];
            break;
        }
        case HMGroupPKTableType_fat:
        {
            pointColor = [UIColor colorWithHexString:@"32CABA"];
            titelStr = @"累计甩脂";
            if (PKScreening == HMGroupPKScreening_Day) {
                targetStr = [NSString stringWithFormat:@"%.fg",(kaluli / 7700) * 2 * 500];

            }
            else {
                targetStr = [NSString stringWithFormat:@"%.2f斤",(kaluli / 7700) * 2];

            }
            if (kaluli > 0) {
                targetStr = [NSString stringWithFormat:@"约%@",targetStr];
            }
            break;
        }
        case HMGroupPKTableType_praise:
        {
            pointColor = [UIColor colorWithHexString:@"F25555"];
            titelStr = @"收获的赞";
            
            targetStr = [NSString stringWithFormat:@"%ld个赞",(long)model.favourCount];
            break;
        }
        default:
            break;
    }
    
    [self.pointView setBackgroundColor:pointColor];
    [self.titelLb setText:titelStr];
    [self.vauelLb setText:targetStr];
}

- (NSString *)configWithKaluli:(CGFloat)kaluli {
    NSString *tempStr = @"";
    if (0 < kaluli && kaluli < 25) {
        tempStr = @"聊胜于无";
    }
    else if (25 <= kaluli && kaluli < 50) {
        tempStr = @"半个苹果";
    }
    else if (50 <= kaluli && kaluli < 100) {
        tempStr = @"1个苹果";
    }
    else if (100 <= kaluli && kaluli < 150) {
        tempStr = @"1盒鲜奶";
    }
    else if (150 <= kaluli && kaluli < 200) {
        tempStr = @"1个甜筒";
    }
    else if (200 <= kaluli && kaluli < 250) {
        tempStr = @"1块黑椒牛排";
    }
    else if (250 <= kaluli && kaluli < 350) {
        tempStr = @"3盒米饭";
    }
    else if (300 <= kaluli && kaluli < 350) {
        tempStr = @"1个炸鸡腿";
    }
    else if (350 <= kaluli && kaluli < 400) {
        tempStr = @"1包麦当劳中薯";
    }
    else if (400 <= kaluli && kaluli < 450) {
        tempStr = @"1盘蛋炒饭";
    }
    else if (450 <= kaluli && kaluli < 500) {
        tempStr = @"1盘鱼香肉丝";
    }
    else if (500 <= kaluli && kaluli < 550) {
        tempStr = @"1盘红焖肘子";
    }
    else if (550 <= kaluli && kaluli < 600) {
        tempStr = @"1桶康师傅红烧牛肉面";
    }
    else if (600 <= kaluli && kaluli < 650) {
        tempStr = @"2个炸鸡腿";
    }
    else if (650 <= kaluli && kaluli < 700) {
        tempStr = @"3块黑椒牛排";
    }
    else if (700 <= kaluli && kaluli < 750) {
        tempStr = @"2包麦当劳中薯";
    }
    else if (750 <= kaluli && kaluli < 800) {
        tempStr = @"4个甜筒";
    }
    else if (800 <= kaluli && kaluli < 850) {
        tempStr = @"2盘蛋炒饭";
    }
    else if (850 <= kaluli && kaluli < 900) {
        tempStr = @"3个炸鸡腿";
    }
    else if (900 <= kaluli && kaluli < 950) {
        tempStr = @"2桶康师傅红烧牛肉面";
    }
    else if (950 <= kaluli && kaluli < 1000) {
        tempStr = @"1盘回锅肉";
    }
    else if (1000 <= kaluli && kaluli < 1050) {
        tempStr = @"5个甜筒";
    }
    else if (1050 <= kaluli && kaluli < 1100) {
        tempStr = @"4块黑椒牛排";
    }
    else if (1100 <= kaluli && kaluli < 1200) {
        tempStr = @"3盘蛋炒饭";
    }
    else if (1200 <= kaluli && kaluli < 1500) {
        tempStr = @"3桶康师傅红烧牛肉面";
    }
    else if (1500 <= kaluli && kaluli < 2000) {
        tempStr = @"4包麦当劳中薯";
    }
    else if (2000 <= kaluli && kaluli < 2500) {
        tempStr = @"4盘蛋炒饭";
    }
    else if (2500 <= kaluli && kaluli < 3000) {
        tempStr = @"4桶康师傅红烧牛肉面";
    }
    else if (3000 <= kaluli && kaluli < 3500) {
        tempStr = @"3盘回锅肉";
    }
    else if (3500 <= kaluli && kaluli < 4000) {
        tempStr = @"10盘蛋炒饭";
    }
    else if (4000 <= kaluli && kaluli < 4500) {
        tempStr = @"10盘鱼香肉丝";
    }
    else if (kaluli >= 4500){
        tempStr = [NSString stringWithFormat:@"%.f盘鱼香肉丝",kaluli / 500];
    }
   
    if (tempStr.length) {
        return [NSString stringWithFormat:@"约%@",tempStr];
    }
    else {
        return @"暂无消耗";
    }
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
