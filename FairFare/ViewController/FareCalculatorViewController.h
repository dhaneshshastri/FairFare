//
//  FareCalculatorViewController.h
//  FairFare
//
//  Created by dhaneshs on 4/6/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetCustomPicker.h"

@class ButtonOptionView;
@protocol ButtonOptionViewDelegate <NSObject>
@optional
- (void)buttonOptionTappedFor:(ButtonOptionView*)buttonOptionView;
@end

@interface FareCalculatorViewController : UIViewController <UIPickerViewDataSource,ActionSheetCustomPickerDelegate,UIPickerViewDataSource,ButtonOptionViewDelegate>
- (void)setData:(NSDictionary*)dict;
- (void)initialize;
@end
