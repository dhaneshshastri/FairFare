//
//  Utils.m
//  FairFare
//
//  Created by dhaneshs on 4/1/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//


#import <Foundation/Foundation.h>


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