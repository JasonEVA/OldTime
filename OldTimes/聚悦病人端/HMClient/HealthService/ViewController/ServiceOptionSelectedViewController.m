//
//  ServiceOptionSelectedViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceOptionSelectedViewController.h"
#import "ServiceOptionSelectTableViewCell.h"

@interface ServiceOptionSelectedViewController ()
{
    UIControl* selectview;
    
    ServiceOptionSelectedTableViewController* tvcOptions;
}

@property (nonatomic, retain) NSArray* serviceOptions;
@property (nonatomic, retain) NSArray* selectedOptions;

@property (nonatomic, copy) SelectOptionSelectOptionsBlock selectBlock;
@end

@implementation ServiceOptionSelectedViewController

- (void) loadView
{
    selectview = [[UIControl alloc]init];
    [selectview setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    [self setView:selectview];
    [selectview addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventAllEvents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTable];
}

- (void) closeControlClicked:(id) sender
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) createTable
{
    UIView* vTable = [[UIView alloc]init];
    [self.view addSubview:vTable];
    vTable.layer.cornerRadius = 2.5;
    vTable.layer.masksToBounds = YES;
    [vTable setBackgroundColor:[UIColor whiteColor]];
    [vTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        //make.height.equalTo([NSNumber numberWithInteger:35 + 45 * _serviceOptions.count]);
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
    }];
    
    UIView* titleview = [[UIView alloc]init];
    [vTable addSubview:titleview];
    [titleview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(vTable);
        make.height.mas_equalTo(@35);
        make.top.equalTo(vTable);
    }];
    
    UILabel* lbTitle = [[UILabel alloc]init];
    [titleview addSubview:lbTitle];
    [lbTitle setBackgroundColor:[UIColor clearColor]];
    [lbTitle setTextColor:[UIColor commonGrayTextColor]];
    [lbTitle setFont:[UIFont font_26]];
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleview);
    }];
    [lbTitle setText:@"请选择自选项目(多选)"];
    
    UIView* lineview = [[UIView alloc]init];
    [titleview addSubview:lineview];
    [lineview setBackgroundColor:[UIColor commonControlBorderColor]];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(titleview);
        make.bottom.equalTo(titleview);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView* buttonview = [[UIView alloc]init];
    [vTable addSubview:buttonview];
    [buttonview setBackgroundColor:[UIColor whiteColor]];
    [buttonview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(vTable);
        make.bottom.equalTo(vTable);
        make.height.mas_equalTo(@40);
    }];
    
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonview addSubview:cancelButton];
    [cancelButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont font_26]];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonview);
        make.top.and.bottom.equalTo(buttonview);
    }];
    
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonview addSubview:confirmButton];
    [confirmButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont font_26]];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelButton.mas_right);
        make.right.equalTo(buttonview);
        make.top.and.bottom.equalTo(buttonview);
        make.width.equalTo(cancelButton);
    }];
    
    [confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* buttonTopLine = [[UIView alloc]init];
    [buttonview addSubview:buttonTopLine];
    [buttonTopLine setBackgroundColor:[UIColor commonControlBorderColor]];
    [buttonTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(titleview);
        make.top.equalTo(buttonview);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView* buttonMidLine = [[UIView alloc]init];
    [buttonview addSubview:buttonMidLine];
    [buttonMidLine setBackgroundColor:[UIColor commonControlBorderColor]];
    [buttonMidLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(buttonview);
        make.top.and.bottom.equalTo(buttonview);
        make.width.mas_equalTo(0.5);
    }];
    
    tvcOptions = [[ServiceOptionSelectedTableViewController alloc]initWithSelectedOption:_selectedOptions ServiceOptions:_serviceOptions];
    [self addChildViewController:tvcOptions];
    [tvcOptions.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tvcOptions.tableView];
    [tvcOptions.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(vTable);
        make.top.equalTo(titleview.mas_bottom);
        make.bottom.equalTo(buttonview.mas_top);
        make.height.mas_equalTo([NSNumber numberWithInteger:_serviceOptions.count * 45]);
    }];

}

- (void) cancelButtonClicked:(id) sender
{
    [self closeSelectView];
}

- (void) confirmButtonClicked:(id) sender
{
    if (_selectBlock)
    {
        NSArray* selectedItems = [tvcOptions selectedOptionItems];
        _selectBlock(selectedItems);
    }
    [self closeSelectView];
}

- (void) closeSelectView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void) showSelectOptionView:(NSArray*) selectedOptions
               ServiceOptions:(NSArray*) options
SelectOptionSelectOptionsBlock:(SelectOptionSelectOptionsBlock) block
{
    UIViewController* vcTop = [HMViewControllerManager topMostController];
    ServiceOptionSelectedViewController* vcSelect = [[ServiceOptionSelectedViewController alloc]initWithNibName:nil bundle:nil];
    [vcSelect setSelectedOptions:selectedOptions];
    [vcSelect setServiceOptions:options];
    [vcSelect setSelectBlock:block];
    
    [vcTop addChildViewController:vcSelect];
    [vcTop.view addSubview:vcSelect.view];
    [vcSelect.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(vcTop.view);
        make.center.equalTo(vcTop.view);
    }];
}



@end

@interface ServiceOptionSelectedTableViewController ()
{
    NSMutableArray* selectedOptions;
    NSArray* servoiceOptions;
}

@end

@implementation ServiceOptionSelectedTableViewController

- (id) initWithSelectedOption:(NSArray*) selectedItems
               ServiceOptions:(NSArray*) options
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.tableView.layer.cornerRadius = 2.5;
        self.tableView.layer.masksToBounds = YES;
        
        selectedOptions = [NSMutableArray arrayWithArray:selectedItems];
        servoiceOptions = options;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (servoiceOptions)
    {
        return servoiceOptions.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceOptionSelectTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceOptionSelectTableViewCell"];
    if (!cell)
    {
        cell = [[ServiceOptionSelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceOptionSelectTableViewCell"];
    }
    
    ServiceDetailOption* option = [servoiceOptions objectAtIndex:indexPath.row];
    [cell setOption:option];
    BOOL isSelected = [self optionIsSelected:option];
    [cell setOptionSelected:isSelected];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (BOOL) optionIsSelected:(ServiceDetailOption*) option
{
    BOOL isSelected = NO;
    for (ServiceDetailOption* opt in selectedOptions)
    {
        if (opt.upDetId == option.upDetId)
        {
            isSelected = YES;
            break;
        }
    }
    return isSelected;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceDetailOption* option = [servoiceOptions objectAtIndex:indexPath.row];
    BOOL isExisted = NO;
    for (ServiceDetailOption* opt in selectedOptions)
    {
        if (opt.upDetId == option.upDetId)
        {
            //已经被选择，取消选择
            [selectedOptions removeObject:opt];
            isExisted = YES;
            break;
        }
    }
    if (!isExisted)
    {
        //没有找到，添加选择
        [selectedOptions addObject:option];
    }
    
    [self.tableView reloadData];
}

- (NSArray*) selectedOptionItems
{
    return selectedOptions;
}

@end
