//
//  G9ModuleCollectionViewItem.m
//  G9 Control
//
//  Created by Simon Biickert on 2014-02-28.
//  Copyright (c) 2014 Simon Biickert. All rights reserved.
//

#import "G9ModuleCollectionViewItem.h"
#import "G9Module.h"
#import "G9ModuleView.h"
#import "G9ParameterInfo.h"
#import "G9Patch+Access.h"

@interface G9ModuleCollectionViewItem ()

@end

@implementation G9ModuleCollectionViewItem

- (G9Module *) module
{
	G9Module *module = (G9Module *)self.representedObject;
	return module;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
		[self.view bind:@"module" toObject:self withKeyPath:@"representedObject" options:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modulesReordered:) name:MODULES_REORDERED object:nil];
    }
    return self;
}

- (void) setRepresentedObject:(id)representedObject
{
	[super setRepresentedObject:representedObject];
	
	// take additional action here
	if ([representedObject isKindOfClass:[G9Module class]])
	{
		G9Module *module = (G9Module *)representedObject;
		
		NSLog(@"Represented object is %@", module.moduleName);
		
		NSString *correctNibName = @"G9ModuleView"; // Default
		
		if ([module.moduleName isEqualToString:MODULE_AMP])
		{
			correctNibName = @"G9AmpModuleView";
			
		}
		else if ([module.moduleName isEqualToString:MODULE_CAB])
		{
			
		}
		else if ([module.moduleName isEqualToString:MODULE_COMP])
		{
			correctNibName = @"G9CompModuleView";
		}
		else if ([module.moduleName isEqualToString:MODULE_DELAY])
		{
			correctNibName = @"G9DelayModuleView";
		}
		else if ([module.moduleName isEqualToString:MODULE_EQ])
		{
			correctNibName = @"G9EqModuleView";
		}
		else if ([module.moduleName isEqualToString:MODULE_EXTLOOP])
		{
			
		}
		else if ([module.moduleName isEqualToString:MODULE_MOD])
		{
			correctNibName = @"G9ModModuleView";
		}
		else if ([module.moduleName isEqualToString:MODULE_REVERB])
		{
			correctNibName = @"G9ReverbModuleView";
		}
		else if ([module.moduleName isEqualToString:MODULE_WAH])
		{
			correctNibName = @"G9WahModuleView";
		}
		else if ([module.moduleName isEqualToString:MODULE_ZNR])
		{
			correctNibName = @"G9ZnrModuleView";
		}
		
		if ([self.nibName isEqualToString:correctNibName] == NO)
		{
			[self reloadView:correctNibName];
		}

	}
}

- (void) reloadView:(NSString *)nibName
{
	NSNib *nib = [[NSNib alloc] initWithNibNamed:nibName bundle:nil];
	NSArray *topLevelObjects;
	if ([nib instantiateWithOwner:self topLevelObjects:&topLevelObjects])
	{
		for (NSUInteger i = 0; i < topLevelObjects.count; i++) {
			NSView *view = [topLevelObjects objectAtIndex:i];
			if ([view isKindOfClass:[G9ModuleView class]]) {
				[self setView:view];
				[self.view bind:@"module" toObject:self withKeyPath:@"representedObject" options:nil];
			}
		}
	}
}

- (void) modulesReordered:(NSNotification *)note
{
	if (note.object == self.view)
	{
		// Easiest way is to just call arrangedModules
		[self.module.patch arrangedModules];
		
		// Scroll the collection view
		NSInteger i = 0;
		for (G9Module *m in self.module.patch.modules)
		{
			if ([m.moduleName isEqualToString:self.module.moduleName])
			{
				NSRect rect = [self.collectionView frameForItemAtIndex:i];
				[self.collectionView scrollRectToVisible:rect];
				break;
			}
			i++;
		}
	}
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
