//
//  LayoutManager.h
//  MarutiSuzukiSales
//
//  Created by Vectorform 2 on 3/26/13.
//  Copyright (c) 2013 Vectorform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum
{
    PLACEMENT_BELOW,
    PLACEMENT_LEFT,
    PLACEMENT_RIGHT,
    PLACEMENT_ABOVE
}ViewPlacementOption;


typedef enum
{
    PLACEMENT_ALIGN_LEFT,
    PLACEMENT_ALIGN_RIGHT,
    PLACEMENT_ALIGN_TOP,
    PLACEMENT_ALIGN_BOTTOM,
    PLACEMENT_ALIGN_CENTER,
    PLACEMENT_ALIGN_NONE
}ViewPlacementAlignmentOption;

typedef enum
{
    POS_LEFT,
    POS_RIGHT,
    POS_CENTER,
    POS_V_CENTER,
    POS_H_CENTER,
    POS_TOP,
    POS_BOTTOM
}ViewPositionOption;


@interface LayoutManager : NSObject
{
    
    
}
+ (LayoutManager*)layoutManager;

- (void)placeSubview:(UIView*)view
             refView:(UIView*)refView
              toView:(UIView*)baseView
          withOffset:(CGPoint)offset
 withPlacementOption:(ViewPlacementOption)viewPlacementOptions
  andALignmentOption:(ViewPlacementAlignmentOption)alignmentOption;

- (NSLayoutConstraint*)positionSubview:(UIView*)view
                                toView:(UIView*)baseView
                            withOffset:(CGPoint)offset
                     andPositionOption:(ViewPositionOption)viewPositionOptions;


- (NSArray*)setFrame:(CGRect)frame ofView:(UIView*)view inView:(UIView*)parentView;
- (NSArray*)setOrigin:(CGPoint)origin ofView:(UIView*)view inView:(UIView*)parentView;
- (NSArray*)setSize:(CGSize)size ofView:(UIView*)view inView:(UIView*)pParentView;
- (NSLayoutConstraint*)setHeight:(CGFloat)height ofView:(UIView*)view inView:(UIView*)pParentView andRelation:(NSLayoutRelation)relation;
- (NSLayoutConstraint*)setWidth:(CGFloat)width ofView:(UIView*)view inView:(UIView*)pParentView andRelation:(NSLayoutRelation)relation;


- (NSLayoutConstraint*)setWidthOfView:(UIView*)view sameAsView:(UIView*)refView
                               inView:(UIView*)pParentView multiplier:(CGFloat)multiplier andRelation:(NSLayoutRelation)relation;


- (NSLayoutConstraint*)setHeightOfView:(UIView*)view sameAsView:(UIView*)refView
                                inView:(UIView*)pParentView multiplier:(CGFloat)multiplier andRelation:(NSLayoutRelation)relation;


- (void)setHeightOfView:(UIView*)view sameAs:(UIView*)refView inView:(UIView*)pParentView;
- (void)setWidthOfView:(UIView*)view sameAs:(UIView*)refView inView:(UIView*)pParentView;
- (void)fillView:(UIView*)view inView:(UIView*)parentView;
- (void)fillView:(UIView*)view inView:(UIView*)parentView isHorizontal:(BOOL)horizontal;
- (void)fillView:(UIView*)view inView:(UIView*)parentView withOffset:(CGPoint)offset;
- (void)fillView:(UIView*)view inView:(UIView*)parentView isHorizontal:(BOOL)horizontal withOffset:(CGPoint)offset;
- (void)layoutWithFormat:(NSString*)format
            toParentView:(UIView*)parentView
               withViews:(NSDictionary*)dict;
- (void)layoutWithFormat:(NSString*)format
            toParentView:(UIView*)parentView
             withOptions:(NSLayoutFormatOptions)options
               withViews:(NSDictionary*)dict;


- (NSLayoutConstraint*)setCenterOfView:(UIView*)view
                                inView:(UIView*)superView
                              constant:(CGFloat)centerValue
                         isHorizontal:(BOOL)horizontal;
- (void)fluidConstraintWithItems:(NSDictionary *) views
                        asString:(NSArray *) stringViews
                       alignAxis:(NSString *) axis
                  verticalMargin:(NSUInteger) vMargin
                horizontalMargin:(NSUInteger) hMargin
                     innerMargin:(NSUInteger) inner
                          inView:(UIView*)parentView;

- (NSLayoutConstraint*)alignView:(UIView*)view toRefView:(UIView*)refView withOffset:(CGPoint)offset inView:(UIView*)parentView withAlignmentOption:(ViewPlacementOption)option;

- (NSLayoutConstraint*)alignView:(UIView*)view
                       toRefView:(UIView*)refView
                      withOffset:(CGPoint)offset
                          inView:(UIView*)parentView
withAlignmentOption:(NSLayoutAttribute)option andRefAlignmentOption:(NSLayoutAttribute)option;
@end
