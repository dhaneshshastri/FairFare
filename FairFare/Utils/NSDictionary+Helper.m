//
//  NSDictionary+Validation.m
//  iSalesTool
//
//  Created by Vectorform 2 on 5/30/12.
//  Copyright 2012 VF. All rights reserved.
//

#import "NSDictionary+Helper.h"
#import "NSOBject+Utility.h"
#import <objc/runtime.h>

@implementation NSDictionary (Helper)
- (id)valueForKeyValidated:(NSString *)key
{
    id value = [self valueForKey:key]; 
    if([value isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else
        return value;
}

- (void)setValueIfNotNil:(id)value forKey:(NSString *)key
{
    id currentObject = [self valueForKey:key];
    if(value)
        [self setValue:value forKey:key];
    else if(!currentObject)
    {
        [self setValue:@"" forKey:key];
    }
}
- (BOOL) setValueIfChangedForKey:(NSString*)key to:(NSString**) destString
{
    NSString* value = self[key];
    NSComparisonResult result = [value compare:*destString options:NSLiteralSearch];
    if(result == NSOrderedSame)
    {
        //so will not save and return no
        return NO;
    }
    else
    {
        //changed
        *destString = value;
        return YES;
    }
}

- (NSString*)stringObjectForKey:(NSString*)key
{
    return [self[key] stringFormat];
}
- (NSString*)stringObjectForKeyFormattedForFloat:(NSString*)key
{
    return [NSString stringWithFormat:@"%f",[self[key] floatFormat]];
}
- (id)validatedValueForKey:(NSString*)key withRefValue:(id)value
{
    id object = self[key];
    if(object)
    {
        return object;
    }
    else
        return value;
}
- (id)validatedValueForKeys:(NSArray*)keys
               withRefValue:(id)value
{
    //Go through the keys and check the result
    //if we have the value then return it
    id object = nil;
    for(NSString* key in keys)
    {
        object = self[key];
        if(object)
        {
            break;
        }
    }
    if(object)
    {
        return object;
    }
    else
    {
        return value;
    }
    
}
- (NSData*)encode
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in self) {
        NSString *encodedValue = [[self valueForKeyValidated:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, (encodedValue) ? encodedValue : @""];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}
//Add this utility method in your class.
+ (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        [obj valueForKey:key] ? [dict setObject:[obj valueForKey:key] forKey:key]:"";
    }
    
    free(properties);
    
    return dict;
}
@end
