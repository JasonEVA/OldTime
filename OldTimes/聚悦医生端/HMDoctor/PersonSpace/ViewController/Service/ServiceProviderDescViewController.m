//
//  ServiceProviderDescViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//


#import "ServiceProviderDescViewController.h"

@interface ServiceProviderDescView : UIView
{
    UILabel* lbTitle;
    UITextView* tvDesc;
}

- (id) initWithProviderDesc:(NSString*) desc;
@end

@implementation ServiceProviderDescView

- (id) initWithProviderDesc:(NSString*) desc
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        lbTitle = [[UILabel alloc]init];
        [lbTitle setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lbTitle];
        [lbTitle setText:@"团队介绍"];
        [lbTitle setTextColor:[UIColor commonTextColor]];
        [lbTitle setFont:[UIFont systemFontOfSize:14]];
        [lbTitle showBottomLine];
        
        [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self);
            make.height.mas_equalTo(@40);
        }];
        
        tvDesc = [[UITextView alloc]init];
        [tvDesc setEditable:NO];
        [tvDesc setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:tvDesc];
        [tvDesc setTextColor:[UIColor commonGrayTextColor]];
        [tvDesc setFont:[UIFont systemFontOfSize:14]];
        [tvDesc setText:desc];
        [tvDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(lbTitle.mas_bottom);
            
            make.bottom.equalTo(self);
        }];
        
        
    }
    
    [self performSelector:@selector(resetSize) withObject:nil afterDelay:0.05];
    return self;
}

- (void) resetSize
{
    NSLog(@"tv %f ,%f", tvDesc.width, tvDesc.contentSize.height);
    [tvDesc mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([NSNumber numberWithFloat:tvDesc.contentSize.height + 16]);
    }];
}

@end


@interface ServiceProviderDescViewController ()
{
    NSString* desc;
    UIControl* closecontrol;
    ServiceProviderDescView* vDesc;
}

- (id) initWithProviderDesc:(NSString*) aDesc;
@end

@implementation ServiceProviderDescViewController

- (id) initWithProviderDesc:(NSString*) aDesc
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        desc = aDesc;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    closecontrol = [[UIControl alloc]init];
    [self.view addSubview:closecontrol];
    [closecontrol setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    [closecontrol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    [closecontrol addTarget:self action:@selector(closecontrolClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    vDesc = [[ServiceProviderDescView alloc]initWithProviderDesc:desc];
    [closecontrol addSubview:vDesc];
    [vDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(closecontrol).with.offset(-15);
        make.left.equalTo(closecontrol).with.offset(15);
        make.centerY.equalTo(closecontrol);
        make.height.lessThanOrEqualTo(closecontrol).with.offset(-72);
    }];
}

- (void) closecontrolClicked:(id) sender
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

+ (void) showInParentViewController:(UIViewController*) parentController
                       ProviderDesc:(NSString*) desc
{
    if (!parentController)
    {
        return;
    }
    ServiceProviderDescViewController* vcDesc = [[ServiceProviderDescViewController alloc]initWithProviderDesc:desc];
    [parentController addChildViewController:vcDesc];
    [parentController.view addSubview:vcDesc.view];
    
    [vcDesc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(parentController.view);
        make.bottom.and.top.equalTo(parentController.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
