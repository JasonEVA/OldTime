//
//  BodyWeightDetectViewController.m
//  HMClient
//
//  Created by lkl on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyWeightDetectViewController.h"
#import "BodyWeightDetectDeviceViewController.h"
#import "PersonBodyHeightEditViewController.h"

@interface BodyWeightDetectViewController ()
{
    DeviceDetectContentViewController *vcInputContent;
    PersonBodyHeightEditViewController *bodyHeightVC;
}
@end

@implementation BodyWeightDetectViewController

- (void) dealloc
{
    if (vcInputContent)
    {
        [vcInputContent removeObserver:self forKeyPath:@"detectResult"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UserInfo *user = [[UserInfoHelper defaultHelper] currentUserInfo];

    if (user.userHeight && user.userHeight > 0) {
        //有身高数据，进入测量体重页面
        vcInputContent = [[BodyWeightDetectDeviceViewController alloc] init];
        [vcInputContent.view setFrame:self.view.bounds];
        [self addChildViewController:vcInputContent];
        [self.view addSubview:vcInputContent.view];
        [vcInputContent addObserver:self forKeyPath:@"detectResult" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    else{
        //没有身高数据，直接进入身高界面添加
        bodyHeightVC = [[PersonBodyHeightEditViewController alloc] init];
        [bodyHeightVC.view setFrame:self.view.bounds];
        [self addChildViewController:bodyHeightVC];
        [self.view addSubview:bodyHeightVC.view];
    }
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"detectResult"])
    {
        NSDictionary* dicPost = [object valueForKey:keyPath];
        if (dicPost) {
            [self postDetectResult:dicPost];
        }
        
    }
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
