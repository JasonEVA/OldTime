//
//  FriendDetailStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "FriendDetailStartViewController.h"
#import "HMSwitchView.h"
#import "FriendInfo.h"
#import "DetectRecordsStartViewController.h"
#import "SurveyRecordsTableViewController.h"
#import "MedicationPlanViewController.h"
#import "FriendSelectViewController.h"
#import "LifeStylePlanTableViewController.h"

typedef enum : NSUInteger {
    DetectRecordsIndex,         //监测记录
    SurveyRecordsIndex,         //随访记录
    PsychologyIndex,
    LifeStyleIndex,             //生活记录
}FriendSwitchIndex;

@interface FriendNavigationButton : UIControl
{
    UILabel* lbFriendName;
    UIImageView* ivArrow;
}

- (void) setFriendRelationName:(NSString*) relationname;
@end

@interface FriendDetailStartViewController ()
<HMSwitchViewDelegate,
TaskObserver>
{
    HMSwitchView* switchview;
    NSMutableArray* friendUsers;    //我的好友列表
    FriendInfo* selectFriend;
    UIView* friendSelView;
    FriendNavigationButton* friendSelectButton;
    
    UIViewController* vcContent;
}

- (void) setSelectFriend:(FriendInfo*) friend;
@end

@implementation FriendNavigationButton

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        
        lbFriendName = [[UILabel alloc]init];
        [self addSubview:lbFriendName];
        [lbFriendName setFont:[UIFont font_30]];
        [lbFriendName setTextColor:[UIColor mainThemeColor]];
        [lbFriendName setTextAlignment:NSTextAlignmentCenter];
        [lbFriendName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.centerY.equalTo(self);
        }];
        
        ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"doctor_icon_arrows_down"]];
        [self addSubview:ivArrow];
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(lbFriendName.mas_right).with.offset(5);
            make.right.equalTo(self).with.offset(-5);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return self;
}

- (void) setFriendRelationName:(NSString*) relationname
{
    [lbFriendName setText:relationname];
}

@end



@implementation FriendDetailStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSwitchView];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[FriendInfo class]])
    {
        FriendInfo* friend = (FriendInfo*) self.paramObject;
        [self setSelectFriend:friend];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"FriendListTask" taskParam:nil TaskObserver:self];
}

- (void) setSelectFriend:(FriendInfo*) friend
{
    selectFriend = friend;
    [self createContentView:DetectRecordsIndex];
    
    [switchview setSelectedIndex:DetectRecordsIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createSwitchView
{
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@43);
    }];
    
    [switchview createCells:@[@"监测", @"随访", @"用药", @"生活"]];
    
    [switchview setDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationBar* bar = self.navigationController.navigationBar;
    if (!friendSelView)
    {
        friendSelView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth - 100)/2, bar.height - 35, 100, 35)];
        [bar addSubview:friendSelView];
        [friendSelView setBackgroundColor:[UIColor clearColor]];
        
        friendSelectButton = [[FriendNavigationButton alloc]init];
        [friendSelView addSubview:friendSelectButton];
        [friendSelectButton addTarget:self action:@selector(friendSelectButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [friendSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(friendSelView);
            make.width.equalTo(friendSelView);
            make.bottom.equalTo(friendSelView).with.offset(-5);
            make.height.mas_equalTo(@30);
        }];
    }
    
    if (selectFriend)
    {
        [friendSelectButton setFriendRelationName:selectFriend.relativeFriendName];
    }

}

- (void)friendSelectButtonClick
{
    if (friendUsers)
    {
        [FriendSelectViewController createWithParentViewController:self item:friendUsers selectblock:^(FriendInfo *friendinfo) {
            
            [friendSelectButton setFriendRelationName:friendinfo.relativeFriendName];
            [self setSelectFriend:friendinfo];
        }];
    }

}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (friendSelView)
    {
        [friendSelView removeFromSuperview];
        friendSelView = nil;
    }
}

- (void) createContentView:(NSInteger) index
{
    if (vcContent)
    {
        [vcContent.view removeFromSuperview];
        [vcContent removeFromParentViewController];
        vcContent = nil;
    }
    
    UserInfo* friendUser = selectFriend.relationUserDet;
    switch (index)
    {
        case DetectRecordsIndex:
        {
            //监测记录
            vcContent = [[DetectRecordsStartViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", friendUser.userId]];
            
        }
            break;
        case SurveyRecordsIndex:
        {
            //随访记录
            vcContent = [[SurveyRecordsTableViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", friendUser.userId]];
        }
            break;
        case PsychologyIndex:
        {
            //用药计划 MedicationPlanViewController
            vcContent = [[MedicationPlanViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", friendUser.userId]];
        }
            break;
        case LifeStyleIndex:
        {
            //生活记录
            vcContent = [[LifeStylePlanViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", friendUser.userId]];
        }
            break;
            default:
            break;
    }
    
    if (vcContent)
    {
        [self addChildViewController:vcContent];
        [self.view addSubview:vcContent.view];
        [vcContent.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.top.equalTo(switchview.mas_bottom);
            make.bottom.equalTo(self.view);
        }];
    }

}

#pragma HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSInteger) selectedIndex
{
    [self createContentView:selectedIndex];
}


#pragma mark - TaskObserver
- (void) task:(NSString *)taskId Result:(id)taskResult
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
    
    if ([taskname isEqualToString:@"FriendListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            friendUsers = [NSMutableArray array];
            NSDictionary* dicResult = (NSDictionary*)taskResult;
            NSArray* myConcern = [dicResult valueForKey:@"myConcern"];
            //NSArray* payAttentionToMe = [dicResult valueForKey:@"payAttentionToMe"];
            if (myConcern && [myConcern isKindOfClass:[NSArray class]])
            {
                [friendUsers addObjectsFromArray:myConcern];
            }
//            if (payAttentionToMe && [payAttentionToMe isEqualToArray:[NSArray array]])
//            {
//                [friendUsers addObjectsFromArray:payAttentionToMe];
//            }

            //[self initFriendNavigationBar];
        }
    }
}
@end
