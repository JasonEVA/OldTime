//
//  MDSDrugDetailTableViewCell.h
//  MintmedicalDrugStore
//
//  Created by jasonwang on 16/7/27.
//  Copyright © 2016年 JasonWang. All rights reserved.
//  药品详情cell

#import <UIKit/UIKit.h>

@interface MDSDrugDetailTableViewCell : UITableViewCell
+ (NSString *)at_identifier;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *detailLb;
@end
