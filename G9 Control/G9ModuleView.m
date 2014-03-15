//
//  G9PatchOverviewView.m
//  G9 Control
//
//  Created by Simon Biickert on 12/28/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9ModuleView.h"
#import "G9Module.h"
#import "G9Setting.h"
#import "G9ParameterInfo.h"

@implementation G9ModuleView

@synthesize module = _module;
@synthesize onOffButton = _onOffButton;
@synthesize onOffButtonTitle = _onOffButtonTitle;

- (void) setModule:(G9Module *)module
{
	_module = module;
	
	NSTextField *moduleLabel = (NSTextField *)[self viewWithTag:MODULE_LABEL_TAG];
	moduleLabel.stringValue = NSLocalizedStringFromTable(module.moduleName, @"Names", nil);
	[moduleLabel sizeToFit];
	
//	NSTextField *typeLabel = (NSTextField *)[self viewWithTag:MODULE_TYPE_TAG];
//	typeLabel.stringValue = [G9ParameterInfo nameForType:module.setting.type inModuleNamed:module.moduleName];
	
	[self toggleOnOffButton:self];
}

- (void) toggleOnOffButton:(id)sender
{
	self.onOffButtonTitle = self.module.setting.enabled ? NSLocalizedString(@"ON", nil) : NSLocalizedString(@"OFF", nil);
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // This is not being called, see awakeFromNib
    }
    return self;
}

- (void) awakeFromNib
{
	[super awakeFromNib];
	[self.onOffButton bind:@"title" toObject:self withKeyPath:@"onOffButtonTitle" options:nil];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

@end
