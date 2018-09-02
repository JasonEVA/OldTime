//
//  SportsTypeSelectViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SportsTypeSelectViewController.h"


@interface SportsTypeSelectView : UIView
{
    UILabel* lbTitle;
    UIScrollView* scrollview;
   
    
}

@property (nonatomic, readonly) NSMutableArray* buttons;
- (id) initWithSportsTypes:(NSArray*) types;


@end

@implementation SportsTypeSelectView

- (id) initWithSportsTypes:(NSArray*) types
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.cornerRadius = 2.5;
        self.layer.masksToBounds = YES;
        
        lbTitle = [[UILabel alloc]init];
        [self addSubview:lbTitle];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [lbTitle setText:@"请选择运动方式"];
        [lbTitle setFont:[UIFont font_26]];
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self);
            make.height.mas_equalTo(@40);
        }];
        [lbTitle showBottomLine];
        
        scrollview = [[UIScrollView alloc]init];
        [self addSubview:scrollview];
        [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(lbTitle.mas_bottom);
            make.bottom.equalTo(self);
        }];
        
        [self createSportsTypeButtons:types];
        
        CGFloat selectHeight = 40;
        NSInteger rows = types.count / 3;
        if (0 < types.count % 3)
        {
            ++rows;
        }
        selectHeight += (rows * 35 + 15 * (rows + 1));
        
        [scrollview setContentSize:CGSizeMake(kScreenWidth - 25, selectHeight)];
    }
    return self;
}

- (void) createSportsTypeButtons:(NSArray*) sportsTypes
{
    MASViewAttribute* leftAttr = scrollview.mas_left;
    MASViewAttribute* topAttr = scrollview.mas_top;
    _buttons = [NSMutableArray array];
    CGFloat gapwidth = (kScreenWidth - 25 - 80 * 3)/4;
    
    for (NSInteger index = 0; index < sportsTypes.count; ++index)
    {
        RecommandSportsType* sportsType = sportsTypes[index];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [scrollview addSubview:button];
        
        [button setBackgroundImage:[UIImage rectImage:CGSizeMake(80, 35) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [button setTitle:sportsType.sportsName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 2.5;
        button.layer.masksToBounds = YES;
        [button.titleLabel setFont:[UIFont font_26]];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 35));
            make.left.equalTo(leftAttr).with.offset(gapwidth);
            make.top.equalTo(topAttr).with.offset(15);
        }];
        [_buttons addObject:button];
        if (2 == index % 3)
        {
            leftAttr = scrollview.mas_left;
            topAttr = button.mas_bottom;
        }
        else
        {
            leftAttr = button.mas_right;
        }
    }
}

@end

@interface SportsTypeSelectViewController ()
{
    NSArray* sportsTypes;
    SportsTypeSelectView* selectview;
}

@property (nonatomic, strong) SportsTypeSelectBlock selectblock;
@end

@implementation SportsTypeSelectViewController

- (id) initWithSportsTypes:(NSArray*) types
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        sportsTypes = types;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectview = [[SportsTypeSelectView alloc]initWithSportsTypes:sportsTypes];
    [self.view addSubview:selectview];
    CGFloat selectHeight = 40;
    NSInteger rows = sportsTypes.count / 3;
    if (0 < sportsTypes.count % 3)
    {
        ++rows;
    }
    selectHeight += (rows * 35 + 15 * (rows + 1));
    if (selectHeight > 366)
    {
        selectHeight = 366;
    }
    [selectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.center.equalTo(self.view);
        make.height.mas_equalTo([NSNumber numberWithFloat:selectHeight]);
    }];

    for (UIButton* button in selectview.buttons)
    {
        [button addTarget:self action:@selector(sportsTypeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}



- (void) loadView
{
    UIControl* closeControl = [[UIControl alloc]init];
    [self setView:closeControl];
    
    [closeControl setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    [closeControl addTarget:self action:@selector(closeController) forControlEvents:UIControlEventTouchUpInside];
}

- (void) closeController
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

+ (void) showInParentController:(UIViewController*) parentController
                    SportsTypes:(NSArray*) types
          SportsTypeSelectBlock:(SportsTypeSelectBlock)block
{
    if (!parentController)
    {
        return;
    }
    
    SportsTypeSelectViewController* vcSelected = [[SportsTypeSelectViewController alloc]initWithSportsTypes:types];
    [vcSelected setSelectblock:block];
    [parentController addChildViewController:vcSelected];
    [parentController.view addSubview:vcSelected.view];
    
    [vcSelected.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(parentController.view);
        make.top.and.bottom.equalTo(parentController.view);
    }];
}

- (void) sportsTypeButtonClicked:(id) sender
{
    NSInteger selIndex = [selectview.buttons indexOfObject:sender];
    if (NSNotFound == selIndex)
    {
        return;
    }
    
    RecommandSportsType* sportsType = sportsTypes[selIndex];
    if (_selectblock)
    {
        _selectblock(sportsType);
    }
    
    [self closeController];
}
@end
