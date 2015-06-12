//
//  HistoryViewController.m
//  FairFare
//
//  Created by dhaneshs on 4/1/15.
//  Copyright (c) 2015 dhaneshs. All rights reserved.
//

#import "HistoryViewController.h"
#import "YouPayViewController.h"
@interface HistoryCell : UITableViewCell
{
    UILabel* _mediumNameLabel;
    UILabel* _sourceLabel;
    UILabel* _destinationLabel;
    UILabel* _totalCostLabel;
    UILabel* _destinationAddressLabel;
    UILabel* _sourceAddressLabel;
}
@property (nonatomic, strong) NSDictionary* data;
@end
@implementation HistoryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                      andData:(NSDictionary*)data
{
    _data = nil;
    _data = data;
    
    return [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
}
- (void)setData:(NSDictionary*)data
{
    _data = nil;
    _data = data;
    [self layoutContent];
}
- (void)layoutContent
{
    //|[Header Label] |
    //|[source label] | [Amount Label] >
    
    //Remove
    [_mediumNameLabel removeFromSuperview];
    [_sourceLabel removeFromSuperview];
    [_destinationLabel removeFromSuperview];
    [_totalCostLabel removeFromSuperview];
    [_sourceAddressLabel removeFromSuperview];
    [_destinationAddressLabel removeFromSuperview];
    
    
    _mediumNameLabel = nil;
    _sourceLabel = nil;
    _destinationLabel = nil;
    _totalCostLabel = nil;
    _sourceAddressLabel = nil;
    _destinationAddressLabel = nil;
    
    //Layout
    for(UIView* view in self.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    UIView* view = [UIView new];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view setBackgroundColor:[UIColor clearColor]];
    {
        [self.contentView addSubview:view];
        
        [[LayoutManager layoutManager] fillView:view
                                         inView:self.contentView];
        //Add Labels
        {
            UIImageView* topHeaderImageView = [UIImageView new];
            if([_data[@"index"] integerValue] == 0)
            {
                [topHeaderImageView setImage:[UIImage imageNamed:@"box1.png"]];
            }
            else
                [topHeaderImageView setImage:[UIImage imageNamed:@"box2.png"]];
            
            
            [topHeaderImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:topHeaderImageView];
            [view setBackgroundColor:[UIColor clearColor]];
            
            [[LayoutManager layoutManager] setHeight:30.0
                                              ofView:topHeaderImageView
                                              inView:view
                                         andRelation:NSLayoutRelationEqual];
            
            [[LayoutManager layoutManager] fillView:topHeaderImageView
                                             inView:view
                                       isHorizontal:YES];
            
            [[LayoutManager layoutManager] alignView:topHeaderImageView
                                           toRefView:view
                                          withOffset:CGPointZero
                                              inView:view
                                 withAlignmentOption:NSLayoutAttributeCenterX
                               andRefAlignmentOption:NSLayoutAttributeCenterX];
            
            [[LayoutManager layoutManager] alignView:topHeaderImageView
                                           toRefView:view
                                          withOffset:CGPointZero
                                              inView:view
                                 withAlignmentOption:NSLayoutAttributeTop
                               andRefAlignmentOption:NSLayoutAttributeTop];
            
            _mediumNameLabel = [UILabel new];
            [_mediumNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:_mediumNameLabel];
            [_mediumNameLabel setBackgroundColor:[UIColor clearColor]];
            
            [_mediumNameLabel setTextColor:[UIColor whiteColor]];
            [_mediumNameLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
            
            [[LayoutManager layoutManager] setWidthOfView:_mediumNameLabel
                                               sameAsView:view
                                                   inView:view
                                               multiplier:0.95
                                              andRelation:NSLayoutRelationEqual];
            
            [[LayoutManager layoutManager] alignView:_mediumNameLabel
                                           toRefView:view
                                          withOffset:CGPointMake(5, 0)
                                              inView:view
                                 withAlignmentOption:NSLayoutAttributeTop
                               andRefAlignmentOption:NSLayoutAttributeTop];
            
            [[LayoutManager layoutManager] alignView:_mediumNameLabel
                                           toRefView:view
                                          withOffset:CGPointZero
                                              inView:view
                                 withAlignmentOption:NSLayoutAttributeCenterX
                               andRefAlignmentOption:NSLayoutAttributeCenterX];
            
            [[LayoutManager layoutManager] setHeight:20
                                              ofView:_mediumNameLabel
                                              inView:view
                                         andRelation:NSLayoutRelationEqual];
            
            
            
            {
                
                NSDictionary* provider = [[ContentManager sharedManager] providerWithProviderId:_data[@"providerId"]
                                                                                   andServiceId:_data[@"serviceId"]];
                NSString* providerOrServiceName = provider[@"name"];
                //Fetch the Service Detail
                if(!providerOrServiceName)
                {
                    NSDictionary* service = [[ContentManager sharedManager] serviceWithServiceId:_data[@"serviceId"]];
                    providerOrServiceName = service[@"name"];
                }
                NSLog(@"%@",[providerOrServiceName description]);
                [_mediumNameLabel setText:providerOrServiceName];
                [_mediumNameLabel setTextAlignment:NSTextAlignmentLeft];
            }
            /////
            UIView* innerView = [UIView new];
            [innerView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:innerView];
            [innerView setBackgroundColor:[UIColor whiteColor]];
            
            [[LayoutManager layoutManager] alignView:topHeaderImageView
                                           toRefView:innerView
                                          withOffset:CGPointZero
                                              inView:view
                                 withAlignmentOption:NSLayoutAttributeBottom
                               andRefAlignmentOption:NSLayoutAttributeTop];
            
            [[LayoutManager layoutManager] fillView:innerView
                                             inView:view
                                       isHorizontal:YES];
            
            [[LayoutManager layoutManager] alignView:innerView
                                           toRefView:view
                                          withOffset:CGPointZero
                                              inView:view
                                 withAlignmentOption:NSLayoutAttributeCenterX
                               andRefAlignmentOption:NSLayoutAttributeCenterX];
            
            [[LayoutManager layoutManager] alignView:innerView
                                           toRefView:view
                                          withOffset:CGPointZero
                                              inView:view
                                 withAlignmentOption:NSLayoutAttributeBottom
                               andRefAlignmentOption:NSLayoutAttributeBottom];
            
            
            //If the source and destinations are set then show addresseses otherwise only distance and fare side by side
            if([self isSourceDestinationSet:_data])
            {
                [self updateUIForSrcDest:innerView
                                 andData:_data];
            }
            else
                [self updateUIForDistanceAndFare:innerView
                                         andData:_data];
            
            return;
            
            //Src/Dest
            _sourceAddressLabel = [UILabel new];
            [_sourceAddressLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:_sourceAddressLabel];
            [_sourceAddressLabel setBackgroundColor:[UIColor clearColor]];
            
            [_sourceAddressLabel setNumberOfLines:2];
            [_sourceAddressLabel setAdjustsFontSizeToFitWidth:YES];
            //
            _mediumNameLabel = [UILabel new];
            [_mediumNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:_mediumNameLabel];
            
            [[LayoutManager layoutManager] setHeight:30.0
                                              ofView:_sourceAddressLabel
                                              inView:view
                                         andRelation:NSLayoutRelationEqual];
            
            [[LayoutManager layoutManager] setWidthOfView:_sourceAddressLabel
                                               sameAsView:view
                                                   inView:view
                                               multiplier:0.8
                                              andRelation:NSLayoutRelationEqual];
            
            [_sourceAddressLabel setBackgroundColor:[UIColor clearColor]];
            
            //Add Price label
            _totalCostLabel = [UILabel new];
            [_totalCostLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:_totalCostLabel];
            [_totalCostLabel setBackgroundColor:[UIColor clearColor]];
            
            [_totalCostLabel setText:formatCurrency([_data[@"calculatedFare"] doubleValue])];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"V:|-2-[_sourceAddressLabel]"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(_sourceAddressLabel)];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"V:[_totalCostLabel(30)]"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(_totalCostLabel)];
            
            [[LayoutManager layoutManager] alignView:_totalCostLabel
                                           toRefView:view
                                          withOffset:CGPointZero
                                              inView:view
                                 withAlignmentOption:NSLayoutAttributeCenterY
                               andRefAlignmentOption:NSLayoutAttributeCenterY];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"H:[_totalCostLabel]-2-|"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(_totalCostLabel)];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"H:|-2-[_sourceAddressLabel]-2-[_totalCostLabel]-2-|"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(_totalCostLabel,_sourceAddressLabel)];
            
            UILabel* toLabel = [UILabel new];
            [toLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:toLabel];
            [toLabel setAdjustsFontSizeToFitWidth:YES];
            [toLabel setTextAlignment:NSTextAlignmentCenter];
            [toLabel setFont:[UIFont italicSystemFontOfSize:14.0]];
            
            //Add or Label
            {
                [[LayoutManager layoutManager] layoutWithFormat:@"V:|-2-[_sourceAddressLabel]-2-[toLabel(20)]"
                                                   toParentView:view
                                                      withViews:NSDictionaryOfVariableBindings(_sourceAddressLabel,toLabel)];
                
                [[LayoutManager layoutManager] layoutWithFormat:@"H:|-2-[toLabel(_sourceAddressLabel)]"
                                                   toParentView:view
                                                      withViews:NSDictionaryOfVariableBindings(toLabel,_sourceAddressLabel)];
            }
            /////
            _destinationAddressLabel = [UILabel new];
            [_destinationAddressLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:_destinationAddressLabel];
            [_destinationAddressLabel setBackgroundColor:[UIColor clearColor]];

            [[LayoutManager layoutManager] layoutWithFormat:@"V:[toLabel]-2-[_destinationAddressLabel(_sourceAddressLabel)]"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(_sourceAddressLabel,toLabel,_destinationAddressLabel)];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"H:|-2-[_destinationAddressLabel(toLabel)]"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(_destinationAddressLabel,toLabel)];
            /////
            [_destinationAddressLabel setNumberOfLines:2];
            [_destinationAddressLabel setAdjustsFontSizeToFitWidth:YES];
            
            //Config To Label
            {
                //Set data
                Address* startAddress = [[AppDataBaseManager appDataBaseManager] addressWithId:_data[@"startLocationId"]
                                                                                  andJourneyId:_data[@"selfId"]];
                
                Address* endAddress = [[AppDataBaseManager appDataBaseManager] addressWithId:_data[@"endLocationId"]
                                                                                andJourneyId:_data[@"selfId"]];
                
                if(![NSObject isValidObject:startAddress.addressLine1] || ![NSObject isValidObject:endAddress.addressLine1])
                {
                    [toLabel setText:@""];
                }
                else
                {
                    [_sourceAddressLabel setText:startAddress.addressLine1];
                    [_destinationAddressLabel setText:endAddress.addressLine1];
                    [toLabel setText:@"To"];
                }
            }
            
            //distance label
            UILabel* distanceLabel = [UILabel new];
            [distanceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:distanceLabel];
            [[LayoutManager layoutManager] layoutWithFormat:@"V:[distanceLabel(toLabel)]-2-|"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(toLabel,distanceLabel)];
            
            [distanceLabel setText:[_data[@"travelledDistance"] doubleValue] > 0 ?
             formatDistance([_data[@"travelledDistance"] doubleValue]) : @""];
            
            
            _mediumNameLabel = [UILabel new];
            [_mediumNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:_mediumNameLabel];
            [_mediumNameLabel setBackgroundColor:[UIColor clearColor]];
            
            {
                
                NSDictionary* provider = [[ContentManager sharedManager] providerWithProviderId:_data[@"providerId"]
                                                                                   andServiceId:_data[@"serviceId"]];
                NSString* providerOrServiceName = provider[@"name"];
                //Fetch the Service Detail
                if(!providerOrServiceName)
                {
                    NSDictionary* service = [[ContentManager sharedManager] serviceWithServiceId:_data[@"serviceId"]];
                    providerOrServiceName = service[@"name"];
                }
                NSLog(@"%@",[providerOrServiceName description]);
                [_mediumNameLabel setText:![NSObject isValidObject:providerOrServiceName] ? @"" : [NSString stringWithFormat:@"With %@",providerOrServiceName]];
                [_mediumNameLabel setTextAlignment:NSTextAlignmentRight];
            }
            //Add or Label
            {
                [[LayoutManager layoutManager] layoutWithFormat:@"V:[_mediumNameLabel(_sourceAddressLabel)]-2-|"
                                                   toParentView:view
                                                      withViews:NSDictionaryOfVariableBindings(_sourceAddressLabel,_mediumNameLabel)];
                
                [[LayoutManager layoutManager] layoutWithFormat:@"H:|-2-[distanceLabel]-1-[_mediumNameLabel(distanceLabel)]-2-[_totalCostLabel]-2-|"
                                                   toParentView:view
                                                      withViews:NSDictionaryOfVariableBindings(distanceLabel,_mediumNameLabel,_totalCostLabel)];
            }
            
            //Vertical spacer
            UIView* verticalDevider = [UIView new];
            [verticalDevider setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:verticalDevider];
            [verticalDevider setBackgroundColor:[UIColor lightGrayColor]];
            //Place vertical devider
            [[LayoutManager layoutManager] alignView:verticalDevider
                                           toRefView:view
                                          withOffset:CGPointZero
                                              inView:view
                                 withAlignmentOption:NSLayoutAttributeCenterY
                               andRefAlignmentOption:NSLayoutAttributeCenterY];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"V:|-5-[verticalDevider]-5-|"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(verticalDevider)];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"H:[verticalDevider(1)]"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(verticalDevider)];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"H:[verticalDevider]-1-[_totalCostLabel]"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(verticalDevider,_totalCostLabel)];
            if([[toLabel text] length] == 0)
            {
                return;
            }
            //Deviders
            UIView* deviderView1 = [UIView new];
            [deviderView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:deviderView1];
            [deviderView1 setBackgroundColor:[UIColor lightGrayColor]];
            
            UIView* deviderView2 = [UIView new];
            [deviderView2 setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:deviderView2];
            [deviderView2 setBackgroundColor:[UIColor lightGrayColor]];
            
            UIView* deviderView3 = [UIView new];
            [deviderView3 setTranslatesAutoresizingMaskIntoConstraints:NO];
            [view addSubview:deviderView3];
            [deviderView3 setBackgroundColor:[UIColor lightGrayColor]];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"V:[deviderView1(1)]-0-[toLabel]-0-[deviderView2(deviderView1)]"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(deviderView1,deviderView2,toLabel)];
            
            [[LayoutManager layoutManager] setWidthOfView:deviderView1
                                               sameAsView:toLabel
                                                   inView:view
                                               multiplier:0.8
                                              andRelation:NSLayoutRelationEqual];
            
            [[LayoutManager layoutManager] setWidthOfView:deviderView3
                                               sameAsView:toLabel
                                                   inView:view
                                               multiplier:0.95
                                              andRelation:NSLayoutRelationEqual];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"H:[deviderView2(deviderView1)]"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(deviderView2,deviderView1)];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"V:[deviderView3(1)]-1-[_mediumNameLabel]"
                                               toParentView:view
                                                  withViews:NSDictionaryOfVariableBindings(deviderView3,_mediumNameLabel)];
            
            [[LayoutManager layoutManager] alignView:deviderView1
                                           toRefView:toLabel
                                          withOffset:CGPointZero
                                              inView:view
                                 withAlignmentOption:NSLayoutAttributeCenterX
                               andRefAlignmentOption:NSLayoutAttributeCenterX];
            
            [[LayoutManager layoutManager] alignView:deviderView2
                                           toRefView:toLabel
                                          withOffset:CGPointZero
                                              inView:view
                                 withAlignmentOption:NSLayoutAttributeCenterX
                               andRefAlignmentOption:NSLayoutAttributeCenterX];
            
            [[LayoutManager layoutManager] alignView:deviderView3
                                           toRefView:toLabel
                                          withOffset:CGPointZero
                                              inView:view
                                 withAlignmentOption:NSLayoutAttributeCenterX
                               andRefAlignmentOption:NSLayoutAttributeCenterX];
        }
    }
}
- (void)updateUIForSrcDest:(UIView*)view
                   andData:(NSDictionary*)data
{
    UIImageView* arrowIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow.png"]];
    [arrowIconView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:arrowIconView];
    [[LayoutManager layoutManager] setSize:CGSizeMake(10, 20)
                                    ofView:arrowIconView
                                    inView:view];
    
    [[LayoutManager layoutManager] alignView:arrowIconView
                                   toRefView:view
                                  withOffset:CGPointZero
                                      inView:view
                         withAlignmentOption:NSLayoutAttributeCenterY
                       andRefAlignmentOption:NSLayoutAttributeCenterY];
    
    [[LayoutManager layoutManager] alignView:arrowIconView
                                   toRefView:view
                                  withOffset:CGPointZero
                                      inView:view
                         withAlignmentOption:NSLayoutAttributeRight
                       andRefAlignmentOption:NSLayoutAttributeRight];
    
    //Add source and destination
    UIImageView* sourceIconImageView = [UIImageView new];
    [sourceIconImageView setBackgroundColor:[UIColor clearColor]];
    [sourceIconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [sourceIconImageView setImage:[UIImage imageNamed:@"icon_start.png"]];
    
    
    UIImageView* destIconImageView = [UIImageView new];
    [destIconImageView setBackgroundColor:[UIColor clearColor]];
    [destIconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  //  [view addSubview:destIconImageView];
    [destIconImageView setImage:[UIImage imageNamed:@"icon_end.png"]];
    
    [_sourceAddressLabel removeFromSuperview];
    _sourceAddressLabel = nil;
    _sourceAddressLabel = [UILabel new];
    [_sourceAddressLabel setText:[self sourceAddressText:_data]];
    [_sourceAddressLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_sourceAddressLabel setAdjustsFontSizeToFitWidth:YES];
    [_sourceAddressLabel setNumberOfLines:2];
    [_sourceAddressLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    [_destinationAddressLabel removeFromSuperview];
    _destinationAddressLabel = nil;
    _destinationAddressLabel = [UILabel new];
    [_destinationAddressLabel setText:[self destAddressText:_data]];
    [_destinationAddressLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_destinationAddressLabel setAdjustsFontSizeToFitWidth:YES];
    [_destinationAddressLabel setNumberOfLines:2];
    [_destinationAddressLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    
    UILabel* distanceLabel = [UILabel new];
    [distanceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [distanceLabel setBackgroundColor:[UIColor clearColor]];
    ///
    [distanceLabel setFont:[UIFont boldSystemFontOfSize:26.0]];
    [distanceLabel setTextAlignment:NSTextAlignmentRight];
    [distanceLabel setText:[_data[@"travelledDistance"] doubleValue] > 0 ?
     formatDistance([_data[@"travelledDistance"] doubleValue]) : @""];

    [_totalCostLabel removeFromSuperview];
    _totalCostLabel = [UILabel new];
    [_totalCostLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_totalCostLabel setBackgroundColor:[UIColor clearColor]];
    [_totalCostLabel setFont:[UIFont boldSystemFontOfSize:26.0]];
    [_totalCostLabel setTextAlignment:NSTextAlignmentRight];
    [_totalCostLabel setText:formatCurrency([_data[@"calculatedFare"] doubleValue])];
    
    
    
    
    {
        UIView* topView = [UIView new];
        [topView setBackgroundColor:[UIColor clearColor]];
        [topView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [view addSubview:topView];
        
        [[LayoutManager layoutManager] setWidthOfView:topView
                                           sameAsView:view
                                               inView:view
                                           multiplier:0.96
                                          andRelation:NSLayoutRelationEqual];
        
        [[LayoutManager layoutManager] alignView:topView
                                       toRefView:view
                                      withOffset:CGPointZero
                                          inView:view
                             withAlignmentOption:NSLayoutAttributeLeft
                           andRefAlignmentOption:NSLayoutAttributeLeft];
        
        UIView* bottomView = [UIView new];
        [bottomView setBackgroundColor:[UIColor clearColor]];
        [bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [view addSubview:bottomView];
        
        [[LayoutManager layoutManager] setWidthOfView:bottomView
                                           sameAsView:view
                                               inView:view
                                           multiplier:0.96
                                          andRelation:NSLayoutRelationEqual];
        
        [[LayoutManager layoutManager] alignView:bottomView
                                       toRefView:view
                                      withOffset:CGPointZero
                                          inView:view
                             withAlignmentOption:NSLayoutAttributeLeft
                           andRefAlignmentOption:NSLayoutAttributeLeft];
        
        [[LayoutManager layoutManager] layoutWithFormat:@"V:|-0-[topView]-0-[bottomView(topView)]-0-|"
                                           toParentView:view
                                              withViews:NSDictionaryOfVariableBindings(bottomView,topView)];
        
        
        //Configure top view
        {
            [topView addSubview:sourceIconImageView];
            [topView addSubview:_sourceAddressLabel];
            [topView addSubview:_totalCostLabel];
            
            [[LayoutManager layoutManager] alignView:sourceIconImageView
                                           toRefView:topView
                                          withOffset:CGPointZero
                                              inView:topView
                                 withAlignmentOption:NSLayoutAttributeCenterY
                               andRefAlignmentOption:NSLayoutAttributeCenterY];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"V:[sourceIconImageView(20)]"
                                               toParentView:topView
                                                  withViews:NSDictionaryOfVariableBindings(sourceIconImageView)];
            
        
            
            [[LayoutManager layoutManager] fillView:_sourceAddressLabel
                                             inView:topView isHorizontal:NO];
            
            [[LayoutManager layoutManager] fillView:_totalCostLabel
                                             inView:topView isHorizontal:NO];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"H:|-1-[sourceIconImageView(20)]-1-[_sourceAddressLabel]-2-[_totalCostLabel(100)]-0-|"
                                               toParentView:topView
                                                  withViews:NSDictionaryOfVariableBindings(sourceIconImageView,_sourceAddressLabel,_totalCostLabel)];
            
            
        }
        //configure bottom view
        {
            [bottomView addSubview:destIconImageView];
            [bottomView addSubview:_destinationAddressLabel];
            [bottomView addSubview:distanceLabel];
            
            [[LayoutManager layoutManager] alignView:destIconImageView
                                           toRefView:bottomView
                                          withOffset:CGPointZero
                                              inView:bottomView
                                 withAlignmentOption:NSLayoutAttributeCenterY
                               andRefAlignmentOption:NSLayoutAttributeCenterY];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"V:[destIconImageView(20)]"
                                               toParentView:bottomView
                                                  withViews:NSDictionaryOfVariableBindings(destIconImageView)];
            
            [[LayoutManager layoutManager] fillView:_destinationAddressLabel
                                             inView:bottomView isHorizontal:NO];
            
            [[LayoutManager layoutManager] fillView:distanceLabel
                                             inView:bottomView isHorizontal:NO];
            
            [[LayoutManager layoutManager] layoutWithFormat:@"H:|-1-[destIconImageView(20)]-1-[_destinationAddressLabel]-2-[distanceLabel(100)]-0-|"
                                               toParentView:bottomView
                                                  withViews:NSDictionaryOfVariableBindings(destIconImageView,_destinationAddressLabel,distanceLabel)];
        }
    }
}
- (void)updateUIForDistanceAndFare:(UIView*)view
                           andData:(NSDictionary*)data
{
    UIImageView* arrowIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow.png"]];
    [arrowIconView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:arrowIconView];
    
    UILabel* distanceLabel = [UILabel new];
    [distanceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:distanceLabel];
    [distanceLabel setBackgroundColor:[UIColor clearColor]];
    ///
    [distanceLabel setFont:[UIFont boldSystemFontOfSize:26.0]];
    [distanceLabel setTextAlignment:NSTextAlignmentLeft];
    [distanceLabel setText:[_data[@"travelledDistance"] doubleValue] > 0 ?
     formatDistance([_data[@"travelledDistance"] doubleValue]) : @""];
    ///
    [_totalCostLabel removeFromSuperview];
    _totalCostLabel = [UILabel new];
    [_totalCostLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:_totalCostLabel];
    [_totalCostLabel setBackgroundColor:[UIColor clearColor]];
    
    [[LayoutManager layoutManager] layoutWithFormat:@"H:|-2-[distanceLabel(_totalCostLabel)]-0-[_totalCostLabel]-2-[arrowIconView(10)]-0-|"
                                       toParentView:view
                                          withViews:NSDictionaryOfVariableBindings(distanceLabel,_totalCostLabel,arrowIconView)];
    
    [[LayoutManager layoutManager] layoutWithFormat:@"V:|-0-[distanceLabel(_totalCostLabel)]-0-|"
                                       toParentView:view
                                          withViews:NSDictionaryOfVariableBindings(distanceLabel,_totalCostLabel)];
    
    [[LayoutManager layoutManager] layoutWithFormat:@"V:|-0-[_totalCostLabel(distanceLabel)]-0-|"
                                       toParentView:view
                                          withViews:NSDictionaryOfVariableBindings(distanceLabel,_totalCostLabel)];
    
    [[LayoutManager layoutManager] layoutWithFormat:@"V:[arrowIconView(20)]"
                                       toParentView:view
                                          withViews:NSDictionaryOfVariableBindings(arrowIconView)];
    
    [[LayoutManager layoutManager] alignView:arrowIconView
                                   toRefView:view
                                  withOffset:CGPointZero
                                      inView:view
                         withAlignmentOption:NSLayoutAttributeCenterY
                       andRefAlignmentOption:NSLayoutAttributeCenterY];
    
    [_totalCostLabel setFont:[UIFont boldSystemFontOfSize:26.0]];
    [_totalCostLabel setTextAlignment:NSTextAlignmentRight];
    [_totalCostLabel setText:formatCurrency([_data[@"calculatedFare"] doubleValue])];
}
- (NSString*)sourceAddressText:(NSDictionary*)data
{
    //Set data
    Address* startAddress = [[AppDataBaseManager appDataBaseManager] addressWithId:data[@"startLocationId"]
                                                                      andJourneyId:data[@"selfId"]];
    
    
    
    return startAddress.addressLine1.length ? startAddress.addressLine1 : @"";
}
- (NSString*)destAddressText:(NSDictionary*)data
{
    Address* endAddress = [[AppDataBaseManager appDataBaseManager] addressWithId:_data[@"endLocationId"]
                                                                    andJourneyId:_data[@"selfId"]];
    
    return endAddress.addressLine1.length ? endAddress.addressLine1 : @"";
}
- (BOOL)isSourceDestinationSet:(NSDictionary*)data
{
    //Set data
    Address* startAddress = [[AppDataBaseManager appDataBaseManager] addressWithId:data[@"startLocationId"]
                                                                      andJourneyId:data[@"selfId"]];
    
    Address* endAddress = [[AppDataBaseManager appDataBaseManager] addressWithId:data[@"endLocationId"]
                                                                    andJourneyId:data[@"selfId"]];
    
    return !(![NSObject isValidObject:startAddress.addressLine1] || ![NSObject isValidObject:endAddress.addressLine1]);
}
@end
@interface HistoryViewController ()
{
    UITableView* _tableView;
    NSArray* _journeys;
}
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                              style:UITableViewStylePlain];
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView.layer setBorderColor:[[UIColor clearColor] CGColor]];
    [_tableView.layer setBorderWidth:1.0];
    [[LayoutManager layoutManager] fillView:_tableView
                                     inView:self.view];
    
    
    [_tableView setContentInset:UIEdgeInsetsMake(65.0,0,0,0)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _journeys = nil;
    _journeys = [[AppDataBaseManager appDataBaseManager] journeys];
    
    if(!_journeys)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@""
                                                       message:@"Oops, you havn't travelled with us yet!"
                                                      delegate:nil
                                             cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
        alert = nil;
        
        [self performSelector:@selector(goBack)
                   withObject:nil
                   afterDelay:1.0];
    }
    
    UIImage* image = [UIImage imageNamed:@"LeftArrow.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem*doneButton=[[UIBarButtonItem alloc] initWithImage:image
                                                  landscapeImagePhone:nil
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(goBack)];
    
    self.navigationItem.leftBarButtonItem = doneButton;
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark TebleView Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Journey* journey = _journeys[[indexPath row]];
    
    if(!journey.endLocationId || !journey.startLocationId)
    {
        return 70.0;
    }
    return 130.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_journeys count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    if(!cell)
    {
        cell = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"historyCell"];
        
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[_journeys[[indexPath row]] dictionary]];
    
    [dict setValue:@([indexPath row])
            forKey:@"index"];
    
    cell.data = dict;//Call layout
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    Journey* journey = _journeys[[indexPath row]];
    //Take to FareCalculator screen
    YouPayViewController* youPayVC = (YouPayViewController*)viewControllerFromStoryboard(@"Main",@"youPayViewController");
    //Create dict with
    //Service
    //Provider
    //SubCategory
    //TravelledDistance
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithDictionary:[journey dictionary]];
    [youPayVC setData:data];
    [self.navigationController pushViewController:youPayVC
                                         animated:YES];
}
#pragma Class Methods
- (void)configureCell:(UITableViewCell*)cell
         forIndexPath:(NSIndexPath*)indexPath
{
    if(!cell)
        return;
    //Add contentView
}
@end
