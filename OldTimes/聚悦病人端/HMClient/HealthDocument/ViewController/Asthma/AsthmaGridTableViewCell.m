//
//  AsthmaGridTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 2017/7/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "AsthmaGridTableViewCell.h"

@interface AsthmaGridTableViewCell ()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, copy) NSMutableArray *objArray;
@end

@implementation AsthmaGridTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        float columnW = (ScreenWidth-25)/6;
        float gridW = (ScreenWidth-25-columnW * 1.5)/5;
        
        [self.contentView addSubview:self.dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(columnW*1.5, self.contentView.height));
        }];
        
        if (!_objArray) {
            _objArray = [NSMutableArray array];
        }
        
        for (int i = 0; i < 5; i++) {
            UIView *gridView = [UIView new];
            [self.contentView addSubview:gridView];
            [gridView showRightLine];
            [gridView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_dateLabel.mas_right).offset(i*gridW);
                make.centerY.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(gridW, self.contentView.height));
            }];
            
            UIImageView *imgView = [UIImageView new];
            [gridView addSubview:imgView];
            imgView.tag = i;
            [_objArray addObject:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(gridView);
                make.size.mas_equalTo(CGSizeMake(18, 18));
            }];
        }
        
    }
    return self;
}

- (void)setAsthmaDiaryModel:(AsthmaDiaryModel *)model
{
    [_dateLabel setText:model.date];

    [model.value enumerateObjectsUsingBlock:^(AsthmaDiaryValueModel *valueModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imgView;
        if ([valueModel.symptomName isEqualToString:@"喘息"]) {
            imgView = [_objArray objectAtIndex:0];
        }
        else if ([valueModel.symptomName isEqualToString:@"咳嗽"]) {
            imgView = [_objArray objectAtIndex:1];
        }
        else if ([valueModel.symptomName isEqualToString:@"活动受限"]) {
            imgView = [_objArray objectAtIndex:2];
        }
        else if ([valueModel.symptomName isEqualToString:@"夜间憋醒"]) {
            imgView = [_objArray objectAtIndex:3];
        }
        else{
            imgView = [_objArray objectAtIndex:4];
        }
        
        if ([valueModel.isRecord isEqualToString:@"Y"]) {
            [imgView setImage:[UIImage imageNamed:@"icon_checkbox_Selections"]];
            [imgView setHidden:NO];
        }
        else{
            [imgView setImage:[UIImage imageNamed:@""]];
            [imgView setHidden:YES];
        }
    }];
}

#pragma mark -- init
- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.numberOfLines = 0;
        [_dateLabel showRightLine];
        [_dateLabel setTextColor:[UIColor commonGrayTextColor]];
        [_dateLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _dateLabel;
}

@end
