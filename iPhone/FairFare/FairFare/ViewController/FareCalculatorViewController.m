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
    NSDictionary* _selectedService;
    NSDictionary* _selectedProvider;
    __weak IBOutlet UIButton *_providerButton;
    __weak IBOutlet UIButton *_serviceButton;
    __weak IBOutlet UILabel *_providerTitle;
    __weak IBOutlet NSLayoutConstraint *_selectProviderTitleHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_selectedProviderNameHeightConstraint;
}
@end

@implementation FareCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_serviceButton setTitle:((NSDictionary*)[[ContentManager sharedManager] services][0])[@"name"]
                    forState:UIControlStateNormal];
    
    //Select first
    _selectedService = [[ContentManager sharedManager] services][0];
    
    
    NSArray* providers = [[ContentManager sharedManager] providersForServiceId:_selectedService[@"selfId"]];
    if(!providers)
    {
        _providerButton.hidden = YES;
    }
    
    [_providerButton setTitle:((NSDictionary*)[[ContentManager sharedManager] providersForServiceId:_selectedService[@"selfId"]][0])[@"name"]
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
        case 2:
            return [[[ContentManager sharedManager] providersForServiceId:_selectedService[@"selfId"]] count];
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
    return 300.0f;
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
            return ((NSDictionary*)[[ContentManager sharedManager] services][row])[@"name"];
        case 2:
            return ((NSDictionary*)[[ContentManager sharedManager] providersForServiceId:_selectedService[@"selfId"]][row])[@"name"];
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
            [_serviceButton setTitle:((NSDictionary*)[[ContentManager sharedManager] services][row])[@"name"]
                            forState:UIControlStateNormal];
            
            _selectedService = nil;
            _selectedService = [[ContentManager sharedManager] services][row];
            
            //Hide
            NSArray* providers = [[ContentManager sharedManager] providersForServiceId:_selectedService[@"selfId"]];
            if(![providers count])
            {
           //     _selectProviderTitleHeightConstraint.constant = 0.0;
                _selectedProviderNameHeightConstraint.constant = 0.0;
                [_providerButton layoutIfNeeded];
               // _providerTitle.hidden = YES;
//                _providerButton.hidden = YES;
            }
            else
            {
                _selectProviderTitleHeightConstraint.constant = 21.0;
                _selectedProviderNameHeightConstraint.constant = 30.0;
                [self.view layoutIfNeeded];
            }
        }
            break;
        case 2:
        {
            [_providerButton setTitle:((NSDictionary*)[[ContentManager sharedManager] providersForServiceId:_selectedService[@"selfId"]][row])[@"name"]
                             forState:UIControlStateNormal];
            
            _selectedProvider = nil;
            _selectedProvider = [[ContentManager sharedManager] providersForServiceId:_selectedService[@"selfId"]][row];
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
    
    NSUInteger index = indexOfItemFor([[ContentManager sharedManager] providersForServiceId:_selectedService[@"selfId"]],
                                      @"name",
                                      _providerButton.titleLabel.text);
    
    _pickerView = nil;
    _pickerView = [ActionSheetCustomPicker showPickerWithTitle:@"Select Provider"
                                                      delegate:self
                                              showCancelButton:NO
                                                        origin:self.view
                                             initialSelections:nil
                                                        andTag:2];
    
    
    
    [(UIPickerView*)(_pickerView.pickerView) selectRow:index
                                           inComponent:0
                                              animated:YES];
    
    
}
- (IBAction)showServicePicker:(id)sender {
    
    NSUInteger index = indexOfItemFor([[ContentManager sharedManager] services],
                                      @"name",
                                      _serviceButton.titleLabel.text);
    
    _pickerView = nil;
    _pickerView = [ActionSheetCustomPicker showPickerWithTitle:@"Select Service"
                                                      delegate:self
                                              showCancelButton:NO
                                                        origin:self.view
                                             initialSelections:nil
                                                        andTag:1];
    
    
    [(UIPickerView*)(_pickerView.pickerView) selectRow:index
                                           inComponent:0
                                              animated:YES];
}
@end
