//
//  id+utility.m
//  iSalesTool
//
//  Created by Vectorform 2 on 6/21/12.
//  Copyright (c) 2012 VF. All rights reserved.
//

#import "NSOBject+Utility.h"



extern UIInterfaceOrientation previousDeviceOrientation;
extern UIInterfaceOrientation currentDeviceOrientation;


@implementation NSObject (utility)
- (NSString*)stringFormat
{
    if([self isKindOfClass:[NSString class]])
    {
        if([(id)self isEqualToString:@"nan"])
        {
            return @"0.0";
        }
        return (NSString*)self;
    }
    if([self isKindOfClass:[NSNumber class]])
    {
        if(isnan([(id)self floatValue]))
        {
            return @"0.0";
        }
        return [(id)self stringValue];
    }
    if([self isKindOfClass:[NSDecimalNumber class]])
    {
        [(id)self stringValue];
    }
    return @"null";
}
- (CGFloat)floatFormat
{
    if([self isKindOfClass:[NSNumber class]])
    {
        if(isnan([(id)self floatValue]))
            return 0.0;
        
        return [(id)self floatValue];
    }
    return [(id)self floatValue];
}
- (void)performBlockInBackground:(dispatch_block_t)taskBlock
                      completion:(dispatch_block_t)completionBlock
                    withPriotity:(dispatch_queue_priority_t)piority
{
    __block dispatch_block_t taskBlockRef = taskBlock;
    __block dispatch_block_t completionBlockRef = completionBlock;

        
        dispatch_async(dispatch_get_global_queue(piority, 0), ^{
            
            taskBlockRef();
            
            dispatch_sync(dispatch_get_main_queue(), completionBlockRef);
            
        });
}
-(void)setInitialOrientation{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    currentDeviceOrientation = orientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        //do stuff here
    }
}
- (void)prepareForOrientationNotification
{
    [self setInitialOrientation];
}

- (void)orientationChanged:(UIInterfaceOrientation)orientation
{    
    if(!UIInterfaceOrientationIsLandscape(orientation) && !UIInterfaceOrientationIsPortrait(orientation))
    {
        return;
    }
    previousDeviceOrientation = currentDeviceOrientation;
    currentDeviceOrientation = orientation;
    
    if(previousDeviceOrientation == currentDeviceOrientation)
    {
        
        return;
    }

    [self performSelector:@selector(delayedOrientationNotification:) withObject:[NSNumber numberWithInt:orientation] afterDelay:0.2];
}
- (void)delayedOrientationNotification:(NSNumber*)orientation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orientationChangeNotification" object:orientation];
}
- (void)removeOrientationNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}
- (NSString*)pathForResourceForFileName:(NSString*)fileName
{
    NSString *fileLocation = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
    return fileLocation;
}
- (void)log:(NSString*)message
{
    @try {
        message ? NSLog(@"%@ %@",message,self) : NSLog(@"%@",self);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.debugDescription);
    }
}
- (BOOL)isNull
{
    return [self isKindOfClass:[[NSNull null] class]];
}
+ (BOOL)isValidObject:(id)object
{
    return (object && ![object isNull]);
}
@end
