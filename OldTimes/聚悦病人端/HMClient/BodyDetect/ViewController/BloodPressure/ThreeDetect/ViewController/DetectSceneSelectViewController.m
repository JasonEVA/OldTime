//
//  DetectSceneSelectViewController.m
//  HMClient
//
//  Created by yinquan on 2017/10/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "DetectSceneSelectViewController.h"

@interface DetectSceneSelectViewController ()
<UITableViewDelegate,
UITableViewDataSource,
TaskObserver>
{
    NSArray<DetectSceneModel*>* sceneModels;
}

@property (nonatomic, strong) DetectSceneSelectHandle selectHandle;

@property (nonatomic, strong) UITableView* tableView;


@end

@implementation DetectSceneSelectViewController

+ (void) showWithSelectHandle:(DetectSceneSelectHandle) handle
{
    DetectSceneSelectViewController* selectViewController = [[DetectSceneSelectViewController alloc] initWithSelectHandle:handle];
    UIViewController* topmostViewController = [HMViewControllerManager topMostController];
    [topmostViewController addChildViewController:selectViewController];
    [topmostViewController.view addSubview:selectViewController.view];
    [selectViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topmostViewController.view);
    }];
}

- (id) initWithSelectHandle:(DetectSceneSelectHandle) handle{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setSelectHandle:handle];
    }
    return self;
}

- (void) loadView{
    UIControl* closeControl = [[UIControl alloc] init];
    [closeControl setBackgroundColor:[UIColor commonTranslucentColor]];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventAllTouchEvents];
    [self setView:closeControl];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createTestSceneModels];
    // Do any additional setup after loading the view.
    [self layoutElements];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"DetectSceneListTask" taskParam:nil TaskObserver:self];
}

/*
- (void) createTestSceneModels
{
    NSMutableArray* models = [NSMutableArray array];
    NSArray<NSString*>* names = @[@"家中", @"门诊", @"病房", @"义诊", @"其他"];
    [names enumerateObjectsUsingBlock:^(NSString * name, NSUInteger idx, BOOL * _Nonnull stop) {
        DetectSceneModel* model = [[DetectSceneModel alloc] init];
        model.name = name;
        [models addObject:model];
    }];
    
    sceneModels = [NSArray arrayWithArray:models];
}
*/
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeControlClicked:(id) sender
{
    [self closeController];
}

- (void) closeController{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) layoutElements{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(@(47 * 5));
    }];
}

#pragma mark - settingAndGetting
- (UITableView*) tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        _tableView.layer.cornerRadius = 5;
        _tableView.layer.masksToBounds = YES;
    }
    return _tableView;
}

#pragma mark - UITableView data source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (sceneModels) {
        return sceneModels.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetectSceneSelectTableViewCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetectSceneSelectTableViewCell"];
        
        [cell.textLabel setFont:[UIFont font_28]];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"535353"]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }

    DetectSceneModel* sceneModel = sceneModels[indexPath.row];
    [cell.textLabel setText:sceneModel.name];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetectSceneModel* sceneModel = sceneModels[indexPath.row];
    if (self.selectHandle) {
        self.selectHandle(sceneModel);
    }
    [self closeController];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError != StepError_None) {
        [self showAlertMessage:errorMessage clicked:^{
            [self closeController];
        }];
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
    if ([taskname isEqualToString:@"DetectSceneListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            sceneModels = (NSArray*) taskResult;
            [self.tableView reloadData];
        }
    }
}
@end
