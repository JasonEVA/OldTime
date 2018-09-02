//
//  HMBasePageViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"

@interface HMBasePageViewController ()<UIGestureRecognizerDelegate>

@end

@implementation HMBasePageViewController

- (id) initWithControllerId:(NSString*) aControllerId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        [self setControllerId:aControllerId];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor commonBackgroundColor];
    
    //滑动返回
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSString *className = NSStringFromClass([self class]);
    ATLog(@"内存警告!!! VC = %@",className);
}

- (NSString*) controllerId
{
    if (!_controllerId) {
        NSString* classname = NSStringFromClass([self class]);
        NSMutableDictionary* controllerIdDictionary = [NSMutableDictionary dictionary];
        [controllerIdDictionary setValue:classname forKey:@"controllerName"];
        
        NSDictionary* controllerParamDictionary = [self controllerParamDictionary];
        if (controllerParamDictionary) {
            [controllerIdDictionary setValue:controllerParamDictionary forKey:@"controllParam"];
        }
        _controllerId = [controllerIdDictionary mj_JSONString];
    }
    
    return _controllerId;
}

- (NSDictionary*) controllerParamDictionary
{
    return nil;
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
