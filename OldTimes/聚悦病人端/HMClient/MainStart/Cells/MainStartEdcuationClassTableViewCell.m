//
//  MainStartEdcuationClassTableViewCell.m
//  HMClient
//
//  Created by yinquan on 17/1/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "MainStartEdcuationClassTableViewCell.h"

@implementation MainStartEdcuationClassTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
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
