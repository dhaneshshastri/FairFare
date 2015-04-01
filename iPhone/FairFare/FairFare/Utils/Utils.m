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