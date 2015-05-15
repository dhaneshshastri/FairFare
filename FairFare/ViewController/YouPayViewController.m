//
//  YouPayViewController.m
//  FairFare
//
//  Created by dhaneshs on 4/17/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import "YouPayViewController.h"
#import "InfoViewController.h"

@interface YouPayViewController ()
{
    NSDictionary* _data;
    NSDictionary* _selectedDetailedFare;
    
    __weak IBOutlet UILabel *_cabTitleLabel;
    __weak IBOutlet UILabel *_minDistanceLabel;
    __weak IBOutlet UILabel *_afterMinDistanceLabel;
    __weak IBOutlet UILabel *_waitingLabel;
    __weak IBOutlet UILabel *_totalDistanceLabel;
    
    __weak IBOutlet UILabel *_minDistanceFareLabel;
    __weak IBOutlet UILabel *_afterMinDistanceFareLabel;
    __weak IBOutlet UILabel *_waitingFareLabel;
    __weak IBOutlet UILabel *_totalDistanceTravelledLabel;
    __weak IBOutlet UILabel *_totalAmount;
}
@end

@implementation YouPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setData:(NSDictionary*)data
{
    _data = nil;
    _data = data;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self calculateFare];
    [self initialize];
}
- (void)initialize
{
    //Set Cab type
    NSString* serviceId = _data[@"serviceId"];
    NSString* providerId = _data[@"providerId"];
    NSString* subCategoryId = _data[@"subCategoryId"];
    NSDictionary* subCategory = nil;
    NSNumber* minDistance = @([_selectedDetailedFare[@"minDistance"] floatValue] * 1000.0);//In meters
    NSNumber* minDistanceFare = @([_selectedDetailedFare[@"minDistanceFare"] integerValue]);
    NSNumber* distanceTravelled = @([_data[@"travelledDistance"] doubleValue]);
    NSNumber* extraDistance = @(([distanceTravelled doubleValue] - [minDistance doubleValue] >= 0) ? : 0);
    NSNumber* extraDistanceInKm = @([extraDistance unsignedLongValue] / 1000.0);
    NSNumber* afterMinDistanceFare = @([_selectedDetailedFare[@"afterMinDistanceCharges"] integerValue]);
    NSNumber* extraDistanceChargedAmount = @([extraDistanceInKm doubleValue] * [afterMinDistanceFare integerValue]);
    NSNumber* waitingTime = @([_data[@"waitingTime"] integerValue]);//Time in minutes
    NSNumber* minWaitingTime = @([_selectedDetailedFare[@"minFreeWaitTime"] integerValue]);
    NSNumber* waitingTimeFare = @([_selectedDetailedFare[@"afterFreeWaitTimeCharges"] integerValue]);//Per min
    NSNumber* waitingTimeCharged = @([waitingTimeFare integerValue] * [waitingTime integerValue]);
    NSNumber* totalAmount = @([waitingTimeCharged floatValue] + [extraDistanceChargedAmount floatValue] + [minDistanceFare floatValue]);
    
    if(serviceId)
    {
        if(!providerId && !subCategoryId)
        {
                //autoRickshaw
        }
        //Get the cab name
        subCategory = [[ContentManager sharedManager] subCategoryForServiceId:serviceId
                                                                   providerId:providerId
                                                             andSubCategoryId:subCategoryId];
    }
    //Title Label
    {
        [_cabTitleLabel setText:subCategory[@"name"]];
    }
    //Min distance label
    {
        [_minDistanceLabel setText:[NSString stringWithFormat:@"Min. Distance Fare (%@)",
                                    formatDistance([minDistance doubleValue])]];
        [_minDistanceFareLabel setText:formatCurrency([minDistanceFare floatValue])];
    }
    //After Min distance
    {
        [_afterMinDistanceLabel setText:
         [NSString stringWithFormat:@"Fare after min. distance (For %@ at %@ per %@)",
                                    formatDistance([extraDistance doubleValue]),formatCurrency([afterMinDistanceFare floatValue]),distanceUnit()]];
        [_afterMinDistanceFareLabel setText:formatCurrency([extraDistanceChargedAmount floatValue])];
    }
    //After Min distance
    {
        [_waitingLabel setText:[NSString stringWithFormat:@"Waiting charges (after %@ min) at %@ per min",
                                         [minWaitingTime stringValue],formatCurrency([waitingTimeFare integerValue])]];
        

        [_waitingFareLabel setText:formatCurrency([waitingTimeCharged floatValue])];
    }
    //Total
    {
        [_totalAmount setText:formatCurrency([totalAmount floatValue])];
    }
    //Set the active journey
    Journey* journey = [[AppDataBaseManager appDataBaseManager] journeyWithId:_data[@"activeJourneyId"]];
    journey.calculatedFare = [totalAmount doubleValue];
    [[AppDataBaseManager appDataBaseManager] saveContext:nil];
}
- (void)calculateFare
{
    if(!_data)
    {
        return;
    }
    NSString* serviceId = _data[@"serviceId"];
    NSString* providerId = _data[@"providerId"];
    NSString* subCategoryId = _data[@"subCategoryId"];
    if(!serviceId)
    {
        return;
    }
    //Get the Fares
    NSArray* fares = [[ContentManager sharedManager] faresForServiceId:serviceId
                                                            providerId:providerId
                                                      andSubCategoryId:subCategoryId];
    NSDictionary* selectedFare = fares[0];
    _selectedDetailedFare = [[ContentManager sharedManager] detailedFareForFareId:selectedFare[@"selfId"]];
    if(!_selectedDetailedFare)
    {
        [self performSelector:@selector(goBack)
                   withObject:nil
                   afterDelay:1.0];
    }
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)showInfo:(id)sender
{
    InfoViewController* infoVC = [[InfoViewController alloc] init];
    NSString* providerId = _data[@"providerId"];
    NSDictionary* service = [[ContentManager sharedManager] providerWithProviderId:providerId];
    [infoVC setUrl:service[@"url"]];
    [self.navigationController pushViewController:infoVC
                                         animated:YES];
}

@end
