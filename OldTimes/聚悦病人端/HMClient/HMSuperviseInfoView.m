//
//  HMSuperviseInfoView.m
//  HMClient
//
//  Created by jasonwang on 2017/7/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSuperviseInfoView.h"
#import "HMSuperviseDetailModel.h"
#import <NSDate+DateTools.h>
#import "NSAttributedString+EX.h"
#import "HMSuperviseEachPointModel.h"

@interface HMSuperviseInfoView ()
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIImageView *arrowView;
@end

@implementation HMSuperviseInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.userInteractionEnabled = YES;
        [self addSubview:self.infoView];
        [self addSubview:self.arrowView];

    }
    return self;
}

- (void)showInfoViewWithArrowXCenter:(CGFloat)XCenter Model:(HMSuperviseDetailModel *)model superviseScreening:(SESuperviseScreening)type kpiCode:(NSString *)kpiCode {
    
    if ([kpiCode isEqualToString:@"XT"]) {
        // 血糖单独处理
        [self fillXTDataXCenter:XCenter Model:model superviseScreening:type];
        return;
    }
    
    if ([kpiCode isEqualToString:@"FLSZ"] && (type !=SESuperviseScreening_Default)) {
        // 呼气峰流速值除按次默认值外，单独处理
        [self fillFLSZDataXCenter:XCenter Model:model superviseScreening:type];
        return;
    }
    
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(35);
        make.width.equalTo(@170).priority(200);
        make.left.greaterThanOrEqualTo(self).offset(5).priority(200);
        make.right.lessThanOrEqualTo(self).offset(-5).priority(200);
        make.centerX.equalTo(self.mas_left).offset(XCenter).priority(100);
    }];
    UILabel *targetLb = [self acquireLabelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"ffffff"] text:@""];
    [targetLb setNumberOfLines:0];
    
    UILabel *tastResult = [self acquireLabelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"ffffff"] text:@""];
    [tastResult setNumberOfLines:0];
    
    if ([kpiCode isEqualToString:@"XY"]) {
        // 血压
        __block NSString *szyStr = @"";
        __block NSString *ssyStr = @"";

        [model.datalist enumerateObjectsUsingBlock:^(HMSuperviseEachPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.subKpiCode isEqualToString:@"SSY"]) {
                ssyStr = obj.testValue;
            }
            if ([obj.subKpiCode isEqualToString:@"SZY"]) {
                szyStr = obj.testValue;
            }
        }];
        
        [targetLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@/%@mmHg",ssyStr,szyStr] UnChangePart:@"mmHg" changePart:[NSString stringWithFormat:@"%@/%@",ssyStr,szyStr] changeColor:[UIColor colorWithHexString:@"ffffff"] changeFont:[UIFont systemFontOfSize:20]]];
        
        NSString *testCont = @"";
        if (model.testCount > 1) {
            testCont = [NSString stringWithFormat:@"(连续%ld次平均值)",(long)model.testCount];
        }
        else {
            testCont = @"";
        }
        
        [tastResult setText:[NSString stringWithFormat:@"%@%@",model.datalist.firstObject.testResult,testCont]];
    }
    else if ([kpiCode isEqualToString:@"XL"]) {
        // 心率
        [targetLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@次/分",model.datalist.firstObject.testValue] UnChangePart:@"次/分" changePart:[NSString stringWithFormat:@"%@",model.datalist.firstObject.testValue] changeColor:[UIColor colorWithHexString:@"ffffff"] changeFont:[UIFont systemFontOfSize:20]]];
        [tastResult setText:[NSString stringWithFormat:@"%@",model.datalist.firstObject.testResult]];
    }
    else if ([kpiCode isEqualToString:@"TZ"]) {
        // 体重
        [targetLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@kg",model.datalist.firstObject.testValue] UnChangePart:@"kg" changePart:[NSString stringWithFormat:@"%@",model.datalist.firstObject.testValue] changeColor:[UIColor colorWithHexString:@"ffffff"] changeFont:[UIFont systemFontOfSize:20]]];
        [tastResult setText:[NSString stringWithFormat:@"%@",model.datalist.firstObject.testResult]];
    }
    else if ([kpiCode isEqualToString:@"OXY"]) {
        // 血氧
        [targetLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@%%",model.datalist.firstObject.testValue] UnChangePart:@"%%" changePart:[NSString stringWithFormat:@"%@",model.datalist.firstObject.testValue] changeColor:[UIColor colorWithHexString:@"ffffff"] changeFont:[UIFont systemFontOfSize:20]]];
        [tastResult setText:[NSString stringWithFormat:@"%@",model.datalist.firstObject.testResult]];
    }
    else if ([kpiCode isEqualToString:@"TEM"]) {
        // 体温
        [targetLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@℃",model.datalist.firstObject.testValue] UnChangePart:@"℃" changePart:[NSString stringWithFormat:@"%@",model.datalist.firstObject.testValue] changeColor:[UIColor colorWithHexString:@"ffffff"] changeFont:[UIFont systemFontOfSize:20]]];
        [tastResult setText:[NSString stringWithFormat:@"%@",model.datalist.firstObject.testResult]];
    }
    else if ([kpiCode isEqualToString:@"NL"]) {
        // 尿量
        __block NSString *day = nil;
        __block NSString *night = nil;
        
        [model.datalist enumerateObjectsUsingBlock:^(HMSuperviseEachPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.subKpiCode isEqualToString:@"NL_SUB_DAY"] && obj.testValue.floatValue > 0) {
                day = obj.testValue;
            }
            if ([obj.subKpiCode isEqualToString:@"NL_SUB_NIGHT"] && obj.testValue.floatValue > 0) {
                night = obj.testValue;
            }
        }];
        NSString *testVeaul = @"";
        NSString *titel = @"";
        
        if (day && night) {
            testVeaul = [NSString stringWithFormat:@"%@/%@",day,night];
            titel = @"日/夜";
        }
        else if (day) {
            testVeaul = day;
            titel = @"日";
        }
        else if (night) {
            testVeaul = night;
            titel = @"夜";
        }
        [targetLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@ml",testVeaul] UnChangePart:@"ml" changePart:[NSString stringWithFormat:@"%@",testVeaul] changeColor:[UIColor colorWithHexString:@"ffffff"] changeFont:[UIFont systemFontOfSize:20]]];
        
        [tastResult setText:titel];

    }
        else if ([kpiCode isEqualToString:@"HX"]) {
        // 呼吸
            [targetLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@次/分",model.datalist.firstObject.testValue] UnChangePart:@"次/分" changePart:[NSString stringWithFormat:@"%@",model.datalist.firstObject.testValue] changeColor:[UIColor colorWithHexString:@"ffffff"] changeFont:[UIFont systemFontOfSize:20]]];
            [tastResult setText:[NSString stringWithFormat:@"%@",model.datalist.firstObject.testResult]];

            
    }
        else if ([kpiCode isEqualToString:@"FLSZ"]) {
            // 峰流速值
            NSString *testResultTime = @"";
            if (model.datalist.firstObject.timeStage == 0) {
                testResultTime = @"早:";
            }
            else if (model.datalist.firstObject.timeStage == 1) {
                testResultTime = @"晚:";

            }
            else {
                testResultTime = @"其他:";

            }
            [targetLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@%@L/min",testResultTime,model.datalist.firstObject.testValue] UnChangePart:@"L/min" changePart:[NSString stringWithFormat:@"%@%@",testResultTime,model.datalist.firstObject.testValue] changeColor:[UIColor colorWithHexString:@"ffffff"] changeFont:[UIFont systemFontOfSize:20]]];
            [tastResult setText:[NSString stringWithFormat:@"%@",model.datalist.firstObject.testResult]];
        }

   
    
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.startday/1000];
    
    UILabel *timeLb = [self acquireLabelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"ffffff" alpha:0.6] text:[date formattedDateWithFormat:@"yyyy年MM月dd日 HH:mm"]];
    NSString *timeStr = @"";
    switch (type) {
        case SESuperviseScreening_Default:
        {
            if ([kpiCode isEqualToString:@"NL"]) {
                // 尿量不显示时间
                timeStr = [date formattedDateWithFormat:@"yyyy年MM月dd日"];

            }
            else {
                timeStr = [date formattedDateWithFormat:@"yyyy年MM月dd日 HH:mm"];

            }
            break;
        }
        case SESuperviseScreening_Day:
        {
            timeStr = [NSString stringWithFormat:@"%@平均值",[date formattedDateWithFormat:@"yyyy年MM月dd日"]];
            break;
        }
        case SESuperviseScreening_Week:
        {
            NSDate *sunday = [date dateByAddingDays:6];
            NSString *sundayFormat = @"";
            NSInteger year = [date formattedDateWithFormat:@"yyyy"].integerValue;
            NSInteger month = [date formattedDateWithFormat:@"MM"].integerValue;
            NSInteger sundayYear = [sunday formattedDateWithFormat:@"yyyy"].integerValue;
            NSInteger sundayMonth = [sunday formattedDateWithFormat:@"MM"].integerValue;
            
            if (sundayYear - year > 0) {
                // 跨年，显示年月日
                sundayFormat = @"yyyy年MM月dd日";
            }
            else if ((sundayMonth - month > 0) && (sundayYear - year == 0))  {
                // 跨月显示月日
                sundayFormat = @"MM月dd日";
            }
            else {
                sundayFormat = @"dd日";
            }
            timeStr = [NSString stringWithFormat:@"%@-%@平均值",[date formattedDateWithFormat:@"yyyy年MM月dd日"],[sunday formattedDateWithFormat:sundayFormat]];

            break;
        }
        case SESuperviseScreening_Month:
        {
            timeStr = [NSString stringWithFormat:@"%@平均值",[date formattedDateWithFormat:@"yyyy年MM月"]];
            break;
        }
            
        default:
            break;
    }
    [timeLb setText:timeStr];
    [timeLb setNumberOfLines:0];
    [self.infoView addSubview:targetLb];
    [self.infoView addSubview:tastResult];
    [self.infoView addSubview:timeLb];
    
    [targetLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.infoView).offset(10);
        make.right.equalTo(self.infoView).offset(-10);
    }];
    
    [tastResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(targetLb);
        make.top.equalTo(targetLb.mas_bottom).offset(7);
        make.right.equalTo(self.infoView).offset(-10);
    }];
    
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(targetLb);
        make.top.equalTo(tastResult.mas_bottom).offset(7);
        make.right.equalTo(self.infoView).offset(-10);
        make.bottom.lessThanOrEqualTo(self.infoView).offset(-15);
    }];
    
    
    
    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom);
        make.centerX.equalTo(self.mas_left).offset(XCenter);
    }];
}

- (void)fillXTDataXCenter:(CGFloat)XCenter Model:(HMSuperviseDetailModel *)model superviseScreening:(SESuperviseScreening)type {
        // 血糖
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(35);
        make.width.equalTo(@170).priority(200);
        make.left.greaterThanOrEqualTo(self).offset(5).priority(200);
        make.right.lessThanOrEqualTo(self).offset(-5).priority(200);
        make.centerX.equalTo(self.mas_left).offset(XCenter).priority(100);
    }];
__weak typeof(self) weakSelf = self;
    __block UIView *lastView;
    [model.datalist enumerateObjectsUsingBlock:^(HMSuperviseEachPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UILabel *targetLbOne = [strongSelf acquireLabelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"ffffff"] text:@""];
        [targetLbOne setNumberOfLines:0];
        
        UILabel *tastResultOne = [strongSelf acquireLabelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"ffffff"] text:@""];
        [tastResultOne setNumberOfLines:0];
        
        [targetLbOne setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@mmol/L",obj.testValue] UnChangePart:@"mmol/L" changePart:[NSString stringWithFormat:@"%@",obj.testValue] changeColor:[UIColor colorWithHexString:@"ffffff"] changeFont:[UIFont systemFontOfSize:20]]];
        NSString *resultStr = @"";
        if (obj.testTimeName.length) {
            resultStr = [NSString stringWithFormat:@"%@（%@）",obj.testResult,obj.testTimeName];
        }
        else {
            resultStr = obj.testResult;
        }
        [tastResultOne setText:resultStr];
        [strongSelf.infoView addSubview:targetLbOne];
        [strongSelf.infoView addSubview:tastResultOne];
        if (!idx) {
            [targetLbOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(strongSelf.infoView).offset(10);
                make.right.equalTo(strongSelf.infoView).offset(-10);
            }];

        }
        else {
            [targetLbOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(strongSelf.infoView).offset(10);
                make.top.equalTo(lastView.mas_bottom).offset(10);
                make.right.equalTo(strongSelf.infoView).offset(-10);
            }];
            
        }
        [tastResultOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(targetLbOne);
            make.top.equalTo(targetLbOne.mas_bottom).offset(7);
            make.right.equalTo(strongSelf.infoView).offset(-10);
        }];
        lastView = tastResultOne;
    }];
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.startday/1000];
    
    UILabel *timeLb = [self acquireLabelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"ffffff" alpha:0.6] text:[date formattedDateWithFormat:@"yyyy年MM月dd日 HH:mm"]];
    NSString *timeStr = @"";
    
    switch (type) {
        case SESuperviseScreening_Default:
        {
            timeStr = [date formattedDateWithFormat:@"yyyy年MM月dd日 HH:mm"];
            break;
        }
        case SESuperviseScreening_Day:
        {
            timeStr = [NSString stringWithFormat:@"%@平均值",[date formattedDateWithFormat:@"yyyy年MM月dd日"]];
            break;
        }
        case SESuperviseScreening_Week:
        {
            NSDate *sunday = [date dateByAddingDays:6];
            NSString *sundayFormat = @"";
            NSInteger year = [date formattedDateWithFormat:@"yyyy"].integerValue;
            NSInteger month = [date formattedDateWithFormat:@"MM"].integerValue;
            NSInteger sundayYear = [sunday formattedDateWithFormat:@"yyyy"].integerValue;
            NSInteger sundayMonth = [sunday formattedDateWithFormat:@"MM"].integerValue;
            
            if (sundayYear - year > 0) {
                // 跨年，显示年月日
                sundayFormat = @"yyyy年MM月dd日";
            }
            else if ((sundayMonth - month > 0) && (sundayYear - year == 0))  {
                // 跨月显示月日
                sundayFormat = @"MM月dd日";
            }
            else {
                sundayFormat = @"dd日";
            }
            timeStr = [NSString stringWithFormat:@"%@-%@平均值",[date formattedDateWithFormat:@"yyyy年MM月dd日"],[sunday formattedDateWithFormat:sundayFormat]];
            
            break;
        }
        case SESuperviseScreening_Month:
        {
            timeStr = [NSString stringWithFormat:@"%@平均值",[date formattedDateWithFormat:@"yyyy年MM月"]];
            break;
        }
            
        default:
            break;
    }
    [timeLb setText:timeStr];
    [timeLb setNumberOfLines:0];
    [self.infoView addSubview:timeLb];

    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastView);
        make.top.equalTo(lastView.mas_bottom).offset(7);
        make.right.equalTo(self.infoView).offset(-10);
        make.bottom.lessThanOrEqualTo(self.infoView).offset(-15);
    }];
    
    
    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom);
        make.centerX.equalTo(self.mas_left).offset(XCenter);
    }];

    

}

- (void)fillFLSZDataXCenter:(CGFloat)XCenter Model:(HMSuperviseDetailModel *)model superviseScreening:(SESuperviseScreening)type {
    // 呼气峰流速值
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(35);
        make.width.equalTo(@170).priority(200);
        make.left.greaterThanOrEqualTo(self).offset(5).priority(200);
        make.right.lessThanOrEqualTo(self).offset(-5).priority(200);
        make.centerX.equalTo(self.mas_left).offset(XCenter).priority(100);
    }];
    __weak typeof(self) weakSelf = self;
    __block UIView *lastView;
    [model.datalist enumerateObjectsUsingBlock:^(HMSuperviseEachPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UILabel *targetLbOne = [strongSelf acquireLabelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"ffffff"] text:@""];
        [targetLbOne setNumberOfLines:0];
        
        NSString *testResultTime = @"";
        if (obj.timeStage == 0) {
            testResultTime = @"早:";
        }
        else if (obj.timeStage == 1) {
            testResultTime = @"晚:";
            
        }
        else {
            testResultTime = @"其他:";
            
        }

        [targetLbOne setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@%@L/min",testResultTime,obj.testValue] UnChangePart:@"L/min" changePart:[NSString stringWithFormat:@"%@%@",testResultTime,obj.testValue] changeColor:[UIColor colorWithHexString:@"ffffff"] changeFont:[UIFont systemFontOfSize:20]]];
        [strongSelf.infoView addSubview:targetLbOne];
        if (!idx) {
            [targetLbOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(strongSelf.infoView).offset(10);
                make.right.equalTo(strongSelf.infoView).offset(-10);
            }];
            
        }
        else {
            [targetLbOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(strongSelf.infoView).offset(10);
                make.top.equalTo(lastView.mas_bottom).offset(10);
                make.right.equalTo(strongSelf.infoView).offset(-10);
            }];
            
        }
        lastView = targetLbOne;
    }];
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.startday/1000];
    
    UILabel *timeLb = [self acquireLabelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"ffffff" alpha:0.6] text:[date formattedDateWithFormat:@"yyyy年MM月dd日 HH:mm"]];
    NSString *timeStr = @"";
    
    switch (type) {
        case SESuperviseScreening_Default:
        {
            timeStr = [date formattedDateWithFormat:@"yyyy年MM月dd日 HH:mm"];
            break;
        }
        case SESuperviseScreening_Day:
        {
            timeStr = [NSString stringWithFormat:@"%@平均值",[date formattedDateWithFormat:@"yyyy年MM月dd日"]];
            break;
        }
        case SESuperviseScreening_Week:
        {
            NSDate *sunday = [date dateByAddingDays:6];
            NSString *sundayFormat = @"";
            NSInteger year = [date formattedDateWithFormat:@"yyyy"].integerValue;
            NSInteger month = [date formattedDateWithFormat:@"MM"].integerValue;
            NSInteger sundayYear = [sunday formattedDateWithFormat:@"yyyy"].integerValue;
            NSInteger sundayMonth = [sunday formattedDateWithFormat:@"MM"].integerValue;
            
            if (sundayYear - year > 0) {
                // 跨年，显示年月日
                sundayFormat = @"yyyy年MM月dd日";
            }
            else if ((sundayMonth - month > 0) && (sundayYear - year == 0))  {
                // 跨月显示月日
                sundayFormat = @"MM月dd日";
            }
            else {
                sundayFormat = @"dd日";
            }
            timeStr = [NSString stringWithFormat:@"%@-%@平均值",[date formattedDateWithFormat:@"yyyy年MM月dd日"],[sunday formattedDateWithFormat:sundayFormat]];
            
            break;
        }
        case SESuperviseScreening_Month:
        {
            timeStr = [NSString stringWithFormat:@"%@平均值",[date formattedDateWithFormat:@"yyyy年MM月"]];
            break;
        }
            
        default:
            break;
    }
    [timeLb setText:timeStr];
    [timeLb setNumberOfLines:0];
    [self.infoView addSubview:timeLb];
    
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastView);
        make.top.equalTo(lastView.mas_bottom).offset(7);
        make.right.equalTo(self.infoView).offset(-10);
        make.bottom.lessThanOrEqualTo(self.infoView).offset(-15);
    }];
    
    
    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom);
        make.centerX.equalTo(self.mas_left).offset(XCenter);
    }];
    
    
    
}

- (UILabel *)acquireLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text {
    UILabel *label = [UILabel new];
    [label setText:text];
    [label setFont:font];
    [label setTextColor:textColor];
    return label;
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [UIView new];
        [_infoView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.65]];
        [_infoView.layer setCornerRadius:4];
    }
    return _infoView;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_kuang"]];
    }
    return _arrowView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
