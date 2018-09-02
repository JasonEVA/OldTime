//
//  PatientListTableViewCell.h
//  HMDoctor
//
//  Created by yinquan on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientInfo.h"
#import "JWHeadImageView.h"

@class NewPatientListInfoModel;

@interface PatientListTableViewCell : UITableViewCell
{
    UILabel* lbComment;
//    UIImageView* ivPortrait;
    UILabel* lbPatientName;
    UILabel* lbPatientAge;
}
@property (nonatomic, strong) JWHeadImageView *headImageView;
@property (nonatomic, strong)  UIButton  *orderMoney; // 服务订单价格

- (void) setPatientInfo:(PatientInfo*) patient;

- (void)configPatientInfo:(PatientInfo*)patient filterKeywords:(NSString *)keywords;

- (void)configCellDataWithNewPatientListInfoModel:(NewPatientListInfoModel *)patient;
- (void)configCellDataWithNewPatientListInfoModel:(NewPatientListInfoModel *)patient filterKeywords:(NSString *)keywords;

@end
