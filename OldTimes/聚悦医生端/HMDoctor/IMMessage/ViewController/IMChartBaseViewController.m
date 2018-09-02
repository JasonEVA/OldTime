//
//  IMChartBaseViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "IMChartBaseViewController.h"
//#import "IMMessageBaseTableViewController.m"

@interface IMChartBaseViewController ()

@end

@implementation IMChartBaseViewController

- (id)initWithDetailModel:(ContactDetailModel *)detailModel
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        contactDetail = detailModel;
        //[self createMessageListTable];
        [self.navigationItem setTitle:contactDetail._target];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createIMInputView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) messageTableControllerName
{
    return  @"IMMessageBaseTableViewController";
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [chatview setHeight:self.view.height];
}

- (void) createIMInputView
{
    if (messageInputView)
    {
        return;
    }
    
    chatview = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:chatview];
    
    messageInputView = [[IMTextMessageInputView alloc]init];
    [chatview addSubview:messageInputView];
    
    [self subviewsLayout];
}

- (void) subviewsLayout
{
//    [chatview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view);
//        make.top.equalTo(self.view);
//        //make.size.equalTo(self.view);
//        make.width.equalTo(self.view);
//        make.height.lessThanOrEqualTo(self.view);
//    }];
    
    
    [messageInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(chatview);
        make.height.greaterThanOrEqualTo(@49);
        make.bottom.equalTo(chatview.mas_bottom);
    }];
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
