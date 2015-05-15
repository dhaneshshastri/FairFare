//
//  id+utility.h
//  iSalesTool
//
//  Created by Vectorform 2 on 6/21/12.
//  Copyright (c) 2012 VF. All rights reserved.
//

#import <Foundation/Foundation.h>

UIInterfaceOrientation currentDeviceOrientation;
UIInterfaceOrientation previousDeviceOrientation;

@interface NSObject (utility)
- (NSString*)stringFormat;
- (CGFloat)floatFormat;
- (void)log:(NSString*)message;
- (void)performBlockInBackground:(dispatch_block_t)taskBlock
                      completion:(dispatch_block_t)completionBlock
                    withPriotity:(dispatch_queue_priority_t)piority;
- (void)prepareForOrientationNotification;
- (void)orientationChanged:(UIInterfaceOrientation)orientation;
- (NSString*)pathForResourceForFileName:(NSString*)fileName;
- (BOOL)isNull;
+ (BOOL)isValidObject:(id)object;
@end
