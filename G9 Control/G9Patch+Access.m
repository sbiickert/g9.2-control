//
//  G9Patch+Access.m
//  G9 Control
//
//  Created by Simon Biickert on 12/24/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9Patch+Access.h"
#import "G9Setting.h"
#import "G9ParameterInfo.h"
#import "G9Module.h"

@implementation G9Patch (Access)

+ (G9Patch *) createPatchWithGroup:(NSString *)group
							  bank:(NSNumber *)bank
						patchIndex:(NSNumber *)patchIndex
			inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"G9Patch"];
	request.predicate = [NSPredicate predicateWithFormat:@"patchBank == %@ and patchIndex == %@", [NSString stringWithFormat:@"%@%@", group, bank], patchIndex];
	
	NSError *error = nil;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (matches.count > 1) {
		for (G9Patch *patch in matches) {
			[context deleteObject:patch];
		}
		matches = nil;
	}
	
	G9Patch *patch;
	if (matches.count == 0)
	{
		// Insert record
		patch = [NSEntityDescription insertNewObjectForEntityForName:@"G9Patch"
												   inManagedObjectContext:context];
	}
	else {
		patch = matches.lastObject;
	}
	
	patch.patchBank = [NSString stringWithFormat:@"%@%@", group, bank];
	patch.patchIndex = patchIndex;
	
	return patch;
}

+ (void) clearAllPatchesInManagedObjectContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"G9Patch"];
	NSError *error = nil;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	for (G9Patch *patch in matches) {
		[context deleteObject:patch];
	}
}

+ (BOOL) automaticallyNotifiesObserversOfModules
{
	return NO;
}

- (void) copyValuesTo:(G9Patch *)other
{
	other.ampSelection = self.ampSelection;
	other.comment = self.comment;
	other.name = self.name;
	other.patchLevel = self.patchLevel;

	[((G9Setting *)self.ampA) copyValuesTo:other.ampA];
	[((G9Setting *)self.ampB) copyValuesTo:other.ampB];
	[((G9Setting *)self.arrm) copyValuesTo:other.arrm];
	[((G9Setting *)self.cab) copyValuesTo:other.cab];
	[((G9Setting *)self.comp) copyValuesTo:other.comp];
	[((G9Setting *)self.delay) copyValuesTo:other.delay];
	[((G9Setting *)self.eqA) copyValuesTo:other.eqA];
	[((G9Setting *)self.eqB) copyValuesTo:other.eqB];
	[((G9Setting *)self.extLoop) copyValuesTo:other.extLoop];
	[((G9Setting *)self.mod) copyValuesTo:other.mod];
	[((G9Setting *)self.reverb) copyValuesTo:other.reverb];
	[((G9Setting *)self.total) copyValuesTo:other.total];
	[((G9Setting *)self.wah) copyValuesTo:other.wah];
	[((G9Setting *)self.znrA) copyValuesTo:other.znrA];
	[((G9Setting *)self.znrB) copyValuesTo:other.znrB];
	
	[((G9Setting *)self.pedal1v1) copyValuesTo:other.pedal1v1];
	[((G9Setting *)self.pedal1v2) copyValuesTo:other.pedal1v2];
	[((G9Setting *)self.pedal1v3) copyValuesTo:other.pedal1v3];
	[((G9Setting *)self.pedal1v4) copyValuesTo:other.pedal1v4];
	[((G9Setting *)self.pedal2v1) copyValuesTo:other.pedal2v1];
	[((G9Setting *)self.pedal2v2) copyValuesTo:other.pedal2v2];
	[((G9Setting *)self.pedal2v3) copyValuesTo:other.pedal2v3];
	[((G9Setting *)self.pedal2v4) copyValuesTo:other.pedal2v4];
	[((G9Setting *)self.pedal2h1) copyValuesTo:other.pedal2h1];
	[((G9Setting *)self.pedal2h2) copyValuesTo:other.pedal2h2];
	[((G9Setting *)self.pedal2h3) copyValuesTo:other.pedal2h3];
	[((G9Setting *)self.pedal2h4) copyValuesTo:other.pedal2h4];
}

- (BOOL) isWahBefore
{
	G9Setting *wah = self.wah;
	G9RangeDomain *range = [G9ParameterInfo rangeForParameter:1 forType:wah.type inModule:MODULE_WAH];
	if ([range isKindOfClass:[G9ValueDomain class]])
	{
		G9ValueDomain *valueDomain = (G9ValueDomain *)range;
		if ([valueDomain valueCount] == 2 && [valueDomain valueAtIndex:0].value == WAH_BEFORE && [valueDomain valueAtIndex:1].value == WAH_AFTER)
		{
			return wah.param1 == WAH_BEFORE;
		}
	}
	return YES;
}

- (BOOL) isAmpPre
{
	G9Setting *amp = [self settingForName:MODULE_AMP];
	G9RangeDomain *range = [G9ParameterInfo rangeForParameter:4 forType:amp.type inModule:MODULE_AMP];
	if ([range isKindOfClass:[G9ValueDomain class]])
	{
		G9ValueDomain *valueDomain = (G9ValueDomain *)range;
		if ([valueDomain valueCount] == 2 && [valueDomain valueAtIndex:0].value == AMP_PRE && [valueDomain valueAtIndex:1].value == AMP_POST)
		{
			return amp.param4 ==  AMP_PRE;
		}
	}
	return YES;
}

- (BOOL) isAmpASelected
{
	return [self.ampSelection isEqualToNumber:[NSNumber numberWithInteger:0]];
}

- (NSArray *) arrangedModules
{
	NSMutableArray *moduleArray = self.modules;
	
	// Array of Module objects. Order dependent on the amp pre/post, wah before/after settings
	NSArray *moduleNamesArray;
	if (self.isWahBefore)
	{
		if (self.isAmpPre)
		{
			// comp, wah, ext, znr, amp, eq, cab, mod, delay, reverb
			moduleNamesArray = @[MODULE_COMP, MODULE_WAH, MODULE_EXTLOOP, MODULE_ZNR, MODULE_AMP,
								 MODULE_EQ, MODULE_CAB, MODULE_MOD, MODULE_DELAY, MODULE_REVERB];
		}
		else
		{
			// comp, wah, mod, delay, ext, znr, amp, eq, cab, reverb
			moduleNamesArray = @[MODULE_COMP, MODULE_WAH, MODULE_MOD, MODULE_DELAY, MODULE_EXTLOOP,
								 MODULE_ZNR, MODULE_AMP, MODULE_EQ, MODULE_CAB, MODULE_REVERB];
		}
	}
	else
	{
		if (self.isAmpPre)
		{
			// comp, ext, znr, amp, eq, cab, wah, mod, delay, reverb
			moduleNamesArray = @[MODULE_COMP, MODULE_EXTLOOP, MODULE_ZNR, MODULE_AMP, MODULE_EQ,
								 MODULE_CAB, MODULE_WAH, MODULE_MOD, MODULE_DELAY, MODULE_REVERB];
		}
		else
		{
			// comp, mod, delay, ext, znr, amp, eq, cab, wah, reverb
			moduleNamesArray = @[MODULE_COMP, MODULE_MOD, MODULE_DELAY, MODULE_EXTLOOP, MODULE_ZNR,
								 MODULE_AMP, MODULE_EQ, MODULE_CAB, MODULE_WAH, MODULE_REVERB];
		}
	}
	
	// Reorder array based on names
	BOOL didReorderModules = NO;
	for (NSInteger i = 0; i < moduleNamesArray.count; i++) {
		NSLog(@"Module %ld is currently %@, should be %@", (long)i, [moduleArray[i] moduleName], moduleNamesArray[i]);
		if ([[moduleArray[i] moduleName] isEqualToString:moduleNamesArray[i]] == NO)
		{
			// find it and insert it here
			for (NSInteger j = i+1; j < moduleArray.count; j++)
			{
				if ([[moduleArray[j] moduleName] isEqualToString:moduleNamesArray[i]])
				{
					G9Module *moduleToReorder = [moduleArray objectAtIndex:j];
					[moduleArray removeObjectAtIndex:j];
					[moduleArray insertObject:moduleToReorder atIndex:i];
					break;
				}
			}
			didReorderModules = YES;
		}
	}
	
	if (didReorderModules) {
		[self triggerModuleBindingUpdate];
	}
	return [NSArray arrayWithArray:moduleArray];
}

- (void) triggerModuleBindingUpdate
{
	[self willChangeValueForKey:@"arrangedModules"];
	[self didChangeValueForKey:@"arrangedModules"];
}

- (G9Setting *) settingForName:(NSString *)moduleName
{
	G9Setting *setting;
	
	if ([moduleName isEqualToString:MODULE_AMP])
	{
		setting = [self isAmpASelected] ? self.ampA : self.ampB;
	}
	else if ([moduleName isEqualToString:MODULE_ARRM])
	{
		setting = self.arrm;
	}
	else if ([moduleName isEqualToString:MODULE_CAB])
	{
		setting = self.cab;
	}
	else if ([moduleName isEqualToString:MODULE_COMP])
	{
		setting = self.comp;
	}
	else if ([moduleName isEqualToString:MODULE_DELAY])
	{
		setting = self.delay;
	}
	else if ([moduleName isEqualToString:MODULE_EQ])
	{
		setting = setting = [self isAmpASelected] ? self.eqA : self.eqB;
	}
	else if ([moduleName isEqualToString:MODULE_EXTLOOP])
	{
		setting = self.extLoop;
	}
	else if ([moduleName isEqualToString:MODULE_MOD])
	{
		setting = self.mod;
	}
//	else if ([moduleName isEqualToString:MODULE_PEDAL])
//	{
//		setting = self.arrm;
//	}
	else if ([moduleName isEqualToString:MODULE_REVERB])
	{
		setting = self.reverb;
	}
	else if ([moduleName isEqualToString:MODULE_TOTAL])
	{
		setting = self.total;
	}
	else if ([moduleName isEqualToString:MODULE_WAH])
	{
		setting = self.wah;
	}
	else if ([moduleName isEqualToString:MODULE_ZNR])
	{
		setting = setting = [self isAmpASelected] ? self.znrA : self.znrB;
	}
	
	return setting;
}

- (NSString *) debugDescription
{
	return [NSString stringWithFormat:@"G9Patch %@-%@ %@", self.patchBank, self.patchIndex, self.name];
}

@end
