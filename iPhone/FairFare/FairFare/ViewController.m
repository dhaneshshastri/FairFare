//
//  ViewController.m
//  FairFare
//
//  Created by dhaneshs on 3/26/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <LiveFrost/LiveFrost.h>
#import "HistoryViewController.h"
#import "M13Checkbox.h"
#import "FareCalculatorViewController.h"


@interface ViewController ()
{
    GMSMapView* _mapView;
    UIView* _controlsView;
    UIButton* _closeButton;
    BOOL _reachedDestinationChecked;
    CLLocation* _currentLocation;
    GMSMutablePath* _travelPath;
    BOOL _reverseGeocodeStartLocation;
}
@property (nonatomic,readonly,strong) LFGlassView* glassView;
@end

@implementation ViewController
@synthesize glassView = _glassView;
- (void)viewDidLoad {
    [super viewDidLoad];
    //Register Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationUpdatedNotification:)
                                                 name:kLocationUpdated
                                               object:nil];
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0
                                                            longitude:0.0
                                                                 zoom:18
                                                              bearing:30
                                                         viewingAngle:30];
    
    
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0,
                                                   0,
                                                   self.view.frame.size.width,
                                                   self.view.frame.size.height)
                                 camera:camera];
    [_mapView setCamera:camera];
    _mapView.mapType = kGMSTypeNormal;
    _mapView.delegate = self;
    GMSUISettings * settings = _mapView.settings;
    [settings setConsumesGesturesInView:NO];
    
    [self.view addSubview:_mapView];
    [self.view insertSubview:_mapView atIndex:0];
    
    [self createAndAddControlsView];
}
- (void)removeControlsView
{
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_controlsView setAlpha:0.0];
                        [_glassView setAlpha:0.0];
                    }
                    completion:^(BOOL finished){
                        //Remove the _controlsView
                        if(_controlsView)
                        {
                            [_controlsView removeFromSuperview];
                            _controlsView = nil;
                        }
                        //Also remove blurr view
                        if(_glassView)
                        {
                            [_glassView removeFromSuperview];
                            _glassView = nil;
                        }
                    }];
    
    
}
- (void)createAndAddControlsView
{
    if(_glassView)
    {
        [_glassView removeFromSuperview];
        _glassView = nil;
    }
    if(_controlsView)
    {
        [_controlsView removeFromSuperview];
        _controlsView = nil;
    }
    [self.view addSubview:self.glassView];
    _controlsView = [[UIView alloc] init];
    [_controlsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_controlsView];
    [[LayoutManager layoutManager] fillView:_controlsView
                                     inView:self.view];
    [_controlsView setBackgroundColor:[UIColor clearColor]];
    
    //Adding controls
    //Add the Buttons
    {
        UIButton* startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [startButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_controlsView addSubview:startButton];
        
        [startButton setTitle:@"Start Journey"
                     forState:UIControlStateNormal];
        
        [startButton addTarget:self
                        action:@selector(startJourney:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [[LayoutManager layoutManager] setWidth:100.0
                                         ofView:startButton
                                         inView:_controlsView
                                    andRelation:NSLayoutRelationEqual];
        
        [[LayoutManager layoutManager] setHeight:100.0
                                          ofView:startButton
                                          inView:_controlsView
                                     andRelation:NSLayoutRelationEqual];
        
        [[LayoutManager layoutManager] alignView:startButton
                                       toRefView:_controlsView
                                      withOffset:CGPointZero
                                          inView:_controlsView
                             withAlignmentOption:NSLayoutAttributeCenterX
                           andRefAlignmentOption:NSLayoutAttributeCenterX];
        
        [[LayoutManager layoutManager] alignView:startButton
                                       toRefView:_controlsView
                                      withOffset:CGPointMake(-50, 0)
                                          inView:_controlsView
                             withAlignmentOption:NSLayoutAttributeCenterY
                           andRefAlignmentOption:NSLayoutAttributeCenterY];
        
        /////
        UIButton* historyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [historyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_controlsView addSubview:historyButton];
        [historyButton addTarget:self
                          action:@selector(showHistory:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [historyButton setTitle:@"History"
                       forState:UIControlStateNormal];
        
        [[LayoutManager layoutManager] setWidth:100.0
                                         ofView:historyButton
                                         inView:_controlsView
                                    andRelation:NSLayoutRelationEqual];
        
        [[LayoutManager layoutManager] setHeight:100.0
                                          ofView:historyButton
                                          inView:_controlsView
                                     andRelation:NSLayoutRelationEqual];
        
        [[LayoutManager layoutManager] alignView:historyButton
                                       toRefView:_controlsView
                                      withOffset:CGPointZero
                                          inView:_controlsView
                             withAlignmentOption:NSLayoutAttributeCenterX
                           andRefAlignmentOption:NSLayoutAttributeCenterX];
        
        [[LayoutManager layoutManager] alignView:historyButton
                                       toRefView:_controlsView
                                      withOffset:CGPointMake(50, 0)
                                          inView:_controlsView
                             withAlignmentOption:NSLayoutAttributeCenterY
                           andRefAlignmentOption:NSLayoutAttributeCenterY];
    }
}
- (void)stopJourney
{
    if(_closeButton)
    {
        [_closeButton removeFromSuperview];
        _closeButton = nil;
    }
    _travelPath = nil;
    [_mapView clear];
    [[LocationShareModel sharedModel] stopUpdatingLocation];
}
- (void)createOnTravelControls
{
    if(_closeButton)
    {
        [_closeButton removeFromSuperview];
        _closeButton = nil;
    }
    _closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_closeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_mapView addSubview:_closeButton];
    [_closeButton addTarget:self
                     action:@selector(stopJourney:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [_closeButton setTitle:@"X"
                  forState:UIControlStateNormal];
    
    [_closeButton setBackgroundColor:[UIColor colorWithRed:1.0
                                                     green:1.0
                                                      blue:1.0
                                                     alpha:0.5]];
    
    [_closeButton setContentCompressionResistancePriority:500
                                                  forAxis:UILayoutConstraintAxisHorizontal];
    
    
    [_closeButton.layer setCornerRadius:15.0];
    
    [[LayoutManager layoutManager] alignView:_closeButton
                                   toRefView:_mapView
                                  withOffset:CGPointZero
                                      inView:_mapView
                         withAlignmentOption:NSLayoutAttributeRight
                       andRefAlignmentOption:NSLayoutAttributeRight];
    
    [[LayoutManager layoutManager] alignView:_closeButton
                                   toRefView:_mapView
                                  withOffset:CGPointMake(65, 0)
                                      inView:_mapView
                         withAlignmentOption:NSLayoutAttributeTop
                       andRefAlignmentOption:NSLayoutAttributeTop];
    
    
}

- (LFGlassView *) glassView {
    if (!_glassView) {
        _glassView = [[LFGlassView alloc] initWithFrame:self.view.bounds];
        _glassView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        _glassView.center = (CGPoint){
            0.5f * CGRectGetWidth(self.view.bounds),
            0.5f * CGRectGetHeight(self.view.bounds)
        };
        _glassView.layer.cornerRadius = 4.0;
    }
    return _glassView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma Location
- (void)locationUpdatedNotification:(NSNotification*)notification
{
    id locations = notification.object;
    CLLocation* newLocation = [locations lastObject];
    CLLocationCoordinate2D theLocation = newLocation.coordinate;
    
    
    [_mapView animateToLocation:theLocation];
    [_mapView animateToZoom:15];

    _currentLocation = nil;
    _currentLocation = newLocation;
    
    [self updatePathWithCoordinate:theLocation];
    
    if(_reverseGeocodeStartLocation)//First one
    {
        GMSGeocoder* geocoder = [GMSGeocoder geocoder];
        
        [geocoder reverseGeocodeCoordinate:theLocation
                         completionHandler:^(GMSReverseGeocodeResponse *geocodeResponse, NSError *erroe){
                         //    NSArray* results = geocodeResponse.results;
                             GMSAddress* firstResult = geocodeResponse.firstResult;

                             // Creates a marker in the center of the map.
                             GMSMarker *marker = [[GMSMarker alloc] init];
                             marker.position = firstResult.coordinate;
                             marker.title = firstResult.thoroughfare;
                             marker.snippet = firstResult.subLocality;
                             marker.map = _mapView;
                         }];
        _reverseGeocodeStartLocation = NO;
    }
}
#pragma Actions
- (void)showHistory:(UIButton*)sender
{
    HistoryViewController* historyVC = (HistoryViewController*)viewControllerFromStoryboard(@"Main",@"historyViewController");
    [self.navigationController pushViewController:historyVC
                                         animated:YES];
}
- (void)startJourney:(UIButton*)sender
{
    _reverseGeocodeStartLocation = YES;
    _currentLocation = nil;
    [self removeControlsView];
    //start updating the location
    [[LocationShareModel sharedModel] startUpdatingLocation];
    [self createOnTravelControls];
}
- (void)stopJourney:(UIButton*)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"Are you sure you want to stop the journey ?"
                                                  delegate:self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes", nil];

    {
        UIView* view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setFrame:CGRectMake(0, 0, 0, 40.0)];
        {
            //Add checkbox
            M13Checkbox *checkBox = [[M13Checkbox alloc] initWithTitle:@"Reached Destination?"];
            checkBox.checkAlignment = M13CheckboxAlignmentLeft;
            [checkBox addTarget:self action:@selector(reachedDestSelected:) forControlEvents:UIControlEventValueChanged];
            [checkBox setBackgroundColor:[UIColor clearColor]];
            
            [view addSubview:checkBox];
            
            //Layout
            {
                [checkBox setTranslatesAutoresizingMaskIntoConstraints:NO];
                
                [[LayoutManager layoutManager] setWidthOfView:checkBox
                                                   sameAsView:view
                                                       inView:view
                                                   multiplier:0.68
                                                  andRelation:NSLayoutRelationEqual];
                
                [[LayoutManager layoutManager] setHeightOfView:checkBox
                                                   sameAsView:view
                                                       inView:view
                                                   multiplier:1.0
                                                  andRelation:NSLayoutRelationEqual];
                
                [[LayoutManager layoutManager] positionSubview:checkBox
                                                        toView:view
                                                    withOffset:CGPointZero
                                             andPositionOption:POS_CENTER];
                
                [checkBox.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
            }
        }
        [alert setValue:view forKey:@"accessoryView"];
    }
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            
        case 1:
        {
            //Stop
            [[LocationShareModel sharedModel] stopUpdatingLocation];
            //Remove the close button
            [self stopJourney];
            //Recreate
            [self createAndAddControlsView];
            //If reached destination, then use the journey data collected and use to calculate the terrif
            if(_reachedDestinationChecked)
            {
                //Take to FareCalculator screen
                FareCalculatorViewController* fareCalculatorVC = (FareCalculatorViewController*)viewControllerFromStoryboard(@"Main",@"fareCalculatorController");
                [self.navigationController pushViewController:fareCalculatorVC
                                                     animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)reachedDestSelected:(M13Checkbox*)sender
{
    _reachedDestinationChecked = sender.checkState == M13CheckboxStateChecked;
}
#pragma mark Polyline
- (void)updatePathWithCoordinate:(CLLocationCoordinate2D)location
{
    if(!_travelPath)
    {
        _travelPath = [GMSMutablePath path];
    }
    [_travelPath addCoordinate:location];
    //Updating polygon
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:_travelPath];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    polyline.geodesic = YES;
    polyline.map = _mapView;
    polyline = nil;
    
    NSLog(@"Plotting >>>>>> ");
}

@end
