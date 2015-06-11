//
//  AppDelegate.m
//  FairFare
//
//  Created by dhaneshs on 3/26/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TestFairy.h"

@interface AppDelegate ()
{
    UIView* _splashView;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [TestFairy begin:@"a63c9055361701b3ccaf2d5d8873db62c4fc5bfa"];
    [GMSServices provideAPIKey:@"AIzaSyCG3BKzz4y1FoeNyDHV_Wysg21ueglRnLw"];
    // Override point for customization after application launch.
    NSLog(@"didFinishLaunchingWithOptions");
    
    self.shareModel = [LocationShareModel sharedModel];
    self.shareModel.afterResume = NO;
    
    UIAlertView * alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else{
        
        // When there is a significant changes of the location,
        // The key UIApplicationLaunchOptionsLocationKey will be returned from didFinishLaunchingWithOptions
        // When the app is receiving the key, it must reinitiate the locationManager and get
        // the latest location updates
        
        // This UIApplicationLaunchOptionsLocationKey key enables the location update even when
        // the app has been killed/terminated (Not in th background) by iOS or the user.
        
        if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
            NSLog(@"UIApplicationLaunchOptionsLocationKey");
            
            // This "afterResume" flag is just to show that he receiving location updates
            // are actually from the key "UIApplicationLaunchOptionsLocationKey"
            self.shareModel.afterResume = YES;
            
            [[self shareModel] initiateWithDelegate:self];
            self.shareModel.anotherLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            self.shareModel.anotherLocationManager.activityType = CLActivityTypeAutomotiveNavigation;
            
            if(IS_OS_8_OR_LATER) {
                [self.shareModel.anotherLocationManager requestAlwaysAuthorization];
            }
            
            [self.shareModel.anotherLocationManager startMonitoringSignificantLocationChanges];
        }
    }
    [DataBaseManager dataBaseManager];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    
    //Disable lock
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    //Splash Image
    {
        _splashView = [[UIView alloc] init];
        [_splashView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.window addSubview:_splashView];
        [[LayoutManager layoutManager] fillView:_splashView
                                         inView:self.window];
        {
            UIImageView *_backgroundImageView = [[UIImageView alloc] init];
            [_backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_backgroundImageView setBackgroundColor:[UIColor redColor]];
            [_splashView addSubview:_backgroundImageView];
            [[LayoutManager layoutManager] fillView:_backgroundImageView
                                             inView:_splashView];
            [_backgroundImageView setImage:[UIImage imageNamed:@"Default.png"]];
            
            //Add Center Logo
            UIImageView* logoImageView = [[UIImageView alloc] init];
            UIImage* image = [UIImage imageNamed:@"logo.png"];
            [logoImageView setImage:image];
            [logoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_splashView addSubview:logoImageView];
            
            logoImageView.alpha = 0.4;
            
            [[LayoutManager layoutManager] setSize:CGSizeMake(image.size.width / 2,
                                                              image.size.height / 2)
                                            ofView:logoImageView
                                            inView:_splashView];
            //_splashView.alpha = 0.0;
            
            [logoImageView setContentMode:UIViewContentModeRedraw];

            [[LayoutManager layoutManager] alignView:logoImageView
                                           toRefView:_splashView
                                          withOffset:CGPointZero
                                              inView:_splashView
                                 withAlignmentOption:NSLayoutAttributeCenterX
                               andRefAlignmentOption:NSLayoutAttributeCenterX];
            
            [[LayoutManager layoutManager] alignView:logoImageView
                                           toRefView:_splashView
                                          withOffset:CGPointZero
                                              inView:_splashView
                                 withAlignmentOption:NSLayoutAttributeCenterY
                               andRefAlignmentOption:NSLayoutAttributeCenterY];
            
            [UIView animateWithDuration:1.0
                                  delay:0.0
                                options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                             animations:^{
                                 
                                 logoImageView.alpha = 1.0;
                                 
                             }completion:nil];
        }
        [self performSelector:@selector(hideSplash)
                   withObject:nil
                   afterDelay:4.0];
    }
    return YES;
}

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations{
    
    
    if(!locations || [locations count] == 0)
        return;
    
    //Notify to other parts of the application that location is updated
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationUpdated
                                                        object:locations];
    
    
    
}
- (void)hideSplash
{
    if([_splashView isDescendantOfView:self.window])
    {
        [_splashView removeFromSuperview];
        _splashView = nil;
        //Remove and add the Storyboard
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"navigationController"];
        
        
        [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
        
        vc.view.alpha = 0.3;
        
        [UIView animateWithDuration:1.0
                         animations:^{
                            
                             vc.view.alpha = 1.0;
                             
                         }];
    }
}
- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(NSError *)error
{
    NSLog(@"%@",[error description]);
//    
//    manager.deferringUpdates
}
- (void) locationManager:(CLLocationManager *)manager
        didUpdateHeading:(CLHeading *)newHeading
{
    //Notify to other parts of the application that location is updated
    [[NSNotificationCenter defaultCenter] postNotificationName:kHeadingUpdated
                                                        object:newHeading];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error description]);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    [self.shareModel.anotherLocationManager stopMonitoringSignificantLocationChanges];
    
    if(IS_OS_8_OR_LATER) {
        [self.shareModel.anotherLocationManager requestAlwaysAuthorization];
    }
    [self.shareModel.anotherLocationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    
    //Remove the "afterResume" Flag after the app is active again.
    self.shareModel.afterResume = NO;
    
    
    [[self shareModel] initiateWithDelegate:self];
    self.shareModel.anotherLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.shareModel.anotherLocationManager.activityType = CLActivityTypeOtherNavigation;
    
    if(IS_OS_8_OR_LATER) {
        [self.shareModel.anotherLocationManager requestAlwaysAuthorization];
    }
    [self.shareModel.anotherLocationManager startMonitoringSignificantLocationChanges];
}

-(void)applicationWillTerminate:(UIApplication *)application{
    NSLog(@"applicationWillTerminate");
}

@end
