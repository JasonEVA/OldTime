//
//  ImageCutViewController.m
//  PictureDemo
//
//  Created by yinqaun on 16/4/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ImageCutViewController.h"

@interface ImageCutViewController ()
<UIScrollViewDelegate>
{
    UIScrollView* scrollview;
    UIImageView* ivImage;
    
    
}
@end

@implementation ImageCutViewController

- (id) initWithImage:(UIImage*) image
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!scrollview)
    {
        scrollview = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:scrollview];
        
        ivImage = [[UIImageView alloc]initWithFrame:scrollview.bounds];
        [scrollview addSubview:ivImage];
        [scrollview setDelegate:self];
        if (ivImage)
        {
            [ivImage setImage:_image];
        }
        
        UIView* upview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrollview.width, (self.view.height - scrollview.width)/2)];
        [self.view addSubview:upview];
        [upview setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.25]];
        
        UIView* topLine = [[UIView alloc]initWithFrame:CGRectMake(0, upview.height - 1, scrollview.width, 1)];
        [upview addSubview:topLine];
        [topLine setBackgroundColor:[UIColor whiteColor]];
        
        
        UIView* downview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrollview.width, (self.view.height - scrollview.width)/2)];
        [self.view addSubview:downview];
        [downview setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.24]];
        [downview setBottom:self.view.height];
        
        UIView* bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrollview.width, 1)];
        [downview addSubview:bottomLine];
        [bottomLine setBackgroundColor:[UIColor whiteColor]];
        
        
        [self imageInitSize];
        
        UIView* bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 64, scrollview.width, 64)];
        [self.view addSubview:bottomview];
        [bottomview setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
        
        //确定按钮
        UIButton* confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:confirmButton];
        [bottomview addSubview:confirmButton];
        [confirmButton setFrame:CGRectMake(scrollview.width - 15 - 56, 15, 56, 34)];
        [confirmButton setTitle:@"选取" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [confirmButton addTarget:self action:@selector(confirmbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //取消按钮
        UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:cancelButton];
        [bottomview addSubview:cancelButton];
        [cancelButton setFrame:CGRectMake(15, 15, 56, 34)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [cancelButton addTarget:self action:@selector(cancelbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) setImage:(UIImage *)image
{
    _image = image;
    if (ivImage)
    {
        [ivImage setImage:_image];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return ivImage;
}

- (void) imageInitSize
{
    if (!_image)
    {
        return;
    }
    CGSize imageSize = _image.size;
    if (0 == imageSize.height || 0 == imageSize.width) {
        return;
    }
    
    CGSize size = CGSizeMake(scrollview.width, scrollview.width);
    float insetHeight = (scrollview.height - scrollview.width)/2;
    if (imageSize.width > imageSize.height)
    {
        CGFloat width = scrollview.width * imageSize.width / imageSize.height ;
        size.width = width;
        [ivImage setHeight:scrollview.width];
        [ivImage setWidth:width];
        
        if (width > scrollview.width)
        {
            [scrollview setContentSize:(CGSizeMake(width, scrollview.width))];
            
        }
        [scrollview setContentOffset:CGPointMake((width - scrollview.width)/2, -insetHeight)];
    }
    else
    {
        CGFloat height = scrollview.width * imageSize.height/imageSize.width ;
        size.height = height;
        [ivImage setWidth:scrollview.width];
        [ivImage setHeight:height];
        [scrollview setContentSize:CGSizeMake(scrollview.width, height)];
        
        [scrollview setContentOffset:CGPointMake(0, -insetHeight + (height - scrollview.width)/2)];
    }
    
    //设置最大伸缩比例
    scrollview.maximumZoomScale=2.5;
    //设置最小伸缩比例
    scrollview.minimumZoomScale=1;
    //[ivImage setCenter:(scrollview.center)];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(insetHeight, 0, insetHeight, 0);

    [scrollview setContentInset:edge];
}

- (void) cancelbuttonClicked:(id) sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void) confirmbuttonClicked:(id) sender
{
    CGPoint ptOffset = scrollview.contentOffset;
    float insetHeight = (scrollview.height - scrollview.width)/2;
    ptOffset.y += insetHeight;
    
//    NSString* sOffset = NSStringFromCGPoint(ptOffset);
//    NSLog(@"confirmbuttonClicked %@", sOffset);
    
    CGSize cutSize = CGSizeMake(scrollview.width * ivImage.image.size.width/ (ivImage.size.width * scrollview.zoomScale),
                                scrollview.width * ivImage.image.size.width/ (ivImage.size.width * scrollview.zoomScale));
    CGRect rtCut = CGRectMake(ptOffset.x * ivImage.image.size.width/ (ivImage.size.width * scrollview.zoomScale), ptOffset.y * ivImage.image.size.width/ (ivImage.size.width * scrollview.zoomScale), cutSize.width, cutSize.height);
                                                                      
    UIImage* cutImage = [ivImage.image getSubImage:rtCut];
    if (0 < _scaleInPex && 1 > (_scaleInPex/ cutImage.size.width))
    {
        cutImage = [cutImage scaleImageToScale:(_scaleInPex/ cutImage.size.width)];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(imageCutViewController:imageCutAndScaled:)])
    {
        [_delegate imageCutViewController:self imageCutAndScaled:cutImage];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
