//
//  NewMissionMainViewController.m
//  launcher
//
//  Created by TabLiu on 16/2/14.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionMainViewController.h"
#import "UIViewController+MMDrawerController.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "UIFont+Util.h"
#import "NewMissionAddMissionViewController.h"
#import "BaseNavigationController.h"
#import "NewGetTaskListRequest.h"
#import "NewMissionListTableViewCell.h"
#import "TaskListModel.h"
#import "NewEditingProjectViewController.h"
#import "ProjectContentModel.h"
#import "NewDeleteTaskRequest.h"
#import "NewDetailMissionViewController.h"
#import "ProjectMembersCollectionView.h"
#import "UnifiedUserInfoManager.h"
#import "NewTaskSearchViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "NewMissionChangeMissionStatusRequest.h"
#import "NewProjectDetailRequest.h"
#import "TaskMainButtonView.h"
#import "ProjectModel.h"
#import "AnimationController.h"
#import "NewMissionUpdateTaskSortRequest.h"

typedef NS_ENUM(NSUInteger, SnapshotMeetsEdge) {
	SnapshotMeetsEdgeTop,
	SnapshotMeetsEdgeBottom,
};

@interface NewMissionMainViewController ()<UITableViewDataSource, UITableViewDelegate,UIViewControllerTransitioningDelegate,BaseRequestDelegate,SWTableViewCellDelegate,NewMissionListTableViewCellDelegate,TaskMainButtonViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic,strong) TaskMainButtonView * buttonView;
@property (nonatomic) VCkind VCtype;

@property (nonatomic,assign)  NSInteger sections;
@property (nonatomic,strong) NSMutableArray * dueTasks;// 过期任务
@property (nonatomic,strong) NSMutableArray * otherTasks;

@property (nonatomic,strong) UIBarButtonItem * searchItem;
@property (nonatomic,strong) UIBarButtonItem * editingItem;

@property (nonatomic,strong) ProjectContentModel * model ;
@property (nonatomic,strong) ProjectMembersCollectionView * projectMembersCollectionView ;// show项目成员

@property (nonatomic,strong) NSDictionary * subtaskDict ;

@property (nonatomic,assign) NSInteger  pageIndex;//

@property (nonatomic,strong) ProjectDetailModel * DetailModel;

@property (nonatomic,strong) UIView * emptyPageView;
@property (nonatomic,assign) BOOL isDrawer ;

@property (nonatomic, strong) UIBarButtonItem *rightAddItem;

@property (nonatomic,copy)  changeLiftVCSelectCell changeCellBlock;
@property (nonatomic, strong)id<UIViewControllerAnimatedTransitioning> animationController;
@property (nonatomic, strong) CADisplayLink *autoScrollTimer;
@property (nonatomic, strong) UIView *snapshot;
@property (nonatomic, assign) SnapshotMeetsEdge autoScrollDirection;
@property (nonatomic, strong) NSArray<TaskListModel *> *exchangedTaskModels;
@property (nonatomic, strong) NSIndexPath *originIndexPath;
@property (nonatomic, strong) NSIndexPath *finalIndexPath;
@property (nonatomic, assign) BOOL needWarning;

@end

@implementation NewMissionMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.VCtype = VCkind_All;
    _sections = 2;
    
    _editingItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"BarButtonImg"] style:UIBarButtonItemStylePlain target:self action:@selector(editingButtonClick)];
    
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.emptyPageView];
    [self.view addSubview:self.projectMembersCollectionView];
    //[self.view addSubview:self.buttonView];
    
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Mission_NewMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *leftItem2 = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CLOSE) style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    
    [self.navigationItem setLeftBarButtonItems:@[leftItem1, leftItem2]];
    [self.navigationItem setRightBarButtonItem:self.rightAddItem];
    
    [self setframes];
    [self changeTitle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshData];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (IOS_VERSION_7_OR_ABOVE) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (IOS_VERSION_7_OR_ABOVE) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.projectMembersCollectionView.hidden = YES;
    if (IOS_VERSION_7_OR_ABOVE) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (NSString *)changeTitle
{
    switch (self.VCtype)
    {
        case VCkind_Today:
        {
            self.title = LOCAL(MISSION_TODAY);
        }
            break;
        case VCkind_Tomorrow:
        {
            self.title = LOCAL(MISSION_TOMORROW);
        }
            break;
        case VCkind_All:
        {
            self.title = LOCAL(NEWMISSION_ALL_MISSION);
        }
            break;
        case VCkind_Notime:
        {
            self.title = LOCAL(NEWMISSION_NO_START_TIME);
        }
            break;
        case VCkind_Send:
        {
            self.title = LOCAL(APPLY_SENDS);
        }
            break;
        case VCkind_Done:
        {
            self.title = LOCAL(NEWMISSION_FINISH);
        }
            break;
        case VCkind_nil:
        default:
            break;
    }
	
	return [self.title copy];
}

#pragma mark - Privite Methods
- (void)editingButtonClick
{
    NSString * userShowID = [UnifiedUserInfoManager share].userShowID;
    if ([userShowID isEqualToString:_model.createUser]) { //修改页面
        __block NewMissionMainViewController * weakSelf = self;
        NewEditingProjectViewController * editingProjectVC = [[NewEditingProjectViewController alloc] init];
        editingProjectVC.showId = _model.showId;
        [editingProjectVC setDeleProjectBlock:^{
            [weakSelf liftTableViewVC_ChangeSelectCellWithPath:[NSIndexPath indexPathForRow:0 inSection:0] model:nil];
        }];
        [editingProjectVC setChangeProjectName:^(NSString *name) {
            weakSelf.title = name;
            weakSelf.model.name = name;
        }];
        [self.navigationController pushViewController:editingProjectVC animated:YES];
    }else {
        
        if (self.projectMembersCollectionView.hidden == NO) {
            [self setProjectMembersHiddenWithHidden:YES];
        }else {
            if (_DetailModel) {
                [self.projectMembersCollectionView setProjectMembersData:_DetailModel.members];
                [self setProjectMembersHiddenWithHidden:NO];
            }else {
                NewProjectDetailRequest * request = [[NewProjectDetailRequest alloc] initWithDelegate:self];
                [request detailShowId:_model.showId];
            }
        }
    }
}

- (void)drawerStart:(BOOL)isShow
{
    self.isDrawer = isShow;
    if (self.projectMembersCollectionView.hidden == NO) {
        [self editingButtonClick];
    }
}

- (void)changeLeftVCSelectCellWithBlock:(changeLiftVCSelectCell)block
{
    self.changeCellBlock = block;
}

- (void)setProjectMembersHiddenWithHidden:(BOOL)hidden
{
    self.projectMembersCollectionView.hidden = hidden;
}

- (void)longPressGestureRecognized:(id)sender
{
	
	UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)sender;
	UIGestureRecognizerState state = gesture.state;
	
	CGPoint location = [gesture locationInView:self.tableview];
	NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:location];
	
	static UIView       *snapshot = nil;
	static NSIndexPath  *sourceIndexPath = nil;
	
	switch (state) {
		case UIGestureRecognizerStateBegan: {
			
			if (indexPath) {
				TaskListModel *selected = [self getCurrentTasksWithSection:indexPath.section][indexPath.row];
				if (!selected.hasParentTask) {
					[self hideAllTasksWithSeciton:indexPath.section];
					[self.tableview reloadData];
					NSInteger index = [[self getCurrentTasksWithSection:indexPath.section] indexOfObject:selected];
					indexPath = [NSIndexPath indexPathForRow:index inSection:indexPath.section];
				}
			
				sourceIndexPath = indexPath;
				NewMissionListTableViewCell *cell = (NewMissionListTableViewCell *)[self.tableview cellForRowAtIndexPath:indexPath];
				NSLog(@"%@", [[self getCurrentTasksWithSection:indexPath.section][indexPath.row] title]);

				
				self.originIndexPath = sourceIndexPath;
				snapshot = [cell getSnapCurrentCell];
				self.snapshot = snapshot;
				__block CGPoint center = cell.center;
				snapshot.center = center;
				snapshot.alpha = 0.0;
				[self.tableview addSubview:snapshot];
				[UIView animateWithDuration:0.25 animations:^{
					
					// Offset for gesture location.
					center.y = location.y;
					snapshot.center = center;
					snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
					snapshot.alpha = 0.98;
					cell.alpha = 0.0;
					cell.hidden = YES;
					
				}];
			}
			break;
		}
			
		case UIGestureRecognizerStateChanged: {
			
			CGPoint center = snapshot.center;
			center.y = location.y;
			snapshot.center = center;
			// Is destination valid and is it different from source?
			if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
				
				// 移动到指定的行
				if (sourceIndexPath.section != indexPath.section) {
					break;
				}
				
				// 子任务移动row<父任务或者>下一个非子任务, 返回原来的row
				// 父任务id等于另一父任务id则移动,否则不移动
				NSLog(@"%ld--->%ld", self.originIndexPath.row, indexPath.row);
				NSMutableArray *tasks = [self getCurrentTasksWithSection:sourceIndexPath.section];
				TaskListModel *proposedModel = tasks[indexPath.row];
				TaskListModel *sourceModel = tasks[self.originIndexPath.row];
				
				if ([sourceModel hasParentTask] && ![sourceModel hasSameParentWithTask:proposedModel]) {
					self.needWarning = (![self.originIndexPath isEqual:indexPath]);
					break;
				}
				self.needWarning = NO;
				
				if ([self checkIfSnapshotMeetsEdge]) {
					[self startAutoScrollTimer];
				} else {
					[self stopAutoScrollTimer];
				}
				
				[self.tableview moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
				UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
				cell.hidden = YES;
				
				sourceIndexPath = indexPath;
				
			}
			break;
		}
			
		default: {
			UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:sourceIndexPath];
			self.finalIndexPath = sourceIndexPath;
			cell.alpha = 0.0;
			
			[UIView animateWithDuration:0.25 animations:^{
				
				snapshot.center = cell.center;
				snapshot.transform = CGAffineTransformIdentity;
				snapshot.alpha = 0.0;
				cell.alpha = 1.0;
				
			} completion:^(BOOL finished) {
				
				cell.hidden = NO;
				sourceIndexPath = nil;
				[snapshot removeFromSuperview];
				snapshot = nil;
			}];
			[self stopAutoScrollTimer];
			
			NSLog(@"begin %@--->final---->%@",self.originIndexPath, self.finalIndexPath);
			
			if ([self.originIndexPath isEqual:self.finalIndexPath]) {
				self.exchangedTaskModels = nil;
				[self updateSortedTasksNeedRefresh:NO];
			} else {
				NSInteger newTaskIndex = self.finalIndexPath.row;
				NSArray *targetTasks = [self getCurrentTasksWithSection:self.finalIndexPath.section];
				self.exchangedTaskModels = [NSArray arrayWithObjects:targetTasks[self.originIndexPath.row], newTaskIndex == 0 ? nil : targetTasks[newTaskIndex + (newTaskIndex < self.originIndexPath.row? -1 : 0)], nil];
			}
			
			[self sendUpdateSortedRequestWithTasks:self.exchangedTaskModels];
			
			break;
		}
	}
}

///排序请求成功后更新数据源
- (void)updateSortedTasksNeedRefresh:(BOOL)refreshed {
	if (self.needWarning) {
		[self postError:LOCAL(MissionMoveError)];
	}
	
	if (refreshed) {
		NSMutableArray *tasks = [self getCurrentTasksWithSection:self.originIndexPath.section];
		TaskListModel *selectedTask = tasks[self.originIndexPath.row];
		[tasks removeObject:selectedTask];
		[tasks insertObject:selectedTask atIndex:self.finalIndexPath.row];
	}
	
	self.originIndexPath = nil;
	self.finalIndexPath = nil;
	[self.tableview reloadData];

}


- (BOOL)checkIfSnapshotMeetsEdge{
	CGFloat minY = CGRectGetMinY(_snapshot.frame);
	CGFloat maxY = CGRectGetMaxY(_snapshot.frame);
	if (minY < self.tableview.contentOffset.y + 60) {
		_autoScrollDirection = SnapshotMeetsEdgeTop;
		return YES;
	}
	if (maxY > self.tableview.bounds.size.height + self.tableview.contentOffset.y - 60) {
		_autoScrollDirection = SnapshotMeetsEdgeBottom;
		return YES;
	}
	return NO;
}

- (void)startAutoScroll{
	CGFloat pixelSpeed = 2;
	if (_autoScrollDirection == SnapshotMeetsEdgeTop) {//向下滚动
		if (self.tableview.contentOffset.y > 0) {
			 pixelSpeed = MAX(floor((self.tableview.contentOffset.y + 60 - _snapshot.center.y) / 60 * 20), pixelSpeed);
			[self.tableview setContentOffset:CGPointMake(0, self.tableview.contentOffset.y - pixelSpeed)];
			_snapshot.center = CGPointMake(_snapshot.center.x, _snapshot.center.y - pixelSpeed);
		}
	}else if (_autoScrollDirection == SnapshotMeetsEdgeBottom){
		//向上滚动
		pixelSpeed = MAX(floor((_snapshot.center.y + 60 - self.tableview.contentOffset.y-self.tableview.bounds.size.height) / 60 * 20), pixelSpeed);
		if (self.tableview.contentOffset.y + self.tableview.bounds.size.height < self.tableview.contentSize.height) {
			[self.tableview setContentOffset:CGPointMake(0, self.tableview.contentOffset.y + pixelSpeed)];
			_snapshot.center = CGPointMake(_snapshot.center.x, _snapshot.center.y + pixelSpeed);
		}
	}
}

- (void)startAutoScrollTimer{
	if (!_autoScrollTimer) {
		_autoScrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(startAutoScroll)];
		[_autoScrollTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
	}
}

- (void)stopAutoScrollTimer{
	if (_autoScrollTimer) {
		[_autoScrollTimer invalidate];
		_autoScrollTimer = nil;
	}
}

#pragma mark - ProjectMembersCollectionView

- (void)btnSearch
{
    NewTaskSearchViewController * searchVC = [[NewTaskSearchViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)back
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)dismissVC {
//    [UIView animateWithDuration:.25 animations:^{
//
//        CATransition *animation = [CATransition animation];
//        animation.duration = 0.7;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];;
//        animation.type = kCATransitionPush;
//        animation.subtype = kCATransitionFromLeft;
//        [self.view.window.layer addAnimation:animation forKey:nil];
//        
//    } completion:^(BOOL finished) {
//        [self dismissViewControllerAnimated:NO completion:nil];
//    }];

//    self.animationController = [AnimationController new];
//    self.transitioningDelegate = self;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)isShowDefineImage
{
    if (self.dueTasks.count == 0 && self.otherTasks.count == 0 ) {
        [self.emptyPageView setHidden:NO];
    }else {
        [self.emptyPageView setHidden:YES];
    }
}


#pragma mark - TaskMainButtonViewDelegate
- (void)TaskMainButtonViewDelegateCallBack_SelectButtonIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [self menuButtonClick];
            break;
            
        case 1:
            [self addMissionButtonClick];
            break;
            
        default:
            break;
    }
}

- (void)menuButtonClick
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)addMissionButtonClick
{
    NewMissionAddMissionViewController *VC = [[NewMissionAddMissionViewController alloc] initWithCreatMainMission];
    VC.myVCkind = self.VCtype;
    if (self.VCtype == VCkind_nil) {
        [VC setProjectName:self.model.name ShowId:self.model.showId];
    }
    __weak typeof(self) weakSelf = self;
    [VC setShowTypeblock:^(NSInteger index, ProjectModel *model) {
        NSIndexPath * path;
        if (index == 100) {
            path= [NSIndexPath indexPathForRow:index inSection:1];
        }else {
            path= [NSIndexPath indexPathForRow:index inSection:0];
        }
        ProjectContentModel * newmodel = [[ProjectContentModel alloc] init];
        newmodel.showId = model.showId;
        newmodel.createUser = model.createUser;
        newmodel.name = model.name;
        if (weakSelf.changeCellBlock) {  // 左侧侧边栏 也要改变
            weakSelf.changeCellBlock(path,model.showId);
        }
        [weakSelf liftTableViewVC_ChangeSelectCellWithPath:path model:newmodel];
    }];
    switch (self.VCtype) {
        case VCkind_Today:
        {
            [VC setTimeType:Time_Type_Today];
        }
            break;
         
        case VCkind_Tomorrow:
        {
            [VC setTimeType:Time_Type_Tomorrow];
        }
            break;
            
        default:
            [VC setTimeType:Time_Type_NO];
            break;
    }
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)setframes
{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.emptyPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableview);
    }];

}

- (void)liftTableViewVC_ChangeSelectCellWithPath:(NSIndexPath *)indexPath model:(ProjectContentModel *)model
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.otherTasks removeAllObjects];
    [self.dueTasks removeAllObjects];
    self.subtaskDict  = [NSMutableDictionary dictionary];
    [self.tableview reloadData];
    
    _DetailModel = nil;
    _sections = 2;
    if (indexPath.section == 0) {
        VCkind kind = (VCkind)indexPath.row;
        self.VCtype = kind;
        [self changeTitle];
        if (self.VCtype == VCkind_Tomorrow || self.VCtype == VCkind_Done) {
            _sections = 1;
        }
        [self.navigationItem setRightBarButtonItems:@[self.rightAddItem] animated:YES];

    }else {
        self.VCtype = VCkind_nil;
        self.title = model.name;
        _model = model;
		_sections = 1;
        [self.navigationItem setRightBarButtonItems:@[ self.rightAddItem, _editingItem] animated:YES];

    }
    [self.tableview.footer setState:MJRefreshStateIdle];
    [self refreshData];
}
#pragma mark - request
- (void)getMoreData
{
    [self requestDataWithPage:_pageIndex+1];
}
- (void)refreshData
{
    // 重新请求数据
    _pageIndex = 0;
    [self requestDataWithPage:_pageIndex+1];
}

- (void)requestDataWithPage:(NSInteger)page
{
    switch (self.VCtype) {
        case VCkind_Today:
        {
            // 今天
            NewGetTaskListRequest * request = [[NewGetTaskListRequest alloc] initWithDelegate:self];
            request.Type = @1;
            request.time = [[NSDate date] timeIntervalSince1970] * 1000;
            request.projectId = @"";
            request.statusType = @"";
            request.pageIndex = @1;
            [request requestData];
        }
            break;
        case VCkind_nil:
        {
            // 项目
            NewGetTaskListRequest * request = [[NewGetTaskListRequest alloc] initWithDelegate:self];
            request.Type = @7;
            request.time = 0;
            request.projectId = _model.showId;
            request.statusType = @"";
            request.pageIndex = @1;
            [request requestData];
        }
            break;
            
        case VCkind_Tomorrow:
        {
            // 明天
            NewGetTaskListRequest * request = [[NewGetTaskListRequest alloc] initWithDelegate:self];
            request.Type = @2;
            request.time = [[NSDate date] timeIntervalSince1970] * 1000;
            request.projectId = @"";
            request.statusType = @"";
            request.pageIndex = @1;
            [request requestData];
        }
            break;
            
        case VCkind_All:
        {
            // 全部
            NewGetTaskListRequest * request = [[NewGetTaskListRequest alloc] initWithDelegate:self];
            request.Type = @4;
            request.time = [[NSDate date] timeIntervalSince1970] * 1000;
            request.projectId = @"";
            request.statusType = @"WAITING";
            request.pageIndex = @1;
            [request requestData];
        }
            break;
            
        case VCkind_Notime:
        {
            // 无开始时间
            NewGetTaskListRequest * request = [[NewGetTaskListRequest alloc] initWithDelegate:self];
            request.Type = @3;
            request.time = 0;
            request.projectId = @"";
            request.statusType = @"";
            request.pageIndex = @1;
            [request requestData];
        }
            break;
            
        case VCkind_Send:
        {
            // 我发出的
            NewGetTaskListRequest * request = [[NewGetTaskListRequest alloc] initWithDelegate:self];
            request.Type = @5;
            request.time = 0;
            request.projectId = @"";
            request.statusType = @"";
            request.pageIndex = @1;
            [request requestData];
        }
            break;
            
        case VCkind_Done:
        {
            // 已完成
            NewGetTaskListRequest * request = [[NewGetTaskListRequest alloc] initWithDelegate:self];
            request.Type = @6;
            request.time = [[NSDate date] timeIntervalSince1970] * 1000;
            request.projectId = @"";
            request.statusType = @"";
            request.pageIndex = @1;
            [request requestData];
            
        }
            break;
            
        default:
        {
            // 其他
        }
            break;
    }
}

- (void)deleteTaskRequestWithShowID:(NSString *)showId path:(NSIndexPath *)path
{
    NewDeleteTaskRequest * request = [[NewDeleteTaskRequest alloc] initWithDelegate:self];
    request.showId = showId;
    request.path = path;
    [request requestData];
    [self postLoading];
}

- (void)deleteDataWithArray:(NSIndexPath *)path
{
	NSMutableArray *tasks = [self getCurrentTasksWithSection:path.section];
	TaskListModel* model = tasks[path.row];
	if (model.level == 2 && model.notNeedDisplacement == YES) {
		NSMutableArray * array = [self.subtaskDict objectForKey:model.parentTaskId];
		[array removeObject:model];
	}
	[tasks removeObjectAtIndex:path.row];
	

    [self.tableview reloadData];
}

- (void)missionChangeMissionStatusRequestWithShowId:(NSString *)ID status:(NSString *)status
{
    NewMissionChangeMissionStatusRequest * request = [[NewMissionChangeMissionStatusRequest alloc] initWithDelegate:self];
    [request requestWithShowID:ID status:status];
    [self postLoading];
}

- (void)sendUpdateSortedRequestWithTasks:(NSArray<TaskListModel *> *)tasks {
	NewMissionUpdateTaskSortRequest *sortRequest = [[NewMissionUpdateTaskSortRequest alloc] initWithDelegate:self];
	NSLog(@"tasks----|||%@|||", tasks);
	[sortRequest sendUpdateSortTasksRequestWithTasks:tasks];
}

#pragma mark - BaseRequestDelegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[NewGetTaskListRequest class]]) {
        // 任务列表
        //_pageIndex +=1;
        [self.dueTasks removeAllObjects];
        [self.otherTasks removeAllObjects];
        NewGetTaskListRequest * requ = (NewGetTaskListRequest *)request;
        NewGetTaskListResponse * resp = (NewGetTaskListResponse *)response;
        if ([requ.Type intValue] != 2 && [requ.Type intValue] < 6) {
            // 今天
            self.dueTasks = [NSMutableArray arrayWithArray:resp.overdue_Array];
            self.otherTasks = [NSMutableArray arrayWithArray:resp.NO_overdue_Array];
            [self.tableview reloadData];
        }else {
            self.otherTasks = [NSMutableArray arrayWithArray:resp.NO_overdue_Array];
            [self.tableview reloadData];
        }
        if (resp.dataArray.count == 0) {
            [self.tableview.footer setState:MJRefreshStateNoMoreData];
        }
        self.subtaskDict = [NSDictionary dictionaryWithDictionary:resp.child_dict];
    }
    else if ([request isKindOfClass:[NewDeleteTaskRequest class]]) {
        NewDeleteTaskRequest * requ = (NewDeleteTaskRequest *)request;
        [self deleteDataWithArray:requ.path];
        
    }else if ([request isKindOfClass:[NewMissionChangeMissionStatusRequest class]]) {
        //NewMissionChangeMissionStatusResponse * resp = (NewMissionChangeMissionStatusResponse *)response;
        [self refreshData];
    }else if ([request isKindOfClass:[NewProjectDetailRequest class]]) {
        NewProjectDetailResponse * resp = (NewProjectDetailResponse *)response;
        _DetailModel = resp.model;
        [self editingButtonClick];
        
	}
	
	[self hideLoading];
	if ([response isKindOfClass:[NewMissionUpdateTaskSortResponse class]]) {
		NSLog(@"更新排序调用完成%@-->", [(NewMissionUpdateTaskSortResponse *)response sortedTask]);
		[self updateSortedTasksNeedRefresh:YES];
		
	}
	
    [self.tableview.footer endRefreshing];
    [self.tableview.header endRefreshing];
    
    [self isShowDefineImage];
    
}
- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self.tableview.footer endRefreshing];
    [self.tableview.header endRefreshing];
    [self postError:errorMessage];
	if ([request isKindOfClass:[NewMissionUpdateTaskSortRequest class]]) {
		[self updateSortedTasksNeedRefresh:NO];
	}
}

#pragma mark - tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dueTasks.count == 0 && self.otherTasks.count == 0 ) {
        return 0;
    }else {
        return _sections;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
    if (section == 0) {
        return self.dueTasks.count;
	} else {
		return self.otherTasks.count;
	}
	 */
	
	return [self getCurrentTasksWithSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"NewMissionListTableViewCell";
    static NSString * str1 = @"NewMissionListTableViewCell1";

	NSMutableArray *tasks = [self getCurrentTasksWithSection:indexPath.section];
	TaskListModel * model = tasks[indexPath.row];
	
    NewMissionListTableViewCell * cell;
    if (model.level == 1 || model.notNeedDisplacement == NO) { // 跟任务
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[NewMissionListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            [cell setRightUtilityButtons:[self rightButtons]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setDelegate:self];
            [cell setButtonDelegate:self];
        }
        if (self.VCtype == VCkind_nil || self.VCtype == VCkind_Send)
        {
            [cell setNeedShowHeadImg:YES];
        }
        else
        {
            [cell setNeedShowHeadImg:NO];
        }
		
        [cell setCellData:model];


    }else { // 子任务
        cell = [tableView dequeueReusableCellWithIdentifier:str1];
        if (!cell) {
            cell = [[NewMissionListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str1];
            [cell setRightUtilityButtons:[self rightButtons]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setDelegate:self];
            [cell setButtonDelegate:self];
        }
        if (self.VCtype == VCkind_nil || self.VCtype == VCkind_Send)
        {
            [cell setNeedShowHeadImg:YES];
        }
        else
        {
            [cell setNeedShowHeadImg:NO];
        }
        [cell setProjrctData:model];
    }
    
    [cell setPath:indexPath];
    if (indexPath.section == 0)
    {
        if (indexPath.row == self.otherTasks.count - 1)
        {
            [cell SetLineHidden:YES];
        }
        else
        {
            [cell SetLineHidden:NO];
        }
    }
    else
    {
        if (indexPath.row == self.dueTasks.count - 1)
        {
            [cell SetLineHidden:YES];
        }
        else
        {
            [cell SetLineHidden:NO];
        }
    }
	
	if (self.originIndexPath && [indexPath isEqual:self.originIndexPath]) {
		cell.hidden = YES;
	} else {
		cell.hidden = NO;
	}
	
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TaskListModel * model = [self getCurrentTasksWithSection:indexPath.section][indexPath.row];

    if (model.level == 1) {
        NewDetailMissionViewController *vc = [[NewDetailMissionViewController alloc] initWithMissionDetailModel:model];
        switch (self.VCtype) {
            case VCkind_Today:
            {
                vc.myVCUsedto = DVCkind_Today;
            }
                break;
            case VCkind_Tomorrow:
            {
                vc.myVCUsedto = DVCkind_Tomorrow;
            }
                break;
                
            default:
                break;
        }
        vc.isFirstVC = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        NewDetailMissionViewController *vc = [[NewDetailMissionViewController alloc] initWithSubMission:model.showId];
        vc.isFirstVC = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_sections == 1) {
        return 0.01;
    }else {
        if (section == 0) {
            if (self.dueTasks.count) {
                return 27.5;
            }
        }else{
            if (self.otherTasks.count) {
                return 27.5;
            }
        }    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60.0f;}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] init];
    if (_sections == 2) {
        UILabel * label = [[UILabel alloc] init];
        label.font  =[UIFont systemFontOfSize:13.0];
        [view addSubview:label];
        
        if (section == 0) {
            if (self.dueTasks.count) {
                label.text = LOCAL(NEWMISSION_OUT_OF_DATE);
                label.frame  =CGRectMake(10, 0, IOS_SCREEN_WIDTH - 10, 27.5);
            }
            
        }else{
            if (self.otherTasks.count) {
				label.text = LOCAL(NEWMISSION_IN_DATE);
                label.frame  =CGRectMake(10, 0, IOS_SCREEN_WIDTH - 10, 27.5);
            }
        }
	}
    return view;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0f] icon:[UIImage imageNamed:@"pencil-1"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] icon:[UIImage imageNamed:@"NewDelect"]];

    return rightUtilityButtons;
}
#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [_tableview indexPathForCell:cell];
    
    TaskListModel * model = [self getCurrentTasksWithSection:cellIndexPath.section][cellIndexPath.row];

    switch (index) {
        case 0:
            // 编辑任务(任务详情)
        {
            NewMissionAddMissionViewController *VC = [[NewMissionAddMissionViewController alloc] initWithEditMissionWithShowID:model.showId];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        case 1:
            // 删除任务
        {
            [self deleteTaskRequestWithShowID:model.showId path:cellIndexPath];
        }
            break;

        default:
            break;
    }
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

#pragma mark - NewMissionListTableViewCellDelegate
- (void)NewMissionListTableViewCell_CompleteButtonClick:(NSIndexPath *)path
{
	NSMutableArray *tasks = [self getCurrentTasksWithSection:path.section];
	TaskListModel * model = tasks[path.row];
    if ([model.type isEqualToString:WAITING_NEW] || [model.type isEqualToString:@"Wating"]) {
        // 待办, 标记为已完成
        [self missionChangeMissionStatusRequestWithShowId:model.showId status:FINISH_NEW];
    }else {
        [self missionChangeMissionStatusRequestWithShowId:model.showId status:WAITING_NEW];
    }
    
}

- (void)NewMissionListTableViewCell_SwitchButtonClick:(NSIndexPath *)path
{
	NSMutableArray *tasks = [self getCurrentTasksWithSection:path.section];
	TaskListModel *task = tasks[path.row];
	if (!task.isOpen) {
		NSArray *array = [self.subtaskDict objectForKey:task.showId];
		[tasks insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(path.row+1, array.count)]];
		task.isOpen = YES;
		
	} else {
		NSArray * array = [self.subtaskDict objectForKey:task.showId];
		[tasks removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(path.row+1, array.count)]];
		task.isOpen = NO;
	}
	[self.tableview reloadData];
	
}

- (void)hideAllTasksWithSeciton:(NSInteger)section {
	NSMutableArray *tasks = [self getCurrentTasksWithSection:section];
	NSMutableArray *tempTasks = [NSMutableArray array];
	[tasks enumerateObjectsUsingBlock:^(TaskListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
		if ([obj hasParentTask]) {
			[tempTasks addObject:obj];
		} else {
			obj.isOpen = NO;
		}
	}];
	
	[tasks removeObjectsInArray:tempTasks];
	
}

# pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

#pragma mark - init
- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
//        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//        _tableview.header = header;
//        
//        _tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
		UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
		longPress.delegate = self;
		[_tableview addGestureRecognizer:longPress];
		
    }
    return _tableview;
}

- (ProjectMembersCollectionView *)projectMembersCollectionView
{
    if (!_projectMembersCollectionView) {
        _projectMembersCollectionView = [[ProjectMembersCollectionView alloc] initWithFrame:CGRectMake(0, 0, IOS_SCREEN_WIDTH, 100)];
        _projectMembersCollectionView.hidden = YES;
    }
    return _projectMembersCollectionView;
}

- (TaskMainButtonView *)buttonView
{
    if (!_buttonView) {
        _buttonView = [[TaskMainButtonView alloc] init];
        [_buttonView setDelegate:self];
    }
    return _buttonView;
}

- (UIView *)emptyPageView
{
    if (!_emptyPageView) {
        _emptyPageView = [[UIView alloc] init];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_nounfinishjob"]];
        UILabel *titel = [[UILabel alloc]init];
        [titel setText:LOCAL(MISSION_EMPTY_ICON)];
        [titel setTextColor:[UIColor themeBlue]];
        [_emptyPageView addSubview:imageView];
        [_emptyPageView addSubview:titel];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView).offset(15);
            make.bottom.equalTo(_emptyPageView.mas_centerY);
        }];
        [titel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView);
            make.top.equalTo(_emptyPageView.mas_centerY).offset(20);
        }];
    }
    return _emptyPageView;
}

- (NSMutableArray *)otherTasks
{
    if (!_otherTasks) {
        _otherTasks = [NSMutableArray array];
    }
    return _otherTasks;
}

- (NSMutableArray *)dueTasks
{
    if (!_dueTasks) {
        _dueTasks = [NSMutableArray array];
    }
    return _dueTasks;
}

- (NSMutableArray <TaskListModel *> *)getCurrentTasksWithSection:(NSInteger)section {
	if (_sections == 2) {
		return section == 1 ? self.otherTasks : self.dueTasks;
	} else {
		return self.otherTasks;
	}
}

- (UIBarButtonItem *)rightAddItem {
    if (!_rightAddItem) {
        _rightAddItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMissionButtonClick)];
    }
    return _rightAddItem;
}

@end
