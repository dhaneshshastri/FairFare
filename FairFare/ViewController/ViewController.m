//
//  ViewController.m
//  FairFare
//
//  Created by dhaneshs on 3/26/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LiveFrost.h"
#import "HistoryViewController.h"
#import "M13Checkbox.h"
#import "FareCalculatorViewController.h"
#import <MapKit/MapKit.h>


@interface ViewController ()
{
    GMSMapView* _mapView;
    UIView* _controlsView;
    UIButton* _closeButton;
    BOOL _reachedDestinationChecked;
    CLLocation* _currentLocation;
    CLLocation* _previousLocation;
    GMSMutablePath* _travelPath;
    BOOL _reverseGeocodeStartLocation;
    BOOL _isNavigating;
    GMSMarker* _navigationMarker;
    UILabel* _travelledDistanceLabel;
    CLLocationDistance _travelledDistance;
    BOOL _journeyStarted;
    GMSAddress* _startAddress;
    GMSAddress* _destinationAddress;
    CLLocation* _startLocation;
    CLLocation* _endLocation;
    NSString* _activeJourneyId;
    UIImageView* _backgroundImageView;
    NSLayoutConstraint* _controlsBackViewWidthConstraint;
}
@property (nonatomic,readonly,strong) LFGlassView* glassView;
@end

@implementation ViewController
@synthesize glassView = _glassView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}
- (void)removeControlsView
{
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_controlsView setAlpha:0.0];
                        [_glassView setAlpha:0.0];
                        [_backgroundImageView setAlpha:0.0];
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
                        [_backgroundImageView removeFromSuperview];
                        _backgroundImageView = nil;
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
    if(_backgroundImageView)
    {
        [_backgroundImageView removeFromSuperview];
        _backgroundImageView = nil;
    }
    //Add background Image view
    {
        
        _backgroundImageView = [[UIImageView alloc] init];
        [_backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_backgroundImageView setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:_backgroundImageView];
        [[LayoutManager layoutManager] fillView:_backgroundImageView
                                         inView:self.view];
        [_backgroundImageView setImage:[UIImage imageNamed:@"Default.png"]];
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
        UIButton* startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [startButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_controlsView addSubview:startButton];
        
        [startButton setImage:[UIImage imageNamed:@"startjourney.png"]
                     forState:UIControlStateNormal];
        
        [startButton addTarget:self
                        action:@selector(startJourney:)
              forControlEvents:UIControlEventTouchUpInside];
        
        [[LayoutManager layoutManager] setWidth:389.0 / 2.0
                                         ofView:startButton
                                         inView:_controlsView
                                    andRelation:NSLayoutRelationEqual];
        
        [[LayoutManager layoutManager] setHeight:88.0 / 2.0
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
        UIButton* historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [historyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_controlsView addSubview:historyButton];
        [historyButton addTarget:self
                          action:@selector(showHistory:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [historyButton setTitle:@"History"
                       forState:UIControlStateNormal];
        
        [historyButton setImage:[UIImage imageNamed:@"history.png"]
                     forState:UIControlStateNormal];
        
        [[LayoutManager layoutManager] setWidth:389.0 / 2.0
                                         ofView:historyButton
                                         inView:_controlsView
                                    andRelation:NSLayoutRelationEqual];
        
        [[LayoutManager layoutManager] setHeight:88.0 / 2.0
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
    //Record
    _endLocation = nil;
    _endLocation = _currentLocation;
    if(_closeButton)
    {
        [_closeButton removeFromSuperview];
        _closeButton = nil;
    }
    _travelPath = nil;
    [_mapView clear];
    [[LocationShareModel sharedModel] stopUpdatingLocation];
    _isNavigating = NO;
    _journeyStarted = NO;
    
    if(!_activeJourneyId || _travelledDistance == 0)
        return;
    //Now Update the created journey object
    __block Journey* journey = [[AppDataBaseManager appDataBaseManager] fetchedResultsFor:@"Journey"
                                                                          sortKey:nil
                                                                  andSearchformat:@"selfId == %@",_activeJourneyId][0];
    
    if(!journey)
    {
        return;
    }
    journey.travelledDistance = _travelledDistance;
    //If source address
    if(_startAddress)
    {
        Address* address = [[AppDataBaseManager appDataBaseManager] createAddressEntryWith:@{@"lat":@(_startLocation.coordinate.latitude),
                                                                                             @"lon":
                                                                                                 @(_startLocation.coordinate.longitude),@"isSource":@(YES),@"journeyId":journey.selfId,@"address":[NSDictionary dictionaryWithPropertiesOfObject:_startAddress]}];
        journey.startLocationId = address.selfId;
        
        [[AppDataBaseManager appDataBaseManager] saveContext:nil];
    }
    else
    {
        //Update
        GMSGeocoder* geocoder = [GMSGeocoder geocoder];
        [geocoder reverseGeocodeCoordinate:_startLocation.coordinate
                         completionHandler:^(GMSReverseGeocodeResponse *geocodeResponse, NSError *erroe){
                             
                             _startAddress = nil;
                             if(!_activeJourneyId)
                                 return ;
                             _startAddress = geocodeResponse.firstResult;

                             Journey* journey = [[AppDataBaseManager appDataBaseManager] fetchedResultsFor:@"Journey"
                                                                                                   sortKey:nil
                                                                                           andSearchformat:@"selfId == %@",_activeJourneyId][0];
                             
                             Address* address = [[AppDataBaseManager appDataBaseManager] createAddressEntryWith:@{@"lat":@(_startLocation.coordinate.latitude),
                                                                                                                  @"lon":
                                                                                                                      @(_startLocation.coordinate.longitude),@"isSource":@(YES),@"journeyId":journey.selfId,@"address":[NSDictionary dictionaryWithPropertiesOfObject:_startAddress]}];
                             journey.startLocationId = address.selfId;
                             
                             [[AppDataBaseManager appDataBaseManager] saveContext:nil];
                         }];
    }
    //If dest address
    if(_destinationAddress)
    {
        Address* address = [[AppDataBaseManager appDataBaseManager] createAddressEntryWith:@{@"lat":@(_endLocation.coordinate.latitude),
                                                                                             @"lon":
                                                                                                 @(_endLocation.coordinate.longitude),@"isDestination":@(YES),@"journeyId":journey.selfId,@"address":[NSDictionary dictionaryWithPropertiesOfObject:_destinationAddress]}];
        journey.startLocationId = address.selfId;
     
        [[AppDataBaseManager appDataBaseManager] saveContext:nil];
    }
    else
    {
        //Update
        GMSGeocoder* geocoder = [GMSGeocoder geocoder];
        [geocoder reverseGeocodeCoordinate:_endLocation.coordinate
                         completionHandler:^(GMSReverseGeocodeResponse *geocodeResponse, NSError *erroe){
                             
                             _destinationAddress = nil;
                             if(!_activeJourneyId)
                                 return ;
                             _destinationAddress = geocodeResponse.firstResult;
                             
                             
                             
                             Journey* journey = [[AppDataBaseManager appDataBaseManager] fetchedResultsFor:@"Journey"
                                                                                                   sortKey:nil
                                                                                           andSearchformat:@"selfId == %@",_activeJourneyId][0];
                             
                             NSDictionary* dict = @{@"lat":@(_endLocation.coordinate.latitude),
                                                    @"lon":
                                                        @(_endLocation.coordinate.longitude),@"isDestination":@(YES),@"journeyId":journey.selfId,@"address":[NSDictionary dictionaryWithPropertiesOfObject:_destinationAddress]};
                             
                             Address* address = [[AppDataBaseManager appDataBaseManager] createAddressEntryWith:dict];
                             journey.endLocationId = address.selfId;
                             
                             [[AppDataBaseManager appDataBaseManager] saveContext:nil];
                         }];
    }
}
- (void)showDistanceLabel
{
    if(!_controlsBackViewWidthConstraint)
        return;
    [_mapView removeConstraint:_controlsBackViewWidthConstraint];
    _controlsBackViewWidthConstraint = nil;
    UIView* view = [_mapView viewWithTag:3000];
    
    _travelledDistanceLabel.alpha = 0.0;
    
    [UIView animateWithDuration:1.0
                     animations:^{
    
                         _travelledDistanceLabel.alpha = 1.0;
                         
                         [[LayoutManager layoutManager] setWidthOfView:view
                                                            sameAsView:_mapView
                                                                inView:_mapView
                                                            multiplier:0.99
                                                           andRelation:NSLayoutRelationEqual];
                         [_mapView layoutIfNeeded];
                         
                     }];
    
}
- (void)createOnTravelControls
{
    UIView* view = [_mapView viewWithTag:3000];
    [view removeFromSuperview];
    //Master panel view
    view = [[UIView alloc] init];
    [view setTag:3000];
    {
        
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_mapView addSubview:view];
        [view.layer setCornerRadius:((43.0 / 1.5) + 4) / 2.0];
        [view setBackgroundColor:[UIColor colorWithRed:0.0 / 255.0
                                                 green:0.0 / 255.0
                                                  blue:0.0 / 255.0
                                                 alpha:0.8]];

        _controlsBackViewWidthConstraint = nil;
        _controlsBackViewWidthConstraint = [[LayoutManager layoutManager] setWidth:(43.0 / 1.5) + 4.0 //4 + 4 on both sides
                                                                            ofView:view
                                                                            inView:_mapView
                                                                       andRelation:NSLayoutRelationEqual];
        
        
        [[LayoutManager layoutManager] setHeight:(43.0 / 1.5) + 4
                                          ofView:view
                                          inView:_mapView
                                     andRelation:NSLayoutRelationEqual];
        
        [[LayoutManager layoutManager] alignView:view
                                       toRefView:_mapView
                                      withOffset:CGPointZero
                                          inView:_mapView
                             withAlignmentOption:NSLayoutAttributeCenterX
                           andRefAlignmentOption:NSLayoutAttributeCenterX];
        
        [[LayoutManager layoutManager] alignView:view
                                       toRefView:_mapView
                                      withOffset:CGPointMake(-2, 0)
                                          inView:_mapView
                             withAlignmentOption:NSLayoutAttributeBottom
                           andRefAlignmentOption:NSLayoutAttributeBottom];
        
        
    }
    if(_closeButton)
    {
        [_closeButton removeFromSuperview];
        _closeButton = nil;
    }
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:_closeButton];
    [_closeButton addTarget:self
                     action:@selector(stopJourney:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [_closeButton setImage:[UIImage imageNamed:@"stopbutton.png"]
                  forState:UIControlStateNormal];
    
    [[LayoutManager layoutManager] setSize:CGSizeMake(43.0 / 1.5, 43.0 / 1.5)
                                    ofView:_closeButton
                                    inView:view];
    
    [_closeButton setContentCompressionResistancePriority:500
                                                  forAxis:UILayoutConstraintAxisHorizontal];
    

    
    [[LayoutManager layoutManager] alignView:_closeButton
                                   toRefView:view
                                  withOffset:CGPointMake(-2, 0)
                                      inView:view
                         withAlignmentOption:NSLayoutAttributeRight
                       andRefAlignmentOption:NSLayoutAttributeRight];
    
    [[LayoutManager layoutManager] alignView:_closeButton
                                   toRefView:view
                                  withOffset:CGPointMake(0, 0)
                                      inView:view
                         withAlignmentOption:NSLayoutAttributeCenterY
                       andRefAlignmentOption:NSLayoutAttributeCenterY];
    
    //Add the distance travelled text
    [_travelledDistanceLabel removeFromSuperview];
    _travelledDistanceLabel = nil;
    _travelledDistanceLabel = [[UILabel alloc] init];
    [_travelledDistanceLabel setFont:[UIFont fontWithName:@"LetsgoDigital-Regular"
                                                     size:24.0]];
    
    [_travelledDistanceLabel.layer setCornerRadius:4.0];
    [_travelledDistanceLabel setClipsToBounds:YES];
    [_travelledDistanceLabel setTextColor:[UIColor colorWithRed:1.0
                                                          green:1.0
                                                           blue:1.0
                                                          alpha:0.7]];
    
    [_travelledDistanceLabel setHidden:YES];
    
    {
        [_travelledDistanceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [view addSubview:_travelledDistanceLabel];
        
        [[LayoutManager layoutManager] setHeight:24.0
                                          ofView:_travelledDistanceLabel
                                          inView:view
                                     andRelation:NSLayoutRelationEqual];
        
        [[LayoutManager layoutManager] setWidth:10.0
                                         ofView:_travelledDistanceLabel
                                         inView:view
                                    andRelation:NSLayoutRelationGreaterThanOrEqual];
        
        [[LayoutManager layoutManager] alignView:_travelledDistanceLabel
                                       toRefView:view
                                      withOffset:CGPointMake(0, 0)
                                          inView:view
                             withAlignmentOption:NSLayoutAttributeCenterY
                           andRefAlignmentOption:NSLayoutAttributeCenterY];
        
        [[LayoutManager layoutManager] alignView:_travelledDistanceLabel
                                       toRefView:view
                                      withOffset:CGPointMake(4.0, 0)
                                          inView:view
                             withAlignmentOption:NSLayoutAttributeLeft
                           andRefAlignmentOption:NSLayoutAttributeLeft];
    }
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
        _glassView.scaleFactor = 1.0;
    }
    return _glassView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Register Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationUpdatedNotification:)
                                                 name:kLocationUpdated
                                               object:nil];
    
    
    [self createAndAddControlsView];
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

#pragma Location Delegates
- (void)headingUpdatedNotification:(NSNotification*)notification
{
    CLHeading* heading = notification.object;
    [_mapView animateToBearing:heading.magneticHeading];
}
- (void)locationUpdatedNotification:(NSNotification*)notification
{
    id locations = notification.object;
    CLLocation* newLocation = [locations lastObject];
    CLLocationCoordinate2D theLocation = newLocation.coordinate;
    
    [_mapView animateToBearing:newLocation.course];
    
    [_mapView animateToLocation:theLocation];
    [_mapView animateToZoom:16];
    
    if(!_journeyStarted)
        return;
    
    if(_currentLocation)
    {
        _previousLocation = nil;
        _previousLocation = _currentLocation;
    }
    
    _currentLocation = newLocation;
    
    CLLocationDistance minThresholdDistance = [_previousLocation distanceFromLocation:_currentLocation];
    
    if(minThresholdDistance < 20.0 && !_isNavigating)
    {
        _isNavigating = NO;
    }
    else{
        NSLog(@"Threshold reached, Navigating %f",minThresholdDistance);
        _isNavigating = YES;
        [self showDistanceLabel];
    }
    if(_isNavigating)
    {
        
        //Append distance
        if(_previousLocation)
            _travelledDistance += [_previousLocation distanceFromLocation:_currentLocation];
        //Show the navigating icon
        // Creates a marker in the center of the map.
        _navigationMarker.map = nil;
        _navigationMarker = nil;
        _navigationMarker = [[GMSMarker alloc] init];
        _navigationMarker.icon = [UIImage imageNamed:@"NavigationArrow.png"];
        _navigationMarker.position = theLocation;
        _navigationMarker.zIndex = 1000;
        _navigationMarker.map = _mapView;
        _navigationMarker.groundAnchor = CGPointMake(0.5, 0.5);
        
        //Update the distance metre
        MKDistanceFormatter *df = [[MKDistanceFormatter alloc] init];
        df.unitStyle = MKDistanceFormatterUnitStyleDefault;
        
        [_travelledDistanceLabel setText:[df stringFromDistance: _travelledDistance]];
        [_travelledDistanceLabel setHidden:NO];
        
        [self updatePathWithCoordinate:theLocation];
    }
    if(_reverseGeocodeStartLocation)//First one
    {
        _startLocation = nil;
        _startLocation = _currentLocation;
        
        //Start Journey
        Journey* journey = [[AppDataBaseManager appDataBaseManager] createJourneyEntryWith:nil];
        _activeJourneyId = journey.selfId;
        
        
        GMSGeocoder* geocoder = [GMSGeocoder geocoder];
        [geocoder reverseGeocodeCoordinate:theLocation
                         completionHandler:^(GMSReverseGeocodeResponse *geocodeResponse, NSError *erroe){
                             
                             _startAddress = nil;
                             _startAddress = geocodeResponse.firstResult;
                             
                             // Creates a marker in the center of the map.
                             GMSMarker *marker = [[GMSMarker alloc] init];
                             marker.position = _startAddress.coordinate;
                             marker.title = _startAddress.thoroughfare;
                             marker.snippet = _startAddress.subLocality;
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
    _journeyStarted = YES;
    _reverseGeocodeStartLocation = YES;
    _currentLocation = nil;
    _travelledDistance = 0.0;
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
    
    if(_travelledDistance > 0)
    {
        UIView* view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setFrame:CGRectMake(0, 0, 0, 40.0)];
        if(_travelledDistance > 0)
        {
            //Add checkbox
            M13Checkbox *checkBox = [[M13Checkbox alloc] initWithTitle:@"Reached Destination?"];
            checkBox.checkAlignment = M13CheckboxAlignmentLeft;
            [checkBox addTarget:self action:@selector(reachedDestSelected:) forControlEvents:UIControlEventValueChanged];
            [checkBox setBackgroundColor:[UIColor clearColor]];
            
            [view addSubview:checkBox];
            checkBox.strokeColor = [UIColor colorWithRed:149.0 / 255.0
                                                   green:137.0 / 255.0
                                                    blue:95.0 / 255.0
                                                   alpha:1.0];
            
            checkBox.checkColor = [UIColor colorWithRed:149.0 / 255.0
                                                   green:137.0 / 255.0
                                                    blue:95.0 / 255.0
                                                   alpha:1.0];
            
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
            _reachedDestinationChecked = checkBox.checkState == M13CheckboxStateChecked;
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
                
                [fareCalculatorVC setData:@{@"addressOrLocation":_startAddress ? : (_currentLocation ? : [NSNull null]),
                                            @"travelledDistance":@(_travelledDistance),
                                            @"activeJourneyId":_activeJourneyId}];
                
                [self.navigationController pushViewController:fareCalculatorVC
                                                     animated:YES];
            }
            else
            {
                [[AppDataBaseManager appDataBaseManager] deleteJourneyWithId:_activeJourneyId];
                _activeJourneyId = nil;
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
    
    //Add the path to DB
    [[AppDataBaseManager appDataBaseManager] addLocationToJourneyWithId:_activeJourneyId
                                                                    lat:location.latitude
                                                                 andLon:location.longitude];
}
@end