//
//  ASPhotoAlbumsViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//  相册VC

#import <UIKit/UIKit.h>

@class WZPhotoPickerController;

@interface ASPhotoAlbumsViewController : UITableViewController

@property (nonatomic, strong) WZPhotoPickerController *pickerController;

@end
