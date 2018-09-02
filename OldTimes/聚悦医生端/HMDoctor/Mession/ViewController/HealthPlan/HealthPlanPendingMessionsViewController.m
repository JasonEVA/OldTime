//
//  HealthPlanPendingMessionsViewController.m
//  HMDoctor
//  健康计划-待处理ViewController

//  Created by yinquan on 2017/8/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanPendingMessionsViewController.h"
#import "HealthPlanMessionTableViewController.h"

typedef void(^HealthPlanPendingStatusSelectBlock)(NSInteger index);

@interface HealthPlanPendingMessionsButton : UIControl

@property (nonatomic, strong) UILabel* titleLable;
@property (nonatomic, strong) UIColor* selectedColor;
@property (nonatomic, strong) UIColor* unselectedColor;

@property (nonatomic, strong) NSString* statusTitle;

- (void) setTitle:(NSString*) title;

@end

@implementation HealthPlanPendingMessionsButton

- (id) initWithStatus:(NSString*) status
{
    self = [super init];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
//        make.width.equalTo(self).offset(-15);
    }];
}

- (void) setTitle:(NSString*) title
{
    [self.titleLable setText:title];
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.layer.borderColor = self.selectedColor.CGColor;
        [self.titleLable setTextColor:self.selectedColor];
    }
    else
    {
        self.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        [self.titleLable setTextColor:self.unselectedColor];
    }
}

#pragma mark - settingAndGetting
- (UILabel*) titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        [self addSubview:_titleLable];
        
        [_titleLable setFont:[UIFont systemFontOfSize:13]];
        [_titleLable setTextColor:self.unselectedColor];
        
        
    }
    return _titleLable;
}

- (UIColor*) selectedColor
{
    if(!_selectedColor)
    {
        _selectedColor = [UIColor mainThemeColor];
    }
    return _selectedColor;
}

- (UIColor*) unselectedColor
{
    if(!_unselectedColor)
    {
        _unselectedColor = [UIColor commonGrayTextColor];
    }
    return _unselectedColor;
}
@end

@interface HealthPlanPendingMessionsButtonView : UIView

@property (nonatomic, strong) NSMutableArray* pendingMessionButtons;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) HealthPlanPendingStatusSelectBlock selectBlock;

- (instancetype)initWithPendingMessionStatusList:(NSArray*) statusList
                                    selecteBlock:(HealthPlanPendingStatusSelectBlock) block;
- (void) setStatusCounts:(NSArray*) statusCounts;
@end

@implementation HealthPlanPendingMessionsButtonView

- (instancetype)initWithPendingMessionStatusList:(NSArray*) statusList
                                    selecteBlock:(HealthPlanPendingStatusSelectBlock) block
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        [self showBottomLine];
        
        [self createButtons:statusList];
        
        [self setSelectBlock:block];
    }
    return self;
}

- (void) setStatusCounts:(NSArray*) statusCounts
{
    [statusCounts enumerateObjectsUsingBlock:^(NSDictionary* countDict, NSUInteger idx, BOOL * _Nonnull stop) {
        __block NSString* statusName = [countDict valueForKey:@"statusName"];
        NSNumber* countNumber = [countDict valueForKey:@"count"];
        __block NSInteger count = 0;
        if (countNumber) {
            count = countNumber.integerValue;
        }
        
        [self.pendingMessionButtons enumerateObjectsUsingBlock:^(HealthPlanPendingMessionsButton* button, NSUInteger idx, BOOL * _Nonnull buttonStop)
        {
            if ([button.statusTitle isEqualToString:statusName])
            {
                [button setTitle:[NSString stringWithFormat:@"%@(%ld)", statusName, count]];
                *buttonStop = YES;
                return ;
            }
        }];
    }];
}

- (void) createButtons:(NSArray*) statusList
{
    _pendingMessionButtons = [NSMutableArray array];
    //全部按钮
    NSMutableArray* list = [NSMutableArray arrayWithArray:statusList];
    [list insertObject:@"0" atIndex:0];
    
    
    [list enumerateObjectsUsingBlock:^(NSString* statusString, NSUInteger idx, BOOL * _Nonnull stop) {
        HealthPlanPendingMessionsButton* button = [[HealthPlanPendingMessionsButton alloc] initWithStatus:statusString];
        [self addSubview:button];
        [button setTitle:[self buttonTitleWithStatus:statusString]];
        [button setStatusTitle:[self buttonTitleWithStatus:statusString]];
        
        [_pendingMessionButtons addObject:button];
    }];
    
    [_pendingMessionButtons enumerateObjectsUsingBlock:^(HealthPlanPendingMessionsButton* button, NSUInteger idx, BOOL * _Nonnull stop) {
       [button mas_makeConstraints:^(MASConstraintMaker *make) {
           make.height.equalTo(self).offset(-30);
           make.centerY.equalTo(self);
           if (idx == 0) {
               make.left.equalTo(self).offset(12.5);
           }
           if (idx > 0)
           {
               HealthPlanPendingMessionsButton* perButton = self.pendingMessionButtons[idx - 1];
               make.width.equalTo(perButton);
               make.left.equalTo(perButton.mas_right).offset(10);
           }
           if (button == [self.pendingMessionButtons lastObject])
           {
               make.right.equalTo(self).offset(-12.5);
           }
       }];
        
        [button setSelected:(idx == self.selectedIndex)];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void) buttonClicked:(id) sender
{
    NSInteger clickedIndex = [self.pendingMessionButtons indexOfObject:sender];
    if (clickedIndex == NSNotFound) {
        return;
    }
    
    if (clickedIndex == self.selectedIndex) {
        return;
    }
    
    _selectedIndex = clickedIndex;
    
    [self.pendingMessionButtons enumerateObjectsUsingBlock:^(HealthPlanPendingMessionsButton* button, NSUInteger idx, BOOL * _Nonnull stop){
        [button setSelected:(idx == self.selectedIndex)];
    }];
    
    if (self.selectBlock) {
        self.selectBlock(self.selectedIndex);
    }
}

- (NSString*) buttonTitleWithStatus:(NSString*) status
{
    NSString* buttonTitle = @"全部";
    switch (status.integerValue)
    {
        case 1:
        {
            buttonTitle = @"待制定";
            break;
        }
        case 2:
        {
            buttonTitle = @"待确认";
            break;
        }
        case 3:
        {
            buttonTitle = @"待调整";
            break;
        }
        case 7:
        {
            buttonTitle = @"执行中";
            break;
        }
        default:
            break;
    }
    
    return buttonTitle;
}
@end

@interface HealthPlanPendingMessionsViewController ()
<TaskObserver>
{
    
}

@property (nonatomic, strong) HealthPlanPendingMessionsCountBlock countBlock;

@property (nonatomic, strong) HealthPlanPendingMessionsButtonView* buttonsView;
@property (nonatomic, strong) UITabBarController* tabbarController;
@property (nonatomic, readonly) NSArray* pendingStatusList;

@property (nonatomic, strong) NSArray* listCounts;
@end

@implementation HealthPlanPendingMessionsViewController
@synthesize pendingStatusList = _pendingStatusList;


- (id) initWithCountBlock:(HealthPlanPendingMessionsCountBlock) block
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _countBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutElements];
    
    NSMutableArray* controllers = [NSMutableArray array];
    [self.pendingStatusList enumerateObjectsUsingBlock:^(NSString* statusString, NSUInteger idx, BOOL * _Nonnull stop) {
        HealthPlanMessionTableViewController* controller = [[HealthPlanMessionTableViewController alloc]initWithStatusList:@[statusString]];
        [controllers addObject:controller];
    }];
    
    HealthPlanMessionTableViewController* allController = [[HealthPlanMessionTableViewController alloc]initWithStatusList:self.pendingStatusList];
    [controllers insertObject:allController atIndex:0];
    [self.tabbarController setViewControllers:controllers];
    
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    [paramDictionary setValue:self.pendingStatusList forKey:@"status"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [paramDictionary setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanListCountTask" taskParam:paramDictionary TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements
{
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(53);
    }];
    
    [self.tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.buttonsView.mas_bottom);
    }];
}

- (NSArray*) undealStatusList
{
    NSMutableArray* statusList = [NSMutableArray array];
    
    
    BOOL privilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:1 OperateCode:kPrivilegeEditOperate];
    if (privilege)
    {
        //待制定
        [statusList addObject:@"1"];
    }
    
    privilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:2 OperateCode:kPrivilegeConfirmOperate];
    if (privilege)
    {
        //待确认
        [statusList addObject:@"2"];
    }
    
    privilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthPlanMode Status:3 OperateCode:kPrivilegeEditOperate];
    if (privilege)
    {
        //待调整
        [statusList addObject:@"3"];
    }
    
    
    return statusList;
}

- (void) selectedStatus:(NSInteger) statusIndex
{
    [self.tabbarController setSelectedIndex:statusIndex];
}

#pragma mark - settingAndGetting
- (NSArray*) pendingStatusList
{
    if (!_pendingStatusList) {
        _pendingStatusList = [self undealStatusList];
    }
    return _pendingStatusList;
}

- (HealthPlanPendingMessionsButtonView*) buttonsView
{
    if(!_buttonsView)
    {
        __weak typeof(self) weakSelf = self;
        _buttonsView = [[HealthPlanPendingMessionsButtonView alloc] initWithPendingMessionStatusList:self.pendingStatusList selecteBlock:^(NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf selectedStatus:index];
        }];
        [self.view addSubview:_buttonsView];
        
    }
    return _buttonsView;
}

- (UITabBarController*) tabbarController
{
    if (!_tabbarController) {
        _tabbarController = [[UITabBarController alloc] init];
        [self.view addSubview:_tabbarController.view];
        [self addChildViewController:_tabbarController];
    }
    return _tabbarController;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"HealthPlanListCountTask"])
    {
        if (taskError != StepError_None) {
            [self showAlertMessage:errorMessage ];
            return;
        }
        
        [self.buttonsView setStatusCounts:self.listCounts];
        
        __block NSNumber* totalCountNumber = 0;
        [self.listCounts enumerateObjectsUsingBlock:^(NSDictionary* countDict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString* statusName = [countDict valueForKey:@"statusName"];
            if (statusName && [statusName isEqualToString:@"全部"]) {
                totalCountNumber = [countDict valueForKey:@"count"];
                *stop = YES;
            }
            
        }];
        
        if (totalCountNumber && self.countBlock)
        {
            self.countBlock(totalCountNumber.integerValue);
        }
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"HealthPlanListCountTask"])
    {
        _listCounts = (NSArray*) taskResult;
    }
}
@end
