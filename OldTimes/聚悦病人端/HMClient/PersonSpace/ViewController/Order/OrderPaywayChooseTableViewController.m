//
//  OrderPaywayChooseTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderPaywayChooseTableViewController.h"
#import "ServiceOrderConfirmInfoTableViewCell.h"

@interface OrderPaywayChooseViewController ()
{
    NSArray* payways;
    OrderPaywayChooseTableViewController* tvcChoose;
}
@property (nonatomic, copy) OrderPaywayChooseBlock chooseBlock;
@end

@interface OrderPaywayChooseTableViewController ()
{
    NSArray* payways;
}

@property (nonatomic, retain) ServicePayWay* selectedPayway;

- (id) initWithPayways:(NSArray*) aPayways;
@end

@implementation OrderPaywayChooseViewController

- (void) dealloc
{
    if (tvcChoose)
    {
        [tvcChoose removeObserver:self forKeyPath:@"selectedPayway"];
    }
}

- (id) initWithPayways:(NSArray*) aPayways
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
        payways = [NSArray arrayWithArray:aPayways];
        
        
        tvcChoose = [[OrderPaywayChooseTableViewController alloc]initWithPayways:payways];
        [self addChildViewController:tvcChoose];
        [self.view addSubview:tvcChoose.tableView];
        [tvcChoose.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.mas_equalTo([NSNumber numberWithFloat: payways.count * 45]);
        }];
        
        [tvcChoose addObserver:self forKeyPath:@"selectedPayway" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

+ (void) showInPerantController:(UIViewController*) parentController
                      Payways:(NSArray*)payways
                    ChooseBlock:(OrderPaywayChooseBlock)block
{
    if (!parentController)
    {
        return;
    }
    OrderPaywayChooseViewController* vcChoose = [[OrderPaywayChooseViewController alloc]initWithPayways:payways];
    [parentController addChildViewController:vcChoose];
    //[vcChoose.view setFrame:vcChoose.view.bounds];
    [parentController.view addSubview:vcChoose.view];
    [vcChoose.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(parentController.view);
        make.top.and.bottom.equalTo(parentController.view);
    }];
    
    [vcChoose setChooseBlock:block];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"selectedPayway"])
    {
        ServicePayWay* selPayway = [object valueForKey:@"selectedPayway"];
        if (_chooseBlock)
        {
            _chooseBlock(selPayway);
        }
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}
@end

@implementation OrderPaywayChooseTableViewController

- (id) initWithPayways:(NSArray*) aPayways
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        payways = [NSArray arrayWithArray:aPayways];
        
    }
    return self;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (payways)
    {
        return payways.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self paywayCell:indexPath.row];
    //return cell;
}


- (UITableViewCell*) paywayCell:(NSInteger) row
{
    ServiceOrderConfirmPaywayTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ServiceOrderConfirmPaywayTableViewCell"];
    if (!cell)
    {
        cell = [[ServiceOrderConfirmPaywayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceOrderConfirmPaywayTableViewCell"];
    }
    
    ServicePayWay* payway = payways[row];
    [cell setPayway:payway];
    
    [cell setIsSelected:NO];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServicePayWay* payway = payways[indexPath.row];
    [self setSelectedPayway:payway];
}
@end
