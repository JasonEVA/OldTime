//
//  NewMultiAndSingleSelectedTableViewCell.m
//  launcher
//
//  Created by 马晓波 on 16/4/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMultiAndSingleSelectedTableViewCell.h"

@interface NewMultiAndSingleSelectedTableViewCell()
@property (nonatomic, assign) BOOL hasSelected;
@end

@implementation NewMultiAndSingleSelectedTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier SelectType:(SelectType)type
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.imageView setImage:[UIImage imageNamed:@"Me_uncheck"]];
        self.hasSelected = NO;
    }
    return self;
}

- (void)setModel:(MultiAndSingleStringModel *)model
{
    if (model.IsSelected)
    {
        [self.imageView setImage:[UIImage imageNamed:@"Me_check"]];
    }
    else
    {
        [self.imageView setImage:[UIImage imageNamed:@"Me_uncheck"]];
    }
}

- (void)setcellseleted
{
    self.hasSelected = !self.hasSelected;
    if (self.hasSelected)
    {
        [self.imageView setImage:[UIImage imageNamed:@"Me_check"]];
    }
    else
    {
        [self.imageView setImage:[UIImage imageNamed:@"Me_uncheck"]];
    }
}
@end
