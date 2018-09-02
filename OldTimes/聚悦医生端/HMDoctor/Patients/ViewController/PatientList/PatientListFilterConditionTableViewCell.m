//
//  PatientListFilterConditionTableViewCell.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientListFilterConditionTableViewCell.h"

@implementation PatientListFilterConditionTableViewCell

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
    if (self) {
        self.textLabel.font = [UIFont font_32];
        self.textLabel.textColor = [UIColor commonBlackTextColor_333333];
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"patientList_check"]];
    }
    return self;
}
@end
