#import <Preferences/PSListController.h>
#include <CoreMotion/CoreMotion.h>
#include <QuartzCore/QuartzCore.h>

@interface GRVRootListController : PSListController

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, strong) CMMotionManager *gravitation_motionManager;
@property (nonatomic, retain) UIDynamicAnimator *gravitation_gravitationAnimator;
@property (nonatomic, retain) UIGravityBehavior *gravitation_gravitationBehavior;
@property (nonatomic, retain) UIFieldBehavior *gravitation_fingerGravBehavior;
@property (nonatomic, retain) UICollisionBehavior *gravitation_gravitationCollisionBehavior;
@end
