//
//  LayoutManager.m
//  MarutiSuzukiSales
//
//  Created by Vectorform 2 on 3/26/13.
//  Copyright (c) 2013 Vectorform. All rights reserved.
//

#import "LayoutManager.h"
static LayoutManager* layoutManager;
@implementation LayoutManager
+ (LayoutManager *)layoutManager
{
    @synchronized(self)
    {
        if (!layoutManager)
        {
            layoutManager = [[LayoutManager alloc] init];
        }
        return layoutManager;
    }
}
- (id)init
{
    self = [super init];
    if(self)
    {
        return self;
    }
    return nil;
}

#pragma mark autoLayoutPLacement
- (void)placeLeftView:(UIView*)view
              refView:(UIView*)refView
           parentView:(UIView*)superView
           withOffset:(CGPoint)offset
         andAlignment:(ViewPlacementAlignmentOption)alignmentOption
{
    if(!superView || !view)
    {
        return;
    }
    NSLayoutAttribute attribute;
    switch (alignmentOption) {
        case PLACEMENT_ALIGN_TOP:
        {
            attribute = NSLayoutAttributeTop;
        }
            break;
        case PLACEMENT_ALIGN_BOTTOM:
        {
            attribute = NSLayoutAttributeBottom;
        }
            break;
        case PLACEMENT_ALIGN_CENTER:
        {
            attribute = NSLayoutAttributeCenterY;
        }
            break;
        default:
            attribute = NSLayoutAttributeLeading;
            break;
    }
    //Position the X
    NSLayoutConstraint* constraintX =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:refView
                                      attribute:NSLayoutAttributeLeft
                                      multiplier:1.0
                                      constant:offset.x];
    
    
    [superView addConstraint:constraintX];
    
    
  //  SAFE_IF_RELEASE(constraintX);//Null
    
    if(alignmentOption != PLACEMENT_ALIGN_NONE)
    {
        //Possition the Top
        NSLayoutConstraint *constraintY =[NSLayoutConstraint
                                          constraintWithItem:view
                                          attribute:attribute
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:refView
                                          attribute:attribute
                                          multiplier:1.0
                                          constant:offset.y];
        
        [superView addConstraint:constraintY];
        
      //  SAFE_IF_RELEASE(constraintY);//Null
    }
    
    
    
   
    
}
- (void)placeRightView:(UIView*)view
               refView:(UIView*)refView
            parentView:(UIView*)superView
            withOffset:(CGPoint)offset
          andAlignment:(ViewPlacementAlignmentOption)alignmentOption

{
    if(!superView || !view)
    {
        return;
    }
    NSLayoutAttribute attribute;
    switch (alignmentOption) {
        case PLACEMENT_ALIGN_TOP:
        {
            attribute = NSLayoutAttributeTop;
        }
            break;
        case PLACEMENT_ALIGN_BOTTOM:
        {
            attribute = NSLayoutAttributeBottom;
        }
            break;
        case PLACEMENT_ALIGN_CENTER:
        {
            attribute = NSLayoutAttributeCenterY;
        }
            break;
            
        default:
            attribute = NSLayoutAttributeLeading;
            break;
    }
    //Position the X
    NSLayoutConstraint* constraintX =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:refView
                                      attribute:NSLayoutAttributeRight
                                      multiplier:1.0
                                      constant:offset.x];
    
    
    if(alignmentOption != PLACEMENT_ALIGN_NONE)
    {
        //Possition the Top
        NSLayoutConstraint *constraintY =[NSLayoutConstraint
                                          constraintWithItem:view
                                          attribute:attribute
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:refView
                                          attribute:attribute
                                          multiplier:1.0
                                          constant:offset.y];
        
        [superView addConstraint:constraintY];
        
      //  SAFE_IF_RELEASE(constraintY);//Null
    }
    
    
    
    
    [superView addConstraint:constraintX];
    
    
 //   SAFE_IF_RELEASE(constraintX);//Null
    
}
- (void)placeBelowView:(UIView*)view
               refView:(UIView*)refView
            parentView:(UIView*)superView
            withOffset:(CGPoint)offset
          andAlignment:(ViewPlacementAlignmentOption)alignmentOption
{
    if(!superView || !view)
    {
        return;
    }
    NSLayoutAttribute attribute;
    
    switch (alignmentOption) {
        case PLACEMENT_ALIGN_LEFT:
        {
            attribute = NSLayoutAttributeLeading;
        }
            break;
        case PLACEMENT_ALIGN_RIGHT:
        {
            attribute = NSLayoutAttributeTrailing;
        }
            break;
        case PLACEMENT_ALIGN_CENTER:
        {
            attribute = NSLayoutAttributeCenterX;
        }
            break;
            
        default:
            attribute = NSLayoutAttributeLeading;
            break;
    }
    //Position the X
    NSLayoutConstraint* constraintX =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:attribute
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:refView
                                      attribute:attribute
                                      multiplier:1.0
                                      constant:offset.x];
    
    
    
    
    //Possition the Top
    NSLayoutConstraint *constraintY =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:refView
                                      attribute:NSLayoutAttributeBottom
                                      multiplier:1.0
                                      constant:offset.y];
    
    
    [superView addConstraint:constraintX];
    [superView addConstraint:constraintY];
    
 //   SAFE_IF_RELEASE(constraintX);//Null
   // SAFE_IF_RELEASE(constraintY);//Null
}
- (void)placeAboveView:(UIView*)view
               refView:(UIView*)refView
            parentView:(UIView*)superView
            withOffset:(CGPoint)offset
          andAlignment:(ViewPlacementAlignmentOption)alignmentOption
{
    if(!superView || !view)
    {
        return;
    }
    
    NSLayoutAttribute attribute;
    
    switch (alignmentOption) {
        case PLACEMENT_ALIGN_LEFT:
        {
            attribute = NSLayoutAttributeLeading;
        }
            break;
        case PLACEMENT_ALIGN_RIGHT:
        {
            attribute = NSLayoutAttributeTrailing;
        }
            break;
            
        default:
            attribute = NSLayoutAttributeLeading;
            break;
    }
    if(alignmentOption != PLACEMENT_ALIGN_NONE)
    {
        //Position the X
        NSLayoutConstraint* constraintX =[NSLayoutConstraint
                                          constraintWithItem:view
                                          attribute:attribute
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:refView
                                          attribute:attribute
                                          multiplier:1.0
                                          constant:offset.x];
        
        [superView addConstraint:constraintX];
     //   SAFE_IF_RELEASE(constraintX);//Null
        
    }
    
    
    
    
    //Possition the Top
    NSLayoutConstraint *constraintY =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:refView
                                      attribute:NSLayoutAttributeTop
                                      multiplier:1.0
                                      constant:offset.y];
    
    
    
    [superView addConstraint:constraintY];
    
    
  //  SAFE_IF_RELEASE(constraintY);//Null
}
- (void)placeSubview:(UIView*)view
             refView:(UIView*)refView
              toView:(UIView*)baseView
          withOffset:(CGPoint)offset
 withPlacementOption:(ViewPlacementOption)viewPlacementOptions
  andALignmentOption:(ViewPlacementAlignmentOption)alignmentOption
{
    //adjust the layouting with option
    switch (viewPlacementOptions) {
        case PLACEMENT_ABOVE:
        {
            [self placeAboveView:view
                         refView:refView
                      parentView:baseView
                      withOffset:offset
                    andAlignment:alignmentOption];
            
        }
            break;
        case PLACEMENT_BELOW:
        {
            [self placeBelowView:view
                         refView:refView
                      parentView:baseView
                      withOffset:offset
                    andAlignment:alignmentOption];
            
        }
            break;
        case PLACEMENT_LEFT:
        {
            [self placeLeftView:view
                        refView:refView
                     parentView:baseView
                     withOffset:offset
                   andAlignment:alignmentOption];
            
        }
            break;
        case PLACEMENT_RIGHT:
        {
            [self placeRightView:view
                         refView:refView
                      parentView:baseView
                      withOffset:offset
                    andAlignment:alignmentOption];
            
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark autoLayoutPosition
- (NSLayoutConstraint*)positionOnTopView:(UIView*)view
                              parentView:(UIView*)superView
                              withOffset:(CGFloat)offset
{
    if(!superView || !view)
    {
        return nil;
    }
    //
    
    
    
    //Possition the Top
    NSLayoutConstraint *constraintY =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:superView
                                      attribute:NSLayoutAttributeTop
                                      multiplier:1.0
                                      constant:offset];
    
    
    //  [superView addConstraint:constraintX];
    [superView addConstraint:constraintY];
    
    //    SAFE_IF_RELEASE(constraintX);//Null
    // SAFE_IF_RELEASE(constraintY);//Null
    return constraintY;
    
}
- (NSLayoutConstraint*)positionOnRightView:(UIView*)view
                                parentView:(UIView*)superView
                                withOffset:(CGFloat)offset
{
    if(!superView || !view)
    {
        return nil;
    }
    
    //Position the X
    NSLayoutConstraint* constraintX =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeRight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:superView
                                      attribute:NSLayoutAttributeRight
                                      multiplier:1.0
                                      constant:offset];
    
    
    [superView addConstraint:constraintX];
    
    //    SAFE_IF_RELEASE(constraintX);//Null
    //   SAFE_IF_RELEASE(constraintY);//Null
    return constraintX;
}
- (NSLayoutConstraint*)positionOnLeftView:(UIView*)view
                               parentView:(UIView*)superView
                               withOffset:(CGFloat)offset
{
    if(!superView || !view)
    {
        return nil;
    }
    
    //Position the X
    NSLayoutConstraint* constraintX =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeLeft
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:superView
                                      attribute:NSLayoutAttributeLeft
                                      multiplier:1.0
                                      constant:offset];
    
    
    
    
    
    [superView addConstraint:constraintX];
    //    [superView addConstraint:constraintY];
    
    //  SAFE_IF_RELEASE(constraintX);//Null
    //  SAFE_IF_RELEASE(constraintY);//Null
    return constraintX;
}
- (NSLayoutConstraint*)positionOnBottomView:(UIView*)view
                                 parentView:(UIView*)superView
                                 withOffset:(CGFloat)offset
{
    if(!superView || !view)
    {
        return nil;
    }
    
    
    //Possition the Top
    NSLayoutConstraint *constraintY =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:superView
                                      attribute:NSLayoutAttributeBottom
                                      multiplier:1.0
                                      constant:offset];
    
    
    [superView addConstraint:constraintY];
    
    return constraintY;
}
- (NSLayoutConstraint*)positionVCenterView:(UIView*)view
                                parentView:(UIView*)superView
                                withOffset:(CGFloat)offset
{
    if(!superView || !view)
    {
        return nil;
    }
    
    
    //Possition the Top
    NSLayoutConstraint *constraintY =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:superView
                                      attribute:NSLayoutAttributeCenterY
                                      multiplier:1.0
                                      constant:offset];
    
    
    [superView addConstraint:constraintY];
    
    return constraintY;
}
- (NSLayoutConstraint*)positionHCenterView:(UIView*)view
                                parentView:(UIView*)superView
                                withOffset:(CGFloat)offset
{
    if(!superView || !view)
    {
        return nil;
    }
    
    
    //Possition the Top
    NSLayoutConstraint *constraintX =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:superView
                                      attribute:NSLayoutAttributeCenterX
                                      multiplier:1.0
                                      constant:offset];
    
    
    [superView addConstraint:constraintX];
    
    return constraintX;
}
- (void)positionOnCenterView:(UIView*)view
                  parentView:(UIView*)superView
                  withOffset:(CGPoint)offset

{
    if(!superView || !view)
    {
        return;
    }
    
    //Position the X
    NSLayoutConstraint* constraintX =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:superView
                                      attribute:NSLayoutAttributeCenterX
                                      multiplier:1.0
                                      constant:offset.x];
    
    
    
    
    //Possition the Y
    NSLayoutConstraint *constraintY =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:superView
                                      attribute:NSLayoutAttributeCenterY
                                      multiplier:1.0
                                      constant:offset.y];
    
    
    [superView addConstraint:constraintX];
    [superView addConstraint:constraintY];
    
 //   SAFE_IF_RELEASE(constraintX);//Null
  //  SAFE_IF_RELEASE(constraintY);//Null
}
- (NSArray*)setFrame:(CGRect)frame ofView:(UIView*)view inView:(UIView*)parentView
{
    [self setOrigin:frame.origin ofView:view inView:parentView];
    [self setSize:frame.size ofView:view inView:parentView];
    
    return nil;
}
- (NSArray*)setOrigin:(CGPoint)origin ofView:(UIView*)view inView:(UIView*)parentView
{
    
    NSLayoutConstraint* constraintX = [[LayoutManager layoutManager] positionSubview:view toView:parentView withOffset:CGPointMake(origin.x, 0) andPositionOption:POS_LEFT];
    NSLayoutConstraint* constraintY = [[LayoutManager layoutManager] positionSubview:view toView:parentView withOffset:CGPointMake(0, origin.y) andPositionOption:POS_TOP];
    
    return @[constraintX,constraintY];
}
- (NSArray*)setSize:(CGSize)size ofView:(UIView*)view inView:(UIView*)pParentView
{
    //Will draw this view in center
    NSLayoutConstraint* widthConstraint;
    NSLayoutConstraint* heightConstraint;
    
    
//    NSDictionary *viewsDictionary =
//    NSDictionaryOfVariableBindings(view);
//    
//    NSArray *verticalConstraints =
//    [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[view(%f)]",size.width]
//                                            options:0
//                                            metrics:nil
//                                              views:viewsDictionary];
//    
//    [pParentView addConstraints:verticalConstraints];
//    
//    
//    verticalConstraints =
//    [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[view(%f)]",size.height]
//                                            options:0
//                                            metrics:nil
//                                              views:viewsDictionary];
//    [pParentView addConstraints:verticalConstraints];
    
    widthConstraint = [[LayoutManager layoutManager] setWidth:size.width
                                                       ofView:view
                                                       inView:pParentView
                                                  andRelation:NSLayoutRelationEqual];
    
    
    heightConstraint = [[LayoutManager layoutManager] setHeight:size.height
                                                       ofView:view
                                                       inView:pParentView
                                                  andRelation:NSLayoutRelationEqual];
    
    
    
    return @[widthConstraint,heightConstraint];
    
    
}
- (NSLayoutConstraint*)setHeightOfView:(UIView*)view sameAsView:(UIView*)refView
                          inView:(UIView*)pParentView multiplier:(CGFloat)multiplier andRelation:(NSLayoutRelation)relation
{
    if(!pParentView || !view)
    {
        return nil;
    }
    //Possition the Top
    NSLayoutConstraint *constraintY =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:relation
                                      toItem:refView
                                      attribute:NSLayoutAttributeHeight
                                      multiplier:multiplier
                                      constant:0];
    
    
    [pParentView addConstraint:constraintY];
    
    return constraintY;
}
- (NSLayoutConstraint*)setHeight:(CGFloat)height ofView:(UIView*)view inView:(UIView*)pParentView andRelation:(NSLayoutRelation)relation
{
    if(!pParentView || !view)
    {
        return nil;
    }
    //Possition the Top
    NSLayoutConstraint *constraintY =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:relation
                                      toItem:nil
                                      attribute:0
                                      multiplier:1.0
                                      constant:height];
    

    [pParentView addConstraint:constraintY];

    return constraintY;
    
    

}

- (NSLayoutConstraint*)setWidthOfView:(UIView*)view sameAsView:(UIView*)refView
                         inView:(UIView*)pParentView multiplier:(CGFloat)multiplier andRelation:(NSLayoutRelation)relation
{
    if(!pParentView || !view)
    {
        return nil;
    }
    //Possition the Top
    NSLayoutConstraint *constraintX =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:relation
                                      toItem:refView
                                      attribute:NSLayoutAttributeWidth
                                      multiplier:multiplier
                                      constant:0];
    
    
    [pParentView addConstraint:constraintX];
    
    return constraintX;
}
- (NSLayoutConstraint*)setWidth:(CGFloat)width ofView:(UIView*)view inView:(UIView*)pParentView andRelation:(NSLayoutRelation)relation
{

    if(!pParentView || !view)
    {
        return nil;
    }
    //Possition the Top
    NSLayoutConstraint *constraintX =[NSLayoutConstraint
                                      constraintWithItem:view
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:relation
                                      toItem:nil
                                      attribute:0
                                      multiplier:1.0
                                      constant:width];
    

    [pParentView addConstraint:constraintX];

    return constraintX;
}
- (void)setHeightOfView:(UIView*)view sameAs:(UIView*)refView inView:(UIView*)pParentView
{
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(view,refView);
    NSArray* verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(refView)]"
                                            options:0
                                            metrics:nil
                                              views:viewsDictionary];
    
    [pParentView addConstraints:verticalConstraints];
}
- (void)setWidthOfView:(UIView*)view sameAs:(UIView*)refView inView:(UIView*)pParentView
{
    //Will draw this view in center
    NSDictionary *viewsDictionary =
    NSDictionaryOfVariableBindings(view,refView);
    
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(refView)]"
                                            options:0
                                            metrics:nil
                                              views:viewsDictionary];
    
    [pParentView addConstraints:horizontalConstraints];
}
- (NSLayoutConstraint*)positionSubview:(UIView*)view
                                toView:(UIView*)baseView
                            withOffset:(CGPoint)offset
                     andPositionOption:(ViewPositionOption)viewPositionOptions
{
    switch (viewPositionOptions) {
        case POS_TOP:
        {
            return [self positionOnTopView:view
                                parentView:baseView
                                withOffset:offset.y];
        }
            break;
        case POS_BOTTOM:
        {
            return [self positionOnBottomView:view
                                   parentView:baseView
                                   withOffset:offset.y];
        }
            break;
        case POS_LEFT:
        {
            return [self positionOnLeftView:view
                                 parentView:baseView
                                 withOffset:offset.x];
        }
            break;
        case POS_RIGHT:
        {
            return [self positionOnRightView:view
                                  parentView:baseView
                                  withOffset:offset.x];
        }
            break;
        case POS_CENTER:
        {
            [self positionOnCenterView:view
                            parentView:baseView
                            withOffset:offset];
            return nil;
        }
            break;
        case POS_H_CENTER:
        {
            return [self positionHCenterView:view
                                  parentView:baseView
                                  withOffset:offset.x];
        }
            break;
        case POS_V_CENTER:
        {
            return [self positionVCenterView:view
                                  parentView:baseView
                                  withOffset:offset.y];
        }
            break;
            
        default:
            break;
    }
    return nil;
    
}
- (void)fillView:(UIView*)view inView:(UIView*)parentView
{
    [self fillView:view inView:parentView isHorizontal:YES];
    [self fillView:view inView:parentView isHorizontal:NO];
}
- (void)fillView:(UIView*)view inView:(UIView*)parentView isHorizontal:(BOOL)horizontal
{
    if(horizontal)
    {
        [self positionSubview:view toView:parentView withOffset:CGPointZero andPositionOption:POS_LEFT];
        [self positionSubview:view toView:parentView withOffset:CGPointZero andPositionOption:POS_RIGHT];
    }
    else
    {
        [self positionSubview:view toView:parentView withOffset:CGPointZero andPositionOption:POS_TOP];
        [self positionSubview:view toView:parentView withOffset:CGPointZero andPositionOption:POS_BOTTOM];
    }
}

- (void)fillView:(UIView*)view inView:(UIView*)parentView withOffset:(CGPoint)offset
{
    [self positionSubview:view toView:parentView withOffset:offset andPositionOption:POS_LEFT];
    [self positionSubview:view toView:parentView withOffset:CGPointMake(-offset.x, 0) andPositionOption:POS_RIGHT];
    
    [self positionSubview:view toView:parentView withOffset:offset andPositionOption:POS_TOP];
    [self positionSubview:view toView:parentView withOffset:CGPointMake(0, -offset.y) andPositionOption:POS_BOTTOM];
}
- (void)fillView:(UIView*)view inView:(UIView*)parentView isHorizontal:(BOOL)horizontal withOffset:(CGPoint)offset
{
    if(horizontal)
    {
        [self positionSubview:view toView:parentView withOffset:offset andPositionOption:POS_RIGHT];
        [self positionSubview:view toView:parentView withOffset:offset andPositionOption:POS_LEFT];
    }
    else
    {
        [self positionSubview:view toView:parentView withOffset:offset andPositionOption:POS_BOTTOM];
        [self positionSubview:view toView:parentView withOffset:offset andPositionOption:POS_TOP];
    }
}
- (void)layoutWithFormat:(NSString*)format
            toParentView:(UIView*)parentView
               withViews:(NSDictionary*)dict
{
    NSArray* constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:format
                                            options:0
                                            metrics:nil
                                              views:dict];
    
    [parentView addConstraints:constraints];
}
- (void)layoutWithFormat:(NSString*)format
            toParentView:(UIView*)parentView
             withOptions:(NSLayoutFormatOptions)options
               withViews:(NSDictionary*)dict
{
    NSArray* constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:format
                                            options:options
                                            metrics:nil
                                              views:dict];
    
    [parentView addConstraints:constraints];
}
- (void)fluidConstraintWithItems:(NSDictionary *) dictViews
                        asString:(NSArray *) stringViews
                       alignAxis:(NSString *) axis
                  verticalMargin:(NSUInteger) vMargin
                horizontalMargin:(NSUInteger) hMargin
                     innerMargin:(NSUInteger) iMargin
                          inView:(UIView*)parentView
{
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity: dictViews.count];
    NSMutableString *globalFormat = [NSMutableString stringWithFormat:@"%@:|-%lu-",
                                     axis,
                                     (unsigned long)([axis isEqualToString:@"V"] ? vMargin : hMargin)
                                     ];
    
    
    
    for (NSUInteger i = 0; i < dictViews.count; i++) {
        
        if (i == 0)
            [globalFormat appendString:[NSString stringWithFormat: @"[%@]-%lu-", stringViews[i], (unsigned long)iMargin]];
        else if(i == dictViews.count - 1)
            [globalFormat appendString:[NSString stringWithFormat: @"[%@(==%@)]-", stringViews[i], stringViews[i-1]]];
        else
            [globalFormat appendString:[NSString stringWithFormat: @"[%@(==%@)]-%lu-", stringViews[i], stringViews[i-1], (unsigned long)iMargin]];
        
        NSString *localFormat = [NSString stringWithFormat: @"%@:|-%lu-[%@]-%lu-|",
                                 [axis isEqualToString:@"V"] ? @"H" : @"V",
                                 (unsigned long)([axis isEqualToString:@"V"] ? hMargin : vMargin),
                                 stringViews[i],
                                 (unsigned long)([axis isEqualToString:@"V"] ? hMargin : vMargin)];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:localFormat
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:dictViews]];
        
        
    }
    [globalFormat appendString:[NSString stringWithFormat:@"%lu-|",
                                (unsigned long)([axis isEqualToString:@"V"] ? vMargin : hMargin)
                                ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:globalFormat
                                                                             options:0
                                                                             metrics:nil
                                                                               views:dictViews]];
    
    
    [parentView addConstraints:constraints];
}
- (NSLayoutConstraint*)alignView:(UIView*)view
                       toRefView:(UIView*)refView
                      withOffset:(CGPoint)offset
                          inView:(UIView*)parentView
             withAlignmentOption:(NSLayoutAttribute)option
           andRefAlignmentOption:(NSLayoutAttribute)optionRef
{
    NSLayoutConstraint* constraint;
    
    //Possition the Top
    constraint =[NSLayoutConstraint
                  constraintWithItem:view
                  attribute:option
                  relatedBy:NSLayoutRelationEqual
                  toItem:refView
                  attribute:optionRef
                  multiplier:1.0
                  constant:offset.x];
    
    
    [parentView addConstraint:constraint];
    
    return constraint;
}
- (NSLayoutConstraint*)alignView:(UIView*)view toRefView:(UIView*)refView withOffset:(CGPoint)offset inView:(UIView*)parentView withAlignmentOption:(ViewPlacementOption)option
{
    switch (option) {
        case PLACEMENT_LEFT:
        {
            return [self leftAlignView:view toRefView:refView withOffset:offset inView:parentView];
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}
- (NSLayoutConstraint*)leftAlignView:(UIView*)view toRefView:(UIView *)refView withOffset:(CGPoint)offset inView:(UIView *)parentView
{
    NSLayoutConstraint* constraintX;
    
    //Possition the Top
    constraintX =[NSLayoutConstraint
                  constraintWithItem:view
                  attribute:NSLayoutAttributeLeft
                  relatedBy:NSLayoutRelationEqual
                  toItem:refView
                  attribute:NSLayoutAttributeLeft
                  multiplier:1.0
                  constant:offset.x];
    
    
    [parentView addConstraint:constraintX];
    
    return constraintX;
}
- (NSLayoutConstraint*)setCenterOfView:(UIView*)view
                                inView:(UIView*)superView
                              constant:(CGFloat)centerValue
                         isHorizontal:(BOOL)horizontal
{
    if(!superView || !view)
    {
        return nil;
    }
    if(!horizontal)//vertical
    {
        
        
        
        //Possition the Top
        NSLayoutConstraint *constraintY =[NSLayoutConstraint
                                          constraintWithItem:view
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:0
                                          toItem:nil
                                          attribute:0
                                          multiplier:1.0
                                          constant:centerValue];
        
        
        [superView addConstraint:constraintY];
        
        return constraintY;
    }
    else
    {
        //Possition the Top
        NSLayoutConstraint *constraintX =[NSLayoutConstraint
                                          constraintWithItem:view
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:0
                                          toItem:nil
                                          attribute:0
                                          multiplier:1.0
                                          constant:centerValue];
        
        
        [superView addConstraint:constraintX];
        
        return constraintX;
    }
}

@end
