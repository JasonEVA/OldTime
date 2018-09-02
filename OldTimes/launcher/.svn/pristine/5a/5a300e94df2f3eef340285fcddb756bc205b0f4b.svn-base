//
//  BaseViewController.m
//  MintTeam
//
//  Created by William Zhang on 15/7/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeTabBarController.h"
#import <MintcodeIM/MintcodeIM.h>
#import "UIColor+Hex.h"
#import "AppDelegate.h"
#import "MyDefine.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIButton *leftBarButtonItem;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger timerCount;

@end

@implementation BaseViewController

+ (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[HomeTabBarController class]]) {
        result = [(HomeTabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IOS_VERSION_7_OR_ABOVE) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.navigationController.viewControllers count] == 1) {
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_blue_new"] style:UIBarButtonItemStyleDone target:self action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
        
    } else {
        [self showLeftItemWithSelector:@selector(clickToBack)];
    }
    
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassigning"
    __weak typeof(self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self.navigationController interactivePopGestureRecognizer].delegate = weakSelf;
    }
#pragma clang diagnostic pop
    
    [self popGestureDisabled:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLeftNumber) name:MTBadgeCountChangedNotification object:nil];
    [self changeLeftNumber];
#ifdef DEBUG
    NSLog(@"%@ ----viewWillAppear", NSStringFromClass(self.class));
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTBadgeCountChangedNotification object:nil];
}

- (void)dealloc {
    NSLog(@"%@ ----dealloc", NSStringFromClass(self.class));
}

#pragma mark - Interface Method
- (void)leftItemNumber:(NSInteger)number {
    NSString *numberString = [NSString stringWithFormat:@"(%ld)",(long)number];
    if (number > 99) {
        numberString = @"(99+)";
    }
    
    if (number <= 0) {
        numberString = @"";
    }
    
    [self.leftBarButtonItem setTitle:numberString forState:UIControlStateNormal];
}

- (void)showLeftItemWithSelector:(SEL)selector {
    if (!selector) {
        selector = @selector(clickToBack);
    }
    
    if ([self respondsToSelector:@selector(clickToBack)]) {
        [self.leftBarButtonItem removeTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.leftBarButtonItem addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBarButtonItem];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

- (void)popGestureDisabled:(BOOL)disabled {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self.navigationController interactivePopGestureRecognizer].enabled = !disabled;
    }
}

#pragma mark - privite methods
- (void)clickToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeLeftNumber {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (![delegate.window.rootViewController isKindOfClass:[HomeTabBarController class]]) {
        return;
    }
    
    [[MessageManager share] queryAllUnreadMessageCountCompletion:^(NSInteger count) {
        [self leftItemNumber:count];
    }];
}

//#pragma mark - UIGestureRecognizer Delegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    return YES;
//}

#pragma mark - Initializer
- (UIButton *)leftBarButtonItem {
    if (!_leftBarButtonItem) {
        _leftBarButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 40)];
        _leftBarButtonItem.tintColor = [UIColor themeBlue];
        [_leftBarButtonItem setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        
        [[_leftBarButtonItem titleLabel] setFont:[UIFont systemFontOfSize:15]];
        [_leftBarButtonItem setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
        [_leftBarButtonItem setTitle:@"" forState:UIControlStateNormal];
        [_leftBarButtonItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [_leftBarButtonItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [_leftBarButtonItem addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBarButtonItem;
}

- (void)RecordToDiary:(NSString *)string
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSThread *current=[NSThread currentThread];
        DDLogInfo(@"当前线程:%@----%@",current,string);
    });
}

- (void)TimerStart
{
    self.timer = nil;
    self.timerCount = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimerStartStart) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
}

- (void)TimerStartStart
{
    self.timerCount = self.timerCount + 1;
    NSLog(@"%ld",self.timerCount);
    if (self.timerCount > 60)
    {
        [self TimerEndWithString:@"但用户超时"];
    }
    
}

- (void)TimerEndWithString:(NSString *)string
{
    [self.timer invalidate];
    [self RecordToDiary:[NSString stringWithFormat:@"共计用时%ld秒,%@",(long)self.timerCount,string]];
}
@end
