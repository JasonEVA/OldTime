//
//  NewSiteMessageItemBaseTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2016/11/1.
//  Copyright © 2016年 YinQ. All rights reserved.
//  新版站内信各项目cell基类

#import <UIKit/UIKit.h>

@interface NewSiteMessageItemBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *receiveTimeLb;
@property (nonatomic, strong) UIView *cardView;      //整个卡片View
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *subTitelLb;
@property (nonatomic, strong) UIImageView *typeImage;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UILabel *rightBtn;

- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor;
@end
