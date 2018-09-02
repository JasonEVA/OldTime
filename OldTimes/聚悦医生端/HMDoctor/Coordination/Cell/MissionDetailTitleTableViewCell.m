//
//  MissionDetailTitleTableViewCell.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/4.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionDetailTitleTableViewCell.h"
#import "MissionDetailModel.h"

@interface MissionDetailTitleTableViewCell ()
@property (nonatomic, strong)  UIImageView  *urgentLogo; // <##>
@end

@implementation MissionDetailTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.font = [UIFont font_30];
        self.textLabel.textColor = [UIColor commonBlackTextColor_333333];
        [self setAccessoryView:self.urgentLogo];
    }
    return self;
}

- (void)configTitleCellWithModel:(MissionDetailModel *)model {
    if(model.taskStatus == TaskStatusTypeDisabled) //拒绝
    {
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *AttributeStr = [[NSMutableAttributedString alloc] initWithString:model.taskTitle attributes:attribtDic];
        self.textLabel.attributedText = AttributeStr;
        
    }
    else {
        self.textLabel.text = model.taskTitle;
    }
    self.urgentLogo.hidden = !(model.taskPriority == MissionTaskPriorityHigh);
}

#pragma mark - Init

- (UIImageView *)urgentLogo {
    if (!_urgentLogo) {
        _urgentLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiaji"]];
        _urgentLogo.hidden = YES;
    }
    return _urgentLogo;
}

@end
