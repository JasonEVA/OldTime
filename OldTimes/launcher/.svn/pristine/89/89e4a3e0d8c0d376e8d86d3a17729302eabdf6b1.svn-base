//
//  LiftTableViewViewController.m
//  launcher
//
//  Created by TabLiu on 16/2/14.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "LiftTableViewViewController.h"
#import "UIColor+Hex.h"
#import "DeviceDefine.h"
#import "UIViewController+MMDrawerController.h"
#import "LiftDrawerTableViewCell.h"
#import "NewGetProjectListRequest.h"
#import "NewGetTaskListCountRequest.h"
#import "NewProjectAddRequest.h"
#import "NewCreatProjectViewController.h"
#import "LiftTextFieldTableViewCell.h"
#import "MyDefine.h"
//#import "TPKeyboardAvoidingTableView.h"

#define Blue_Color  [UIColor colorWithRed:8/255.0 green:119/255.0 blue:192/255.0 alpha:1]

@interface LiftTableViewViewController ()<UITableViewDataSource,UITableViewDelegate,BaseRequestDelegate,LiftTextFieldTableViewCellDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * titleArray;
@property (nonatomic,strong) NSArray * imgArray;
@property (nonatomic, strong) UIView *viewShadow;
@property (nonatomic,copy)   tableViewSelectForRow  selectBlock;
@property (nonatomic,strong) NSArray * projectArray;
@property (nonatomic,strong) NSArray * taskCountArray;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (nonatomic,assign) BOOL isShowTFCell; // 记录是否需要展示输入框的cell
/* 记录选中的是第几区 */
@property (nonatomic,strong) NSIndexPath * selectPath;
/* 是第一区 则是 showid */
@property (nonatomic,strong) NSString * selctShowID ;

@property (nonatomic,copy) viewWillAppearBlock  appearBlock ;


@end

@implementation LiftTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Blue_Color;
    
    _projectArray = [NSArray arrayWithObject:LOCAL(NEWMISSION_ADD_ONE_MISSION)];
    
    _titleArray = [[NSMutableArray alloc] init];
    _titleArray= @[LOCAL(MISSION_TODAY),LOCAL(MISSION_TOMORROW),LOCAL(NEWMISSION_ALL_MISSION),LOCAL(NEWMISSION_NO_START_TIME),LOCAL(MISSION_MYSENDTASK),LOCAL(NEWMISSION_FINISH)];// 暂时写死
    _imgArray = @[@"Mission_Today",@"Mission_Tomorrow",@"Mission_AllTask",@"Mission_NoStartTime",@"Mission_MeCreat",@"Mission_complete"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, LIFT_TABLEVIEW_WIDTH, IOS_SCREEN_HEIGHT - 20) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = Blue_Color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    [_tableView addGestureRecognizer:gest];
    
    _selectPath = [NSIndexPath indexPathForRow:2 inSection:0];
     [self.view addSubview:_tableView];
    
    self.viewShadow = [[UIView alloc] init];
    self.viewShadow.frame = CGRectMake(LIFT_TABLEVIEW_WIDTH - 30, 20, 30, IOS_SCREEN_HEIGHT - 20);
    self.viewShadow.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.viewShadow];
    self.viewShadow.userInteractionEnabled = NO;
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.viewShadow.bounds;
    [self.viewShadow.layer addSublayer:self.gradientLayer];
    
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 0);
    
    //设定颜色组
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                  (__bridge id)[UIColor mtc_colorWithW:235/255.0 alpha:0.3].CGColor];
    
    self.gradientLayer.locations = @[@(0.5f) ,@(1.0f)];
    
    _isShowTFCell = NO;
    [self request];
}

- (void)resignKeyBoard
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:FALSE];
    [super viewWillAppear:animated];
    
    [self request];

    if (_appearBlock) {
        _appearBlock(YES);
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [super viewDidDisappear:animated];
    if (_appearBlock) {
        _appearBlock(NO);
    }

}

- (void)setViewWillAppearBlock:(viewWillAppearBlock)block
{
    _appearBlock = block;
}

- (void)setCellSelectForRowBlock:(tableViewSelectForRow)block
{
    _selectBlock = block;
}

- (void)changeSelectCellWithPath:(NSIndexPath *)path showId:(NSString *)showId
{
    self.selectPath = path;
    if (![self.selctShowID isEqualToString:showId]) {
        self.selctShowID = showId;
    }
}

- (void)request
{
    NewGetProjectListRequest * request = [[NewGetProjectListRequest alloc] initWithDelegate:self];
    request.seleShowId = self.selctShowID;
    [request getNewList];
    
    NewGetTaskListCountRequest * request1 = [[NewGetTaskListCountRequest alloc] initWithDelegate:self];
    [request1 getList];
}

- (void)creatProjectRequestWithProjectName:(NSString *)name
{
    NewProjectAddRequest * request = [[NewProjectAddRequest alloc] initWithDelegate:self];
    [request createProject:name people:@[]];
}

- (void)selectAtIndex:(NSInteger)index {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    });
}

#pragma mark - BaseRequestDelegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[NewGetProjectListRequest class]]) {
        NewGetProjectListResponse * resp = (NewGetProjectListResponse *)response;
        
        if (resp.isNeedDefine && self.selectPath.section == 1) {
            self.selectPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        NSMutableArray * array= [[NSMutableArray alloc] init];
        [array addObject:_projectArray[0]];
        _projectArray = [array arrayByAddingObjectsFromArray:resp.dataArray];
        [self.tableView reloadData];
    }else if ([request isKindOfClass:[NewGetTaskListCountRequest class]]) {
        NewGetTaskListCountResponse * resp = (NewGetTaskListCountResponse *)response;
        _taskCountArray = [NSArray arrayWithArray:resp.dataArray];
        [self.tableView reloadData];
    }else if ([request isKindOfClass:[NewProjectAddRequest class]]) {
        
        NewProjectAddResponse * resp = (NewProjectAddResponse *)response;
        
        ProjectContentModel * model = [[ProjectContentModel alloc] init];
        model.name = resp.projectName;
        model.showId = resp.showId;
        model.createUser = resp.createUser;
        NSMutableArray * array = [NSMutableArray arrayWithArray:_projectArray];
        [array insertObject:model atIndex:1];
        _projectArray = array;
        _isShowTFCell = NO;
        [self.tableView reloadData];
    }
}
- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}


#pragma mark - LiftTextFieldTableViewCellDelegate
- (void)textField_ShouldBeginEditing
{
    
}
- (void)textField_ShouldEndEditingWithText:(NSString *)text
{
    if (text == nil || [text isEqualToString:@""]) {
        _isShowTFCell = NO;
        [self isShowKeyboard];
        return;
    }
    [self creatProjectRequestWithProjectName:text];
}

- (void)isShowKeyboard
{
    if (_isShowTFCell) {
        [self.tableView setContentOffset:CGPointMake(0, 600 - IOS_SCREEN_WIDTH)];
    }else {
        [self.tableView setContentOffset:CGPointMake(0, 0)];
        [self.tableView reloadData];
    }
}

- (void)setCellBGWithSection:(NSIndexPath *)indexPath ShowID:(NSString *)showId
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == self.selectPath.row) {
            // 选中的是同一个
            return;
        }
        {
            //把老的 设置为为选中
            NSIndexPath * path = [NSIndexPath indexPathForRow:self.selectPath.row inSection:0];
            LiftDrawerTableViewCell * cell = [self.tableView cellForRowAtIndexPath:path];
            [cell setCellIsSelect:YES];
        }
        {
            // 把新的设置为选中
            LiftDrawerTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell setCellIsSelect:NO];
        }
        
        // 记录新的选中
        self.selectPath = indexPath;
        self.selctShowID = @"";
    }else {
        switch (indexPath.row) {
            case 0:
                return; // 添加项目入口,不处理
                break;
                
            case 1:
            {
                if (_isShowTFCell) {
                    return; // 输入框 ,不处理
                }
                ProjectContentModel * model = [self.projectArray objectAtIndex:indexPath.row];
                if ([model.showId isEqualToString:self.selctShowID]) {
                    return;// 选中的是同一项目
                }
                self.selctShowID = model.showId;
            }
                break;
                
            default:
            {
                ProjectContentModel * model;
                NSInteger row;
                if (_isShowTFCell) {
                    row = indexPath.row - 1;
                }else {
                    row = indexPath.row;
                }
                model = [self.projectArray objectAtIndex:row];
                if ([model.showId isEqualToString:self.selctShowID]) {
                    return;// 选中的是同一项目
                }
                self.selctShowID = model.showId;
                
            }
                break;
        }
        self.selectPath = indexPath;
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    if (indexPath.section == 0) {
        if (_selectBlock) {
            _selectBlock(indexPath,nil);
        }
        [self setCellBGWithSection:indexPath ShowID:nil];
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }else {
        if (indexPath.row == 0) {
            // 新建
            _isShowTFCell = YES;
            [self.tableView reloadData];
            [self isShowKeyboard];
            return;
        }else {
            if (indexPath.row == 1 && _isShowTFCell) {
                return;
            }
            ProjectContentModel * model = _projectArray[indexPath.row];
            _selectBlock(indexPath,model);
            [self setCellBGWithSection:indexPath ShowID:model.showId];
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }
    }
}



#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _titleArray.count;
    }else {
        if (_isShowTFCell) {
            return _projectArray.count + 1;
        }else {
            return _projectArray.count;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * timeStr = @"cell1";
    static NSString * addProjectStr = @"cell2";
    static NSString * TFStr = @"cell3";
    //static NSString * delectStr = @"cell4";
    
    if (indexPath.section == 0) {
        LiftDrawerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:timeStr];
        if (!cell) {
            cell = [[LiftDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timeStr];
        }
        [cell setCellTitle:[NSString stringWithFormat:@"%@",_titleArray[indexPath.row]]];
        [cell setIconImageName:_imgArray[indexPath.row]];
        
        if (_taskCountArray && _taskCountArray.count) {
            TaskCountModel * model = _taskCountArray[indexPath.row];
            [cell setNumberWithallNumber:model.count];
        }else {
            [cell setNumberWithallNumber:0];
        }
        if (self.selectPath.row == indexPath.row && self.selectPath.section == indexPath.section) {
            [cell setCellIsSelect:YES];
        }else {
            [cell setCellIsSelect:NO];
        }
        return cell;
    } else {
        if (_isShowTFCell) {
            // 需要输入框
            if (indexPath.row == 0) {
                LiftDrawerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:addProjectStr];
                if (!cell) {
                    cell = [[LiftDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addProjectStr];
                }
                [cell setCellTitle:[NSString stringWithFormat:@"%@",_projectArray[indexPath.row]]];
                [cell setIconImageName:@"Mission_NewAdd"];
                [cell setNumberWithUnRead:0 allNumber:0 isShow:NO];
                return cell;
            }else if (indexPath.row == 1) {
//                if (!_TFCell) {
//                    _TFCell = [[LiftTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TFStr];
//                }
                LiftTextFieldTableViewCell * cell = [[LiftTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TFStr];
                [cell setIconImg:@"Mission_Folder"];
                [cell showKeyboard];
                cell.delegate = self;
                return cell;
            } else {
                LiftDrawerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:timeStr];
                if (!cell) {
                    cell = [[LiftDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timeStr];
                }
                ProjectContentModel * model = _projectArray[indexPath.row -1];
                [cell setCellTitle:model.name];
                [cell setIconImageName:@"Mission_Folder"];
                [cell setNumberWithUnRead:model.unFinishedTask allNumber:model.allTask isShow:YES];
                
                if (self.selectPath.section == indexPath.section) {
                    if ([model.showId isEqualToString:self.selctShowID]) {
                        [cell setCellIsSelect:YES];
                    }else {
                        [cell setCellIsSelect:NO];
                    }
                }else {
                    [cell setCellIsSelect:NO];
                }
                return cell;
            }
            
        }else {
            
            if (indexPath.row == 0) {
                LiftDrawerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:addProjectStr];
                if (!cell) {
                    cell = [[LiftDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addProjectStr];
                }
                [cell setCellTitle:[NSString stringWithFormat:@"%@",_projectArray[indexPath.row]]];
                [cell setIconImageName:@"Mission_NewAdd"];
                [cell setNumberWithUnRead:0 allNumber:0 isShow:NO];
                return cell;
            }else {
                LiftDrawerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:timeStr];
                if (!cell) {
                    cell = [[LiftDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timeStr];
                }
                ProjectContentModel * model = _projectArray[indexPath.row];
                [cell setCellTitle:model.name];
                [cell setIconImageName:@"Mission_Folder"];
                [cell setNumberWithUnRead:model.unFinishedTask allNumber:model.allTask isShow:YES];
                if (self.selectPath.section == indexPath.section) {
                    if ([model.showId isEqualToString:self.selctShowID]) {
                        [cell setCellIsSelect:YES];
                    }else {
                        [cell setCellIsSelect:NO];
                    }
                }else {
                    [cell setCellIsSelect:NO];
                }

                return cell;
            }
        }
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
    label.backgroundColor = [UIColor clearColor];
    //label.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    if (section == 1)
    {
        label.text = [NSString stringWithFormat:@"  %@",LOCAL(MISSION_PROJECT)];
    }
    return label;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView performWithoutAnimation:^{
        [cell layoutIfNeeded];
    }];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] icon:[UIImage imageNamed:@"pencil-1"]];
    
    return rightUtilityButtons;
}


@end
