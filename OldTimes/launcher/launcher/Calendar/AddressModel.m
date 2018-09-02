//
//  AddressModel.m
//  launcher
//
//  Created by William Zhang on 15/8/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)c {
    self = [super init];
    if (self) {
        self.coordinate = c;
    }
    return self;
}

/*
 *	Finds an address component of a specific type inside the given address components array
 */
+ (NSString *)addressComponent:(NSString *)component inAddressArray:(NSArray *)array ofType:(NSString *)type {
    NSUInteger index = [array indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop){
        return [(NSString *)([[obj objectForKey:@"types"] objectAtIndex:0]) isEqualToString:component];
    }];
    
    if(index == NSNotFound) return nil;
    
    return [[array objectAtIndex:index] valueForKey:type];
}

+ (instancetype)nullPlace {
    return [[self alloc] initWithCoordinate:CLLocationCoordinate2DMake(MAXLAT, MAXLAT)];
}


@end
