//
//  FareCalculatorViewController.m
//  FairFare
//
//  Created by dhaneshs on 4/6/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import "FareCalculatorViewController.h"
#import <MapKit/MapKit.h>
#import "YouPayViewController.h"


@interface ButtonOptionView : UIView
{
    UILabel* _headerLabel;
    UIButton* _optionButton;
}
@property (nonatomic,readonly) NSString* title;
@property (nonatomic,readonly) NSString* buttonTitle;
@property (nonatomic,weak) id <ButtonOptionViewDelegate> delegate;
@end
@implementation ButtonOptionView
- (id)initWithTitle:(NSString*)title
     andButtonTitle:(NSString*)buttonTitle {
    if (self = [super init]) {
        _title = title;
        _buttonTitle = buttonTitle;
        [self layoutViews];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutViews];
}
- (void)setTitle:(NSString*)title
{
    _title = title;
    [_headerLabel setText:title];
}
- (void)setButtonTitle:(NSString*)buttonTitle
{
    _buttonTitle = buttonTitle;
    [_optionButton setTitle:buttonTitle
                   forState:UIControlStateNormal];
}
- (void)setTitle:(NSString *)title
  andButtonTitle:(NSString*)buttonTitle
{
    [self setTitle:title];
    [self setButtonTitle:buttonTitle];
}
- (void)layoutViews
{
    //Add subviews
    _headerLabel = [UILabel new];
    [_headerLabel setText:_title];
    [_headerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_headerLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [_headerLabel setTextColor:[UIColor colorWithRed:92.0 / 255.0
                                               green:94.0 / 255.0
                                                blue:145.0 / 255.0
                                               alpha:1.0]];
    [self addSubview:_headerLabel];
    
    //
    _optionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_optionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_optionButton];
    {
        [[LayoutManager layoutManager] layoutWithFormat:@"H:|-[_headerLabel]-|"
                                           toParentView:self
                                              withViews:NSDictionaryOfVariableBindings(_headerLabel)];
        
        [[LayoutManager layoutManager] layoutWithFormat:@"H:|-[_optionButton]"
                                           toParentView:self
                                              withViews:NSDictionaryOfVariableBindings(_optionButton)];
        
        //align
        [[LayoutManager layoutManager] layoutWithFormat:@"V:|-[_headerLabel(25@20)]-[_optionButton]-|"
                                           toParentView:self
                                              withViews:NSDictionaryOfVariableBindings(_headerLabel,_optionButton)];
    }
    [_optionButton setTitle:_buttonTitle
                   forState:UIControlStateNormal];
    [_optionButton setTitleColor:[UIColor colorWithRed:154.0 / 255.0
                                                 green:138.0 / 255.0
                                                  blue:94.0 / 255.0
                                                 alpha:1.0]
                        forState:UIControlStateNormal];
    
    [_optionButton addTarget:self
                      action:@selector(buttonAction:)
            forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonAction:(UIButton*)button
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(buttonOptionTappedFor:)])
    {
        [self.delegate buttonOptionTappedFor:self];
    }
}
@end

@interface FareCalculatorViewController ()
{
    ActionSheetCustomPicker* _pickerView;
    NSArray* _services;
    NSArray* _providers;
    NSArray* _subCategories;
    NSDictionary* _selectedService;
    NSDictionary* _selectedProvider;
    NSDictionary* _selectedSubCategory;
    ///////
    __weak IBOutlet ButtonOptionView* _providerOptionView;
    __weak IBOutlet ButtonOptionView* _subCategoryOptionView;
    ///////
    __weak IBOutlet UIButton *_cabButton;
    __weak IBOutlet UIButton *_autoRickshawButton;
    __weak IBOutlet UILabel *_cityLabel;
    __weak IBOutlet UILabel *_distanceTravelledLabel;
    ///////
    NSDictionary* _data;
    NSString* _activeJourneyId;
    __weak IBOutlet UIView *_autoTopView;
    __weak IBOutlet UIView *_cabTopView;
}
@end

@implementation FareCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(cabViewAction:)];
    tapGesture.delegate = self;
    _cabTopView.userInteractionEnabled = YES;
    [_cabTopView addGestureRecognizer:tapGesture];
    
    tapGesture = nil;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(autoViewAction:)];
        tapGesture.delegate = self;
    _autoTopView.userInteractionEnabled = YES;
    [_autoTopView addGestureRecognizer:tapGesture];
}
- (void)initialize
{
    _services = nil;
    _selectedService = nil;
    _providers = nil;
    _selectedProvider = nil;
    _subCategories = nil;
    _selectedSubCategory = nil;
    /////////
    _services = [[ContentManager sharedManager] services];
    _selectedService = _services[0];
    _providers = [[ContentManager sharedManager] providersForServiceId:_selectedService[@"selfId"]];
    _selectedProvider = _providers[0];
    _subCategories = [[ContentManager sharedManager] subCategoriesForServiceId:_selectedService[@"selfId"]
                                                                 andProviderId:_selectedProvider[@"selfId"]];
    _selectedSubCategory = _subCategories[0];
    _providerOptionView.hidden = !isArraySafe(_providers);
    _subCategoryOptionView.hidden = !isArraySafe(_subCategories);
    /////////
    [_providerOptionView setButtonTitle:_selectedProvider[@"name"]];
 //   [_servicesOptionView setButtonTitle:_selectedService[@"name"]];
    [_subCategoryOptionView setButtonTitle:_selectedSubCategory[@"name"]];
}
- (void)createOptions
{
    /////
//    [_servicesOptionView setTitle:@"Select Service"
//                   andButtonTitle:@""];
    
    [_providerOptionView setTitle:@"Select Provider"
                   andButtonTitle:@""];
    
    [_subCategoryOptionView setTitle:@"Select Category"
                   andButtonTitle:@""];

    //
 //   _servicesOptionView.delegate = self;
    _providerOptionView.delegate = self;
    _subCategoryOptionView.delegate = self;
    
    /////
 //   _servicesOptionView.tag = 1000;
    _providerOptionView.tag = 2000;
    _subCategoryOptionView.tag = 3000;
    ////
}
- (void)updateOptions
{
    //Set selected
    _providerOptionView.hidden = !isArraySafe(_providers);
    _subCategoryOptionView.hidden = !isArraySafe(_subCategories);
}
- (void)resetOptionsForService:(NSDictionary*)service
{
    //Rest other options depending upon this
    if(!service)
    {
        return;
    }
    _providers = [[ContentManager sharedManager] providersForServiceId:service[@"selfId"]];
    //Categories
    _subCategories = nil;
    //Select first
    _providerOptionView.hidden = !_providers || [_providers count] == 0;
    _subCategoryOptionView.hidden = !_subCategories || [_subCategories count] == 0;
    ////
    /////////
    [_providerOptionView setButtonTitle:(_providers[0])[@"name"]];
 //   [_servicesOptionView setButtonTitle:service[@"name"]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createOptions];
    [self initialize];
    
    UIImage* image = [UIImage imageNamed:@"LeftArrow.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem*doneButton=[[UIBarButtonItem alloc] initWithImage:image
                                                  landscapeImagePhone:nil
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(goBack)];
    
    self.navigationItem.leftBarButtonItem = doneButton;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CLLocationDistance distanceTravelled = [_data[@"travelledDistance"] doubleValue];
    //Update the distance metre
    MKDistanceFormatter *df = [[MKDistanceFormatter alloc] init];
    df.unitStyle = MKDistanceFormatterUnitStyleDefault;
    
    _cabButton.selected = YES;
    if(distanceTravelled > 0)
    {
        [_distanceTravelledLabel setText:[df stringFromDistance: distanceTravelled]];
    }
    
  //  id address = _data[@"addressOrLocation"];
//    if([address isKindOfClass:[GMSAddress class]])
//    {
//        //Address
//        [_cityLabel setText:[NSString stringWithFormat:@"In %@",((GMSAddress*)address).locality]];
//        [_cityLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
//    }
    //Else fetch the address and show
    id location = _data[@"addressOrLocation"];
    if([location isKindOfClass:[CLLocation class]])
    {
        GMSGeocoder* geocoder = [GMSGeocoder geocoder];
        
        [geocoder reverseGeocodeCoordinate:[((CLLocation*)location) coordinate]
                         completionHandler:^(GMSReverseGeocodeResponse *geocodeResponse, NSError *erroe){
                             
                             GMSAddress* address = geocodeResponse.firstResult;
                             
                             //Address
                             [_cityLabel setText:[NSString stringWithFormat:@"In %@",address.locality]];
                         }];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //Check whether we have tapped 'CalculateFare'
    Journey* journey = [[AppDataBaseManager appDataBaseManager] journeyWithId:_activeJourneyId];
    if(![NSObject isValidObject:journey.serviceId])
    {
        //We have not pressed 'CalculateFare'
        //Delete the journey
        [[AppDataBaseManager appDataBaseManager] deleteJourneyWithId:_activeJourneyId];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
            return [_services count];
        case 2:
            return [_providers count];
        case 3:
            return [_subCategories count];
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
            return ((NSDictionary*)_services[row])[@"name"];
        case 2:
            return ((NSDictionary*)_providers[row])[@"name"];
        case 3:
            return ((NSDictionary*)_subCategories[row])[@"name"];
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
//            _selectedService = nil;
//            _selectedService = [[ContentManager sharedManager] services][row];
//            //Set
//            [_servicesOptionView setButtonTitle:_selectedService[@"name"]];
//            //Reset the provider and subcategory
//            _providers = nil;
//            _subCategories = nil;
        }
            break;
        case 2:
        {
            _subCategories = nil;
            _selectedProvider = nil;
            _selectedProvider = _providers[row];
            [_providerOptionView setButtonTitle:_selectedProvider[@"name"]];
        }
            break;
        case 3:
        {
            _selectedSubCategory = nil;
            _selectedSubCategory = _subCategories[row];
            [_subCategoryOptionView setButtonTitle:_selectedSubCategory[@"name"]];
        }
            break;
            
        default:
            break;
    }
    if(!_providers)
    {
        //Set both
        _providers = [[ContentManager sharedManager] providersForServiceId:_selectedService[@"selfId"]];
        _selectedProvider = _providers[0];
        [_providerOptionView setButtonTitle:_selectedProvider[@"name"]];
    }
    if(!_subCategories)
    {
        _subCategories = [[ContentManager sharedManager] subCategoriesForServiceId:_selectedService[@"selfId"]
                                                                     andProviderId:_selectedProvider[@"selfId"]];
        _selectedSubCategory = _subCategories[0];
        [_subCategoryOptionView setButtonTitle:_selectedSubCategory[@"name"]];

    }
    [self updateOptions];
}

- (void)showProvidersPicker {
    
    NSUInteger index = indexOfItemFor(_providers,
                                      @"name",
                                      _providerOptionView.buttonTitle);
    
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
- (void)showSubCategoriesPicker {
    
    NSUInteger index = indexOfItemFor(_subCategories,
                                      @"name",
                                      _subCategoryOptionView.buttonTitle);
    _pickerView = nil;
    _pickerView = [ActionSheetCustomPicker showPickerWithTitle:@"Select Category"
                                                      delegate:self
                                              showCancelButton:NO
                                                        origin:self.view
                                             initialSelections:nil
                                                        andTag:3];
    [(UIPickerView*)(_pickerView.pickerView) selectRow:index
                                           inComponent:0
                                              animated:YES];
}
- (void)showServicePicker {
    
//    NSUInteger index = indexOfItemFor([[ContentManager sharedManager] services],
//                                      @"name",
//                                      _servicesOptionView.buttonTitle);
//    _pickerView = nil;
//    _pickerView = [ActionSheetCustomPicker showPickerWithTitle:@"Select Service"
//                                                      delegate:self
//                                              showCancelButton:NO
//                                                        origin:self.view
//                                             initialSelections:nil
//                                                        andTag:1];
//    [(UIPickerView*)(_pickerView.pickerView) selectRow:index
//                                           inComponent:0
//                                              animated:YES];
}

- (IBAction)calculateFare:(UIButton *)sender
{
    //Take to FareCalculator screen
    YouPayViewController* youPayVC = (YouPayViewController*)viewControllerFromStoryboard(@"Main",@"youPayViewController");
    //Create dict with
    //Service
    //Provider
    //SubCategory
    //TravelledDistance
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithDictionary:_data];
    if(_selectedService[@"selfId"])
    {
        [data setObject:_selectedService[@"selfId"]
              forKey:@"serviceId"];
    }
    if(_selectedProvider[@"selfId"])
    {
        [data setObject:_selectedProvider[@"selfId"]
                 forKey:@"providerId"];
    }
    if(_selectedSubCategory[@"selfId"])
    {
        [data setObject:_selectedProvider[@"selfId"]
                 forKey:@"subCategoryId"];
    }
    if(_data[@"travelledDistance"])
    {
        [data setObject:_data[@"travelledDistance"]
                 forKey:@"travelledDistance"];
    }
    [youPayVC setData:data];
    [self.navigationController pushViewController:youPayVC
                                         animated:YES];
    
    //Set the active journey
    Journey* journey = [[AppDataBaseManager appDataBaseManager] journeyWithId:_data[@"activeJourneyId"]];
    journey.serviceId = _selectedService[@"selfId"];
    journey.providerId = _selectedProvider[@"selfId"];
    journey.subCategoryId = _selectedSubCategory[@"selfId"];
    [[AppDataBaseManager appDataBaseManager] saveContext:nil];
}
- (void)setData:(NSDictionary*)dict
{
    _data = nil;
    _data = dict;
    _activeJourneyId = _data[@"activeJourneyId"];
}
- (void)autoViewAction:(id)sender {
    [self autoRadioButtonTapped:_autoRickshawButton];
}
- (void)cabViewAction:(id)sender {
    [self cabRadioButtonTapped:_cabButton];
}
- (IBAction)autoRadioButtonTapped:(UIButton*)sender {
    
    if([sender isSelected])
    {
        return;
    }
    
    [sender setSelected:!sender.selected];
    [_cabButton setSelected:!sender.selected];
    
    _selectedService = nil;
    _selectedService = _services[1];
    
    _providers = nil;
    _subCategories = nil;
    if(!_providers)
    {
        //Set both
        _providers = [[ContentManager sharedManager] providersForServiceId:_selectedService[@"selfId"]];
        _selectedProvider = _providers[0];
        [_providerOptionView setButtonTitle:_selectedProvider[@"name"]];
    }
    if(!_subCategories)
    {
        _subCategories = [[ContentManager sharedManager] subCategoriesForServiceId:_selectedService[@"selfId"]
                                                                     andProviderId:_selectedProvider[@"selfId"]];
        _selectedSubCategory = _subCategories[0];
        [_subCategoryOptionView setButtonTitle:_selectedSubCategory[@"name"]];
        
    }
    [self updateOptions];
}
- (IBAction)cabRadioButtonTapped:(UIButton*)sender {

    if([sender isSelected])
    {
        return;
    }
    
    [sender setSelected:!sender.selected];
    [_autoRickshawButton setSelected:!sender.selected];
    _selectedService = nil;
    _selectedService = _services[0];
    
    _providers = nil;
    _subCategories = nil;
    if(!_providers)
    {
        //Set both
        _providers = [[ContentManager sharedManager] providersForServiceId:_selectedService[@"selfId"]];
        _selectedProvider = _providers[0];
        [_providerOptionView setButtonTitle:_selectedProvider[@"name"]];
    }
    if(!_subCategories)
    {
        _subCategories = [[ContentManager sharedManager] subCategoriesForServiceId:_selectedService[@"selfId"]
                                                                     andProviderId:_selectedProvider[@"selfId"]];
        _selectedSubCategory = _subCategories[0];
        [_subCategoryOptionView setButtonTitle:_selectedSubCategory[@"name"]];
        
    }
    [self updateOptions];
}
#pragma mark ButtonOptionView Delegates
- (void)buttonOptionTappedFor:(ButtonOptionView*)buttonOptionView
{
    switch (buttonOptionView.tag) {
        case 1000://Service
            [self showServicePicker];
            break;
        case 2000://Provider
            [self showProvidersPicker];
            break;
        case 3000://SubCategory
            [self showSubCategoriesPicker];
            break;
        default:
            break;
    }
}
@end
