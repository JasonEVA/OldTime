//
//  HMFriendsPayQRCodeViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/10/17.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMFriendsPayQRCodeViewController.h"
#import "ServiceOrder.h"
#import "OrderInfo.h"

@interface HMFriendsPayQRCodeViewController ()
@property (nonatomic, strong) ServiceOrder *orderModel;
@property (nonatomic, copy) NSString *name;
@end

@implementation HMFriendsPayQRCodeViewController

- (instancetype)initWithOrderModel:(ServiceOrder *)model name:(NSString *)name
{
    self = [super init];
    if (self) {
        self.orderModel = model;
        self.name = name;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    }
    return self;
}

- (instancetype)initWithOrderInfoModel:(OrderInfo *)model name:(NSString *)name
{
    self = [super init];
    if (self) {
        self.orderModel = [ServiceOrder new];
        self.orderModel.orderMoney = model.orderMoney;
        self.orderModel.orderName = model.orderName;
        self.orderModel.orderId = model.orderId;
        self.orderModel.jumpUrl = model.jumpUrl;
        
        self.name = name;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configElements];
    // Do any additional setup after loading the view.
}
#pragma mark -private method
- (void)configElements {
    UIView *backView = [UIView new];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [backView.layer setCornerRadius:4];
    [backView setClipsToBounds:YES];
    
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(35);
        make.right.equalTo(self.view).offset(-35);
        make.center.equalTo(self.view);
        make.height.equalTo(@400);
    }];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dissmissClick) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-10);
        make.top.equalTo(backView).offset(10);
    }];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qy_logo"]];
    [self.view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(backView.mas_top);
    }];
    
    UILabel *bottomLb = [UILabel new];
    [bottomLb setText:@"请在30分钟内完成付款，订单在30分钟后失效，您需重新下单。"];
    [bottomLb setTextAlignment:NSTextAlignmentCenter];
    [bottomLb setTextColor:[UIColor whiteColor]];
    [bottomLb setFont:[UIFont systemFontOfSize:15]];
    [bottomLb setNumberOfLines:0];
    
    [self.view addSubview:bottomLb];
    [bottomLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(backView.mas_bottom).offset(15);
        make.left.equalTo(backView).offset(34);
        make.right.equalTo(backView).offset(-34);
    }];
    
    UILabel *nameLb = [UILabel new];
    [nameLb setText:[NSString stringWithFormat:@"姓名：%@",self.name]];
    [nameLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    [nameLb setFont:[UIFont systemFontOfSize:15]];
    
    [backView addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(55);
        make.left.equalTo(backView).offset(23);
        make.right.lessThanOrEqualTo(backView).offset(-23);
    }];
    
    UILabel *serviceLb = [UILabel new];
    [serviceLb setText:[NSString stringWithFormat:@"服务：%@",self.orderModel.orderName]];
    [serviceLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    [serviceLb setFont:[UIFont systemFontOfSize:15]];
    
    [backView addSubview:serviceLb];
    [serviceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLb.mas_bottom).offset(5);
        make.left.equalTo(backView).offset(23);
        make.right.lessThanOrEqualTo(backView).offset(-23);
    }];
    
    UILabel *moneryLb = [UILabel new];
    [moneryLb setText:[NSString stringWithFormat:@"金额：¥%.2f",self.orderModel.orderMoney]];
    [moneryLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    [moneryLb setFont:[UIFont systemFontOfSize:15]];
    
    [backView addSubview:moneryLb];
    [moneryLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serviceLb.mas_bottom).offset(5);
        make.left.equalTo(backView).offset(23);
        make.right.lessThanOrEqualTo(backView).offset(-23);
    }];
    
    UIImageView *QRImageView = [[UIImageView alloc] initWithImage:[self acquireQRImageWithUrl:[NSString stringWithFormat:@"%@?orderId=%ld&souceCode=iOS",self.orderModel.jumpUrl,self.orderModel.orderId]]];
    
    [backView addSubview:QRImageView];
    [QRImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneryLb.mas_bottom).offset(25);
        make.centerX.equalTo(backView);
        make.width.height.equalTo(@190);
    }];
    
    UILabel *jietuLb = [UILabel new];
    [jietuLb setText:@"截图分享或扫一扫付款"];
    [jietuLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    [jietuLb setFont:[UIFont systemFontOfSize:15]];
    
    [backView addSubview:jietuLb];
    [jietuLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(QRImageView.mas_bottom).offset(15);
        make.centerX.equalTo(backView);
    }];
}

- (UIImage *)acquireQRImageWithUrl:(NSString *)url {
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSString *string = url;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    
    // 4. 显示二维码
    return [self createNonInterpolatedUIImageFormCIImage:image withSize:190];
    
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - event Response
- (void)dissmissClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI
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
