//
//  BodyDetectStartTableViewCell.m
//  HMClient
//
//  Created by lkl on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyDetectStartTableViewCell.h"

@interface BodyDetectStartTableViewCell ()
{
    UIImageView *ivIcon;
    UILabel *lbDetectName;
    UILabel *lbDetectRecord;
    UIView* cuttinglineView;
}
@end

@implementation BodyDetectStartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivIcon = [[UIImageView alloc] init];
        [self addSubview:ivIcon];
        [ivIcon setImage:[UIImage imageNamed:@"health_icon_05"]];
        
        lbDetectName = [[UILabel alloc] init];
        [self addSubview:lbDetectName];
        [lbDetectName setTextColor:[UIColor commonTextColor]];
        
        lbDetectRecord = [[UILabel alloc] init];
        [self addSubview:lbDetectRecord];
        [lbDetectRecord setTextColor:[UIColor commonLightGrayTextColor]];
        [lbDetectRecord setFont:[UIFont font_26]];
        
        cuttinglineView = [[UIView alloc] init];
        [self addSubview:cuttinglineView];
        [cuttinglineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        
        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [lbDetectName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivIcon.mas_right).with.offset(10);
        make.top.mas_equalTo(10*kScreenScale);
    }];
    
    [lbDetectRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbDetectName.mas_left);
        make.top.equalTo(lbDetectName.mas_bottom).with.offset(5);
    }];

    [cuttinglineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.mas_bottom).with.offset(-0.5);
    }];
}

- (void)setDetectName:(NSString *)name
{
    [lbDetectName setText:[NSString stringWithFormat:@"%@",name]];
}

- (void)setImageCode:(NSString *)code
{
    NSString *kpiCode = code;
    NSString *imageName = nil;
    if ([kpiCode isEqualToString:@"XY"]){
        imageName = @"health_icon_01";
    }
    else if ([kpiCode isEqualToString:@"TZ"]){
        imageName = @"health_icon_03";
    }
    else if ([kpiCode isEqualToString:@"XL"]){
        imageName = @"health_icon_02";
    }
    else if ([kpiCode isEqualToString:@"XD"]){
        imageName = @"health_icon_electrocardiogram";
    }
    else if ([kpiCode isEqualToString:@"XT"]){
        imageName = @"health_icon_09";
    }
    else if ([kpiCode isEqualToString:@"XZ"]){
        imageName = @"health_icon_11";
    }
    else if ([kpiCode isEqualToString:@"NL"]){
        imageName = @"health_icon_05";
    }
    else if ([kpiCode isEqualToString:@"HX"]){
        imageName = @"health_icon_12";
    }
    else if ([kpiCode isEqualToString:@"OXY"]){
        imageName = @"health_icon_04";
    }
    else if ([kpiCode isEqualToString:@"TEM"]){
        imageName = @"health_icon_temperature1";
    }
    else if ([kpiCode isEqualToString:@"FLSZ"]){
        imageName = @"health_icon_pef1";
    }
    
    //
    else if ([kpiCode isEqualToString:@"SURVEY"]){
        imageName = @"health_icon_10";
    }
    else if ([kpiCode isEqualToString:@"NUTRITION"]){
        imageName = @"health_icon_07";
    }
    else if ([kpiCode isEqualToString:@"SPORTS"]){
        imageName = @"health_icon_08";
    }
    else if ([kpiCode isEqualToString:@"MENTALITY"]){
        imageName = @"health_icon_13";
    }
    else if ([kpiCode isEqualToString:@"DRUGS"]){   //记服药
        imageName = @"health_icon_06";
    }
    else{
        
        imageName = @"";
    }
    
    [ivIcon setImage:[UIImage imageNamed:imageName]];
}

- (void)setDetectRecord:(NSString *)record
{
    if (record.length == 0) {
        return ;
    }
    
    [lbDetectRecord setText:record];
        
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    [lineView setBackgroundColor:[UIColor commonRedColor]];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.width.mas_equalTo(3);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

@end

@interface BodyDetectOtherStartTableViewCell ()
{
    UIImageView *ivIcon;
    UILabel *lbDetectName;
    UIView* cuttinglineView;
}
@end

@implementation BodyDetectOtherStartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivIcon = [[UIImageView alloc] init];
        [self addSubview:ivIcon];
        [ivIcon setImage:[UIImage imageNamed:@"health_icon_05"]];
        
        lbDetectName = [[UILabel alloc] init];
        [self addSubview:lbDetectName];
        [lbDetectName setTextColor:[UIColor commonTextColor]];
        
        cuttinglineView = [[UIView alloc] init];
        [self addSubview:cuttinglineView];
        [cuttinglineView setBackgroundColor:[UIColor commonCuttingLineColor]];

        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [lbDetectName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivIcon.mas_right).with.offset(10);
        make.centerY.equalTo(self);
    }];
    
    [cuttinglineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0.5);
    }];
}

- (void)setDetectName:(NSString *)name
{
    [lbDetectName setText:[NSString stringWithFormat:@"%@",name]];
}

- (void)setImageCode:(NSString *)code
{
    NSString *kpiCode = code;
    NSString *imageName = nil;
    if ([kpiCode isEqualToString:@"XY"]){
        imageName = @"health_icon_01";
    }
    else if ([kpiCode isEqualToString:@"TZ"]){
        imageName = @"health_icon_03";
    }
    else if ([kpiCode isEqualToString:@"XL"]){
        imageName = @"health_icon_02";
    }
    else if ([kpiCode isEqualToString:@"XD"]){
        imageName = @"health_icon_electrocardiogram";
    }
    else if ([kpiCode isEqualToString:@"XT"]){
        imageName = @"health_icon_09";
    }
    else if ([kpiCode isEqualToString:@"XZ"]){
        imageName = @"health_icon_11";
    }
    else if ([kpiCode isEqualToString:@"NL"]){
        imageName = @"health_icon_05";
    }
    else if ([kpiCode isEqualToString:@"HX"]){
        imageName = @"health_icon_12";
    }
    else if ([kpiCode isEqualToString:@"OXY"]){
        imageName = @"health_icon_04";
    }
    else if ([kpiCode isEqualToString:@"TEM"]){
        imageName = @"health_icon_temperature1";
    }
    else if ([kpiCode isEqualToString:@"FLSZ"]){
        imageName = @"health_icon_pef1";
    }
    
    //
    else if ([kpiCode isEqualToString:@"SURVEY"]){
        imageName = @"health_icon_10";
    }
    else if ([kpiCode isEqualToString:@"NUTRITION"]){
        imageName = @"health_icon_07";
    }
    else if ([kpiCode isEqualToString:@"SPORTS"]){
        imageName = @"health_icon_08";
    }
    else if ([kpiCode isEqualToString:@"MENTALITY"]){
        imageName = @"health_icon_13";
    }
    else if ([kpiCode isEqualToString:@"DRUGS"]){   //记服药
        imageName = @"health_icon_06";
    }
    else{
        
        imageName = @"";
    }
    
    [ivIcon setImage:[UIImage imageNamed:imageName]];
}
@end
