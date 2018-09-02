//
//  AttentionListTableViewController.m
//  HMClient
//
//  Created by lkl on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AttentionListTableViewController.h"
#import "HMSwitchView.h"

@interface AttentionListStartViewController ()
<HMSwitchViewDelegate>
{
    HMSwitchView* attentionSwitchview;
    AttentionListTableViewController *tvcAttentionList;
}
@end

@implementation AttentionListStartViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的关注"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self createOrderSwitchView];
    [self createListTable:0];
}

- (void) createOrderSwitchView
{
    attentionSwitchview = [[HMSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 47)];
    [self.view addSubview:attentionSwitchview];
    [attentionSwitchview createCells:@[@"医生", @"专家团队"]];
    
    [attentionSwitchview setDelegate:self];
}

- (NSString*) attentionTableClass:(NSInteger) index
{
    NSString* classname = nil;
    switch (index)
    {
        case 0:
            classname = @"AttentionStaffListTableViewController";
            break;
        case 1:
            classname = @"AttentionTeamListTableViewController";
            break;
        default:
            break;
    }
    return classname;
}

- (void) createListTable:(NSInteger) index
{
    NSString* tableClassName = [self attentionTableClass:index];
    if (!tableClassName || 0 == tableClassName.length)
    {
        return;
    }
    
    if (tvcAttentionList)
    {
        if ([tvcAttentionList isKindOfClass:NSClassFromString(tableClassName)])
        {
            return;
        }
        
        [tvcAttentionList.tableView removeFromSuperview];
        [tvcAttentionList removeFromParentViewController];
    }
    
    tvcAttentionList = [[NSClassFromString(tableClassName) alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcAttentionList];
    [tvcAttentionList.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tvcAttentionList.tableView];
    
    [tvcAttentionList.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(attentionSwitchview.mas_bottom).with.offset(5);
        make.bottom.equalTo(self.view);
    }];

}


#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView *)switchview SelectedIndex:(NSInteger)selectedIndex
{
    [self createListTable:selectedIndex];
    
}

@end




@interface AttentionListTableViewController ()

@end

@implementation AttentionListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

@end
