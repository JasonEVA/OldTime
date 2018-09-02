//
//  GooglePlaceFinderDAL.m
//  launcher
//
//  Created by William Zhang on 15/8/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "GooglePlaceFinderDAL.h"
#import <AFNetworking/AFNetworking.h>
#import "UnifiedUserInfoManager.h"
#import "PlaceModel.h"
#import <objc/runtime.h>

//static NSString * const google_api_key = @"AIzaSyCP6xJg1vWDl8YnjB2sZbUAvS_bJQhW8aQ";
static NSString * const google_api_key = @"AIzaSyD8nLRiQR6HFQhz6soUDko8GLKgHJevTxE";
static double radius = 50000;   //  50000米最大

@interface NSURLSessionTask (identifier)

@property (nonatomic, assign) BOOL isCancel;

@end

@interface GooglePlaceFinderDAL ()

@property (nonatomic, strong) NSURLSessionDataTask *task;

@property (nonatomic, getter=isGettingMore) BOOL getMore;

@property (nonatomic, strong) NSMutableDictionary *patameter;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *nextPageToken;

@end

@implementation GooglePlaceFinderDAL

#pragma mark - Interface Method
- (void)findPlacesNamed:(NSString *)placeName near:(CLLocationCoordinate2D)center {
    self.getMore = NO;
    // 搜索地址
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?location=%lf,%lf",center.latitude, center.longitude];
    self.urlString = urlString;
    
    NSDictionary *parameter = @{@"radius":@(radius),
                                @"query":placeName,
                                @"key":google_api_key,
                                @"language":[[UnifiedUserInfoManager share] getLocaleIdentifier].localeIdentifier};
    
    self.patameter = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [self startFindPlaceWithParameter:self.patameter];
}

- (void)findMore {
    self.getMore = YES;
    if ([self.nextPageToken length]) {
        [self.patameter setObject:self.nextPageToken forKey:@"pagetoken"];
    }
    [self startFindPlaceWithParameter:self.patameter];
}

#pragma mark - Private Method
- (void)startFindPlaceWithParameter:(NSDictionary *)parameter {
    AFHTTPSessionManager *AFManager = [AFHTTPSessionManager manager];
    AFManager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    if (self.task) {
        self.task.isCancel = YES;
        [self.task cancel];
    }
    
    self.task = [AFManager GET:self.urlString parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (task.isCancel) {
            return;
        }
        
        [self requestFinished:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (task.isCancel) {
            return;
        }
        
        [self requestFailed:error];
    }];
}

#pragma mark - Network
- (void)requestFinished:(id)responseObj {
    if (self.delegate && [self.delegate respondsToSelector:@selector(GooglePlaceFinderDALDelegateCallBack_FindPlaces:remain:)]) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSString *status = [responseObj valueForKey:@"status"];
            if ([status isEqualToString:@"OK"]) {
                // 成功，搭建数组
                NSArray *foundLoactions = [responseObj objectForKey:@"results"];
                NSMutableArray *results = [NSMutableArray array];
                
                for (NSDictionary *placeResult in foundLoactions) {
                    double lat = [[placeResult valueForKeyPath:@"geometry.location.lat"] doubleValue];
                    double lng = [[placeResult valueForKeyPath:@"geometry.location.lng"] doubleValue];
                    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
                    
                    PlaceModel *foundPlace = [[PlaceModel alloc] initWithCoordinate:coord];
                    [foundPlace setName:[placeResult valueForKey:@"name"]];
                    [foundPlace setFullAddress:[placeResult valueForKey:@"formatted_address"]];
                    [foundPlace setGoogleId:[placeResult valueForKey:@"id"]];
                    [foundPlace setGoogleIconPath:[placeResult valueForKey:@"icon"]];
                    [foundPlace setGoogleRef:[placeResult valueForKey:@"reference"]];
                    [foundPlace setRating:[[placeResult valueForKey:@"rating"] doubleValue]];
                    [foundPlace setTypes:[placeResult objectForKey:@"types"]];

                    [results addObject:foundPlace];
                }
                
                NSString *pagetoken = [responseObj valueForKey:@"next_page_token"];
                BOOL remain = NO;
                if (pagetoken && [pagetoken length]) {
                    remain = YES;
                    self.nextPageToken = pagetoken;
                } else {
                    self.nextPageToken = @"";
                }
                
                if (self.isGettingMore && [self.delegate respondsToSelector:@selector(GooglePlaceFinderDALDelegateCallBack_FindMorePlaces:remain:)])
                {
                    [self.delegate GooglePlaceFinderDALDelegateCallBack_FindMorePlaces:results remain:remain];
                } else
                {
                    [self.delegate GooglePlaceFinderDALDelegateCallBack_FindPlaces:results remain:remain];
                }
            }
            
            NSError *error = nil;
            if([status isEqualToString:@"ZERO_RESULTS"])
            {
                error = [NSError errorWithDomain:@"MJPlacesFinderError" code:1 userInfo:nil];
            }
            else if([status isEqualToString:@"OVER_QUERY_LIMIT"])
            {
                error = [NSError errorWithDomain:@"MJPlacesFinderError" code:2 userInfo:nil];
            }
            else if([status isEqualToString:@"REQUEST_DENIED"])
            {
                error = [NSError errorWithDomain:@"MJPlacesFinderError" code:3 userInfo:nil];
            }
            else if([status isEqualToString:@"INVALID_REQUEST"])
            {
                error = [NSError errorWithDomain:@"MJPlacesFinderError" code:4 userInfo:nil];
            }
            
            if ([self.delegate respondsToSelector:@selector(GooglePlaceFinderDALDelegateCallBack_FailWithError:)]) {
                [self.delegate GooglePlaceFinderDALDelegateCallBack_FailWithError:error];
            }
        }
    }
    
}

- (void)requestFailed:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    if ([self.delegate respondsToSelector:@selector(GooglePlaceFinderDALDelegateCallBack_FailWithError:)]) {
        [self.delegate GooglePlaceFinderDALDelegateCallBack_FailWithError:error];
    }
}

@end

@implementation NSURLSessionTask (identifier)

- (BOOL)isCancel {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsCancel:(BOOL)isCancel {
    objc_setAssociatedObject(self, @selector(isCancel), @(isCancel), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
