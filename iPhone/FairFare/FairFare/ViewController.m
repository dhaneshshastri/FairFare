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


@interface ViewController ()
{
    GMSMapView* _mapView;
    UIView* _controlsView;
    UIButton* _closeButton;
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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:9];
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0,
                                                   0,
                                                   self.view.frame.size.width,
                                                   self.view.frame.size.height)
                                 camera:camera];
    [_mapView setCamera:camera];
    _mapView.myLocationEnabled = YES;
    _mapView.mapType = kGMSTypeSatellite;
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
    [self.view addSubview:self.glassView];
    if(_controlsView)
    {
        [_controlsView removeFromSuperview];
        _controlsView = nil;
    }
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
    id locationDict = notification.object;
    CLLocation* newLocation = locationDict[@"newLocation"];
    CLLocationCoordinate2D theLocation = newLocation.coordinate;
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = theLocation;
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = _mapView;
    
    [_mapView animateToLocation:theLocation];
    [_mapView animateToZoom:15];
    
    NSLog(@"Location updated: %@",newLocation);
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
    [self removeControlsView];
    //start updating the location
    [[LocationShareModel sharedModel] restartLocationUpdate];
    [self createOnTravelControls];
}
- (void)stopJourney:(UIButton*)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"Are you sure you want to stop the journey ?"
                                                  delegate:self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            
        case 1:
        {
            //stop
            [[LocationShareModel sharedModel] stopUpdatingLocation];
            //Remove the close button
            [self stopJourney];
        }
            break;
            
        default:
            break;
    }
}
@end
