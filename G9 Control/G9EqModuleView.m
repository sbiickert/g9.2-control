//
//  G9EqModuleView.m
//  G9 Control
//
//  Created by Simon Biickert on 2014-03-02.
//  Copyright (c) 2014 Simon Biickert. All rights reserved.
//

#import "G9EqModuleView.h"
#import "G9Module.h"
#import "G9ParameterInfo.h"
#import "G9Setting.h"

@interface G9EqModuleView ()

@property (readwrite) BOOL initialBindingComplete;

@end

@implementation G9EqModuleView
@synthesize initialBindingComplete = _initialBindingComplete;

- (void) setModule:(G9Module *)module
{
	[super setModule:module];
	
	if (self.initialBindingComplete == NO)
	{
		for (NSUInteger i = 1; i <= [G9ParameterInfo parameterCountForModuleNamed:self.module.moduleName]; i++)
		{
			NSString *keyPath = [NSString stringWithFormat:@"module.setting.param%lu", i];
			id label;
			SuppressPerformSelectorLeakWarning(label = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"paramValueLabel%lu", (unsigned long)i])]);
			[label bind:@"value" toObject:self withKeyPath:keyPath options:nil];
			
			id slider;
			SuppressPerformSelectorLeakWarning(slider = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"paramSlider%lu", (unsigned long)i])]);
			[slider bind:@"value" toObject:self withKeyPath:keyPath options:nil];
		}
		
		self.initialBindingComplete = YES;
	}
	
	[self updateLabels];
	[self updateControls];
}

- (void) updateLabels
{
	for (NSUInteger i = 1; i <= [G9ParameterInfo parameterCountForModuleNamed:self.module.moduleName]; i++)
	{
		id label;
		NSString *selName = [NSString stringWithFormat:@"paramLabel%lu", (unsigned long)i];
		SEL s = NSSelectorFromString(selName);
		SuppressPerformSelectorLeakWarning(label = [self performSelector:s]);
		[label setStringValue:[G9ParameterInfo nameForParameter:i forType:self.module.setting.type inModuleNamed:self.module.moduleName]];
		[label setToolTip:[G9ParameterInfo descriptionForParameter:i forType:self.module.setting.type inModuleNamed:self.module.moduleName]];
		[label sizeToFit];
	}
}

- (void) updateControls
{
	G9RangeDomain *range;
	for (NSUInteger i = 1; i <= [G9ParameterInfo parameterCountForModuleNamed:self.module.moduleName]; i++)
	{
		id slider;
		SuppressPerformSelectorLeakWarning(slider = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"paramSlider%lu", (unsigned long)i])]);
		
		NSString *keyPath = [NSString stringWithFormat:@"module.setting.param%lu", i];
		range = [G9ParameterInfo rangeForParameter:i forType:self.module.setting.type inModule:self.module.moduleName];
		
		[slider setMinValue:range.minimum];
		[slider setMaxValue:range.maximum];
		[slider setNumberOfTickMarks:range.maximum - range.minimum + 1];
		[slider setToolTip:[G9ParameterInfo descriptionForParameter:i forType:self.module.setting.type inModuleNamed:self.module.moduleName]];
		
		// Make sure the current value jives with the range
		NSNumber *currentNumber = (NSNumber *)[self valueForKeyPath:keyPath];
		NSInteger correctedValue = [range correctValueToClosestLegalValue:[currentNumber integerValue]];
		[self setValue:[NSNumber numberWithInteger:correctedValue] forKeyPath:keyPath];
		
		[(NSSlider*)slider setIntegerValue:correctedValue];
	}
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

@end
