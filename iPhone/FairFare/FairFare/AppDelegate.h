//
//  AppDelegate.h
//  FairFare
//
//  Created by dhaneshs on 3/26/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationShareModel.h"




@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) LocationShareModel * shareModel;

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

@end

