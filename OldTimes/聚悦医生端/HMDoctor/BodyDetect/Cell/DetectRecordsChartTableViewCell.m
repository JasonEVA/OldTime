//
//  DetectRecordsChartTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecordsChartTableViewCell.h"
#import "BloodPressureThriceDetectModel.h"
#import "HMPopupSelectView.h"

@implementation DetectRecordsChartTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, 200)];
        [webview setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:webview];
        [webview scalesPageToFit];

        clickcontrol = [[UIControl alloc]init];
        [self.contentView addSubview:clickcontrol];
        [clickcontrol setBackgroundColor:[UIColor clearColor]];
        [clickcontrol addTarget:self action:@selector(clickControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.contentView);
        make.top.and.left.equalTo(self.contentView);
    }];
    
    [clickcontrol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.contentView);
        make.top.and.left.equalTo(self.contentView);
    }];

}

- (void) clickControlClicked:(id) sender
{
    if (!_targetControllerName || 0 == _targetControllerName.length)
    {
        return;
    }
    
    UserInfo* targetUser = [[UserInfo alloc]init];
    [targetUser setUserId:[_userId integerValue]];
    
    [HMViewControllerManager createViewControllerWithControllerName:_targetControllerName ControllerObject:targetUser];

}

- (void) loadChartWithUrl:(NSString*) chartUrl
{
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:chartUrl]]];
}
@end

@interface BodyWeightDetectRecordsChartTableViewCell ()
{
    NSInteger subType;  //0  TZ_SUB ，1 TZ_BMI
    NSString* webUrl;
}
@end

@implementation BodyWeightDetectRecordsChartTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //TODO:添加体重／BMI切换控件
        NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"体重",@"BMI", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
        [self addSubview:segmentedControl];
        segmentedControl.tintColor = [UIColor mainThemeColor];
        [segmentedControl.layer setCornerRadius:12.0f];
        [segmentedControl.layer setMasksToBounds:YES];
        [segmentedControl setSelectedSegmentIndex:0];
        [segmentedControl.layer setBorderColor:[[UIColor mainThemeColor] CGColor]];
        [segmentedControl.layer setBorderWidth:1.0f];
        [segmentedControl addTarget:self action:@selector(reLoadChart:) forControlEvents:UIControlEventValueChanged];
        
        [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-20);
            make.top.equalTo(self).with.offset(4);
            make.size.mas_equalTo(CGSizeMake(65, 25));
        }];
        
    }
    return self;
}

- (void) reLoadChart:(UISegmentedControl *)seg
{
    NSString* chartUrl = webUrl;
    subType = seg.selectedSegmentIndex;
    //刷新体重图表
    NSString* chartWebUrl = nil;
    switch (subType)
    {
        case 0:
        {
            chartWebUrl = [chartUrl stringByAppendingString:@"&childKpiCode=TZ_SUB"];
        }
            break;
        case 1:
        {
            chartWebUrl = [chartUrl stringByAppendingString:@"&childKpiCode=TZ_BMI"];
        }
            break;
        default:
            break;
    }
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:chartWebUrl]]];
    
}

- (void) loadChartWithUrl:(NSString*) chartUrl
{
    webUrl = chartUrl;
    NSString* chartWebUrl = nil;
    switch (subType)
    {
        case 0:
        {
            chartWebUrl = [chartUrl stringByAppendingString:@"&childKpiCode=TZ_SUB"];
        }
            break;
        case 1:
        {
            chartWebUrl = [chartUrl stringByAppendingString:@"&childKpiCode=TZ_BMI"];
        }
            break;
        default:
            break;
    }
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:chartWebUrl]]];
}
@end

@interface BloodSugarConstastRecordsChartTableViewCell()
{
    NSString* childKpi;
    NSString* webUrl;
    
    UIControl *periodControl;
    UILabel *lbperiod;
    UIImageView *downIcon;
    
    HMPopupSelectView *testPeriodView;
}
@end

@implementation BloodSugarConstastRecordsChartTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //TODO:创建血糖时段选择按钮
        
        periodControl = [[UIControl alloc] init];
        [self addSubview:periodControl];
        [periodControl.layer setCornerRadius:12.0f];
        [periodControl.layer setMasksToBounds:YES];
        [periodControl setBackgroundColor:[UIColor mainThemeColor]];
        [periodControl addTarget:self action:@selector(periodControlClick) forControlEvents:UIControlEventTouchUpInside];
        
        lbperiod = [[UILabel alloc] init];
        [periodControl addSubview:lbperiod];
        [lbperiod setText:@"全部"];
        [lbperiod setFont:[UIFont font_20]];
        [lbperiod setTextColor:[UIColor whiteColor]];
        [lbperiod setTextAlignment:NSTextAlignmentCenter];
        
        downIcon = [[UIImageView alloc] init];
        [self addSubview:downIcon];
        [downIcon setImage:[UIImage imageNamed:@"icon_down_arrow"]];
        
        [self subViewsLayout];
        
    }
    return self;
}

- (void)subViewsLayout
{
    [periodControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(webview).with.offset(-20);
        make.top.equalTo(webview).with.offset(4);
        make.size.mas_equalTo(CGSizeMake(65, 25));
    }];
    
    [lbperiod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(periodControl).with.offset(-5);
        make.centerY.equalTo(periodControl);
    }];
    
    [downIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(periodControl.mas_right).with.offset(-5);
        make.centerY.equalTo(periodControl);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
}

- (void)periodControlClick
{
    testPeriodView = [[HMPopupSelectView alloc] initWithKpiCode:@"XT" dateList:nil];
    [self addSubview:testPeriodView];
    
    [testPeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    __weak typeof(lbperiod) weakLbperiod = lbperiod;
    __weak typeof(self) weakSelf = self;
    [testPeriodView setDataSelectBlock:^(NSDictionary *testPeriodItem){
        [weakLbperiod setText:[testPeriodItem valueForKey:@"name"]];
        childKpi = [testPeriodItem valueForKey:@"ID"];
        [weakSelf reloadChart];
    }];
}

- (void) reloadChart
{
    float width = [lbperiod.text widthSystemFont:[UIFont font_20]];
    
    [periodControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width + 25, 25));
    }];
    
    NSString* chartWebUrl = webUrl;
    if (childKpi )
    {
        chartWebUrl = [chartWebUrl stringByAppendingFormat:@"&testTimeId=%@", childKpi];
    }
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:chartWebUrl]]];

}

- (void) loadChartWithUrl:(NSString*) chartUrl
{
    webUrl = [chartUrl stringByAppendingString:@"&islegend=1"];;
    NSString* chartWebUrl = webUrl;
    if (childKpi )
    {
        chartWebUrl = [chartWebUrl stringByAppendingFormat:@"&testTimeId=%@", childKpi];
    }
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:chartWebUrl]]];
}
@end

//血压
@interface BloodPressureDetectRecordsChartTableViewCell ()
{
    //    NSString* childKpi;
    NSString* webUrl;
    
    UIControl *periodControl;
    UILabel *lbperiod;
    UIImageView *downIcon;
    
    NSString *testTimeId;
    HMPopupSelectView *testPeriodView;
}
@end

@implementation BloodPressureDetectRecordsChartTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //TODO:创建血压时段选择按钮
        
        periodControl = [[UIControl alloc] init];
        [self addSubview:periodControl];
        [periodControl.layer setCornerRadius:12.0f];
        [periodControl.layer setMasksToBounds:YES];
        [periodControl setBackgroundColor:[UIColor mainThemeColor]];
        [periodControl addTarget:self action:@selector(periodControlClick) forControlEvents:UIControlEventTouchUpInside];
        
        lbperiod = [[UILabel alloc] init];
        [periodControl addSubview:lbperiod];
        [lbperiod setText:@"全部"];
        [lbperiod setFont:[UIFont font_20]];
        [lbperiod setTextColor:[UIColor whiteColor]];
        [lbperiod setTextAlignment:NSTextAlignmentCenter];
        
        downIcon = [[UIImageView alloc] init];
        [self addSubview:downIcon];
        [downIcon setImage:[UIImage imageNamed:@"icon_down_arrow"]];
        
        [self subViewsLayout];
        
    }
    return self;
}

- (void)subViewsLayout
{
    [periodControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(webview).with.offset(-20);
        make.top.equalTo(webview).with.offset(4);
        make.size.mas_equalTo(CGSizeMake(65, 25));
    }];
    
    [lbperiod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(periodControl).with.offset(-5);
        make.centerY.equalTo(periodControl);
    }];
    
    [downIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(periodControl.mas_right).with.offset(-5);
        make.centerY.equalTo(periodControl);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
}

- (void)periodControlClick
{
    testPeriodView = [[HMPopupSelectView alloc] initWithKpiCode:@"XY" dateList:nil];
    [self addSubview:testPeriodView];
    
    [testPeriodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    __weak typeof(lbperiod) weakLbperiod = lbperiod;
    __weak typeof(self) weakSelf = self;
    [testPeriodView setDataSelectBlock:^(NSDictionary *testPeriodItem){
        [weakLbperiod setText:[testPeriodItem valueForKey:@"name"]];
        testTimeId = [testPeriodItem valueForKey:@"ID"];
        [weakSelf reloadChart];
    }];
}

- (void) reloadChart
{
    float width = [lbperiod.text widthSystemFont:[UIFont font_20]];
    
    [periodControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width + 25, 25));
    }];
    
    NSString* chartWebUrl = webUrl;
    
    if (testTimeId )
    {
        chartWebUrl = [chartWebUrl stringByAppendingFormat:@"&testTimeId=%@", testTimeId];
    }
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:chartWebUrl]]];
    
}

- (void) loadChartWithUrl:(NSString*) chartUrl
{
    webUrl = chartUrl;
    NSString* chartWebUrl = webUrl;
    
    if (testTimeId )
    {
        chartWebUrl = [chartWebUrl stringByAppendingFormat:@"&testTimeId=%@", testTimeId];
    }
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:chartWebUrl]]];
}

@end
