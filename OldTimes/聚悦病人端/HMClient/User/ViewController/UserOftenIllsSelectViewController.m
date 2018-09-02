//
//  UserOftenIllsSelectViewController.m
//  HMClient
//
//  Created by yinqaun on 16/7/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserOftenIllsSelectViewController.h"

#import "UserOftenIllsSelectTableViewCell.h"

@interface UserOftenIllsSelectTableViewController : UITableViewController
{
    NSArray* offenIllsItems;
}

@property (nonatomic, retain) NSMutableArray* selectIlls;

- (id) initWithOftenIlls:(NSArray*) oftenIlls;
@end

@interface UserOftenIllsSelectViewController ()
{
    NSArray* offenIllsItems;
    UserOftenIllsSelectTableViewController* tvcSelectController;
}
@property (nonatomic, strong) UserOftenIllSelectBlock selectedBlock;

- (id) initWithOftenIlls:(NSArray*) oftenIlls;
@end



@implementation UserOftenIllsSelectViewController

- (id) initWithOftenIlls:(NSArray*) oftenIlls
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        offenIllsItems = [NSArray arrayWithArray:oftenIlls];
    }
    return self;
}

- (void) loadView
{
    UIControl* closeControl = [[UIControl alloc]init];
    [self setView:closeControl];
    [closeControl setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createSelectTable];
     
}

- (void) createSelectTable
{
    CGFloat totalHeight = 0;
    if (offenIllsItems)
    {
        totalHeight = offenIllsItems.count * 44;
    }
    if (totalHeight > kScreenHeight - 160)
    {
        totalHeight = kScreenHeight - 160;
    }
    
    UIView* selectview = [[UIView alloc]init];
    [self.view addSubview:selectview];
    [selectview setBackgroundColor:[UIColor whiteColor]];
    [selectview.layer setCornerRadius:4];
    [selectview.layer setMasksToBounds:YES];
    
    [selectview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).with.offset(12.5);
                make.right.equalTo(self.view).with.offset(-12.5);
                make.centerY.equalTo(self.view);
                make.height.mas_equalTo([NSNumber numberWithFloat:totalHeight]);
            }];
    
    UILabel* lbTitle = [[UILabel alloc]init];
    [selectview addSubview:lbTitle];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [lbTitle setBackgroundColor:[UIColor mainThemeColor]];
    [lbTitle setTextColor:[UIColor whiteColor]];
    [lbTitle setText:@"选择疾病"];
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(selectview);
        make.top.equalTo(selectview);
        make.height.mas_equalTo(@40);
    }];
    
    UIView* confirmview = [[UIView alloc]init];
    [selectview addSubview:confirmview];
    [confirmview showTopLine];
    
    [confirmview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(selectview);
        make.height.mas_equalTo(60);
    }];
    
    UIButton* confirmbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmview addSubview:confirmbutton];
    [confirmbutton setBackgroundImage:[UIImage rectImage:CGSizeMake(20, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [confirmbutton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmbutton.titleLabel setFont:[UIFont font_30]];
    confirmbutton.layer.cornerRadius = 5;
    confirmbutton.layer.masksToBounds = YES;
    
    [confirmbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(confirmview);
        make.left.equalTo(confirmview).with.offset(10);
        make.right.equalTo(confirmview).with.offset(-10);
        make.height.mas_equalTo(45);
    }];
    
    tvcSelectController = [[UserOftenIllsSelectTableViewController alloc]initWithOftenIlls:offenIllsItems];
    [self addChildViewController:tvcSelectController];
    [selectview addSubview:tvcSelectController.tableView];
    [confirmbutton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [tvcSelectController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectview);
        make.right.equalTo(selectview);
        make.top.equalTo(lbTitle.mas_bottom);
        make.bottom.equalTo(confirmview.mas_top);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeControlClicked:(id) sender
{
    [self closeController];
}

- (void) closeController
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+ (void) showInParentController:(UIViewController*) parentController
                      OftenIlls:(NSArray*) oftenIlls
                    SelectBlock:(UserOftenIllSelectBlock)block
{
    if (!parentController)
    {
        return;
    }
    UserOftenIllsSelectViewController* vcSelect = [[UserOftenIllsSelectViewController alloc]initWithOftenIlls:oftenIlls];
    [parentController addChildViewController:vcSelect];
    [parentController.view addSubview:vcSelect.view];
    [vcSelect.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(parentController.view);
        make.top.and.bottom.equalTo(parentController.view);
    }];
    
    [vcSelect setSelectedBlock:block];
}

- (void) confirmButtonClicked:(id) sender
{
    if (_selectedBlock)
    {
        NSArray* selectedIlls = tvcSelectController.selectIlls;
        NSMutableArray* illIds = [NSMutableArray array];
        for (UserOftenIllInfo* illItem in selectedIlls) {
            [illIds addObject:[NSString stringWithFormat:@"%ld", illItem.illId]];
        }
        _selectedBlock(illIds);
    }
    [self closeController];
}

@end

@implementation UserOftenIllsSelectTableViewController

- (id) initWithOftenIlls:(NSArray*) oftenIlls
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        offenIllsItems = [NSArray arrayWithArray:oftenIlls];
        _selectIlls = [NSMutableArray array];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    //已经选择的疾病
    UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
    if (user.userIlls && 0 < user.userIlls.count)
    {
        for (UserOftenIllInfo* ill in offenIllsItems)
        {
            for (UserOftenIllInfo* selectedIll in user.userIlls)
            {
                if (ill.illId == selectedIll.illId)
                {
                    [_selectIlls addObject:ill];
                }
            }
        }
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (offenIllsItems)
    {
        return offenIllsItems.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserOftenIllsSelectTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserOftenIllsSelectTableViewCell"];
    if (!cell)
    {
        cell = [[UserOftenIllsSelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserOftenIllsSelectTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UserOftenIllInfo* illItem = offenIllsItems[indexPath.row];
    [cell setOftenIll:illItem];
    [cell setIsSelected:[self illIsSelected:illItem]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserOftenIllInfo* illItem = offenIllsItems[indexPath.row];
    NSInteger selectedIndex = [self indexOfSelectedIll:illItem];
    if (NSNotFound == selectedIndex)
    {
        //还没有选择该疾病,添加
        [_selectIlls addObject:illItem];
    }
    else
    {
        //已经还没有选择该疾病,添加
        UserOftenIllInfo* illInfo = _selectIlls[selectedIndex];
        [_selectIlls removeObject:illInfo];
    }
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger) indexOfSelectedIll:(UserOftenIllInfo*) ill
{
    NSInteger selectedIndex = NSNotFound;
    for (NSInteger index = 0; index < _selectIlls.count; ++index)
    {
        UserOftenIllInfo* illInfo = _selectIlls[index];
        if (ill.illId == illInfo.illId)
        {
            selectedIndex = index;
            break;
        }
    }
    
    return selectedIndex;
    
}

- (BOOL) illIsSelected:(UserOftenIllInfo*) ill
{
    if (!ill)
    {
        return NO;
    }
    
    BOOL isSelected = NO;
    for (UserOftenIllInfo* illInfo in _selectIlls)
    {
        if (ill.illId == illInfo.illId)
        {
            isSelected = YES;
            break;
        }
    }
    
    return isSelected;
}

@end
