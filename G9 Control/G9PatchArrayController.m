//
//  G9ArrayController.m
//  G9 Control
//
//  Created by Simon Biickert on 12/28/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9PatchArrayController.h"
#import "G9PatchSet+Access.h"
#import "G9Patch+Access.h"

@implementation G9PatchArrayController

@synthesize tableView = _tableView;

- (id) init
{
	self = [super init];
	
	if (self)
	{
		[self initSortDescriptors];
	}
	
	return self;
}

- (void) awakeFromNib
{
	[self initSortDescriptors];
	[self.tableView registerForDraggedTypes:@[G9_PATCH_DND_TYPE]];
	self.tableView.dataSource = self;
	[super awakeFromNib];
}

- (void) initSortDescriptors
{
	NSSortDescriptor *sortBank = [[NSSortDescriptor alloc] initWithKey:@"patchBank" ascending:YES];
	NSSortDescriptor *sortIndex = [[NSSortDescriptor alloc] initWithKey:@"patchIndex" ascending:YES];
	
	self.sortDescriptors = @[sortBank, sortIndex];
}

#pragma mark Drag and Drop in tableview

- (BOOL) tableView:(NSTableView *)tableView
writeRowsWithIndexes:(NSIndexSet *)rowIndexes
	  toPasteboard:(NSPasteboard *)pboard
{
	NSLog(@"Start drag %@", rowIndexes);
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pboard declareTypes:@[G9_PATCH_DND_TYPE] owner:self];
	[pboard setData:data forType:G9_PATCH_DND_TYPE];
	return YES;
}

- (NSDragOperation) tableView:(NSTableView *)tableView
				 validateDrop:(id<NSDraggingInfo>)info
				  proposedRow:(NSInteger)row
		proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
	//NSLog(@"Validate drag");
	
	if (dropOperation == NSTableViewDropOn)
	{
		return NSDragOperationCopy;
	}
	
	// For "reorder" operations, the patch must be moving in the same patchset
	id source = [info draggingSource];
	if (source != self.tableView)
	{
		return NSDragOperationNone;
	}
	
	// Will the relocation be within the same bank?
	// Get the moving patch and the patch it is moving above
	NSPasteboard *draggingPBoard = [info draggingPasteboard];
	
	NSData *data = [draggingPBoard dataForType:G9_PATCH_DND_TYPE];
	NSIndexSet *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	NSUInteger rowIndex = rowIndexes.firstIndex;

	G9Patch *movingPatch = [self.arrangedObjects objectAtIndex:rowIndex];
	G9Patch *abovePatch = row < [self.arrangedObjects count] ? [self.arrangedObjects objectAtIndex:row] : nil;
	G9Patch *belowPatch = row > 0 ? [self.arrangedObjects objectAtIndex:row - 1] : nil;
	
	if (movingPatch == abovePatch || movingPatch == belowPatch) {
		return NSDragOperationNone;
	}
	
	if ([movingPatch.patchBank isEqualToString:abovePatch.patchBank] || [movingPatch.patchBank isEqualToString:belowPatch.patchBank]) {
		return NSDragOperationMove;
	}
	
	return NSDragOperationNone;
}

- (BOOL) tableView:(NSTableView *)tableView
		acceptDrop:(id<NSDraggingInfo>)info
			   row:(NSInteger)row
	 dropOperation:(NSTableViewDropOperation)dropOperation
{
	// Accept the drop here
	NSLog(@"Accept drop");
	
	NSPasteboard *draggingPBoard = [info draggingPasteboard];
	
	NSData *data = [draggingPBoard dataForType:G9_PATCH_DND_TYPE];
	NSIndexSet *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	NSUInteger rowIndex = rowIndexes.firstIndex;
	
	if (dropOperation == NSTableViewDropOn)
	{
		// Overwrite the patch at the index (i.e. copy)
		NSTableView *source = [info draggingSource];
		G9PatchArrayController *controller = (G9PatchArrayController *)[source dataSource];
		
		G9Patch *movingPatch = [controller.arrangedObjects objectAtIndex:rowIndex];
		G9Patch *overwritePatch = [self.arrangedObjects objectAtIndex:row];
		
		[movingPatch copyValuesTo:overwritePatch];
	}
	else // NSTableViewDropAbove, i.e. reorder within bank
	{
		G9Patch *movingPatch = [self.arrangedObjects objectAtIndex:rowIndex];
		G9Patch *targetPatch = [self.arrangedObjects objectAtIndex:row];
		
		if ([movingPatch.patchBank isEqualToString:targetPatch.patchBank])
		{
			// reorder bank relative to targetPatch's patchIndex
			if (row > rowIndex) {
				// Moving patch to higher index: the target will be shifting lower, so subtract one
				[movingPatch.patchSet movePatch:movingPatch toIndex:[NSNumber numberWithInteger:[targetPatch.patchIndex integerValue] - 1]];
			}
			else {
				[movingPatch.patchSet movePatch:movingPatch toIndex:targetPatch.patchIndex];
			}
		}
		else
		{
			// reorder bank so that movingPatch has patchIndex 5
			[movingPatch.patchSet movePatch:movingPatch toIndex:[NSNumber numberWithInteger:5]];
		}
		[self rearrangeObjects];
	}
	return YES;
}
@end
