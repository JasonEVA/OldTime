//
//  NewMultiAndSingleSelectedTableViewCell.h
//  launcher
//
//  Created by 马晓波 on 16/4/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiAndSingleStringModel.h"

typedef enum{
    SelectType_Single = 0,
    SelectType_Multi = 1,
    SelectType_nil = 2,
}SelectType;

@interface NewMultiAndSingleSelectedTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier SelectType:(SelectType)type;
- (void)setcellseleted:(BOOL)selected;
- (void)setModel:(MultiAndSingleStringModel *)model;
@end
