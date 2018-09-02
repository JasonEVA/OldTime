//
//  PersonServiceComplainViewController.m
//  HMClient
//
//  Created by Dee on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonServiceComplainViewController.h"
#import "PersonServiceComPlainContentTableViewCell.h"
#import "PersonComplainHistoryListViewController.h"
#import "GetUserServiceByCompTypeTask.h"
#import "GetUserServiceComplainTypesTask.h"
#import "AddUserServiceComplaintTask.h"
#import "UIView+Progress.h"
typedef NS_ENUM(NSInteger, CELLTYPE)
{
    k_Complain_Type = 0,  //选择投诉对象类型
    k_Complain_Object,    //选择投诉对象
    k_complaint_Content   //输入投诉内容
};

static NSString *const k_complainDetaultType = @"请选择投诉对象类型";
static NSString *const k_complainDefaultObject = @"请选择投诉对象";


@interface PersonServiceComplainViewController ()<UITableViewDelegate, UITableViewDataSource, TaskObserver>

@property(nonatomic, strong) UITableView  *tableView;

@property(nonatomic, strong) UIButton  *submitBtn;

//二维
@property(nonatomic, strong) NSMutableArray  *titleArray;
//投诉类型原始数据字典
@property(nonatomic, strong) NSDictionary  *complainTypesDict;
//投诉对象原始数据数组 -- 仅当前类型下
@property(nonatomic, strong) NSMutableArray  *complainObjectOriginArray;
//处理完成后的投诉类型
@property(nonatomic, strong) NSMutableArray  *complainTypesArray;
//处理完成后的投诉对象
@property(nonatomic, copy) NSMutableArray  *complainObjectArray;
//投诉类型一项是否打开
@property(nonatomic, assign) BOOL  showTypes;
//投诉对象一项是否打开
@property(nonatomic, assign) BOOL  showObjects;
//当前对象类型
@property(nonatomic, copy) NSString  *currentObjectType;
//当前对象
@property(nonatomic, copy) NSString  *currentObject;

@property(nonatomic, copy) NSString  *currentContent;
//当前选择对象类型的index
@property(nonatomic, assign) NSInteger currentTypeIndex;

@end



@implementation PersonServiceComplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.tableView.backgroundColor;
    [self configElement];
    [self configNavigation];
    [self GetComplaintType];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - privateMethod

- (void)configNavigation
{
    self.title = @"投诉";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"投诉记录" style:UIBarButtonItemStylePlain target:self action:@selector(goToComplainHistoryListAction)];
    [self.navigationItem setRightBarButtonItem:item];
    self.currentObjectType = k_complainDetaultType;
    self.currentObject     = k_complainDefaultObject;
}

- (void)configElement
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view);
    }];
}

- (void)GetComplaintType
{
    NSDictionary *dict = [NSDictionary dictionary];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetUserServiceComplainTypesTask class]) taskParam:dict TaskObserver:self];
    [self.view showWaitView];
}

- (void)getcomplainObjectWithIndex:(NSInteger)index
{
    //没有数据时才去获取
    if (![self.complainObjectArray[index] count])
    {
        NSArray *allkeys = [self.complainTypesDict allKeys];
        UserInfo *userinfo = [[UserInfoHelper defaultHelper] currentUserInfo];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSString stringWithFormat:@"%@",allkeys[index]] forKey:@"compType"];
        [dict setValue:[NSString stringWithFormat:@"%ld",userinfo.userId] forKey:@"userId"];
        [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetUserServiceByCompTypeTask class]) taskParam:dict TaskObserver:self];
        [self.view showWaitView];
    }else
    {
        
    }
}

#pragma mark - uitableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell;
    switch (indexPath.section)
    {
        case k_Complain_Type:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"k_Complain_Type"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"k_Complain_Type"];
            }
            
            cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
            cell.textLabel.textColor = [UIColor commonGrayTextColor];
            if (!indexPath.row)
            {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.showTypes?@"icon_top_list_arrow":@"icon_down_list_arrow"]];
            }else
            {
                cell.accessoryView = nil;
            }
            
        }
            break;
        case k_Complain_Object:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"k_Complain_Object"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"k_Complain_Object"];
            }
            cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
            cell.textLabel.textColor = [UIColor commonGrayTextColor];
            if (!indexPath.row)
            {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down_list_arrow"]];
            }
        }
            break;
        case k_complaint_Content:
        {
            PersonServiceComPlainContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PersonServiceComPlainContentTableViewCell identifier]];
            [cell getContentWithBlock:^(NSString *content) {
                self.currentContent = content;
            }];
            return cell;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  section == k_complaint_Content?90:5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == k_Complain_Type?15:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  indexPath.section != k_complaint_Content?45:200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *array = self.titleArray[indexPath.section];
    //点击第一行的行首
    if (indexPath.section == k_Complain_Type )
    {   //关闭的时候
        if (array.count == 1 && !self.showTypes)
        {
            [array removeAllObjects];
            [array addObject:k_complainDetaultType];
            [array addObjectsFromArray:self.complainTypesArray];
        }else
        {
            NSString *str = array[indexPath.row];
            if (![str isEqualToString:self.currentObjectType]) {
                if (![self.currentObject isEqualToString:k_complainDefaultObject]) {
                    // 清空投诉对象
                    NSMutableArray *arrayObject = self.titleArray[1];
                    self.currentObject = k_complainDefaultObject;
                    [arrayObject removeAllObjects];
                    [arrayObject addObject:k_complainDefaultObject];
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            self.currentObjectType = str;
            [array removeAllObjects];
            [array addObject:str];
        }
         self.showTypes ^= 1;
        if (![array[0] isEqualToString:k_complainDetaultType])
        {
            self.currentTypeIndex = indexPath.row - 1;
            [self getcomplainObjectWithIndex:indexPath.row -1];
        }
    }else if (indexPath.section == k_Complain_Object)
    {
        if ([self.currentObjectType isEqualToString:k_complainDetaultType] || self.currentObjectType == nil)
        {
            [self.view showAlertMessage:@"请先选择投诉类型"];
            return;
        }
        if (array.count == 1 && !self.showObjects)
        {
            [array removeAllObjects];
            [array addObject:k_complainDefaultObject];
            [array addObjectsFromArray:self.complainObjectArray[self.currentTypeIndex]];
        }else
        {
            NSString *str = array[indexPath.row];
            self.currentObject = str;
            [array removeAllObjects];
            [array addObject:str];
        }
        self.showObjects ^= 1;
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == k_complaint_Content)
    {
        UIView *contentView = [UIView new];
        contentView.backgroundColor = tableView.backgroundColor;
        [contentView addSubview:self.submitBtn];
        self.submitBtn.frame = CGRectMake(0, 15, tableView.frame.size.width, 45);
        return contentView;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - taskReultDelegate
- (void)task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:NSStringFromClass([GetUserServiceComplainTypesTask class])])
    {
        //保存原始数据
        self.complainTypesDict = taskResult;
        if ([taskResult isKindOfClass:[NSDictionary class]])
        {
            NSMutableArray * tempArray = [NSMutableArray array];
            for (int i = 0; i < [taskResult count]; i++)
            {
                id value = [taskResult objectForKey:[[taskResult allKeys] objectAtIndex:i]];
                [tempArray addObject:value];
            }
            //提取出原始数据
            self.complainTypesArray= tempArray;
        }
    }else if ([taskname isEqualToString:NSStringFromClass([GetUserServiceByCompTypeTask class])])
    {
        self.complainObjectOriginArray = taskResult;
        
        if ([taskResult isKindOfClass:[NSArray class]])
        {
            NSMutableArray * tempArray = [NSMutableArray array];
            
            for (int i = 0; i < [taskResult count]; i++)
            {
                NSDictionary *dict = taskResult[i];
                id value = [dict objectForKey:@"compObjectName"];
                [tempArray addObject:value];
            }
            //提取出原始数据
            [self.complainObjectArray[self.currentTypeIndex] addObjectsFromArray:tempArray];
        }
    }else if([taskname isEqualToString:NSStringFromClass([AddUserServiceComplaintTask class])])
    {
        [self.view closeWaitView];
        [self goToComplainHistoryListAction];
    }
    
    [self.view closeWaitView];
}

- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (!taskId || 0 == taskId.length) {return;}
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if (taskError == StepError_None) {return;}
    [self.view showAlertMessage:errorMessage];
}

#pragma mark -- eventRespond
- (void)goToComplainHistoryListAction
{
    PersonComplainHistoryListViewController *vc = [[PersonComplainHistoryListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitAction
{
    if (self.currentContent.length <= 0 || self.currentContent == nil)
    {
        [self.view showAlertMessage:@"请输入投诉内容"];
        return;
    }
    
    if (![self.currentObjectType isEqualToString:k_complainDetaultType]  && ![self.currentObject isEqualToString:k_complainDefaultObject])
    {
        NSString * complaintID = @"";
        for (NSDictionary *dict in self.complainObjectOriginArray)
        {
            NSString *compName = [dict valueForKey:@"compObjectName"];
            if ([compName isEqualToString:self.currentObject])
            {
                complaintID = [dict valueForKey:@"compObjectId"];
            }
        }
        
        NSString *typeid = [self.complainTypesDict allKeys][self.currentTypeIndex];
        UserInfo *userinfo = [[UserInfoHelper defaultHelper] currentUserInfo];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSString stringWithFormat:@"%@",typeid] forKey:@"compType"];
        [dict setValue:[NSString stringWithFormat:@"%@",complaintID] forKey:@"compObjectId"];
        [dict setValue:self.currentContent forKey:@"compContent"];
        [dict setValue:[NSString stringWithFormat:@"%ld",userinfo.userId] forKey:@"userId"];
        [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([AddUserServiceComplaintTask  class]) taskParam:dict TaskObserver:self];
        [self.view showWaitView];
    }else
    {
        [self.view showAlertMessage:@"请选择合适的对象或类型"];
        return;
    }
}

#pragma mark - setterAndGetter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[PersonServiceComPlainContentTableViewCell class] forCellReuseIdentifier:[PersonServiceComPlainContentTableViewCell identifier]];
    }
    return _tableView;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:[UIColor mainThemeColor]];
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = [NSMutableArray array];
        [_titleArray addObject:[NSMutableArray arrayWithObject:k_complainDetaultType]];
        [_titleArray addObject:[NSMutableArray arrayWithObject:k_complainDefaultObject]];
        [_titleArray addObject:[NSMutableArray arrayWithObject:@""]];
    }
    return _titleArray;
}

- (NSMutableArray *)complainObjectArray
{
    if (!_complainObjectArray)
    {
        _complainObjectArray = [NSMutableArray array];
        for (int i = 0; i < self.complainTypesArray.count; i++) {
            [_complainObjectArray addObject:[NSMutableArray array]];
        }
    }
    return _complainObjectArray;
}

@end
