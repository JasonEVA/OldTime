//
//  ApplyTotalDetail_headTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  申请人和审批人的详情页面的headcell

#import <UIKit/UIKit.h>
#import "ApplyDetailInformationModel.h"
typedef enum
{
    theCharger = 0,
    thePropose = 1,
}CharacterType;

@interface ApplyTotalDetail_headTableViewCell : UITableViewCell

+(NSString *)identifier;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier from:(CharacterType)charactype;
- (void)SetDataWithModel:(ApplyDetailInformationModel *)model;
@end
