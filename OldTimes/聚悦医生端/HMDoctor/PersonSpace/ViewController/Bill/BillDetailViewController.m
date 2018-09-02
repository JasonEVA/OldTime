//
//  BillDetailViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "BillDetailViewController.h"
#import "BillDetailTableViewCell.h"
#import "BillInfo.h"

typedef enum : NSInteger{
    BillDetailInfoSection,
    BillDetailDateSection,
    BillDetailSectionCount,
}BillDetailSection;

@interface BillDetailViewController ()
{
    BillDetailTableViewController *tvcBillDetail;
}
@end


@interface BillDetailTableViewController ()

@property(nonatomic, retain) BillInfo* billinfo;

@end

@implementation BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"账单详情"];
    
    tvcBillDetail = [[BillDetailTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcBillDetail];
    [self.view addSubview:tvcBillDetail.tableView];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[BillInfo class]])
    {
        BillInfo* billinfo = (BillInfo*) self.paramObject;
        tvcBillDetail.billinfo = billinfo;
    }
    
    [tvcBillDetail.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


@implementation BillDetailTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.tableView setScrollEnabled:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return BillDetailSectionCount;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case BillDetailInfoSection:
            return 2;
            break;
            
        case BillDetailDateSection:
            return 1;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case BillDetailInfoSection:
            return 50;
            break;
            
        case BillDetailDateSection:
            return 70;
            break;
            
        default:
            break;
    }
    
    return 0;
}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case BillDetailInfoSection:
        {
            cell = [self setBillDetilInfoCell:indexPath];
        }
            break;
            
        case BillDetailDateSection:
            cell = [self setBillDetilDateCell];
            break;

            
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (UITableViewCell*)setBillDetilInfoCell:(NSIndexPath *) indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.row)
    {
        case 0:
        {
            BillMoneyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BillMoneyTableViewCell"];
            
            if (!cell)
            {
                cell = [[BillMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BillMoneyTableViewCell"];
            }
            
            [cell setBillDetailInfo:_billinfo];
            return cell;
        }
            break;
            
        case 1:
        {
            BillServiceNameTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BillServiceNameTableViewCell"];
            
            if (!cell)
            {
                cell = [[BillServiceNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BillServiceNameTableViewCell"];
            }
            [cell setBillDetailInfo:_billinfo];
            return cell;
        }
            
        default:
            break;
    }
    return cell;
}

- (BillDetailTableViewCell*)setBillDetilDateCell
{
    BillDetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BillDetailTableViewCell"];
    
    if (!cell)
    {
        cell = [[BillDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BillDetailTableViewCell"];
    }
    [cell setBillDetailInfo:_billinfo];
    return cell;
}


@end
