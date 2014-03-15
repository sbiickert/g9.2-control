//
//  G9CompModuleView.m
//  G9 Control
//
//  Created by Simon Biickert on 2014-03-01.
//  Copyright (c) 2014 Simon Biickert. All rights reserved.
//

#import "G9WahModuleView.h"
#import "G9Module.h"
#import "G9ParameterInfo.h"
#import "G9Setting.h"
#import "G9Value.h"

@implementation G9WahModuleView

@synthesize popUpArrayControllers = _popUpArrayControllers;

- (void) setModule:(G9Module *)module
{
	[super setModule:module];
	
	// Set up and bind the rest of the controls
	NSUInteger typeCount = [G9ParameterInfo typeCountForModuleNamed:self.module.moduleName];
	NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:typeCount];
	for (NSUInteger i = 0; i < typeCount; i++)
	{
		[mArray addObject:@{@"name": [G9ParameterInfo nameForType:i inModuleNamed:self.module.moduleName],
							@"value": [NSNumber numberWithUnsignedInteger:i]}];
	}
	
	self.typeArrayController = [[NSArrayController alloc] initWithContent:[NSArray arrayWithArray:mArray]];

	[self.typePopUp bind:@"content" toObject:self.typeArrayController withKeyPath:@"arrangedObjects" options:nil];
	[self.typePopUp bind:@"contentObjects" toObject:self.typeArrayController withKeyPath:@"arrangedObjects.value" options:nil];
	[self.typePopUp bind:@"contentValues" toObject:self.typeArrayController withKeyPath:@"arrangedObjects.name" options:nil];
	[self.typePopUp bind:@"selectedObject" toObject:self withKeyPath:@"module.setting.type" options:nil];
	
	[self addObserver:self forKeyPath:@"module.setting.type" options:0 context:NULL];
	[self updateParameterLabels];
	[self updateControls];

}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"module.setting.type"])
	{
		[self updateParameterLabels];
		[self updateControls];
	}
}

- (void) updateParameterLabels
{
	for (NSUInteger i = 1; i <= [G9ParameterInfo parameterCountForModuleNamed:self.module.moduleName]; i++)
	{
		id label;
		SuppressPerformSelectorLeakWarning(
			label = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"paramLabel%lu", (unsigned long)i])]
		);
		[label setStringValue:[G9ParameterInfo nameForParameter:i forType:self.module.setting.type inModuleNamed:self.module.moduleName]];
		[label sizeToFit];
	}
}

- (void) updateControls
{
	G9RangeDomain *range;
	for (NSUInteger i = 1; i <= [G9ParameterInfo parameterCountForModuleNamed:self.module.moduleName]; i++)
	{
		id slider;
		id popup;
		SuppressPerformSelectorLeakWarning(slider = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"paramSlider%lu", (unsigned long)i])]);
		SuppressPerformSelectorLeakWarning(popup = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"paramPopUp%lu", (unsigned long)i])]);
		
		NSString *keyPath = [NSString stringWithFormat:@"module.setting.param%lu", i];
		range = [G9ParameterInfo rangeForParameter:i forType:self.module.setting.type inModule:self.module.moduleName];
		
		[slider setMinValue:range.minimum];
		[slider setMaxValue:range.maximum];
		[slider setNumberOfTickMarks:range.maximum - range.minimum + 1];

		if ([range isKindOfClass:[G9ValueDomain class]])
		{
			// Show popup button, hide slider
			[slider setHidden:YES];
			[popup setHidden:NO];
			
			// Make the popup menu values
			G9ValueDomain *domain = (G9ValueDomain *)range;
			NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:domain.valueCount];
			for (NSUInteger i = 0; i < domain.valueCount; i++)
			{
				G9Value *value = [domain valueAtIndex:i];
				[mArray addObject:@{@"name": value.label,
									@"value": [NSNumber numberWithUnsignedInteger:value.value]}];
			}
			
			NSArrayController *controller;
			if (self.popUpArrayControllers[keyPath])
			{
				// Use previous array controller
				controller = self.popUpArrayControllers[keyPath];
				[controller setContent:[NSArray arrayWithArray:mArray]];
			}
			else {
				// Create the new array controller
				controller = [[NSArrayController alloc] initWithContent:[NSArray arrayWithArray:mArray]];
				[self.popUpArrayControllers setValue:controller forKey:keyPath];
			
				// Bind the popup to it
				[popup bind:@"content" toObject:controller withKeyPath:@"arrangedObjects" options:nil];
				[popup bind:@"contentObjects" toObject:controller withKeyPath:@"arrangedObjects.value" options:nil];
				[popup bind:@"contentValues" toObject:controller withKeyPath:@"arrangedObjects.name" options:nil];
			}
			
			[popup bind:@"selectedObject" toObject:self withKeyPath:keyPath options:nil];
		}
		else
		{
			// Show slider, hide popup button
			[slider setHidden:NO];
			[popup setHidden:YES];
			[popup unbind:@"selectedObject"];
		}
		
		// Make sure the current value jives with the range
		NSNumber *currentNumber = (NSNumber *)[self valueForKeyPath:keyPath];
		NSInteger correctedValue = [range correctValueToClosestLegalValue:[currentNumber integerValue]];
		[self setValue:[NSNumber numberWithInteger:correctedValue] forKeyPath:keyPath];
	}
}

- (void) viewWillDraw
{
	[self.typePopUp sizeToFit];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) awakeFromNib
{
	[super awakeFromNib];
	
	[self.typePopUp bind:@"enabled" toObject:self withKeyPath:@"module.setting.enabled" options:nil];
	
	for (NSUInteger i = 1; i <= [G9ParameterInfo parameterCountForModuleNamed:MODULE_WAH]; i++)
	{
		NSString *keyPath = [NSString stringWithFormat:@"module.setting.param%lu", i];
		id label;
		SuppressPerformSelectorLeakWarning(label = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"paramValueLabel%lu", (unsigned long)i])]);
		[label bind:@"value" toObject:self withKeyPath:keyPath options:nil];
	
		id slider;
		SuppressPerformSelectorLeakWarning(slider = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"paramSlider%lu", (unsigned long)i])]);
		[slider bind:@"value" toObject:self withKeyPath:keyPath options:nil];
		[slider bind:@"enabled" toObject:self withKeyPath:@"module.setting.enabled" options:nil];
		
		id popup;
		SuppressPerformSelectorLeakWarning(popup = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"paramPopUp%lu", (unsigned long)i])]);
		[popup bind:@"enabled" toObject:self withKeyPath:@"module.setting.enabled" options:nil];
	}
	self.popUpArrayControllers = [[NSMutableDictionary alloc] init];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

@end
