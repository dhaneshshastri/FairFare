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


UIViewController* viewControllerFromStoryboard(NSString* storyBoardName,NSString* controllerId);
id dataFromPlistFile(NSString* fileName);
NSUInteger indexOfItemFor(NSArray* array,NSString* matchingKey,NSString* matchingText);

#endif
