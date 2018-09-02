//
//  MainConsoleFunctionEditTableViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "MainConsoleFunctionEditTableViewController.h"
#import "MainConsoleUtil.h"
#import "MainConsoleFunctionView.h"
#import "MainConsoleFunctionButton.h"

@interface ReplaceAnimationModel : NSObject

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger endIndex;

@end

@implementation ReplaceAnimationModel

@end

@interface MainConsoleFunctionEditTableViewController ()
{
    MainConsoleEditSelectedFunctionView* selectedFunctionsView;
    MainConsoleFunctionView* unselectedFunctionsView;
    
    MainConsoleUtil* mainConsoleUtil;
    
    NSMutableArray* selectedFunctionModels;
    NSMutableArray* unselectedFunctionModels;
    
    CGPoint startPoint;
    CGPoint originPoint;
    
}
@end

typedef NS_ENUM(NSUInteger, MainConsoleFunctionSection) {
    MainConsoleFunctionSelectedSection,
    MainConsoleFunctionUnSelectedSection,
    MainConsoleFunctionSectionCount,
};

@implementation MainConsoleFunctionEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    mainConsoleUtil = [MainConsoleUtil shareInstance];
    
    selectedFunctionModels = [NSMutableArray arrayWithArray:mainConsoleUtil.selectedFunctions];
    unselectedFunctionModels = [NSMutableArray arrayWithArray:mainConsoleUtil.unSelectedFunctions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveSelectedMainFunctions
{
    [mainConsoleUtil saveSelectedMainFunctions:selectedFunctionModels];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMainConsoleFunctionNotificationName object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return MainConsoleFunctionSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    UILabel* titleLable = [[UILabel alloc] init];
    [headerview addSubview:titleLable];
    [titleLable setFont:[UIFont systemFontOfSize:14]];
    [titleLable setTextColor:[UIColor commonTextColor]];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview).with.offset(15);
        make.centerY.equalTo(headerview);
    }];
    
    switch (section) {
        case MainConsoleFunctionSelectedSection:
        {
            [titleLable setText:@"已有功能"];
            UILabel* drugLable = [[UILabel alloc] init];
            [headerview addSubview:drugLable];
            [drugLable setFont:[UIFont systemFontOfSize:12]];
            [drugLable setTextColor:[UIColor commonGrayTextColor]];
            [drugLable setText:@"按住拖动调整排序"];
            
            [drugLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerview);
                make.right.equalTo(headerview).with.offset(-15);
            }];
        }
            break;
        case MainConsoleFunctionUnSelectedSection:
        {
            [titleLable setText:@"可选功能"];
            
            
        }
        default:
            break;
    }
    return headerview;
}

- (CGFloat) selectionFunctionViewHeight
{
    if (selectedFunctionModels) {
        NSInteger rows = selectedFunctionModels.count / 3;
        if ((selectedFunctionModels.count % 3) > 0) {
            ++rows;
        }
        return (kScreenWidth - 30)/3 * rows;
    }
    
    return 0;
}

- (CGFloat) unselectionFunctionViewHeight
{
    if (unselectedFunctionModels) {
        NSInteger rows = unselectedFunctionModels.count / 3;
        if ((unselectedFunctionModels.count % 3) > 0) {
            ++rows;
        }
        return (kScreenWidth - 30)/3 * rows;
    }
    
    return 46;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MainConsoleFunctionSelectedSection:
        {
            return [self selectionFunctionViewHeight];
            break;
        }
        case MainConsoleFunctionUnSelectedSection:
        {
            return [self unselectionFunctionViewHeight];
            break;
        }
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case MainConsoleFunctionSelectedSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MainConsoleFunctionSelectedSectionTableCell"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainConsoleFunctionSelectedSectionTableCell"];
//                selectedFunctionsView = [[MainConsoleEditSelectedFunctionView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, [self selectionFunctionViewHeight])];
                selectedFunctionsView = [[MainConsoleEditSelectedFunctionView alloc] init];
                [cell.contentView addSubview:selectedFunctionsView];
                
                [selectedFunctionsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
                }];
                [selectedFunctionsView showTopLine];
                [selectedFunctionsView showLeftLine];
                [selectedFunctionsView showRightLine];
                [selectedFunctionsView showBottomLine];
                
            }
            
            [selectedFunctionsView setFunctionModels:selectedFunctionModels];

            [selectedFunctionsView setHidden:(selectedFunctionModels.count == 0)];

            [selectedFunctionsView.functionButtons enumerateObjectsUsingBlock:^(MainConsoleEditSelectedFunctionButton* deleteButton, NSUInteger idx, BOOL * _Nonnull stop) {
                [deleteButton.minusButton addTarget:self action:@selector(deleteFunctionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
//                MainConsoleFunctionModel* model = selectedFunctionModels[idx];
//                if (model.status == 0) {
//                    //必选项，不拖动
//                    return ;
//                }
                UILongPressGestureRecognizer *panGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandel:)];
                [panGestureRecognizer setMinimumPressDuration:0.5];
                [deleteButton addGestureRecognizer:panGestureRecognizer];
            }];
            break;
        }
        case MainConsoleFunctionUnSelectedSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MainConsoleFunctionUnSelectedSectionTableCell"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainConsoleFunctionUnSelectedSectionTableCell"];
                unselectedFunctionsView = [[MainConsoleEditUnSelectedFunctionView alloc] init];
                [cell.contentView addSubview:unselectedFunctionsView];
                [unselectedFunctionsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).with.offset(15);
                    make.right.equalTo(cell.contentView).with.offset(-15);
                }];
                
                [unselectedFunctionsView showTopLine];
                [unselectedFunctionsView showLeftLine];
                [unselectedFunctionsView showRightLine];
                [unselectedFunctionsView showBottomLine];
                
            }
            
            [unselectedFunctionsView setFunctionModels:unselectedFunctionModels];

            [unselectedFunctionsView.functionButtons enumerateObjectsUsingBlock:^(MainConsoleEditUnSelectedFunctionButton* appendButton, NSUInteger idx, BOOL * _Nonnull stop) {
                MainConsoleFunctionModel* unselectedModel = unselectedFunctionModels[idx];
                __block BOOL isSelected = NO;
                [selectedFunctionModels enumerateObjectsUsingBlock:^(MainConsoleFunctionModel* selectedModel, NSUInteger idx, BOOL * _Nonnull stop)
                {
                    if ([unselectedModel.functionCode isEqualToString:selectedModel.functionCode])
                    {
                        isSelected = YES;
                        *stop = YES;
                        return ;
                    }
                    
                }];
                
                if (isSelected)
                {
                    [appendButton.plusButton setEnabled:NO];
                    [appendButton.plusButton setImage:[UIImage imageNamed:@"main_console_button_appended"] forState:UIControlStateDisabled];
                    return;
                }
                
                [appendButton.plusButton addTarget:self action:@selector(appendFunctionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }];
            
            [unselectedFunctionsView setHidden:(unselectedFunctionModels.count == 0)];
            break;
        }
        default:
            break;
    }
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainConsoleFunctionDisplayTableViewCell"];
    }
    // Configure the cell...
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - AppendAndDelete
- (void) deleteFunctionButtonClicked:(id) sender
{
    if (![sender isKindOfClass:[UIButton class]])
    {
        return;
    }
    UIButton* minusButton = (UIButton*)sender;
    UIView* functionButton = minusButton.superview;
    NSInteger functionIndex = [selectedFunctionsView.functionButtons indexOfObject:functionButton];
    if (functionIndex == NSNotFound) {
        return;
    }
    
    MainConsoleFunctionModel* deleteFunctionModel = selectedFunctionModels[functionIndex];
    [selectedFunctionModels removeObject:deleteFunctionModel];
//    [unselectedFunctionModels addObject:deleteFunctionModel];
    
    [self.tableView reloadData];
}

- (void) appendFunctionButtonClicked:(id) sender
{
    if (![sender isKindOfClass:[UIButton class]])
    {
        return;
    }
    UIButton* plusButton = (UIButton*)sender;
    UIView* functionButton = plusButton.superview;
    
    NSInteger functionIndex = [unselectedFunctionsView.functionButtons indexOfObject:functionButton];
    if (functionIndex == NSNotFound) {
        return;
    }
    
    MainConsoleFunctionModel* appendFunctionModel = unselectedFunctionModels[functionIndex];
    [selectedFunctionModels addObject:appendFunctionModel];
//    [unselectedFunctionModels removeObject:appendFunctionModel];
    [self.tableView reloadData];
}

- (void) longPressHandel:(UILongPressGestureRecognizer*) recognizer
{
    UIButton* button = (UIButton*)recognizer.view;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            startPoint = [recognizer locationInView:recognizer.view];
            originPoint = button.center;
            [button hideRightLine];
            [button hideBottomLine];
            
            [UIView animateWithDuration:0.2 animations:^{
                button.transform = CGAffineTransformMakeScale(1.1, 1.1);
                button.alpha = 0.7;}];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint newPoint = [recognizer locationInView:recognizer.view];
            CGFloat deltaX = newPoint.x-startPoint.x;
            CGFloat deltaY = newPoint.y-startPoint.y;
            button.center = CGPointMake(button.center.x+deltaX,button.center.y+deltaY);
            //NSLog(@"center = %@",NSStringFromCGPoint(btn.center));
         
            

            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGPoint newPoint = [recognizer locationInView:recognizer.view];
            CGFloat deltaX = newPoint.x-startPoint.x;
            CGFloat deltaY = newPoint.y-startPoint.y;
            CGPoint targetCenter = CGPointMake(button.center.x+deltaX,button.center.y+deltaY);

            NSInteger drugSrcIndex = [selectedFunctionsView.functionButtons indexOfObject:recognizer.view];
            
            NSInteger targetRow = (targetCenter.y / (selectedFunctionsView.width / 3)) ;
            NSInteger targetCol = (targetCenter.x / (selectedFunctionsView.width / 3));
            NSInteger drugTargetIndex = targetRow * 3 + targetCol;

            if (drugTargetIndex < 0 || drugTargetIndex >= selectedFunctionModels.count) {
                [self.tableView reloadData];
                return;
            }
            
            MainConsoleFunctionModel* srcFunctionModel = selectedFunctionModels[drugSrcIndex];

            [selectedFunctionModels removeObjectAtIndex:drugSrcIndex];
            [selectedFunctionModels insertObject:srcFunctionModel atIndex:drugTargetIndex];
                
            
            [self.tableView reloadData];
            
            ReplaceAnimationModel* model = [[ReplaceAnimationModel alloc] init];
            model.startIndex = drugTargetIndex;
            model.endIndex = drugSrcIndex;
            [self performSelector:@selector(startReplaceAnimation:) withObject:model afterDelay:0.06];
            break;
        }
        default:
            break;
    }
    
}


- (void) startReplaceAnimation:(ReplaceAnimationModel*) animationModel
{
    [selectedFunctionsView replaceSortAnimation:animationModel.startIndex endIndex:animationModel.endIndex];
}
@end
