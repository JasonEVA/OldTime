//
//  HealthDiscoveryViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthDiscoveryViewController.h"
#import "HealthDiscoveryCollectionViewController.h"
@interface HealthDiscoveryViewController ()
{
    HealthDiscoveryCollectionViewController* cvcDiscovery;
}
@end

@implementation HealthDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"健康中心"];
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
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!cvcDiscovery)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        cvcDiscovery = [[HealthDiscoveryCollectionViewController alloc]initWithCollectionViewLayout:layout];
        [self addChildViewController:cvcDiscovery];
        [cvcDiscovery.collectionView setFrame:self.view.bounds];
        [self.view addSubview:cvcDiscovery.collectionView];
    }
}
@end
