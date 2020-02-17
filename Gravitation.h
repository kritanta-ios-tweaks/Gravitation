#include <UIKit/UIKit.h>
#include <Foundation/Foundation.h>
#include <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#include <objc/runtime.h>
@interface SBIconListView : UIView  <UICollisionBehaviorDelegate>
//@property (nonatomic, retain) subviews
-(void)layoutIconsNow;
@property (nonatomic, assign) NSInteger iconsInRowForSpacingCalculation;
// ios 13
-(void)setVisibleColumnRange:(NSRange)range;
// ios 12
-(void)showIconImagesFromColumn:(NSInteger)arg1 toColumn:(NSInteger)arg2 totalColumns:(NSInteger)arg3 allowAnimations:(BOOL)arg4;
-(CGPoint)originForIconAtIndex:(NSUInteger)index;
@end
