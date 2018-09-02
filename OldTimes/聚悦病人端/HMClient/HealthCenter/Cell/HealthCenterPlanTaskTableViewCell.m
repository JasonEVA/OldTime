//
//  HealthCenterPlanTaskTableViewCell.m
//  HMClient
//
//  Created by Andrew Shen on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterPlanTaskTableViewCell.h"
#import "DateUtil.h"

@interface HealthCenterPlanTaskTableViewCell ()
{
    UIView* topLine;
    UIView* downLine;
    UIView* circleview;
    
    UILabel  *lbTime;
    
    UIView* planContentView;
    UIImageView* ivContent;
    UILabel* lbTitle;
    UILabel* lbStatus;
    UIView* sepLine;
    
    UILabel* lbTitleCon;
}

@end

@implementation HealthCenterPlanTaskTableViewCell

#pragma mark - Interface Method

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        topLine = [[UIView alloc]init];
        [self.contentView addSubview:topLine];
        [topLine setBackgroundColor:[UIColor mainThemeColor]];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@1);
            make.height.mas_equalTo(@11.5);
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(53);
        }];
        
        circleview = [[UIView alloc]init];
        [circleview setBackgroundColor:[UIColor mainThemeColor]];
        [self.contentView addSubview:circleview];
        [circleview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topLine);
            make.top.equalTo(topLine.mas_bottom).with.offset(1.5);
            make.size.mas_equalTo(CGSizeMake(6, 6));
        }];
        circleview.layer.cornerRadius = 3;
        circleview.layer.masksToBounds = YES;
        
        downLine = [[UIView alloc]init];
        [downLine setBackgroundColor:[UIColor mainThemeColor]];
        [self.contentView addSubview:downLine];
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@1);
            make.top.equalTo(circleview.mas_bottom).with.offset(1.5);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(53);
        }];
        
        lbTime = [[UILabel alloc]init];
        [self.contentView addSubview:lbTime];
        [lbTime setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbTime setFont:[UIFont font_22]];
        
        [lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(circleview.mas_left).with.offset(-6);
            make.centerY.equalTo(circleview);
        }];
        
        planContentView = [[UIView alloc]init];
        [self.contentView addSubview:planContentView];
        [planContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(circleview.mas_right).with.offset(2.5);
            make.right.equalTo(self.contentView).with.offset(-14);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).with.offset(-9);
        }];
        
        ivContent = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_record_bg"]];
        [planContentView addSubview:ivContent];
        [ivContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(planContentView);
            make.top.and.bottom.equalTo(planContentView);
        }];
        
        lbTitle = [[UILabel alloc]init];
        [planContentView addSubview:lbTitle];
        [lbTitle setFont:[UIFont font_28]];
        [lbTitle setTextColor:[UIColor commonTextColor]];
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(planContentView).with.offset(23);
            make.top.equalTo(planContentView).with.offset(10);
        }];
        
        lbStatus = [[UILabel alloc]init];
        [planContentView addSubview:lbStatus];
        [lbStatus setFont:[UIFont font_24]];
        [lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lbTitle);
            make.right.equalTo(planContentView).with.offset(-14);
        }];
        
        
        lbTitleCon = [[UILabel alloc]init];
        [planContentView addSubview:lbTitleCon];
        [lbTitleCon setFont:[UIFont font_26]];
        [lbTitleCon setTextColor:[UIColor commonGrayTextColor]];
        [lbTitleCon setNumberOfLines:0];
        [lbTitleCon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbTitle);
            make.right.lessThanOrEqualTo(lbStatus.mas_right);
            make.top.equalTo(lbTitle.mas_bottom).with.offset(10);
            make.bottom.equalTo(planContentView).with.offset(-11);
        }];
    }
    return self;
}

- (void) setPlanMession:(PlanMessionListItem*) plan
{
    if ([plan.kpiCode isEqualToString:@"XL"]) {
        [lbTitle setText:@"测心电"];
        [lbTitleCon setText:@"心电"];
        
    }
    else {
        [lbTitle setText:plan.title];
        [lbTitleCon setText:plan.taskCon];
    }
    [lbTime setText:[plan excTimeString]];
    [lbStatus setText:plan.statusName];
    [lbStatus setTextColor:[plan statusColor]];
    
    if (plan.code && 0 < plan.code.length && [plan.code isEqualToString:@"REVIEW"])
    {
        [lbStatus setText:@""];
    }
}

@end
