//
//  ContentManager.h
//  FairFare
//
//  Created by dhaneshs on 4/7/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentManager : NSObject
- (NSArray*)cities;
- (NSArray*)services;
- (NSArray*)categories;
- (NSArray*)providersForServiceId:(NSString*)serviceId;
+ (id)sharedManager;
@end
