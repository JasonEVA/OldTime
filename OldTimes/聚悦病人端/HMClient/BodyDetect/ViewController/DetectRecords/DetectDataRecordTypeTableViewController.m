//
//  DetectDataRecordTypeTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectDataRecordTypeTableViewController.h"

@implementation DetectDataRecordType

@end

@interface DetectDataRecordTypeSelectedViewController ()
{
    UIView* vTable;
    DetectDataRecordTypeTableViewController* tvcSelect;
}

@property (nonatomic, copy) DataRecordTypeSelectedBlock selectedBlock;
@end

@implementation DetectDataRecordTypeSelectedViewController

+ (void) createSelectedControllerInParent:(UIViewController*) parentController
              DataRecordTypeSelectedBlock:(DataRecordTypeSelectedBlock) block
{
    if (!parentController)
    {
        return;
    }
    DetectDataRecordTypeSelectedViewController* vcSelect = [[DetectDataRecordTypeSelectedViewController alloc]initWithNibName:nil bundle:nil];
    [vcSelect setSelectedBlock:block];
    
    [parentController addChildViewController:vcSelect];
    [vcSelect.view setFrame:parentController.view.bounds];
    [parentController.view addSubview:vcSelect.view];
    
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
    UIControl* closeControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:closeControl];
    [closeControl addTarget:self action:@selector(removeSubViews) forControlEvents:UIControlEventTouchUpInside];
    
    /*UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removeSubViews)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:recognizer];*/
}

- (void)removeSubViews
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!tvcSelect)
    {
        CGRect rtTable = CGRectMake(self.view.width - 12.5 - 65  * kScreenScale, 40 * kScreenScale, 65 * kScreenScale, 25 * 5 * kScreenScale);
        
        vTable = [[UIView alloc]initWithFrame:rtTable];
        [self.view addSubview:vTable];

        NSMutableArray* types = [NSMutableArray array];
        
        DetectDataRecordType* allType = [[DetectDataRecordType alloc]init];
        [allType setTypeName:@"全部"];
        [types addObject:allType];
        
        DetectDataRecordType* bpType = [[DetectDataRecordType alloc]init];
        [bpType setTypeName:@"血压"];
        [bpType setKpiCode:@"XY"];
        [types addObject:bpType];
        
        DetectDataRecordType* hrType = [[DetectDataRecordType alloc]init];
        [hrType setTypeName:@"心率"];
        [hrType setKpiCode:@"XL"];
        [types addObject:hrType];
        
        DetectDataRecordType* bwType = [[DetectDataRecordType alloc]init];
        [bwType setTypeName:@"体重"];
        [bwType setKpiCode:@"TZ"];
        [types addObject:bwType];
        
        DetectDataRecordType* bsType = [[DetectDataRecordType alloc]init];
        [bsType setTypeName:@"血糖"];
        [bsType setKpiCode:@"XT"];
        [types addObject:bsType];
        
        DetectDataRecordType* bfType = [[DetectDataRecordType alloc]init];
        [bfType setTypeName:@"血脂"];
        [bfType setKpiCode:@"XZ"];
        [types addObject:bfType];
        
        DetectDataRecordType* uvType = [[DetectDataRecordType alloc]init];
        [uvType setTypeName:@"尿量"];
        [uvType setKpiCode:@"NL"];
        [types addObject:uvType];
        
        DetectDataRecordType* boType = [[DetectDataRecordType alloc]init];
        [boType setTypeName:@"血氧"];
        [boType setKpiCode:@"OXY"];
        [types addObject:boType];
        
        DetectDataRecordType* bthType = [[DetectDataRecordType alloc]init];
        [bthType setTypeName:@"呼吸"];
        [bthType setKpiCode:@"HX"];
        [types addObject:bthType];
        
        DetectDataRecordType* temType = [[DetectDataRecordType alloc]init];
        [temType setTypeName:@"体温"];
        [temType setKpiCode:@"TEM"];
        [types addObject:temType];
        
        DetectDataRecordType* pefType = [[DetectDataRecordType alloc]init];
        [pefType setTypeName:@"峰流速值"];
        [pefType setKpiCode:@"FLSZ"];
        [types addObject:pefType];
        
        tvcSelect = [[DetectDataRecordTypeTableViewController alloc]initWithTypeList:types];
        [self addChildViewController:tvcSelect];
        [tvcSelect.tableView setFrame:vTable.bounds];
        [vTable addSubview:tvcSelect.tableView];
        
        __weak typeof(self) weakSelf = self;

        [tvcSelect setSelectedBlock:^(DetectDataRecordType* type)
         {
             __strong typeof(weakSelf) strongSelf = weakSelf;
             if (strongSelf.selectedBlock)
             {
                 strongSelf.selectedBlock(type);
             }
             
             [strongSelf.view removeFromSuperview];
             [strongSelf removeFromParentViewController];
         }];
        
        UIView* bottomline = [[UIView alloc]init];
        [bottomline setBackgroundColor:[UIColor mainThemeColor]];
        [vTable addSubview:bottomline];
        
        [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.left.equalTo(vTable);
            make.bottom.equalTo(vTable);
            make.height.mas_equalTo(0.5);
        }];
    }
}

@end

@interface DetectDataRecordTypeTableViewCell : UITableViewCell
{
    UILabel* lbName;
    UIView* leftLine;
    UIView* rightLine;
    UIView* bottomLine;
}

- (void) setTypeName:(NSString*) name;
@end

@implementation DetectDataRecordTypeTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbName = [[UILabel alloc]init];
        [self.contentView addSubview:lbName];
        [lbName setFont:[UIFont font_24]];
        [lbName setTextColor:[UIColor mainThemeColor]];
        
        leftLine = [[UIView alloc]init];
        [self.contentView addSubview:leftLine];
        [leftLine setBackgroundColor:[UIColor mainThemeColor]];
        
        rightLine = [[UIView alloc]init];
        [self.contentView addSubview:rightLine];
        [rightLine setBackgroundColor:[UIColor mainThemeColor]];
        
        bottomLine = [[UIView alloc]init];
        [self.contentView addSubview:bottomLine];
        [bottomLine setBackgroundColor:[UIColor mainThemeColor]];
        
        [self subviewLayout];
    }
    
    return self;
}

- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).with.offset(9);
//        make.right.equalTo(self.contentView).with.offset(-9);
        make.center.equalTo(self.contentView);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.and.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(0.5);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.top.and.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(0.5);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (void) setTypeName:(NSString*) name
{
    [lbName setText:name];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        [self.contentView setBackgroundColor:[UIColor mainThemeColor]];
        [lbName setTextColor:[UIColor whiteColor]];
    }
    else
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [lbName setTextColor:[UIColor mainThemeColor]];
    }
}
@end

@interface DetectDataRecordTypeTableViewController ()
{
    NSArray* typeItems;
}


@end

@implementation DetectDataRecordTypeTableViewController

- (id) initWithTypeList:(NSArray*) list
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        typeItems = [NSArray arrayWithArray:list];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    if (typeItems)
    {
        return typeItems.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25 * kScreenScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetectDataRecordTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetectDataRecordTypeTableViewCell" ];
    if (!cell)
    {
        cell = [[DetectDataRecordTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetectDataRecordTypeTableViewCell"];
    }
    // Configure the cell...
    DetectDataRecordType* recordType = typeItems[indexPath.row];
    [cell setTypeName:recordType.typeName];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetectDataRecordType* recordType = typeItems[indexPath.row];
    if (_selectedBlock)
    {
        _selectedBlock(recordType);
    }
}

@end
