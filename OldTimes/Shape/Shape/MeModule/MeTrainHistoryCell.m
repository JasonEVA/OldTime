//
//  MeTrainHistoryCell.m
//  Shape
//
//  Created by jasonwang on 15/11/13.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeTrainHistoryCell.h"
#import "UILabel+EX.h"
#import <Masonry.h>
#import "UIColor+Hex.h"

@implementation MeTrainHistoryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.dateLb];
        [self.contentView addSubview:self.timeLb];
        [self.contentView addSubview:self.detailView];
        [self.contentView addSubview:self.point];
        
        [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(18);
            make.centerY.equalTo(self.contentView);
        }];
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateLb.mas_bottom).offset(5);
            make.centerX.equalTo(self.dateLb);
        }];
        
        [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(16);
            make.left.equalTo(self.dateLb.mas_right).offset(20);
        }];

        
        [self.point mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_left).offset(70);
            make.centerY.equalTo(self.detailView);
            make.width.height.mas_equalTo(7);
        }];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(70, 0)];
    [path addLineToPoint:CGPointMake(70, self.frame.size.height)];
    [path setLineWidth:1];
    [[UIColor themeBackground_373737] setStroke];
    [path stroke];

}

- (void)setMyContent:(MeTrainHistoryDetailModel *)model
{
    [self.detailView setMyContent:model];
//    NSDateFormatter *dateFor = [[NSDateFormatter alloc]init];
//    [dateFor setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date = [dateFor dateFromString:model.completionTime];
//    [self.dateLb setText:[NSString stringWithFormat:@"%@",date]];
//    [dateFor setDateFormat:@"HH:mm"];
//    [self.timeLb setText:[dateFor stringFromDate:model.completionTime]];
}

- (UILabel *)dateLb
{
    if (!_dateLb) {
        _dateLb = [UILabel setLabel:_dateLb text:@"08-01" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
    }
    return _dateLb;
}

- (UILabel *)timeLb
{
    if (!_timeLb) {
        _timeLb = [UILabel setLabel:_timeLb text:@"19:20" font:[UIFont systemFontOfSize:14] textColor:[UIColor colorLightGray_898888]];
    }
    return _timeLb;
}

- (MeTrainHistoryDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[MeTrainHistoryDetailView alloc]init];
        _detailView.layer.cornerRadius = 5;
    }
    return _detailView;
}


- (MePointView *)point
{
    if (!_point) {
        _point = [[MePointView alloc]init];
    }
    return _point;
}
@end
