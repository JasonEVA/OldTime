//
//  AsthmaDiaryViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/7/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "AsthmaDiaryViewController.h"
#import "AsthmaGridTableViewCell.h"
#import "ClientHelper.h"
#import "RecordExtendTitleModel.h"

@interface AsthmaDiaryViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) UIView *pefChartView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *dirayView;
@property (nonatomic, strong) NSArray *asthmaDiaryArray;

@end

@implementation AsthmaDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self p_configElements];
    [self getAsthmaDiary];
}

- (id) initWithUserId:(NSString*) aUserId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self){
        _userId = aUserId;
    }
    return self;
}
- (void)refreshDataWithUserID:(NSString *)userID {
    _userId = userID;
    [self getAsthmaDiary];
}

#pragma mark - Private Method
- (void)getAsthmaDiary
{
    [self at_postLoading];
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:_userId forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AsthmaDiaryTask" taskParam:dicPost TaskObserver:self];
}

// 设置元素控件
- (void)p_configElements {
    [self.view addSubview:self.pefChartView];
    [self.pefChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    [self.pefChartView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_pefChartView);
    }];
    
    [self.view addSubview:self.dirayView];
    [self.dirayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pefChartView.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.dirayView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_dirayView).insets(UIEdgeInsetsMake(10, 12.5, 10, 12.5));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _asthmaDiaryArray.count ? _asthmaDiaryArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.tableHeaderView.width, 45)];
    [headerView setBackgroundColor:[UIColor mainThemeColor]];
    NSArray *titleArray = @[@"日期",@"喘息",@"咳嗽",@"活动受限",@"夜间憋醒",@"其他"];
    float columnW = (ScreenWidth-25)/6;
    float gridW = (ScreenWidth-25-columnW * 1.5)/5;
    for (int i = 0; i < 6; i++) {
        UILabel *titleLabel = [UILabel new];
        [headerView addSubview:titleLabel];
        titleLabel.numberOfLines = 0;
        [titleLabel showRightLine];
        [titleLabel setText:[titleArray objectAtIndex:i]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont font_28]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        if (i == 0) {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headerView.mas_left);
                make.centerY.equalTo(headerView);
                make.size.mas_equalTo(CGSizeMake(columnW*1.5, 45));
            }];
        }
        else{
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headerView.mas_left).offset(columnW*1.5+(i-1)*gridW);
                make.centerY.equalTo(headerView);
                make.size.mas_equalTo(CGSizeMake(gridW, 45));
            }];
        }
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (kArrayIsEmpty(_asthmaDiaryArray)) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setText:@"暂无数据"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setTextColor:[UIColor commonGrayTextColor]];
        [cell.textLabel setFont:[UIFont font_30]];
        return cell;
    }
    
    AsthmaGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AsthmaGridTableViewCell"];
    if (!cell)
    {
        cell = [[AsthmaGridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AsthmaGridTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    AsthmaDiaryModel *model = [_asthmaDiaryArray objectAtIndex:indexPath.row];
    [cell setAsthmaDiaryModel:model];
    return cell;
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (StepError_None != taskError) {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    [self at_hideLoading];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"AsthmaDiaryTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]]) {
            _asthmaDiaryArray = (NSArray *)taskResult;
            [self.tableView reloadData];
        }
    }
}

#pragma mark -- init
- (UIView *)pefChartView{
    if (!_pefChartView) {
        _pefChartView = [UIView new];
    }
    return _pefChartView;
}

- (UIView *)dirayView{
    if (!_dirayView) {
        _dirayView = [UIView new];
        [_dirayView setBackgroundColor:[UIColor whiteColor]];
    }
    return _dirayView;
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [UIWebView new];
        [_webView setBackgroundColor:[UIColor whiteColor]];
        [_webView scalesPageToFit];
        _webView.scrollView.bounces = NO;
        NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&kpiCode=FLSZ&userId=%@&dateType=3", kZJKHealthDataBaseUrl, _userId];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    return _webView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView.layer setCornerRadius:5.0f];
        [_tableView.layer setMasksToBounds:YES];
        [_tableView.layer setBorderColor:[UIColor mainThemeColor].CGColor];
        [_tableView.layer setBorderWidth:1.0f];
        //[_tableView registerClass:[AsthmaGridTableViewCell class] forCellReuseIdentifier:[AsthmaGridTableViewCell at_identifier]];
    }
    return _tableView;
}

@end
