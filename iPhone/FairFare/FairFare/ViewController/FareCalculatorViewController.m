//
//  FareCalculatorViewController.m
//  FairFare
//
//  Created by dhaneshs on 4/6/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import "FareCalculatorViewController.h"

@interface FareCalculatorViewController ()
{
    ActionSheetCustomPicker* _pickerView;
    __weak IBOutlet UIButton *_serviceButton;
}
@end

@implementation FareCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_serviceButton setTitle:[[ContentManager sharedManager] services][0]
                    forState:UIControlStateNormal];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
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
/////////////////////////////////////////////////////////////////////////
#pragma mark - ActionSheetCustomPickerDelegate Optional's
/////////////////////////////////////////////////////////////////////////
- (void)configurePickerView:(UIPickerView *)pickerView
{
    // Override default and hide selection indicator
    pickerView.showsSelectionIndicator = NO;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{

}

/////////////////////////////////////////////////////////////////////////
#pragma mark - UIPickerViewDataSource Implementation
/////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (pickerView.tag) {
        case 1:
            return [[[ContentManager sharedManager] services] count];
        default:break;
    }
    return 0;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark UIPickerViewDelegate Implementation
/////////////////////////////////////////////////////////////////////////

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: return 300.0f;
        default:break;
    }
    
    return 0;
}
/*- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
 {
 return
 }
 */
// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 1:
            return [[ContentManager sharedManager] services][row];
        default:break;
    }
    return nil;
}

/////////////////////////////////////////////////////////////////////////

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Row %li selected in component %li", (long)row, (long)component);

    switch (_pickerView.tag) {
        case 1:
        {
            //Set
            [_serviceButton setTitle:[[ContentManager sharedManager] services][row]
                            forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}
- (IBAction)showCityPicker:(id)sender
{
    
}
- (IBAction)showCategoryPicker:(id)sender {
    
    
    
    
}
- (IBAction)showServicePicker:(id)sender {
    
    _pickerView = nil;
    _pickerView = [ActionSheetCustomPicker showPickerWithTitle:@"Select Service"
                                                      delegate:self
                                              showCancelButton:NO
                                                        origin:self.view
                                             initialSelections:nil
                                                        andTag:1];
    _pickerView.tag = 1;
}
@end
