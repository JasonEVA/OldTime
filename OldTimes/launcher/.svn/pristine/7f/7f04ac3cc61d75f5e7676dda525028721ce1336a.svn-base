//
//  ATManagerClockTimeCell.m
//  Clock
//
//  Created by SimonMiao on 16/7/21.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATManagerClockTimeCell.h"
#import "ATManagerClockTimeCellModel.h"

#import "UIColor+ATHex.h"
#import "UILabel+ATCreate.h"

@interface ATManagerClockTimeCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UISwitch *switchCtl;

@end

@implementation ATManagerClockTimeCell

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel at_createLabWithText:@"" fontSize:15.0 titleColor:[UIColor at_blackColor]];
    }
    
    return _titleLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel at_createLabWithText:@"" fontSize:15.0 titleColor:[UIColor at_lightGrayColor]];
    }
    
    return _timeLab;
}

- (UISwitch *)switchCtl {
    if (!_switchCtl) {
        _switchCtl = [[UISwitch alloc] init];
        [_switchCtl addTarget:self action:@selector(switchCtlClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _switchCtl;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.switchCtl];
        
        [self initConstrains];
    }
    
    return self;
}

- (void)initConstrains {
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLab);
        make.left.mas_greaterThanOrEqualTo(self.titleLab.mas_right).offset(15);
        
    }];
    
    [self.switchCtl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLab);
        make.right.mas_equalTo(self.contentView).offset(- 15);
        make.left.mas_greaterThanOrEqualTo(self.timeLab.mas_right).offset(10);
    }];
}

- (void)updateCellWithData:(id)aCellData hideHeaderLine:(BOOL)isHeaderHidden hideFooterLine:(BOOL)isFooterHidden
{
    if ([aCellData isKindOfClass:[ATManagerClockTimeCellModel class]]) {
        ATManagerClockTimeCellModel *model = (ATManagerClockTimeCellModel *)aCellData;
        self.titleLab.text = model.titleStr;
        self.timeLab.text = model.timeStr;
    }
}

- (void)switchCtlClicked {
    
}

@end
