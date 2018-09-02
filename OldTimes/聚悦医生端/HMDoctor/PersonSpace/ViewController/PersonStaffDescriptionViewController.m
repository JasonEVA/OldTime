//
//  PersonStaffDescriptionViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/7/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "PersonStaffDescriptionViewController.h"
#import "PersonStaffDescriptionUpdateViewController.h"



@interface PersonStaffDescriptionViewController ()

@property (nonatomic, readonly) PersonStaffDescStyle descStyle;
@property (nonatomic, readonly) PersonStaffDescriptionUpdateViewController* updateViewController;
@end

@implementation PersonStaffDescriptionViewController
@synthesize updateViewController = _updateViewController;
//- (id) initWithControllerId:(NSString*) aControllerId
//{
//    self = [super initWithControllerId:aControllerId];
//    if (self) {
//        
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.paramObject && [self.paramObject isKindOfClass:[NSNumber class]])
    {
        NSNumber* styleNumber = (NSNumber*) self.paramObject;
        _descStyle = styleNumber.integerValue;
    }
    
    switch (self.descStyle) {
        case PersonStaff_GoodAt:
        {
            self.navigationItem.title = @"擅长";
            break;
        }
        case PersonStaff_Summary:
        {
            self.navigationItem.title = @"简介";
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.updateViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (PersonStaffDescriptionUpdateViewController*) updateViewController
{
    if (!_updateViewController) {
        Class controllerClass;
        switch (self.descStyle) {
            case PersonStaff_GoodAt:
            {
                controllerClass = NSClassFromString(@"PersonStaffDescriptionGoodAtUpdateViewController");
                break;
            }
            case PersonStaff_Summary:
            {
                controllerClass = NSClassFromString(@"PersonStaffDescriptionSummaryUpdateViewController");
                break;
            }
            default:
                break;
        }
        _updateViewController = [[controllerClass alloc] init];
        [self addChildViewController:_updateViewController];
        [self.view addSubview:_updateViewController.view];
        
    }
    return _updateViewController;
}

@end
