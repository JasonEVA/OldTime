//
//  NewCalendarMapWithAddressTableViewCell.m
//  launcher
//
//  Created by 马晓波 on 16/3/9.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarMapWithAddressTableViewCell.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Masonry/Masonry.h>
#import "PlaceModel.h"
#import "Category.h"
#import "MyDefine.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <Masonry/Masonry.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@interface NewCalendarMapWithAddressTableViewCell()<BMKMapViewDelegate>

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *detailLabel;

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) GMSMarker  *marker;
@property (nonatomic, strong) UIImageView *locationImageView;

@property (nonatomic, strong) PlaceModel *placeModel;

@property (nonatomic, strong) BMKMapView *baiduMapView;
@property (nonatomic, strong) BMKPointAnnotation *lastPoint;

@end

static CGFloat const mapHeight  = 150;
static CGFloat const margeLabel = 100;
static NSString *const killMapDelegateNotification = @"killMapDelegate";

@implementation NewCalendarMapWithAddressTableViewCell
+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

+ (CGFloat)height {
    return 190;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
//        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.locationImageView];
        
        
//        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.titleLabel.mas_right).offset(8);
//            make.right.lessThanOrEqualTo(self.locationImageView.mas_left).offset(-8);
//            make.centerY.equalTo(self.titleLabel);
//            make.left.equalTo(self.contentView).offset(margeLabel).priorityLow();
//        }];
        
        [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.titleLabel);
        }];
        
        if (isUseGoogel) {//使用谷歌地图
            [self.contentView addSubview:self.mapView];
            [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.left.equalTo(self.contentView);
                make.height.equalTo(@(mapHeight));
            }];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(13);
                make.top.equalTo(self.mapView.mas_bottom).offset(10);
            }];
            
            
        } else {  //使用百度地图
            [self.contentView addSubview:self.baiduMapView];
            [self.baiduMapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.left.equalTo(self.contentView);
                make.height.equalTo(@(mapHeight));
            }];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(13);
                make.top.equalTo(self.baiduMapView.mas_bottom).offset(10);
                make.right.lessThanOrEqualTo(self.locationImageView.mas_left).offset(-10);
            }];
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(killMapDelegate) name:killMapDelegateNotification object:nil];
        }
    }
    return self;
}

#pragma mark - Interface Method
- (void)mapWithPlaceModel:(PlaceModel *)placeModel {
    [self.titleLabel setText:placeModel.name];
//    [self.detailLabel setText:placeModel.fullAddress];
    if (isUseGoogel) {
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:placeModel.coordinate.latitude longitude:placeModel.coordinate.longitude zoom:15];
        [self.mapView setCamera:camera];
        
        if (self.marker) {
            [self.marker setMap:nil];
            self.marker = nil;
        }
        
        // 标记
        self.marker = [GMSMarker markerWithPosition:placeModel.coordinate];
        self.marker.map = self.mapView;
    } else {
        [self.baiduMapView removeAnnotation:self.lastPoint];
        [self.baiduMapView setCenterCoordinate:placeModel.coordinate animated:YES];
        BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
        [point setCoordinate:placeModel.coordinate];
        [point setTitle:placeModel.name];
        self.lastPoint = point;
        [self.baiduMapView addAnnotation:point];
    }
    
}

- (void)setAccessoryDisclosureIndicator {
    
    UIImage *image = [UIImage imageNamed:@"disclosureIndicator"];
    self.locationImageView.image = image;
}

// 此处记得不用的时候需要置nil，否则影响内存的释放
- (void)killMapDelegate
{
    self.baiduMapView.delegate = nil;
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    BMKPinAnnotationView* newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    return newAnnotationView;
}
#pragma mark - Initializer

- (BMKMapView *)baiduMapView
{
    if (!_baiduMapView) {
        _baiduMapView = [[BMKMapView alloc] init];
        [_baiduMapView setDelegate:self];
        [_baiduMapView setZoomLevel:15];
        [_baiduMapView setScrollEnabled:YES];
    }
    return _baiduMapView;
}
- (GMSMapView *)mapView {
    if (!_mapView) {
        _mapView = [[GMSMapView alloc] init];
        _mapView.myLocationEnabled = YES;
        //        _mapView.settings.scrollGestures = NO;
        //        _mapView.settings.zoomGestures = no;
    }
    return _mapView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel           = [UILabel new];
        _titleLabel.font      = [UIFont mtc_font_30];
        _titleLabel.textColor = [UIColor mtc_colorWithHex:0x666666];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel           = [UILabel new];
        _detailLabel.font      = [UIFont mtc_font_26];
        _detailLabel.textColor = [UIColor minorFontColor];
    }
    return _detailLabel;
}

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        UIImage *image = [UIImage imageNamed:@"Calendar_Location_Logo"];
        _locationImageView = [[UIImageView alloc] initWithImage:image];
        [_locationImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _locationImageView;
}

@end
