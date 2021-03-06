//
//  Utils.h
//  FairFare
//
//  Created by dhaneshs on 3/31/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#ifndef FairFare_Utils_h
#define FairFare_Utils_h

#define kLocationUpdated @"kLocationUpdated"
#define kHeadingUpdated @"kHeadingUpdated"


UIViewController* viewControllerFromStoryboard(NSString* storyBoardName,NSString* controllerId);
id dataFromPlistFile(NSString* fileName);
NSUInteger indexOfItemFor(NSArray* array,NSString* matchingKey,NSString* matchingText);
NSArray* safeArray(NSArray* array);
NSDictionary* safeDictionary(NSDictionary* dict);
BOOL isArraySafe(NSArray* array);
BOOL isDictionarySafe(NSDictionary* dict);
BOOL isDateBetweenDates(NSDate* date,NSDate* beginDate,NSDate* endDate);
int minutesSinceMidnight(NSDate* date);
NSString* formatCurrency(float amount);
NSString* formatDistance(double distance);
NSString* formatTime(double timeInMinutes);
NSString* distanceUnit();//will return Mi or Km
NSComparisonResult compareStringDates(NSString* dateStr1,NSString* dateStr2);
NSString* getCurrentDetailedDateAndTime();
NSString* getCurrentDateAndTime();
#endif
