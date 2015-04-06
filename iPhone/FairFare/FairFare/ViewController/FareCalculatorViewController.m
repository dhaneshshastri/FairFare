//
//  FareCalculatorViewController.m
//  FairFare
//
//  Created by dhaneshs on 4/6/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import "FareCalculatorViewController.h"

@interface FareCalculatorViewController ()

@end

@implementation FareCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIPickerView* servicePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 20.0)];
//    [servicePicker setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:servicePicker];
//    servicePicker.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark Picker Data Source
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}
@end
