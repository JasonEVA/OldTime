//
//  WZPhotoPickerController.m
//  WZPhotoPickerController
//
//  Created by williamzhang on 15/10/23.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "WZPhotoPickerController.h"
#import "HMBaseNavigationViewController.h"
#import "ASPhotoAlbumsViewController.h"

@interface WZPhotoPickerController ()

@end

@implementation WZPhotoPickerController

- (void)dealloc
{
    NSLog(@"-------------->PhotoPickerDealloc");
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.allowMutipleSelection = YES;
        self.maximumNumberOfSelection = 9;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAlbumsViewController];
}

- (void)setUpAlbumsViewController {
        
    ASPhotoAlbumsViewController *albumsViewController = [[ASPhotoAlbumsViewController alloc] init];
    albumsViewController.pickerController = self;
    HMBaseNavigationViewController *navigationController = [[HMBaseNavigationViewController alloc] initWithRootViewController:albumsViewController];
    
    [self addChildViewController:navigationController];

    navigationController.view.frame = self.view.bounds;
    [self.view addSubview:navigationController.view];
    
    [navigationController didMoveToParentViewController:self];
}

- (void)addPhotoPickerHandlerNoti:(ASPhotoPickerCompletionHandler)handler {
    self.photoPickerHandler = handler;
}

#pragma mark - Setter
- (void)setMaximumNumberOfSelection:(NSUInteger)maximumNumberOfSelection {
    _maximumNumberOfSelection = maximumNumberOfSelection;
    if (_maximumNumberOfSelection == 1) {
        self.allowMutipleSelection = NO;
    }
}

@end
