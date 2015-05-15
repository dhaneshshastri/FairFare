//
//  NSDictionary+Validation.h
//  iSalesTool
//
//  Created by Vectorform 2 on 5/30/12.
//  Copyright 2012 VF. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (Helper)

- (id)valueForKeyValidated:(NSString *)key;
- (BOOL) setValueIfChangedForKey:(NSString*)key to:(NSString**) destString;
- (void)setValueIfNotNil:(id)value forKey:(NSString *)key;
- (NSString*)stringObjectForKey:(NSString*)key;
- (NSString*)stringObjectForKeyFormattedForFloat:(NSString*)key;
- (id)validatedValueForKey:(NSString*)key withRefValue:(id)value;
- (id)validatedValueForKeys:(NSArray*)key withRefValue:(id)value;
- (NSData*)encode;
+ (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj;
@end


