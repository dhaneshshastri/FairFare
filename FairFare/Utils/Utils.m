//
//  Utils.m
//  FairFare
//
//  Created by dhaneshs on 4/1/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


UIViewController* viewControllerFromStoryboard(NSString* storyBoardName,NSString* controllerId)
{
    // Get the storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoardName
                                                         bundle:nil];
    //Get the controller from the storyboard.
    UIViewController *controller = (UIViewController *)
    [storyboard instantiateViewControllerWithIdentifier:controllerId];
    
    
    return controller;
}

id dataFromPlistFile(NSString* fileName)
{
    if(!fileName)
        return nil;
    
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:[fileName stringByDeletingPathExtension]  withExtension:[fileName pathExtension]];
    id fileData = [NSArray arrayWithContentsOfURL:url];
    if(fileData)
    {
        return fileData;
    }
    else
    {
        //May the URL is Qualified (full path)
        fileData = [NSArray arrayWithContentsOfFile:fileName];
        
        if(fileData)
        {
            return fileData;
        }
        else
        {
            //May be dict
            fileData = [NSDictionary dictionaryWithContentsOfURL:url];
            if(fileData)
            {
                return fileData;
            }
            else
            {
                url = [NSURL URLWithString:fileName];
                fileData = [NSDictionary dictionaryWithContentsOfURL:url];
                if(fileData)
                    return fileData;
                else
                    return nil;
            }
        }
        return fileName;
    }
}
NSUInteger indexOfItemFor(NSArray* array,NSString* matchingKey,NSString* matchingText)
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", matchingKey, matchingText];
    
    NSUInteger index = [array  indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        return [predicate evaluateWithObject:obj];
    }];
    return index;
}
NSArray* safeArray(NSArray* array)
{
    return (array.count ? array : nil);
}
NSDictionary* safeDictionary(NSDictionary* dict)
{
    return (dict.count ? dict : nil);
}
BOOL isArraySafe(NSArray* array)
{
    return array && [array count] > 0;
}
BOOL isDictionarySafe(NSDictionary* dict)
{
    return dict && [dict count] > 0;
}
BOOL isDateBetweenDates(NSDate* date,NSDate* beginDate,NSDate* endDate)
{
    int startTime   = minutesSinceMidnight(beginDate);
    int endTime  = minutesSinceMidnight(endDate);
    int nowTime     = minutesSinceMidnight(date);
    
    return startTime <= nowTime && nowTime <= endTime;
}
int minutesSinceMidnight(NSDate* date)
{
    NSCalendar* calender = [NSCalendar currentCalendar];
    [calender setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDateComponents *components = [calender components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    return 60 * (int)[components hour] + (int)[components minute];
}
NSString* formatCurrency(float amount)
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:amount]];
    return numberAsString;
}
NSString* formatDistance(double distance)
{
    //Update the distance metre
    MKDistanceFormatter *df = [[MKDistanceFormatter alloc] init];
    df.unitStyle = MKDistanceFormatterUnitStyleDefault;
    return [df stringFromDistance: distance];
}
NSString* distanceUnit()//will return Mi or Km
{
    NSString* formattedString = formatDistance(1000);
    return safeArray([formattedString componentsSeparatedByString:@" "])[1];
}
NSComparisonResult compareStringDates(NSString* dateStr1,NSString* dateStr2)
{
    if(!dateStr1 || [dateStr1 length] == 0)
    {
        dateStr1 = @"2000-01-01 00:00:00";
    }
    if(!dateStr2  || [dateStr2 length] == 0)
    {
        dateStr2 = @"2000-01-01 00:00:00";
    }
    //Date object
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date1 = [dateFormatter dateFromString:dateStr1];
    NSDate* date2 = [dateFormatter dateFromString:dateStr2];
    //    logToConsole([date1 string]);
    //   logToConsole([date2 string]);
    return [date1 compare:date2];
}
NSString* getCurrentDetailedDateAndTime()
{
    NSDate *now = [NSDate date];
    
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone *destTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMToffset = [sourceTimeZone secondsFromGMTForDate:now];
    NSInteger destGMToffset = [destTimeZone secondsFromGMTForDate:now];
    
    NSTimeInterval interval = destGMToffset - sourceGMToffset;
    
    NSDate *destDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:now];
    // logToConsole([destDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"]);
    return [destDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
}
NSString* getCurrentDateAndTime()
{
    NSDate *now = [NSDate date];
    
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone *destTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMToffset = [sourceTimeZone secondsFromGMTForDate:now];
    NSInteger destGMToffset = [destTimeZone secondsFromGMTForDate:now];
    
    NSTimeInterval interval = destGMToffset - sourceGMToffset;
    
    NSDate *destDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:now];
    // logToConsole([destDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"]);
    return [destDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
}