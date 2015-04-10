//
//  FareCalculatorViewController.h
//  FairFare
//
//  Created by dhaneshs on 4/6/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetCustomPicker.h"
@interface FareCalculatorViewController : UIViewController <UIPickerViewDataSource,ActionSheetCustomPickerDelegate,UIPickerViewDataSource>
- (void)setData:(NSDictionary*)dict;
@end
