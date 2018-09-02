//
//  PicturePerviewViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/26.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PicturePerviewViewController.h"

@interface PicturePerviewViewController ()
<UIScrollViewDelegate>
{
    UIControl* closeview;
    UIImageView* ivImage;
    UIScrollView* scrollview;
}

@property (nonatomic, retain) NSString* thumbPath;
@property (nonatomic, retain) NSString* imagePath;
@end

@implementation PicturePerviewViewController

- (id) initWithThumbPath:(NSString*) thumbPath
               ImagePath:(NSString*) imagePath
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        [self setThumbPath:thumbPath];
        [self setImagePath:imagePath];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    scrollview = [[UIScrollView alloc]init];
    [scrollview setDelegate:self];
    [self.view addSubview:scrollview];
    
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showThumbImage)];
    
    [scrollview addGestureRecognizer:tapGesture];
//    closeview = [[UIControl alloc]init];
//    [closeview setBackgroundColor:[UIColor redColor]];
//    [scrollview addSubview:closeview];
//    [closeview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(scrollview);
//        make.top.and.bottom.equalTo(scrollview);
//    }];
//    [closeview addTarget:self action:@selector(showThumbImage) forControlEvents:UIControlEventTouchUpInside];
    ivImage = [[UIImageView alloc]initWithFrame:_thumbframe];
    [scrollview addSubview:ivImage];
    
    UIImage* imgThumb = [UIImage imageWithContentsOfFile:_thumbPath];
    if (imgThumb)
    {
        [ivImage setImage:imgThumb];
    }
    else
    {
        [ivImage sd_setImageWithURL:[NSURL URLWithString:_imagePath] placeholderImage:[UIImage imageNamed:@"img_default"]];
    }
    //[ivImage setImage:imgThumb];
    
    [self performSelector:@selector(showImage) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) showImage
{
    UIImage* image = [UIImage imageWithContentsOfFile:_imagePath];
    CGSize imageSize = image.size;
    CGFloat imageHeihgt = imageSize.height * (self.view.width / imageSize.width);
    imageSize.height = imageHeihgt;
    imageSize.width = self.view.width;
    NSTimeInterval animationDuration = 0.30f;
//    [UIView setAnimationDelegate:self];
    [UIView beginAnimations:@"ShowResizeImageView" context:nil];
    //[UIView setAnimationDuration:animationDuration];
    
    [ivImage setImage:image];
    float insetHeight = 0;
    CGRect rtImage = CGRectMake(0, 0, imageSize.width, imageSize.height);
    if (imageSize.height < scrollview.height)
    {
        //rtImage.origin.y = (scrollview.height - imageSize.height)/2;
        insetHeight = (scrollview.height - imageSize.height)/2;
        //[scrollview setContentSize:scrollview.size];
    }
    else
    {
        
        [scrollview setContentSize:imageSize];
    }
    [ivImage setFrame:rtImage];
    
    //[UIView commitAnimations];
    [UIView animateWithDuration:animationDuration animations:^{
        
    } completion:^(BOOL finished) {
        


        [scrollview setBackgroundColor:[UIColor blackColor]];
        
    }];
    
    //设置最大伸缩比例
    scrollview.maximumZoomScale=2.5;
    //设置最小伸缩比例
    scrollview.minimumZoomScale=1;
    //[ivImage setCenter:(scrollview.center)];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(insetHeight, 0, insetHeight, 0);
    //UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0);
    [scrollview setContentInset:edge];
}

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return ivImage;
}

- (void) showThumbImage
{
    UIImage* image = [UIImage imageWithContentsOfFile:_thumbPath];
    
    NSTimeInterval animationDuration = 0.30f;
    //    [UIView setAnimationDelegate:self];
    [UIView beginAnimations:@"ShowResizeThumbView" context:nil];
    [ivImage setImage:image];
    
    [ivImage setFrame:_thumbframe];
    [UIView animateWithDuration:animationDuration animations:^{
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
    }];

}

@end
