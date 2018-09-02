//
//  PrescrbeStartDetailViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescrbeStartDetailViewController.h"
#import "PrescribeInfo.h"
#import "ClientHelper.h"

@interface PrescrbeStartDetailViewController ()<TaskObserver>
{
    NSMutableArray *prescribeDetailItem;
    NSString *userRecipeId;
    
    UIWebView* webview;
}
@end

@implementation PrescrbeStartDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"用药建议详情"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[PrescribeInfo class]])
    {
        PrescribeInfo *info = (PrescribeInfo *)self.paramObject;
        userRecipeId = info.userRecipeId;
        
    }
    
    webview = [[UIWebView alloc] init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    [webview scalesPageToFit];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/jkda/showRecipe.htm?vType=YS&userRecipeId=%@",kZJKHealthDataBaseUrl,userRecipeId];

    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
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
