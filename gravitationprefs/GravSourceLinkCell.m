#include <Preferences/PSTableCell.h>

@interface GravSourceLinkCell : PSTableCell

@end

@implementation GravSourceLinkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier 
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
	}

	return self;
}

- (void)setSelected:(BOOL)arg1 animated:(BOOL)arg2
{
	[super setSelected:arg1 animated:arg2];

	if (!arg1) return;
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/KritantaDev/Gravitation"] options:@{} completionHandler:nil];
}
@end