#include "GRVRootListController.h"

@implementation GRVRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	// [UIColor colorWithRed:0.00 green:0.27 blue:0.35 alpha:1.0];

	self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, 100)];
	self.headerView.backgroundColor = [UIColor colorWithRed:0.07 green:0.20 blue:0.13 alpha:1.0];

	// TODO: not this lol

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 30, 50)];
	label.font = [UIFont boldSystemFontOfSize:25];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.numberOfLines = 1;
	label.text = @"G";
	[self.headerView addSubview:label];

	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 30, 50)];
	label2.font = [UIFont boldSystemFontOfSize:25];
	label2.textAlignment = NSTextAlignmentCenter;
	label2.textColor = [UIColor whiteColor];
	label2.numberOfLines = 1;
	
	label2.text = @"R";
	[self.headerView addSubview:label2];

	UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 30, 50)];
	label3.font = [UIFont boldSystemFontOfSize:25];
	label3.textAlignment = NSTextAlignmentCenter;
	label3.textColor = [UIColor whiteColor];
	label3.numberOfLines = 1;
	
	label3.text = @"A";
	[self.headerView addSubview:label3];

	UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, 30, 50)];
	label4.font = [UIFont boldSystemFontOfSize:25];
	label4.textAlignment = NSTextAlignmentCenter;
	label4.textColor = [UIColor whiteColor];
	label4.numberOfLines = 1;
	
	label4.text = @"V";
	[self.headerView addSubview:label4];

	UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, 30, 50)];
	label5.font = [UIFont boldSystemFontOfSize:25];
	label5.textAlignment = NSTextAlignmentCenter;
	label5.textColor = [UIColor whiteColor];
	label5.numberOfLines = 1;
	
	label5.text = @"I";
	[self.headerView addSubview:label5];

	UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(170, 30, 30, 50)];
	label6.font = [UIFont boldSystemFontOfSize:25];
	label6.textAlignment = NSTextAlignmentCenter;
	label6.textColor = [UIColor whiteColor];
	label6.numberOfLines = 1;
	
	label6.text = @"T";
	[self.headerView addSubview:label6];

	UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(190, 30, 30, 50)];
	label7.font = [UIFont boldSystemFontOfSize:25];
	label7.textAlignment = NSTextAlignmentCenter;
	label7.textColor = [UIColor whiteColor];
	label7.numberOfLines = 1;
	
	label7.text = @"A";
	[self.headerView addSubview:label7];

	UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 30, 50)];
	label8.font = [UIFont boldSystemFontOfSize:25];
	label8.textAlignment = NSTextAlignmentCenter;
	label8.textColor = [UIColor whiteColor];
	label8.numberOfLines = 1;
	
	label8.text = @"T";
	[self.headerView addSubview:label8];

	UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(240, 30, 30, 50)];
	label9.font = [UIFont boldSystemFontOfSize:25];
	label9.textAlignment = NSTextAlignmentCenter;
	label9.textColor = [UIColor whiteColor];
	label9.numberOfLines = 1;
	
	label9.text = @"I";
	[self.headerView addSubview:label9];

	UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(270, 30, 30, 50)];
	label10.font = [UIFont boldSystemFontOfSize:25];
	label10.textAlignment = NSTextAlignmentCenter;
	label10.textColor = [UIColor whiteColor];
	label10.numberOfLines = 1;
	label10.text = @"O";
	[self.headerView addSubview:label10];

	UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(310, 30, 30, 50)];
	label11.font = [UIFont boldSystemFontOfSize:25];
	label11.textAlignment = NSTextAlignmentCenter;
	label11.textColor = [UIColor whiteColor];
	label11.numberOfLines = 1;
	
	label11.text = @"N";
	[self.headerView addSubview:label11];

	self.gravitation_gravitationAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.headerView];
	self.gravitation_gravitationBehavior = [[UIGravityBehavior alloc] initWithItems:@[]];

	self.gravitation_gravitationCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
    self.gravitation_gravitationCollisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.gravitation_gravitationCollisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    //self.gravitation_gravitationCollisionBehavior.collisionDelegate = self;

	if (self.gravitation_gravitationBehavior)
	{
		for (UIView *i in self.headerView.subviews)
		{
			if (![self.gravitation_gravitationBehavior.items containsObject:i])
			{
				[self.gravitation_gravitationBehavior addItem:i];
			}	
		}
	}
	if (self.gravitation_gravitationCollisionBehavior)
	{
		for (UIView *i in self.headerView.subviews)
		{
			if (![self.gravitation_gravitationCollisionBehavior.items containsObject:i])
			{
				[self.gravitation_gravitationCollisionBehavior addItem:i];
			}	
		}
	}

	__weak GRVRootListController *weakSelf = self;

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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = self.headerView;

    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end
