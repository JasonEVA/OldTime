//
//  HealthPlanDateSelectView.m
//  HMClient
//
//  Created by yinqaun on 16/6/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthPlanDateSelectView.h"
#import "UIBarButtonItem+BackExtension.h"
#import "HMPopupSelectView.h"
#import "NuritionFoodListTableViewController.h"
#import "FoodListItem.h"
#import "UIButton+Category.h"

static NSInteger maxTextCount = 150;

@interface HealthPlanDateSelectView()
{
    UILabel* lbDate;

}
@end

@implementation HealthPlanDateSelectView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        _insbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_insbutton];
        [_insbutton setImage:[UIImage imageNamed:@"icon_l_gray_arrow"] forState:UIControlStateNormal];
        [_insbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [_insbutton addTarget:self action:@selector(dateDesButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _desbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_desbutton];
        [_desbutton setImage:[UIImage imageNamed:@"icon_r_gray_arrow"] forState:UIControlStateNormal];
        [_desbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [_desbutton addTarget:self action:@selector(dateIncButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        lbDate = [[UILabel alloc]init];
        [lbDate setFont:[UIFont font_30]];
        [lbDate setTextColor:[UIColor commonTextColor]];
        [self addSubview:lbDate];
        [lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [self setDate:[NSDate date]];
    }
    return self;
}

- (void) dateIncButtonClicked:(id) sender
{
    if (!_date)
    {
        [self setDate:[NSDate date]];
    }
    NSDate* date = [_date dateByAddingDays:1];
    [self setDate:date];
}

- (void) dateDesButtonClicked:(id) sender
{
    if (!_date)
    {
        [self setDate:[NSDate date]];
    }
    NSDate* date = [_date dateByAddingDays:-1];
    [self setDate:date];
}


- (void) setDate:(NSDate *)date
{
    _date = date;
    NSString* dateStr = [_date formattedDateWithFormat:@"yyyy年MM月dd日"];
    [lbDate setText:dateStr];
}

@end


@interface HealthPlanSENavTitleView ()
@property (nonatomic, strong) UIButton *leftCutBtn;
@property (nonatomic, strong) UIButton *rightAddBtn;

@end

@implementation HealthPlanSENavTitleView

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor mainThemeColor]];
        
        [self setDate:[NSDate date]];
        
        [self addSubview:self.backBtn];
        [self addSubview:self.dateLb];
        [self addSubview:self.leftCutBtn];
        [self addSubview:self.rightAddBtn];
        [self addSubview:self.dietRecordBtn];
        
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(10);
            make.left.equalTo(self).offset(15);
        }];
        
        NSString *dateString = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"];
        [self.dateLb setText:dateString];
        [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBtn);
            make.centerX.equalTo(self);
        }];
        
        [self.leftCutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_dateLb.mas_left).offset(-10);
            make.centerY.equalTo(self.backBtn);
            make.size.mas_equalTo(CGSizeMake(16, 8));
        }];
        
        [self.rightAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBtn);
            make.left.equalTo(_dateLb.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(16, 8));
        }];

        [self.dietRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBtn);
            make.right.equalTo(self).offset(-15);
        }];
    }
    return self;
}

#pragma mark - Event Response

- (void) setDate:(NSDate *)date
{
    _date = date;
    NSString* dateStr = [_date formattedDateWithFormat:@"yyyy-MM-dd"];
    _dateLb.text = dateStr;
}
- (void)leftDateBtnClick{
    if (!_date){
        [self setDate:[NSDate date]];
    }
    NSDate* date = [_date dateByAddingDays:-1];
    [self setDate:date];
}

- (void)rightDateBtnClick{
    if (!_date){
        [self setDate:[NSDate date]];
    }
    if ([_date isToday]) {
//        [self at_postError:@"已经是当前日期" duration:1];
        if (_clickBlock) {
            _clickBlock();
        }
        return;
    }
    NSDate* date = [_date dateByAddingDays:1];
    [self setDate:date];
}

#pragma mark -- init

- (UIButton *)buttonWithImageNamed:(NSString *)imageNamed
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, button.currentBackgroundImage.size.width, button.currentBackgroundImage.size.height);
    [button setEnlargeEdgeWithTop:10 right:15 bottom:5 left:10];
    return button;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [self buttonWithImageNamed:@"back"];
    }
    return _backBtn;
}

- (UIButton *)leftCutBtn{
    if (!_leftCutBtn) {
        _leftCutBtn = [self buttonWithImageNamed:@"c_whiteArrow"];
        [_leftCutBtn setTransform:CGAffineTransformMakeRotation(-M_PI/2)];
        [_leftCutBtn addTarget:self action:@selector(leftDateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftCutBtn;
}

- (UIButton *)rightAddBtn{
    if (!_rightAddBtn) {
        _rightAddBtn = [self buttonWithImageNamed:@"c_whiteArrow"];
        [_rightAddBtn setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        [_rightAddBtn addTarget:self action:@selector(rightDateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightAddBtn;
}

- (UIButton *)dietRecordBtn{
    if (!_dietRecordBtn) {
        _dietRecordBtn = [UIButton new];
        [_dietRecordBtn setTitle:@"饮食记录" forState:UIControlStateNormal];
        [_dietRecordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dietRecordBtn.titleLabel setFont:[UIFont font_26]];
    }
    return _dietRecordBtn;
}

- (UILabel *)dateLb{
    if (!_dateLb) {
        _dateLb = [UILabel new];
        [_dateLb setTextColor:[UIColor whiteColor]];
        [_dateLb setFont:[UIFont font_28]];
        [_dateLb setTextAlignment:NSTextAlignmentCenter];
    }
    return _dateLb;
}
@end


@interface HealthPlanSEAddDietView () <UITextViewDelegate>

@property (nonatomic, strong) UIControl *mealSelectControl;
@property (nonatomic, strong) UILabel *mealLb;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation HealthPlanSEAddDietView

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // 设置元素控件
        [self configElements];

        _dietType = [self getTheTimeBucket];
        NSString *mealStr = nil;
        switch (_dietType.integerValue) {
            case 1:
                mealStr = @"早餐";
                break;
                
            case 2:
                mealStr = @"午餐";
                break;
                
            case 3:
                mealStr = @"晚餐";
                break;
                
            case 4:
                mealStr = @"加餐";
                break;
                
            default:
                break;
        }
        [self.mealLb setText:mealStr];
    }
    return self;
}

// 设置元素控件
- (void)configElements{

    [self addSubview:self.mealSelectControl];
    [self.mealSelectControl addSubview:self.mealLb];
    [self.mealSelectControl addSubview:self.imgView];
    [self addSubview:self.tvFood];
    [self addSubview:self.placeholderLb];
    
    [self.mealSelectControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.top.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(65 * kScreenScale, 30));
    }];
    
    [self.mealLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mealSelectControl);
        make.left.equalTo(self.mealSelectControl).offset(10);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mealSelectControl);
        make.right.equalTo(self.mealSelectControl.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(13, 8));
    }];
    
    [self.tvFood mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mealSelectControl.mas_right).with.offset(10);
        make.right.equalTo(self).with.offset(-12.5);
        make.top.equalTo(self.mealSelectControl.mas_top);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.placeholderLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mealSelectControl.mas_right).with.offset(10);
        make.right.equalTo(self).with.offset(-12.5);
        make.top.equalTo(self.mealSelectControl.mas_top).offset(10);
    }];
}

- (void)mealSelectControlClick{

    [self.tvFood resignFirstResponder];
    
    NSArray *arr = @[@{@"name":@"早餐",@"ID":@"1"},@{@"name":@"午餐",@"ID":@"2"},@{@"name":@"晚餐",@"ID":@"3"},@{@"name":@"加餐",@"ID":@"4"}];
    
    HMPopUpSelectView *showView = [HMPopUpSelectView initWithFrame:self.ownViewController.view.bounds title:@"请选择" dataArray:arr block:^(NSDictionary *dicItem) {
        [self.mealLb setText:[dicItem valueForKey:@"name"]];
//        NSLog(@"%@",[dicItem valueForKey:@"ID"]);
        self.dietType = [dicItem valueForKey:@"ID"];
        
    }];
    [self.ownViewController.view addSubview:showView];
}

- (void)setFoodTextView:(NSString *)text placeholder:(BOOL)isShow{
    if (isShow) {
        [self.placeholderLb setText:@"请简单描述这一餐(不超过150个字)，如2个蔬菜包子，一杯豆浆"];
    }
    else{
        [self.placeholderLb setText:@""];
    }
    
    if (_tvFood.text.length >= 150) {
        [self.ownViewController at_postError:[NSString stringWithFormat:@"最多输入%ld字",(long)maxTextCount]];
        return;
    }
    [self.tvFood setText:text];
}

#pragma mark -- init
- (UIControl *)mealSelectControl{
    if (!_mealSelectControl) {
        _mealSelectControl = [UIControl new];
        _mealSelectControl.backgroundColor = [UIColor mainThemeColor];
        [_mealSelectControl.layer setCornerRadius:15.0f];
        [_mealSelectControl.layer setMasksToBounds:YES];
        [_mealSelectControl addTarget:self action:@selector(mealSelectControlClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mealSelectControl;
}

- (UILabel *)mealLb{
    if (!_mealLb) {
        _mealLb = [UILabel new];
        [_mealLb setTextColor:[UIColor whiteColor]];
        [_mealLb setFont:[UIFont font_28]];
    }
    return _mealLb;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_waterfal_downArrow"]];
    }
    return _imgView;
}

- (UITextView *)tvFood{
    if (!_tvFood) {
        _tvFood = [[UITextView alloc] init];
        [_tvFood setFont:[UIFont font_26]];
        [_tvFood setTextColor:[UIColor commonTextColor]];
        _tvFood.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        _tvFood.layer.borderWidth = 0.5;
        _tvFood.layer.cornerRadius = 2.5;
        _tvFood.layer.masksToBounds = YES;
        [_tvFood setReturnKeyType:UIReturnKeyDone];
        [_tvFood setDelegate:self];
    }
    return _tvFood;
}

- (UILabel *)placeholderLb{
    if (!_placeholderLb) {
        _placeholderLb = [[UILabel alloc] init];
        [_placeholderLb setNumberOfLines:0];
        [_placeholderLb setText:@"请简单描述这一餐(不超过150个字)，如2个蔬菜包子，一杯豆浆"];
        [_placeholderLb setFont:[UIFont systemFontOfSize:14.0f]];
        [_placeholderLb setTextColor:[UIColor commonGrayTextColor]];
        [_placeholderLb sizeToFit];
    }
    return _placeholderLb;
}

#pragma mark -- textViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        _placeholderLb.text = @"请简单描述这一餐(不超过150个字)，如2个蔬菜包子，一杯豆浆";
    }else
    {
        _placeholderLb.text = @"";
    }
    
    //字数限制操作
    if (textView.text.length >= maxTextCount) {
        textView.text = [textView.text substringToIndex:maxTextCount];
        [self.ownViewController at_postError:[NSString stringWithFormat:@"最多输入%ld字",(long)maxTextCount]];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -- shijian
//将时间点转化成日历形式
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate * destinationDateNow = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];
    
    //设置当前的时间点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}
//获取时间段
-(NSString *)getTheTimeBucket
{
    //    NSDate * currentDate = [self getNowDateFromatAnDate:[NSDate date]];
    
    NSDate * currentDate = [NSDate date];
    if ([currentDate compare:[self getCustomDateWithHour:5]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:11]] == NSOrderedAscending)
    {
        return @"1";  //早餐
    }
    else if ([currentDate compare:[self getCustomDateWithHour:11]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:17]] == NSOrderedAscending)
    {
        return @"2";  //午餐
    }
    else if ([currentDate compare:[self getCustomDateWithHour:17]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:20]] == NSOrderedAscending)
    {
        return @"3";  //晚餐
    }
    //    else if ([currentDate compare:[self getCustomDateWithHour:20]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:5]] == NSOrderedAscending)
    //    {
    //        return @"";
    //    }
    else
    {
        return @"4";  //加餐
    }
}
@end
