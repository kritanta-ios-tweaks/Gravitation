#include "Gravitation.h"

// Custom properties for Gravitation
@interface SBIconListView (Gravitation)

@property (nonatomic, strong)CMMotionManager *gravitation_motionManager;
@property (nonatomic, retain)UIDynamicAnimator *gravitation_gravitationAnimator;
@property (nonatomic, retain)UIGravityBehavior *gravitation_gravitationBehavior;
@property (nonatomic, retain)UIFieldBehavior *gravitation_fingerGravBehavior;
@property (nonatomic, retain)UICollisionBehavior *gravitation_gravitationCollisionBehavior;
@property (nonatomic, assign)BOOL gravitation_observersAdded;
@property (nonatomic, assign)BOOL gravitation_isReadyForMemoryFuck;

@end


// #pragma Globals
// If the icons are currently unhinged
static BOOL _rtGravityActive = NO;

// Preferences
static BOOL _pfTweakEnabled = YES;
static BOOL _pfFingerGravityEnabled = YES;
//static BOOL _pfConglomerate = YES; // Try and find a way to let all icons into viewframe

NSDictionary *prefs = nil;

// Global toggle for animations
// #pragma Toggle Animations
void toggleAnimations()
{
    if (!_rtGravityActive && _pfTweakEnabled)[[NSNotificationCenter defaultCenter] postNotificationName:@"GravitationStart" object:nil];
    else  [[NSNotificationCenter defaultCenter] postNotificationName:@"GravitationStop" object:nil];
    _rtGravityActive = !_rtGravityActive;
}



// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//
//
// Hooks
// #pragma Hooks -=-=-=-=-=-=-
//
//
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-



%hook SBIconListView

%property (nonatomic, strong)CMMotionManager *gravitation_motionManager;
%property (nonatomic, retain)UIDynamicAnimator *gravitation_gravitationAnimator;
%property (nonatomic, retain)UIGravityBehavior *gravitation_gravitationBehavior;
%property (nonatomic, retain)UICollisionBehavior *gravitation_gravitationCollisionBehavior;
%property (nonatomic, retain)UIFieldBehavior *gravitation_fingerGravBehavior;
%property (nonatomic, assign)BOOL gravitation_observersAdded;
%property (nonatomic, assign)BOOL gravitation_isReadyForMemoryFuck;

- (id)init
{
    id o = %orig;
    
    return o;
}

- (void)layoutIconsNow
{
    %orig;
    if (!self.gravitation_observersAdded)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gravitation_startAnimations)name:@"GravitationStart" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gravitation_endAnimations)name:@"GravitationStop" object:nil];

        self.gravitation_observersAdded=YES;
    }
}


//
//    Hack to force all icon views to always be loaded into memory even
//        when they are off screen.
//
//    Default iOS behavior is to reuse icon views, which is smart, but
//         completely breaks the gravity engine. 
//
//  #pragma IconHack
//
- (void)setVisibleColumnRange:(NSRange)range
{
    // We need to wait until icons have been initially loaded, at least, to do this. 
    // Otherwise it will completely screw up icon labels (wtf apple??)
    if (self.gravitation_isReadyForMemoryFuck && range.length == 0)range.length = self.iconsInRowForSpacingCalculation;
    if (!_rtGravityActive)%orig(range);
}

// Hook both setter and getter in case they aren't called consecutively
- (NSRange)visibleColumnRange 
{
    NSRange range = %orig;
    if (self.gravitation_isReadyForMemoryFuck && range.length == 0)range.length = self.iconsInRowForSpacingCalculation;
    return range;
}

//  ios 12 version of the icon hack above
//    needs work
- (void)showIconImagesFromColumn:(NSInteger)arg1 toColumn:(NSInteger)arg2 totalColumns:(NSInteger)arg3 allowAnimations:(BOOL)arg4
{
    if (!(arg3==4))
    {
        %orig(0,3,4,NO);
    }
    else
        %orig(arg1, arg2, arg3, arg4);
}

// #pragma Animation Start/Stop
%new 
- (void)gravitation_startAnimations 
{
    if (_pfFingerGravityEnabled)[self setValue:@NO forKey:@"deliversTouchesForGesturesToSuperview"];
    self.gravitation_isReadyForMemoryFuck = YES;
    if ([self respondsToSelector:@selector(setVisibleColumnRange:)])
        [self setVisibleColumnRange:NSMakeRange(0,4)];
    else 
        [self showIconImagesFromColumn:0 toColumn:3 totalColumns:4 allowAnimations:NO];

    [self layoutIconsNow];
    //UIView *refView = (_pfConglomerate)? self.superview : self;
    self.gravitation_gravitationAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    self.gravitation_gravitationBehavior = [[UIGravityBehavior alloc] initWithItems:@[]];

    self.gravitation_gravitationCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
    self.gravitation_gravitationCollisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.gravitation_gravitationCollisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.gravitation_gravitationCollisionBehavior.collisionDelegate = self;

    if (self.gravitation_gravitationBehavior)
    {
        for (UIView *i in self.subviews)
        {
            if (![i.description containsString:@"SBIcon"])continue;
            if (![self.gravitation_gravitationBehavior.items containsObject:i])
            {
                [self.gravitation_gravitationBehavior addItem:i];
            }    
        }
    }
    if (self.gravitation_gravitationCollisionBehavior)
    {
        for (UIView *i in self.subviews)
        {
            if (![i.description containsString:@"SBIcon"])continue;
            if (![self.gravitation_gravitationCollisionBehavior.items containsObject:i])
            {
                [self.gravitation_gravitationCollisionBehavior addItem:i];
            }    
        }
    }

    __weak SBIconListView *weakSelf = self;

    self.gravitation_motionManager = [[CMMotionManager alloc] init];

    [self.gravitation_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] 
                                                        withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error)
        {

            if (error != nil)
            {
                NSLog(@"Error %@",error);
                return;
            }
            weakSelf.gravitation_gravitationBehavior.gravityDirection = CGVectorMake(motion.gravity.x * 3, -motion.gravity.y * 3);
        }
    ];
    [self.gravitation_gravitationAnimator addBehavior:self.gravitation_gravitationCollisionBehavior];
    [self.gravitation_gravitationAnimator addBehavior:self.gravitation_gravitationBehavior];
}

%new 
- (void)gravitation_endAnimations
{
    [self setValue:@YES forKey:@"deliversTouchesForGesturesToSuperview"];
      [self.gravitation_gravitationAnimator removeAllBehaviors];
 
      [UIView animateWithDuration:1.0
                            delay:0.0
           usingSpringWithDamping:.8
            initialSpringVelocity:5
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{                 
                   for (UIView *obj in self.subviews)
                    {
                       CGPoint origin = [self originForIconAtIndex:[self.subviews indexOfObject:obj]];
                       [(UIView *)obj setTransform:CGAffineTransformIdentity];
                       [(UIView *)obj setFrame:CGRectMake(origin.x, origin.y, ((UIView *)obj).frame.size.width, ((UIView *)obj).frame.size.height)];
                    }
               }
               completion:^(BOOL finished)
               {
               }];
    self.gravitation_gravitationAnimator = nil;
    self.gravitation_gravitationBehavior = nil;
    self.gravitation_gravitationCollisionBehavior = nil;
    self.gravitation_motionManager = nil;
}

// #pragma Collision Behavior

%new
- (void)collisionBehavior:(UICollisionBehavior *)behavior 
      beganContactForItem:(id)item 
   withBoundaryIdentifier:(id)identifier 
                  atPoint:(CGPoint)p
{
    // I'm leaving this here because eventually something fun can be done with it
}

%new
- (void)collisionBehavior:(UICollisionBehavior *)behavior 
      endedContactForItem:(id)item 
   withBoundaryIdentifier:(id)identifier
{
    // see previous comment
}

//    #pragma Touch Handling
- (void)touchesBegan:(NSSet *)touches 
           withEvent:(UIEvent *)event
{
    if (!_pfFingerGravityEnabled)return;
    UITouch *touch = [[event allTouches] anyObject];
      CGPoint point = [touch locationInView:touch.view];
    if (self.gravitation_fingerGravBehavior)
        self.gravitation_fingerGravBehavior.position = point;
    if (!self.gravitation_fingerGravBehavior)
    {
        self.gravitation_fingerGravBehavior = [UIFieldBehavior radialGravityFieldWithPosition:point];
        for (UIView *v in self.subviews)
        {
            [self.gravitation_fingerGravBehavior addItem:v];
        }
        self.gravitation_fingerGravBehavior.strength =50;
        self.gravitation_fingerGravBehavior.minimumRadius=100;
        self.gravitation_fingerGravBehavior.region = UIRegion.infiniteRegion; // swift? in my objc? more likely than you think!
        [self.gravitation_gravitationAnimator addBehavior:self.gravitation_fingerGravBehavior];
    }
}

- (void)touchesMoved:(NSSet *)touches 
           withEvent:(UIEvent *)event
{
    if (!_pfFingerGravityEnabled)return;
    UITouch *touch = [[event allTouches] anyObject];
      CGPoint point = [touch locationInView:touch.view];
    CGFloat force = (touch.force == 0)? 2 : touch.force;
    if (self.gravitation_fingerGravBehavior)
    {
        self.gravitation_fingerGravBehavior.strength =50*force;
        self.gravitation_fingerGravBehavior.position = point;
    }
}
- (void)touchesEnded:(NSSet *)touches 
           withEvent:(UIEvent *)event
           {
               if (!_pfFingerGravityEnabled)return;
               [self.gravitation_gravitationAnimator removeBehavior:self.gravitation_fingerGravBehavior];
               self.gravitation_fingerGravBehavior = nil;
           }

%end

// #pragma Gesture Handler

%hook SBHomeScreenWindow

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    %orig;
    if(event.type == UIEventSubtypeMotionShake)
    {
        toggleAnimations();
    }
}

%end


%hook SBRootFolderView 

// IDK if this actually helps us, but it cant hurt? /shrug

- (BOOL)hidesOffscreenCustomPageViews
{
    return NO;
}

%end


// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//
//
// Gravitation Preferences
// #pragma Preferences -=-=-=-=-=-=-
//
//
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


#define kIdentifier @"me.kritanta.gravitationprefs"
#define kSettingsChangedNotification (CFStringRef)@"me.kritanta.gravitationprefs/Prefs"
#define kSettingsPath @"/var/mobile/Library/Preferences/me.kritanta.gravitationprefs.plist"

static void *observer = NULL;

static void reloadPrefs()
{
    if ([NSHomeDirectory()isEqualToString:@"/var/mobile"])
    {
        CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

        if (keyList)
        {
            prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));

            if (!prefs)
            {
                prefs = [NSDictionary new];
            }
            CFRelease(keyList);
        }
    } 
    else 
    {
        prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
    }
}

static void preferencesChanged()
{
    CFPreferencesAppSynchronize((CFStringRef)kIdentifier);
    reloadPrefs();

    _pfTweakEnabled = [prefs objectForKey:@"tweakEnabled"] ? [[prefs valueForKey:@"tweakEnabled"] boolValue] : YES;
    _pfFingerGravityEnabled = [prefs objectForKey:@"fingerGravity"] ? [[prefs valueForKey:@"fingerGravity"] boolValue] : YES;
}

// #pragma constructor
%ctor 
{
    preferencesChanged();

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        &observer,
        (CFNotificationCallback)preferencesChanged,
        (CFStringRef)@"me.kritanta.gravitation/Prefs",
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );

    NSLog(@"Gravitation: Initialized");
}

