//
//  PointRedemptionCalendarViewController.m
//  JYClientDemo
//
//  Created by yinquan on 2017/7/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "PointRedemptionCalendarViewController.h"
#import "PointRedemptionCalendarView.h"
#import "AppDelegate.h"
/*
 
 */

@interface PointRedemptionCalendarHubView ()

@end

@implementation PointRedemptionCalendarHubView

- (id) init
{
    self = [super init];
    if (self) {
        NSArray* colors = @[[UIColor colorWithHexString:@"31c9ba"], [UIColor colorWithHexString:@"3cd395"]];
        UIImage* patternImage = [UIImage gradientColorImageFromColors:colors gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(400, 400)];
        
        UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:patternImage];
        [self addSubview:backgroundImageView];
        
        [backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        NSDate* todayDate = [NSDate date];
        
        [self.dateLabel setText:[todayDate formattedDateWithFormat:@"yyyy年MM月dd日"]];
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(60, 25, 25, 20));
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        
        make.top.equalTo(self).with.offset(9);
        make.right.equalTo(self).with.offset(-9);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(25);
        make.top.equalTo(self).with.offset(20);
    }];

}



#pragma mark - settingAndGetting

- (UIButton*) closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_closeButton];
        [_closeButton setImage:[UIImage imageNamed:@"close_button_icon"] forState:UIControlStateNormal];
        [_closeButton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    }
    return _closeButton;
}

- (UILabel*) dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        [self addSubview:_dateLabel];
        
        [_dateLabel setFont:[UIFont systemFontOfSize:15]];
        [_dateLabel setTextColor:[UIColor whiteColor]];
    }
    return _dateLabel;
}

- (PointRedemptionCalendarView*) calendarView
{
    if (!_calendarView) {
        _calendarView = [[PointRedemptionCalendarView alloc] init];
        [self addSubview:_calendarView];
        
        _calendarView.layer.cornerRadius = 4;
        _calendarView.layer.masksToBounds = YES;
    }
    return _calendarView;
}

@end

@interface PointRedemptionCalendarViewController ()





@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;


@end

@implementation PointRedemptionCalendarViewController

+ (void) show
{

    PointRedemptionCalendarViewController* pointRedemptionViewController = [[[self class] alloc] init];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [app.window addSubview:pointRedemptionViewController.view];
    [pointRedemptionViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(app.window);
            }];
    UIViewController* topmostViewController = [HMViewControllerManager topMostController] ;
    [topmostViewController addChildViewController:pointRedemptionViewController];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _monthDate = [NSDate date];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.hubView.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.hubView.calendarView addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.hubView.calendarView addGestureRecognizer:self.rightSwipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeButtonClicked:(id) sender
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.hubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
    }];
    
    
}

- (void) setMonthlyPointRecordModels:(NSArray*) models
{
    [self.hubView.calendarView setMonthlyPointRecordModels:models];
}


- (void) loadPointRedemptionRecords:(NSString*) monthString
{
    [self.hubView.calendarView setMonth:[self.monthDate formattedDateWithFormat:@"yyyy-MM"]];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    return;
    /*
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"你在往左边跑啊....");
        NSDate* monthDate = [self.monthDate dateByAddingMonths:1];
        NSString* currentmonthString = [[NSDate date] formattedDateWithFormat:@"yyyy-MM"];
        NSDate* currentMonth = [NSDate dateWithString:currentmonthString formatString:@"yyyy-MM"];
        
        NSInteger monthsFrom = [monthDate monthsFrom:currentMonth];
        if (monthsFrom > 0)
        {
            return;
        }
        _monthDate = monthDate;
        NSString* monthString = [monthDate formattedDateWithFormat:@"yyyy-MM-01"];
        [self loadPointRedemptionRecords:monthString];

    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"你在往右边跑啊....");
        
        NSDate* monthDate = [self.monthDate dateBySubtractingMonths:1];
        _monthDate = monthDate;
        NSString* monthString = [monthDate formattedDateWithFormat:@"yyyy-MM-01"];
        [self loadPointRedemptionRecords:monthString];
        

    }
     */
}

#pragma gettingAndSetting
- (PointRedemptionCalendarHubView*) hubView
{
    if (!_hubView) {
        _hubView = [[PointRedemptionCalendarHubView alloc] init];
        [self.view addSubview:_hubView];
        
        _hubView.layer.shadowOpacity = 0.5;// 阴影透明度
        _hubView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
        _hubView.layer.shadowRadius = 3;// 阴影扩散的范围控制
        _hubView.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    }
    return _hubView;
}



@end


