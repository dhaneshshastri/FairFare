//
//  LocationShareModel.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import "LocationShareModel.h"

@implementation LocationShareModel

//Class method to make sure the share model is synch across the app
+ (id)sharedModel
{
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    return sharedMyModel;
}
- (void)initiateWithDelegate:(id<CLLocationManagerDelegate>)delegate
{
    if(self.anotherLocationManager)
    {
        [self.anotherLocationManager stopMonitoringSignificantLocationChanges];
        [self.anotherLocationManager stopUpdatingLocation];
        self.anotherLocationManager = nil;
    }

    self.anotherLocationManager = [[CLLocationManager alloc]init];
    self.anotherLocationManager.delegate = delegate;
    
    
    self.anotherLocationManager.distanceFilter = kCLDistanceFilterNone;
}
- (void)restartLocationUpdate
{
    [self.anotherLocationManager stopUpdatingLocation];
    [self.anotherLocationManager startUpdatingLocation];
}
- (void)stopUpdatingLocation
{
    [self.anotherLocationManager stopUpdatingLocation];
}

@end
