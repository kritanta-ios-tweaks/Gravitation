#include <Preferences/PSTableCell.h>
#include <CoreMotion/CoreMotion.h>
#include <QuartzCore/QuartzCore.h>

@interface PSGravityLinkCell : PSTableCell

@property (nonatomic, strong) CMMotionManager *gravitation_motionManager;
@property (nonatomic, retain) UIDynamicAnimator *gravitation_gravitationAnimator;
@property (nonatomic, retain) UIGravityBehavior *gravitation_gravitationBehavior;
@property (nonatomic, retain) UIFieldBehavior *gravitation_fingerGravBehavior;
@property (nonatomic, retain) UICollisionBehavior *gravitation_gravitationCollisionBehavior;

@end

@implementation PSGravityLinkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier 
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
        self.gravitation_gravitationAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.contentView];
        self.gravitation_gravitationBehavior = [[UIGravityBehavior alloc] initWithItems:@[]];

        self.gravitation_gravitationCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
        self.gravitation_gravitationCollisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        self.gravitation_gravitationCollisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
        //self.gravitation_gravitationCollisionBehavior.collisionDelegate = self;

        if (self.gravitation_gravitationBehavior)
        {
            for (UIView *i in self.contentView.subviews)
            {
                if (![self.gravitation_gravitationBehavior.items containsObject:i])
                {
                    [self.gravitation_gravitationBehavior addItem:i];
                }	
            }
        }
        if (self.gravitation_gravitationCollisionBehavior)
        {
            for (UIView *i in self.contentView.subviews)
            {
                if (![self.gravitation_gravitationCollisionBehavior.items containsObject:i])
                {
                    [self.gravitation_gravitationCollisionBehavior addItem:i];
                }	
            }
        }

        __weak PSGravityLinkCell *weakSelf = self;

        self.gravitation_motionManager = [[CMMotionManager alloc] init];

        [self.gravitation_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {

            if (error != nil) {
                NSLog(@"Error %@",error);
                return;
            }
            weakSelf.gravitation_gravitationBehavior.gravityDirection = CGVectorMake(motion.gravity.x * 3, -motion.gravity.y * 3);
            //        self.bkView.transform = CGAffineTransformMakeRotation(atan2(motion.gravity.x, motion.gravity.y) - M_PI);
        }];
        [self.gravitation_gravitationAnimator addBehavior:self.gravitation_gravitationCollisionBehavior];
        [self.gravitation_gravitationAnimator addBehavior:self.gravitation_gravitationBehavior];
	}

	return self;
}

@end