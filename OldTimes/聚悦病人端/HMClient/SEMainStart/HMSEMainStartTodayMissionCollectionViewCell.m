//
//  HMSEMainStartTodayMissionCollectionViewCell.m
//  HMClient
//
//  Created by JasonWang on 2017/5/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSEMainStartTodayMissionCollectionViewCell.h"
#import "PlanMessionListItem.h"

@interface HMSEMainStartTodayMissionCollectionViewCell ()
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *btnLb;
@property (nonatomic, strong) UIImageView *unFinishImageView;
@property (nonatomic, strong) UILabel *detailLb;
@end

@implementation HMSEMainStartTodayMissionCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.timeLb];
        [self.backView addSubview:self.titelLb];
        [self.backView addSubview:self.btnLb];
        [self.backView addSubview:self.unFinishImageView];
        [self.backView addSubview:self.detailLb];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).offset(12);
            make.top.equalTo(self.backView).offset(7);
            make.right.lessThanOrEqualTo(self.backView).offset(-10);
        }];
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.titelLb.mas_bottom).offset(3);
        }];
        
        [self.btnLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.timeLb.mas_bottom).offset(5);
            make.height.equalTo(@21);
            make.width.equalTo(@55);
        }];
        
        
        [self.unFinishImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.backView);
        }];
        
        [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.titelLb.mas_bottom).offset(10);
            make.width.equalTo(@130);
            make.bottom.lessThanOrEqualTo(self.backView).offset(-15);
        }];
        
    }
    return self;
}

#pragma mark -private method
- (void)configElements {
}

- (void)setImageCode:(PlanMessionListItem *)model
{
    NSString *code = model.code;

    NSString *imageName = nil;
    NSString *timeString = @"";
    if ([code isEqualToString:@"TEST"]) {
        
        NSString *kpiCode = model.kpiCode;

        if ([kpiCode isEqualToString:@"XY"]){
            imageName = @"SEMainStartcard_xueya";
        }
        else if ([kpiCode isEqualToString:@"TZ"]){
            imageName = @"SEMainStartcard_tizhong";
        }
        else if ([kpiCode isEqualToString:@"XL"]){
            imageName = @"SEMainStartcard_xinlv";
        }
        else if ([kpiCode isEqualToString:@"XT"]){
            imageName = @"SEMainStartcard_xeutang";
        }
        else if ([kpiCode isEqualToString:@"XZ"]){
            imageName = @"SEMainStartcard_xuezhi";
        }
        else if ([kpiCode isEqualToString:@"NL"]){
            imageName = @"SEMainStartcard_niaoliang";
        }
        else if ([kpiCode isEqualToString:@"HX"]){
            imageName = @"SEMainStartcard_huxi";
        }
        else if ([kpiCode isEqualToString:@"OXY"]){
            imageName = @"SEMainStartcard_xeuyang";
        }
        else if ([kpiCode isEqualToString:@"TEM"]){
            imageName = @"SEMainStartcard_tiwen";
        }
        else if ([kpiCode isEqualToString:@"FLSZ"]){
            imageName = @"SEMainStartcard_fengliu";
        }
        else {
            imageName = @"SEMainStartcard_tiwen";
        }
        timeString = [model excTimeString];
    }
    //
    else if ([code isEqualToString:@"SURVEY"]){  // 随访
        imageName = @"SEMainStartcard_suifang";
        timeString = [model excTimeString];
    }
    else if ([code isEqualToString:@"NUTRITION"]){  // 饮食
        imageName = @"SEMainStartcard_yinshi";
        timeString = @"合理饮食很重要";
    }
    else if ([code isEqualToString:@"SPORTS"]){  // 运动
        imageName = @"SEMainStartcard_yundong";
        timeString = model.taskCon;

    }
    else if ([code isEqualToString:@"MENTALITY"]){ // 心情
        imageName = @"SEMainStartcard_xinqing";
        timeString = @"你今天心情如何？";

    }
    else if ([code isEqualToString:@"DRUGS"]){   //记服药
        imageName = @"SEMainStartcard_yongyoa";
        timeString = @"今天别忘了吃药哦";

    }
    else if ([code isEqualToString:@"ASSESSMENT"]){   //评估
        imageName = @"SEMainStartcard_pinggu";
        timeString = [model excTimeString];

    }
    else if ([code isEqualToString:@"REVIEW"]){   //复查
        imageName = @"SEMainStartcard_fucha";
        timeString = [model excTimeString];

    }
    else{
        
        imageName = @"SEMainStartcard_suifang";
        timeString = [model excTimeString];

    }
    
    [self.backView setImage:[UIImage imageNamed:imageName]];
    [self.timeLb setText:timeString];

}

#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)fillDataWithModel:(PlanMessionListItem *)model {
    [self.detailLb setHidden:![model.code isEqualToString:@"REVIEW"]];
    [self.btnLb setHidden:[model.code isEqualToString:@"REVIEW"]];
    [self.timeLb setHidden:[model.code isEqualToString:@"REVIEW"]];
    [self.unFinishImageView setHidden:[model.code isEqualToString:@"REVIEW"]];
    
    [self setImageCode:model];

//    if ([model.kpiCode isEqualToString:@"XL"]) {
//        [self.titelLb setText:@"测心电"];
//
//    }
//    else {
    [self.titelLb setText:model.title];
//    }
    
    if ([model.code isEqualToString:@"REVIEW"]) {
    // 复查
        [self.detailLb setText:model.taskCon];
    }
    else {
        if ([model.status isEqualToString:@"0"]) {
            [self.btnLb setText:model.statusName];
        }
        else {
            [self.btnLb setText:@"待记录"];
        }
        [self.unFinishImageView setHidden:![model.status isEqualToString:@"3"]];
    }
    
}
#pragma mark - init UI
- (UIImageView *)backView {
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEMainStartcard_suifang"]];
    }
    return _backView;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_titelLb setFont:[UIFont systemFontOfSize:17]];
    }
    return _titelLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [UILabel new];
        [_timeLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_timeLb setFont:[UIFont systemFontOfSize:14]];
        [_timeLb setAlpha:0.8];
    }
    return _timeLb;
}

- (UILabel *)btnLb {
    if (!_btnLb) {
        _btnLb = [UILabel new];
        [_btnLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_btnLb setFont:[UIFont systemFontOfSize:13]];
        [_btnLb.layer setBorderColor:[[UIColor colorWithHexString:@"ffffff"] CGColor]];
        [_btnLb.layer setBorderWidth:0.5];
        [_btnLb.layer setCornerRadius:10];
        [_btnLb setTextAlignment:NSTextAlignmentCenter];
        [_btnLb setClipsToBounds:YES];
    }
    return _btnLb;
}

- (UIImageView *)unFinishImageView {
    if (!_unFinishImageView) {
        _unFinishImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEMainStartim_nofinish"]];
    }
    return _unFinishImageView;
}

- (UILabel *)detailLb {
    if (!_detailLb) {
        _detailLb = [UILabel new];
        [_detailLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_detailLb setFont:[UIFont systemFontOfSize:14]];
        [_detailLb setNumberOfLines:2];
    }
    return _detailLb;
}
@end
