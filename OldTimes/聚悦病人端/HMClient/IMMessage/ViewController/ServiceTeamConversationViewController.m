//
//  ServiceTeamConversationViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceTeamConversationViewController.h"
#import "InitializationHelper.h"
//#import "IMConversationChatViewController.h"
#import "ChatGroupViewController.h"
#import "HMClientGroupChatModel.h"
#import "ServiceTeamMemberInfoView.h"
#import "HMDoctorIconNavView.h"
#import "ChatGroupViewController.h"
#import "IMMessageHandlingCenter.h"
#import "IMPatientContactExtensionModel.h"

@interface CustomView : UIImageView

@end
@implementation CustomView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = 44.0 - bounds.size.width;
    CGFloat heightDelta = 44.0 - bounds.size.height;
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
static CGFloat const kTeamViewHeight = 90.0;
@interface ServiceTeamConversationViewController ()<TaskObserver>
{
//    IMConversationChatViewController* vcTeamMessage;
    NSInteger teamId;
    NSArray* staffs;
}
@property (nonatomic, strong)  ServiceTeamMemberInfoView  *teamMemberInfoView; // <##>
@property (nonatomic, strong) HMClientGroupChatModel *model;
@property (nonatomic, strong)  CustomView  *moveOperationView; // <##>
@property (nonatomic, strong)  UIBarButtonItem  *rightTeamItem; // <##>
@property (nonatomic, strong)  UIBarButtonItem  *rightDotsItem; // <##>

@property (nonatomic, strong)  HMDoctorIconNavView  *teamNaviView; // <##>
@property (nonatomic, strong)  MASConstraint  *teamViewBottomConstraint; // <##>
@property (nonatomic)  BOOL  teamViewShow; // <##>
@property (nonatomic)  CGFloat  offset; // <##>

@property (nonatomic, strong) ChatGroupViewController *teamChatVC;

@end

@implementation ServiceTeamConversationViewController

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"offset"];
}

- (instancetype)initWithChatModel:(HMClientGroupChatModel *)chatModel
{
    self = [super init];
    if (self) {
        _model = chatModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor commonBackgroundColor];
    [self configElements];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    UIButton *imageBtn =  [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, 38, 38)];
    [imageBtn setImage:[UIImage imageNamed:@"icon_navi_close"] forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(dismissChatVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:imageBtn];
    UILabel *label = [UILabel new];
    label.text = self.model.teamName;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont font_30];
    label.frame = CGRectMake(0, 0, 200, 44);
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    [self.navigationItem setLeftBarButtonItems:@[cancelItem, titleItem]];
    [self.navigationItem setRightBarButtonItem:self.rightTeamItem];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureResponse:)];
    panGesture.maximumNumberOfTouches = 1;
    [self.navigationController.navigationBar addGestureRecognizer:panGesture];
    
    [self addObserver:self forKeyPath:@"offset" options:NSKeyValueObservingOptionNew context:nil];

    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置数据
- (void)configData {
    __weak typeof(self) weakSelf = self;
    
    [self.teamMemberInfoView configDoctorsInfo:self.model.staffs leaderID:self.model.teamStaffId memberClickedCompletion:^(StaffInfo * _Nonnull staffInfo) {
        //跳转到医生详情 StaffDetailViewController
        [weakSelf teamViewMoveAction];
        [HMViewControllerManager createViewControllerWithControllerName:@"StaffDetailViewController" ControllerObject:staffInfo];
    }];
}

// 设置约束
- (void)configConstraints {
    
    [[MessageManager share] querySessionDataWithUid:self.model.grouptargetId completion:^(ContactDetailModel *detailModel) {
        
        if (!detailModel && self.model.grouptargetId) {
            detailModel = [[ContactDetailModel alloc] init];
            detailModel._target = self.model.grouptargetId;
        }
        self.teamChatVC = [[ChatGroupViewController alloc] initWithDetailModel:detailModel];
        [self.view addSubview:self.teamChatVC.view];
        [self addChildViewController:self.teamChatVC];
        [self.teamChatVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        [self.view addSubview:self.teamMemberInfoView];
        [self.teamMemberInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            self.teamViewBottomConstraint = make.bottom.equalTo(self.view.mas_top);
            make.height.mas_equalTo(kTeamViewHeight);
        }];

        
       IMPatientContactExtensionModel *extensionModel = [IMPatientContactExtensionModel mj_objectWithKeyValues:[detailModel._extension mj_JSONObject]];
        [self.teamNaviView setHidden:extensionModel.classify == 5];
        
        if (extensionModel.classify == 5) {
            UIButton *imageBtn =  [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, 38, 38)];
            [imageBtn setImage:[UIImage imageNamed:@"icon_navi_close"] forState:UIControlStateNormal];
            [imageBtn addTarget:self action:@selector(dismissChatVC) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:imageBtn];            
            UILabel *label = [UILabel new];
            label.text = detailModel._nickName;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont font_30];
            label.frame = CGRectMake(0, 0, ScreenWidth - 80, 44);
            UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:label];
            [self.navigationItem setLeftBarButtonItems:@[cancelItem, titleItem]];
        }
    }];


}


#pragma mark - Event Response

- (void)dismissChatVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)teamViewMoveAction {
    self.offset = self.teamViewShow ? 0 : kTeamViewHeight;

    self.teamViewBottomConstraint.offset = self.offset;
    CGFloat alpha = self.teamViewShow ? 1 : 0.01;
    CGAffineTransform transform = self.teamViewShow ? CGAffineTransformMakeScale(1.0, 1.0) : CGAffineTransformMakeScale(1.3, 1.3);
    self.teamViewShow ^= 1;
    [UIView animateWithDuration:0.24 animations:^{
        [self.view layoutIfNeeded];
        self.rightTeamItem.customView.alpha = alpha;
        [self.rightTeamItem.customView setTransform:transform];
        self.teamChatVC.tableView.contentInset = UIEdgeInsetsMake((self.teamViewShow ? kTeamViewHeight : 0), 0, 0, 0);

    } completion:^(BOOL finished) {
            [self.navigationItem setRightBarButtonItem:(self.teamViewShow ? self.rightDotsItem : self.rightTeamItem)];
    }];
}

- (void)panGestureResponse:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture translationInView:self.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            self.offset = MIN(kTeamViewHeight, MAX(0 , self.offset + point.y));
            self.teamViewBottomConstraint.offset = self.offset;
            [self.teamMemberInfoView.superview layoutIfNeeded];
            self.teamChatVC.tableView.contentInset = UIEdgeInsetsMake(self.offset, 0, 0, 0);

            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (self.offset >= (kTeamViewHeight * 0.5)) {
                self.offset = kTeamViewHeight;
                self.teamViewShow = YES;
            }
            else {
                self.offset = 0;
                self.teamViewShow = NO;
            }
            CGFloat alpha = self.teamViewShow ? 0.01 : 1;

            self.teamViewBottomConstraint.offset = self.offset;
            [UIView animateWithDuration:0.12 animations:^{
                [self.teamMemberInfoView.superview layoutIfNeeded];
                self.rightTeamItem.customView.alpha = alpha;
                self.teamChatVC.tableView.contentInset = UIEdgeInsetsMake(self.teamViewShow ? kTeamViewHeight : 0, 0, 0, 0);
            } completion:^(BOOL finished) {
                    [self.navigationItem setRightBarButtonItem:(self.teamViewShow ? self.rightDotsItem : self.rightTeamItem)];
            }];
            break;
        }
        default:
            break;
    }

    //每次移动完，将移动量置为0，否则下次移动会加上这次移动量
    [gesture setTranslation:CGPointZero inView:self.view];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"offset"]) {
        CGAffineTransform transform = CGAffineTransformMakeScale(1 + 0.3 * (self.offset / kTeamViewHeight), 1 + 0.3 * (self.offset / kTeamViewHeight));
        self.rightTeamItem.customView.alpha = 1.0 * (1 - (self.offset / kTeamViewHeight));
        [self.rightTeamItem.customView setTransform:transform];
        
    }
}

#pragma mark - Delegate

#pragma mark -TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length) {
        return;
    }
    [self.view closeWaitView];
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
}

#pragma mark - Override

#pragma mark - Init

- (ServiceTeamMemberInfoView *)teamMemberInfoView {
    if (!_teamMemberInfoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(85, 78);
        layout.sectionInset = UIEdgeInsetsMake(12, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _teamMemberInfoView = [[ServiceTeamMemberInfoView alloc] initWithFlowLayout:layout itemSize:CGSizeZero];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureResponse:)];
        panGesture.maximumNumberOfTouches = 1;
        [_teamMemberInfoView addGestureRecognizer:panGesture];
    }
    return _teamMemberInfoView;
}

- (CustomView *)moveOperationView {
    if (!_moveOperationView) {
        _moveOperationView = [[CustomView alloc] initWithImage:[UIImage imageNamed:@"icon_moveGesture_btn"]];
        _moveOperationView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureResponse:)];
        panGesture.maximumNumberOfTouches = 1;
        [_moveOperationView addGestureRecognizer:panGesture];

    }
    return _moveOperationView;
}

- (HMDoctorIconNavView *)teamNaviView {
    if (!_teamNaviView) {
        _teamNaviView = [HMDoctorIconNavView new];
        NSInteger rightItemCount = MIN(3, self.model.staffs.count);
        _teamNaviView.frame = CGRectMake(0, 0, (25 - 4) * rightItemCount + 15 , 25);
        if (self.model.staffs.count) {
            [_teamNaviView fillDataWithDataList:self.model.staffs];
        }
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teamViewMoveAction)];
        [_teamNaviView addGestureRecognizer:tapGesture];
        _teamNaviView.userInteractionEnabled = YES;
    }
    return _teamNaviView;
}

- (UIBarButtonItem *)rightTeamItem {
    if (!_rightTeamItem) {
        _rightTeamItem = [[UIBarButtonItem alloc] initWithCustomView:self.teamNaviView];
    }
    return _rightTeamItem;
}

- (UIBarButtonItem *)rightDotsItem {
    if (!_rightDotsItem) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dots"]];
        view.frame = CGRectMake(0, 0, 24, 24);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teamViewMoveAction)];
        [view addGestureRecognizer:tapGesture];
        _rightDotsItem = [[UIBarButtonItem alloc] initWithCustomView:view];

    }
    return _rightDotsItem;
}
@end
