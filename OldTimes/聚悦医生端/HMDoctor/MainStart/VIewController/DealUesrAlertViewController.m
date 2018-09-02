//
//  DealUesrAlertViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/3.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DealUesrAlertViewController.h"

@interface DealUesrAlertCell : UIControl
{
    UIImageView* ivSelected;
    UILabel* lbTitle;
}

- (id) initWithTitle:(NSString*) title;

@end

@implementation DealUesrAlertCell

- (id) initWithTitle:(NSString*) title
{
    self = [super init];
    if (self)
    {
        ivSelected = [[UIImageView alloc]init];
        [self addSubview:ivSelected];
        [ivSelected mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(10);
        }];
        
        lbTitle = [[UILabel alloc]init];
        [self addSubview:lbTitle];
        [lbTitle setText:title];
        [lbTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbTitle setFont:[UIFont systemFontOfSize:14]];
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(ivSelected.mas_right).with.offset(6);
        }];
    }
    return self;
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (!selected)
    {
        [ivSelected setImage:[UIImage imageNamed:@"c_contact_unselected"]];
    }
    else
    {
        [ivSelected setImage:[UIImage imageNamed:@"c_contact_selected"]];
    }
}
@end

@interface DealUesrAlertView : UIView
{
    UILabel* lbTitle;
    
    NSMutableArray* dealCells;
    
}

@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, readonly) UIButton* confirmbutton;
@end

@implementation DealUesrAlertView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        lbTitle = [[UILabel alloc]init];
        [self addSubview:lbTitle];
        [lbTitle setText:@"请选择处理方式"];
        [lbTitle setTextColor:[UIColor whiteColor]];
        [lbTitle setFont:[UIFont systemFontOfSize:15]];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [lbTitle setBackgroundColor:[UIColor mainThemeColor]];
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self);
            make.height.mas_equalTo(30);
        }];
        
        _confirmbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_confirmbutton];
        [_confirmbutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 44) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_confirmbutton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        _confirmbutton.layer.cornerRadius = 2.5;
        _confirmbutton.layer.masksToBounds = YES;
        
        [_confirmbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.right.equalTo(self).with.offset(-10);
            make.bottom.equalTo(self).with.offset(-5);
            make.height.mas_equalTo(@40);
        }];
        
        [self createCells];
        
        
    }
    return self;
}

- (void) createCells
{
    NSArray* titles = @[@"调整预警值", @"调整用药", @"继续监测", @"通知复诊", @"联系患者", @"取消"];
    dealCells = [NSMutableArray array];
    for (NSInteger index = 0; index < titles.count; ++index)
    {
        NSString* title = titles[index];
        DealUesrAlertCell* cell = [[DealUesrAlertCell alloc]initWithTitle:title];
        [self addSubview:cell];
        [dealCells addObject:cell];
        [cell setSelected:(index == _selectedIndex)];
        [cell addTarget:self action:@selector(dealCellClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.height.mas_equalTo(@51);
            if (0 == index % 2)
            {
                make.left.equalTo(self);
            }
            else
            {
                DealUesrAlertCell* leftCell = dealCells[index - 1];
                make.left.equalTo(leftCell.mas_right);
                make.top.equalTo(leftCell);
                //make.height.equalTo(leftCell);
                make.right.equalTo(self);
                make.width.equalTo(leftCell);
            }
            
            if (index < 2)
            {
                make.top.equalTo(lbTitle.mas_bottom).with.offset(5);
            }
            else //if(0 == index % 2)
            {
                DealUesrAlertCell* topCell = dealCells[index - 2];
                make.top.equalTo(topCell.mas_bottom);
                make.height.equalTo(topCell);
            }

        }];
    }
}

- (void) dealCellClicked:(id) sender
{
    if (![sender isKindOfClass:[DealUesrAlertCell class]])
    {
        return;
    }
    DealUesrAlertCell* selCell = (DealUesrAlertCell*) sender;
    NSInteger selIndex = [dealCells indexOfObject:selCell];
    if (_selectedIndex == selIndex)
    {
        return;
    }
    _selectedIndex = selIndex;
    
    for (DealUesrAlertCell* cell in dealCells)
    {
        [cell setSelected:(cell == selCell)];
    }
    
}


@end

@interface DealUesrAlertViewController ()
<TaskObserver>
{
    UserAlertInfo* alertInfo;
    DealUesrAlertView* dealview;
}

@property (nonatomic, copy) UserAlertDealCompletedBlock completedblock;
@end

@implementation DealUesrAlertViewController

- (id) initWithUserAlertInfo:(UserAlertInfo*) userAlert
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        alertInfo = userAlert;
    }
    return self;
}

+ (void) showInParentViewController:(UIViewController*) parentController
                      UserAlertInfo:(UserAlertInfo*) userAlert
        UserAlertDealCompletedBlock:(UserAlertDealCompletedBlock)block
{
    if (!parentController || !userAlert)
    {
        return;
    }
    
    DealUesrAlertViewController* vcDealAlert = [[DealUesrAlertViewController alloc]initWithUserAlertInfo:userAlert];
    [vcDealAlert setCompletedblock:block];
    [parentController addChildViewController:vcDealAlert];
    [parentController.view addSubview:vcDealAlert.view];
    [vcDealAlert.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(parentController.view);
        make.top.and.bottom.equalTo(parentController.view);
    }];
}

- (void) loadView
{
    UIControl* closeControl = [[UIControl alloc]init];
    [self setView:closeControl];
    
    [closeControl setBackgroundColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:0.32]];
    [closeControl addTarget:self action:@selector(closeController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dealview = [[DealUesrAlertView alloc]init];
    [self.view addSubview:dealview];
    [dealview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.centerY.equalTo(self.view);
        make.height.mas_equalTo(@235);
    }];
    
    [dealview.confirmbutton addTarget:self action:@selector(dealConfirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeController
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) dealConfirmButtonClicked:(id) sender
{
    DealAlertWay dealway = dealview.selectedIndex;
    if (DealAlert_Cancel == dealway) {
        [self closeController];
        return ;
    }
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"staffUserId"];
    [dicPost setValue:alertInfo.testResulId forKey:@"testResulId"];
    [dicPost setValue:[NSNumber numberWithInteger:(dealway + 1)] forKey:@"type"];
    
    //[self closeController]; DealUserAlertTask
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"DealUserAlertTask" taskParam:dicPost TaskObserver:self];
}

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"DealUserAlertTask"])
    {
        NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
        NSNumber* numType = [dicParam valueForKey:@"type"];
        if (numType && [numType isKindOfClass:[NSNumber class]])
        {
            switch (numType.intValue - 1)
            {
                case DealAlert_AdjustValue:
                    
                    break;
                case DealAlert_ContactPatient:
                {
                    
                }
                    break;
                default:
                    break;
            }
        }
        
        if (_completedblock)
        {
            _completedblock();
        }
        [self closeController];
    }
}
@end
