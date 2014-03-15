//
//  G9Document.m
//  G9 Control
//
//  Created by Simon Biickert on 12/24/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9Document.h"
#import "G9XexTranslator.h"
#import "G9ModuleView.h"
#import "G9ParameterInfo.h"
#import "G9ValueDomain.h"
#import "G9Value.h"

@implementation G9Document

@synthesize collectionViewItem = _collectionViewItem;
@synthesize pedal1TargetsController = _pedal1TargetsController;
@synthesize pedal2VTargetsController = _pedal2VTargetsController;
@synthesize pedal2HTargetsController = _pedal2HTargetsController;

@synthesize arrmTargetsController = _arrmTargetsController;
@synthesize arrmSyncController = _arrmSyncController;
@synthesize arrmWaveController = _arrmWaveController;

- (id)init
{
    self = [super init];
    if (self) {
		[self performSelectorOnMainThread:@selector(initializeDocumentContent) withObject:nil waitUntilDone:NO];
	}
    return self;
}

- (void) initializeDocumentContent
{
	// Check that the document has a patchset in it
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"G9PatchSet"];
	
	NSError *error = nil;
	NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
	if (matches.count == 0)
	{
		// Initialize with factory patches
		[G9XexTranslator loadDefaultPatchesIntoManagedObjectContext:self.managedObjectContext];
	}
}

- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"G9Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	
	// Control target information for pedal, arrm popup buttons
	NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:CONTROL_MAX + 1];
	for (NSUInteger i = 0; i <= CONTROL_MAX; i++)
	{
		[mArray addObject:@{@"name": [G9ParameterInfo labelForControlTargetIndex:i],
							@"value": [NSNumber numberWithUnsignedInteger:i]}];
	}
	
	self.pedal1TargetsController = [[NSArrayController alloc] initWithContent:[NSArray arrayWithArray:mArray]];
	self.pedal2VTargetsController = [[NSArrayController alloc] initWithContent:[NSArray arrayWithArray:mArray]];
	self.pedal2HTargetsController = [[NSArrayController alloc] initWithContent:[NSArray arrayWithArray:mArray]];
	self.arrmTargetsController = [[NSArrayController alloc] initWithContent:[NSArray arrayWithArray:mArray]];
	
	// ARRM wave and sync popup buttons
	G9ValueDomain *waveDomain = (G9ValueDomain *)[G9ParameterInfo rangeForParameter:4 forType:0 inModule:MODULE_ARRM];
	mArray = [[NSMutableArray alloc] init]; // reusing var
	for (G9Value *value in waveDomain.values) {
		[mArray addObject:@{@"name": value.label, @"value":[NSNumber numberWithUnsignedInteger:value.value]}];
	}
	self.arrmWaveController = [[NSArrayController alloc] initWithContent:[NSArray arrayWithArray:mArray]];

	G9ValueDomain *syncDomain = (G9ValueDomain *)[G9ParameterInfo rangeForParameter:5 forType:0 inModule:MODULE_ARRM];
	mArray = [[NSMutableArray alloc] init]; // reusing var
	for (G9Value *value in syncDomain.values) {
		[mArray addObject:@{@"name": value.label, @"value":[NSNumber numberWithUnsignedInteger:value.value]}];
	}
	self.arrmSyncController = [[NSArrayController alloc] initWithContent:[NSArray arrayWithArray:mArray]];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}
@end
