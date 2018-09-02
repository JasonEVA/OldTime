//
//  MainConsoleMoreViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "MainConsoleMoreViewController.h"
#import "MainConsoleFunctionDisplayTableViewController.h"
#import "MainConsoleFunctionEditTableViewController.h"

@interface MainConsoleMoreViewController ()
{
    BOOL isEditing;
    UITableViewController* functionTableViewController;
}
@end

@implementation MainConsoleMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createFunctionTableViewController];
    
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBarButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:bbi];
}

- (void) editBarButtonClicked:(id) sender
{
    isEditing = YES;
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBarButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:bbi];
    [self createFunctionTableViewController];
}

- (void) doneBarButtonClicked:(id) sender
{
    //TODO:保存修改
    if (functionTableViewController) {
        if ([functionTableViewController isKindOfClass:[MainConsoleFunctionEditTableViewController class]]) {
            MainConsoleFunctionEditTableViewController* editTableViewContorller = (MainConsoleFunctionEditTableViewController*) functionTableViewController;
            
            [editTableViewContorller saveSelectedMainFunctions];
        }
    }
    isEditing = NO;
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBarButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:bbi];
    [self createFunctionTableViewController];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) createFunctionTableViewController
{
    if (!isEditing) {
        if (functionTableViewController) {
            if ([functionTableViewController isKindOfClass:[MainConsoleFunctionDisplayTableViewController class]]) {
                return;
            }
            [functionTableViewController.tableView removeFromSuperview];
            [functionTableViewController removeFromParentViewController];
            functionTableViewController = nil;
        }
        
        
        functionTableViewController = [[MainConsoleFunctionDisplayTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self addChildViewController:functionTableViewController];
        [self.view addSubview:functionTableViewController.tableView];
        [functionTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else
    {
        if (functionTableViewController) {
            if ([functionTableViewController isKindOfClass:[MainConsoleFunctionEditTableViewController class]]) {
                return;
            }
            [functionTableViewController.tableView removeFromSuperview];
            [functionTableViewController removeFromParentViewController];
            functionTableViewController = nil;
        }
        
        
        functionTableViewController = [[MainConsoleFunctionEditTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self addChildViewController:functionTableViewController];
        [self.view addSubview:functionTableViewController.tableView];
        [functionTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

@end
