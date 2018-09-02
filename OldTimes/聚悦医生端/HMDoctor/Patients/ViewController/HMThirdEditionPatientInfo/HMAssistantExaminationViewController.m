//
//  HMAssistantExaminationViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/3/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMAssistantExaminationViewController.h"
#import "HMAssistantExaminationTableViewCell.h"
#import "HMCheckItemView.h"

@interface AssistantExaminationView : UIView

@property (nonatomic, strong) UIControl* headerControl;
@property (nonatomic, strong) UILabel *lbContent;
@property (nonatomic, strong) UIImageView* ivArrow;
@property (nonatomic, strong) UIView *lineview;

@property (nonatomic, copy) void(^selectSelectedBlock)();

- (void)setContentTitle:(NSString *)content;
@end

@implementation AssistantExaminationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _lineview = [[UIView alloc]init];
        [_lineview setBackgroundColor:[UIColor mainThemeColor]];
        [self addSubview:_lineview];
        
        [_lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.width.mas_equalTo(@1);
            make.top.equalTo(self);
            make.left.equalTo(self).with.offset(51);
        }];
        
        _headerControl = [[UIControl alloc]init];
        [self addSubview:_headerControl];
        [_headerControl setBackgroundColor:[UIColor whiteColor]];
        _headerControl.layer.cornerRadius = 15;
        _headerControl.layer.masksToBounds = YES;
        [_headerControl.layer setBorderColor:[[UIColor mainThemeColor] CGColor]];
        [_headerControl.layer setBorderWidth:1.0f];
        [_headerControl addTarget:self action:@selector(summaryControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_headerControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-12);
            make.size.mas_equalTo(CGSizeMake(80 * kScreenScale, 30));
            make.centerY.equalTo(self);
        }];

        _ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_month_downarrow"]];
        [_headerControl addSubview:_ivArrow];
        
        [_ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerControl);
            make.right.equalTo(_headerControl).with.offset(-8);
            make.size.mas_equalTo(CGSizeMake(10, 6));
        }];
        
        _lbContent = [[UILabel alloc] init];
        [_headerControl addSubview:_lbContent];
        [_lbContent setText:@"全部"];
        [_lbContent setTextColor:[UIColor mainThemeColor]];
        [_lbContent setFont:[UIFont font_28]];
        
        [_lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_headerControl);
        }];
    }
    return self;
}

- (void) summaryControlClicked:(id) sender
{
    if (_selectSelectedBlock)
    {
        _selectSelectedBlock();
    }
}

- (void)setContentTitle:(NSString *)content{
    [_lbContent setText:content];
    if (!content) {
        [_lbContent setText:@"全部"];
    }
}

@end


@interface HMAssistantExaminationViewController ()
<TaskObserver,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *admissionId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *itemTypeCode;
@property (nonatomic, strong) NSArray *imgList;

@property (nonatomic, copy) NSString *itemName;

@end

@implementation HMAssistantExaminationViewController

- (instancetype)initWithUserID:(NSString *)userID admissionId:(NSString *)admissionId
{
    self = [super init];
    if (self) {
        _userId = userID;
        _admissionId = admissionId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getgetCheckImgList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createDateChanged:) name:@"OnlineArchivesDateChangedNotification" object:nil];
}

- (void)createDateChanged:(NSNotification *)notification
{
    self.admissionId = [notification object];
    [self getgetCheckImgList];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getgetCheckImgList{

    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setObject:self.admissionId forKey:@"admissionId"];
    
    //2 辅助检查
    [dicPost setObject:@"2" forKey:@"type"];
    
    //不填写查询全部项目
    if (self.itemTypeCode && self.itemTypeCode.length > 0) {
        [dicPost setObject:self.itemTypeCode forKey:@"itemTypeCode"];
    }
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"getCheckImgListTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.imgList)
    {
        return self.imgList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.imgList || self.imgList.count == 0) {
        return 0.00001;
    }
    return 47;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.imgList || self.imgList.count == 0) {
        return nil;
    }
    AssistantExaminationView *headerview = [[AssistantExaminationView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 47)];
    
    //__weak typeof (AssistantExaminationView) *headerviewSelf = headerview;
   __weak typeof(self) weakSelf = self;
    [headerview setSelectSelectedBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        HMCheckItemView *itemView = [[HMCheckItemView alloc] initWithadmissionId:strongSelf.admissionId];
        [strongSelf.view addSubview:itemView];
        [itemView setBackgroundColor:[UIColor clearColor]];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(strongSelf.view);
        }];
        
        [itemView setItemSelectBlock:^(CheckItemTypeModel *itemTypeModel) {
            _itemName = itemTypeModel.itemTypeName;
            strongSelf.itemTypeCode = itemTypeModel.itemTypeCode;
            [strongSelf getgetCheckImgList];
        }];
    }];
    [headerview setContentTitle:_itemName];
    return headerview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 125;
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMAssistantExaminationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssistantExaminationTableViewCell"];
    if (!cell)
    {
        cell = [[HMAssistantExaminationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AssistantExaminationTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell setOwnerViewController:self];
    HMGetCheckImgListModel *model = [self.imgList objectAtIndex:indexPath.row];
    [cell setCheckImgList:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMGetCheckImgListModel *model = [self.imgList objectAtIndex:indexPath.row];
    [HMViewControllerManager createViewControllerWithControllerName:@"HMAssistIndicesDetailViewController" ControllerObject:model];
    
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
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
    
    if ([taskname isEqualToString:@"getCheckImgListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]]) {
            self.imgList = taskResult;
            [self.tableView reloadData];
        }
    }
}

#pragma mark - init UI

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}


#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"img_blank_list"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.imgList || self.imgList.count == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -68;
}
@end
