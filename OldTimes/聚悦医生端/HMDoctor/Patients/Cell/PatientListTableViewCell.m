//
//  PatientListTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientListTableViewCell.h"
#import "NewPatientListInfoModel.h"

@interface PatientListTableViewCell ()
{
 
//    UILabel* lbDisease;
//    
//    UILabel* lbDetectTime;
    
    
}
@property (nonatomic, strong)  UIButton  *btnIllDiagnose; // 病名

@end

@implementation PatientListTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.headImageView = [[JWHeadImageView alloc]init];
        [self.contentView addSubview:self.headImageView];
        
        lbPatientName = [[UILabel alloc]init];
        [self.contentView addSubview:lbPatientName];
        [lbPatientName setFont:[UIFont font_32]];
        [lbPatientName setTextColor:[UIColor commonBlackTextColor_333333]];
        
        lbPatientAge = [[UILabel alloc]init];
        [self.contentView addSubview:lbPatientAge];
        [lbPatientAge setFont:[UIFont font_30]];
        [lbPatientAge setTextColor:[UIColor commonBlackTextColor_333333]];
        
//        lbComment = [[UILabel alloc]init];
//        [self.contentView addSubview:lbComment];
//        [lbComment setFont:[UIFont font_28]];
//        [lbComment setTextColor:[UIColor commonGrayTextColor]];
        
        [self.contentView addSubview:self.btnIllDiagnose];
        [self.contentView addSubview:self.orderMoney];

        /*
        lbDetectTime = [[UILabel alloc]init];
        [self.contentView addSubview:lbDetectTime];
        [lbDetectTime setFont:[UIFont systemFontOfSize:12]];
        [lbDetectTime setTextColor:[UIColor commonGrayTextColor]];
        
        lbDisease = [[UILabel alloc]init];
        [self.contentView addSubview:lbDisease];
        [lbDisease setFont:[UIFont systemFontOfSize:11]];
        [lbDisease setTextColor:[UIColor commonGrayTextColor]];
        */
        [self subviewsLayout];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) subviewsLayout
{
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12.5);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.centerY.equalTo(self.contentView);
    }];
    
    [lbPatientName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).with.offset(7);
        make.top.equalTo(self.headImageView).with.offset(2.5);
    }];
    
    [lbPatientAge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPatientName.mas_right).offset(10);
        make.centerY.equalTo(lbPatientName);
    }];
    
//    [lbComment mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(lbPatientName);
//        make.top.equalTo(lbPatientName.mas_bottom).with.offset(3.5);
//        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
//        
//    }];
    
    [self.orderMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lbPatientName);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.greaterThanOrEqualTo(lbPatientAge.mas_right).offset(3);
    }];
    
    [self.btnIllDiagnose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPatientName);
        make.top.equalTo(lbPatientName.mas_bottom).with.offset(3.5);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    // 设置优先级
    
    [lbPatientName setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [lbPatientAge setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.orderMoney setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
//    [lbDetectTime mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(lbComment.mas_right).with.offset(2);
//        make.top.equalTo(lbComment);
//        
//        
//
//    }];
//    
//    [lbDisease mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView).with.offset(-12.5);
//        make.bottom.equalTo(lbComment);
//        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
//    }];
}

- (void) setPatientInfo:(PatientInfo*) patient
{
    [lbPatientName setText:patient.userName];
    if (!patient.userName || 0 == patient.userName.length)
    {
        [lbPatientName setText:@" "];
    }
    NSString* ageString = [NSString stringWithFormat:@"%@ %ld", patient.sex, patient.age];
    [lbPatientAge setText:ageString];
    
    NSString* commentString = [self detectValueStringWithDatas:patient.userTestDatas];
    if (!commentString)
    {
        commentString = @" ";
    }
    NSString* dateString = [self detectTimeStringWithDatas:patient.userTestDatas];
    if (dateString) {
        commentString = [commentString stringByAppendingFormat:@" %@",dateString];
    }
    
//    if (patient.illName) {
//        commentString = [commentString stringByAppendingFormat:@" %@",patient.illName];
//    }
    
//    [lbComment setText:commentString];
    if (patient.imgUrl)
    {
        [self.headImageView fillImageWithName:patient.userName url:[NSURL URLWithString:patient.imgUrl]];
    }
    [self.btnIllDiagnose setTitle:patient.diseaseTitle forState:UIControlStateNormal];
    self.btnIllDiagnose.hidden = !patient.diseaseTitle.length;
//    [lbDetectTime setText:[self detectTimeStringWithDatas:patient.userTestDatas]];
//    
//    [lbDisease setText:patient.illName];
    [self.orderMoney setHidden:patient.orderMoney<=0];
    CGFloat temp = 0;
    if (patient.orderMoney >= 1000) {
       temp = patient.orderMoney / 1000.0;
        NSNumber *number = [NSNumber numberWithFloat:temp];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = NSNumberFormatterRoundFloor;
        formatter.maximumFractionDigits = 1;
        [self.orderMoney setTitle:[NSString stringWithFormat:@"%@K",[formatter stringFromNumber:number]] forState:UIControlStateNormal];

    }
    else {
        temp = patient.orderMoney;
        [self.orderMoney setTitle:[self removeFloatAllZero:[NSString stringWithFormat:@"%f",patient.orderMoney]] forState:UIControlStateNormal];
    }
    
    
}

- (void)configPatientInfo:(PatientInfo*)patient filterKeywords:(NSString *)keywords {
    [self setPatientInfo:patient];
    lbPatientName.attributedText = [self text:patient.userName searchText:keywords];
}

- (void)configCellDataWithNewPatientListInfoModel:(NewPatientListInfoModel *)patient {
    [lbPatientName setText:patient.userName];
    if (!patient.userName || 0 == patient.userName.length)
    {
        [lbPatientName setText:@" "];
    }
    NSString* ageString = [NSString stringWithFormat:@"%@ %ld", patient.sex, patient.age];
    [lbPatientAge setText:ageString];
    
    NSString* commentString = [self detectValueStringWithDatas:patient.userTestDatas];
    if (!commentString)
    {
        commentString = @" ";
    }
    NSString* dateString = [self detectTimeStringWithDatas:patient.userTestDatas];
    if (dateString) {
        commentString = [commentString stringByAppendingFormat:@" %@",dateString];
    }
    
//    [lbComment setText:commentString];
 
    NSURL *urlHead = avatarURL(avatarType_80, [NSString stringWithFormat:@"%d",patient.userId]);
    [self.headImageView fillImageWithName:patient.userName url:urlHead];
    
    [self.btnIllDiagnose setTitle:patient.diseaseTitle forState:UIControlStateNormal];
    self.btnIllDiagnose.hidden = !patient.diseaseTitle.length;
    
    [self.orderMoney setHidden:patient.orderMoney<=0];
    CGFloat temp = 0;

    if (patient.orderMoney >= 1000) {
        temp = patient.orderMoney / 1000.0;
        NSNumber *number = [NSNumber numberWithFloat:temp];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = NSNumberFormatterRoundFloor;
        formatter.maximumFractionDigits = 1;
        
        [self.orderMoney setTitle:[NSString stringWithFormat:@"%@K",[formatter stringFromNumber:number]] forState:UIControlStateNormal];
        
    }
    else {
        temp = patient.orderMoney;
        [self.orderMoney setTitle:[self removeFloatAllZero:[NSString stringWithFormat:@"%f",patient.orderMoney]] forState:UIControlStateNormal];
    }

}

- (NSString*)removeFloatAllZero:(NSString*)string
{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}

- (void)configCellDataWithNewPatientListInfoModel:(NewPatientListInfoModel *)patient filterKeywords:(NSString *)keywords {
    [self configCellDataWithNewPatientListInfoModel:patient];
    lbPatientName.attributedText = [self text:patient.userName searchText:keywords];
}

#pragma mark - Private Method
- (NSString*) detectTimeStringWithDatas:(NSDictionary*) dicDatas
{
    if (!dicDatas)
    {
        return nil;
    }
    NSString* dateStr = [dicDatas valueForKey:@"testTime"];
    if (!dateStr)
    {
        return nil;
    }
    
    NSDate* date = [NSDate dateFromeStandardDateString:dateStr];
    if (!date)
    {
        date = [NSDate dateFromStandardDateTimeString:dateStr];
    }
    
    if (!date)
    {
        return nil;
    }
    
    NSString* timeStr = [date formattedDateWithFormat:@"HH:mm"];
    NSString* dateString = [date formattedDateWithFormat:@"yy-MM-dd"];
    if ([date isToday])
    {
        dateString = @"今天";
    }
    if ([date isYesterday])
    {
        dateString = @"昨天";
    }
    
    dateString = [dateString stringByAppendingFormat:@" %@", timeStr];
    return dateString;
}

- (NSString*) detectValueStringWithDatas:(NSDictionary*) dicDatas
{
    if (!dicDatas)
    {
        return @" ";
    }
    
    NSString* testValue = [dicDatas valueForKey:@"testValue"];
    if (!testValue || ![testValue isKindOfClass:[NSString class]] || 0 == testValue.length)
    {
        return @" ";
    }
    
    return testValue;
}

- (NSString*) xdValueStringWithDic:(NSDictionary*)dicData
{
    NSString* valueString = @" ";
    if (!dicData)
    {
        return valueString;
    }
    NSString* sValue = [dicData valueForKey:@"PR"];
    if (sValue)
    {
        valueString = [NSString stringWithFormat:@"心率 %ld次/分", sValue.integerValue];
    }
    return valueString;
}

- (NSString*) xyValueStringWithDic:(NSDictionary*)dicData
{
    NSString* valueString = @" ";
    
    if (!dicData)
    {
        return valueString;
    }
    NSString* ssyStr = [dicData valueForKey:@"SSY"];
    NSString* szyStr = [dicData valueForKey:@"SZY"];
    
    if (!ssyStr || ![ssyStr isKindOfClass:[NSString class]])
    {
        return valueString;
    }
    
    if (!szyStr || ![szyStr isKindOfClass:[NSString class]])
    {
        return valueString;
    }
    
    valueString = [NSString stringWithFormat:@"血压 %ld/%ldmmHg", ssyStr.integerValue, szyStr.integerValue];
    return valueString;
}

- (NSString*) xtValueStringWithDic:(NSDictionary*)dicData
{
    NSString* valueString = @" ";
    
    if (!dicData)
    {
        return valueString;
    }
    
    NSString* testValue = [dicData valueForKey:@"testValue"];
    NSString* kpiName = [dicData valueForKey:@"kpiName"];
    
    if (!testValue || ![testValue isKindOfClass:[NSString class]])
    {
        return valueString;
    }
    
    if (!kpiName || ![kpiName isKindOfClass:[NSString class]])
    {
        return valueString;
    }
    
    valueString = [NSString stringWithFormat:@"血糖 %@fmmol/L %@", testValue, kpiName];
    
    return valueString;
}

// 富文本
- (NSMutableAttributedString *)text:(NSString *)string searchText:(NSString *)text
{
    NSMutableString * mutableString = [[NSMutableString alloc] initWithString:string];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    int length = 0;
    while (YES) {
        NSRange range = [mutableString rangeOfString:text options:NSCaseInsensitiveSearch];
        if (range.length > 0) {
            NSRange newRange = NSMakeRange(range.location + length, range.length);
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor mainThemeColor] range:newRange];
            [mutableString deleteCharactersInRange:range];
            length += range.length;
        }else {
            return str;
        }
    }
    return str;
}

#pragma mark - Init
- (UIButton *)btnIllDiagnose {
    if (!_btnIllDiagnose) {
        _btnIllDiagnose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnIllDiagnose setTitleColor:[UIColor commonLightGrayColor_999999] forState:UIControlStateNormal];
        _btnIllDiagnose.titleLabel.font = [UIFont font_24];
        [_btnIllDiagnose setImage:[UIImage imageNamed:@"ic_bq"] forState:UIControlStateNormal];
        [_btnIllDiagnose setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -6)];
        _btnIllDiagnose.enabled = NO;
    }
    return _btnIllDiagnose;
}

- (UIButton *)orderMoney {
    if (!_orderMoney) {
        _orderMoney = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderMoney setTitleColor:[UIColor colorWithHexString:@"ff9c37"] forState:UIControlStateNormal];
        _orderMoney.titleLabel.font = [UIFont font_24];
        [_orderMoney setImage:[UIImage imageNamed:@"ic_jb"] forState:UIControlStateNormal];
        [_orderMoney setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -6)];
        _orderMoney.enabled = NO;
    }
    return _orderMoney;
}
@end
