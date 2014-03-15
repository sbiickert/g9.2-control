//
//  G9PatchSet+Access.m
//  G9 Control
//
//  Created by Simon Biickert on 12/24/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9PatchSet+Access.h"
#import "G9Patch+Access.h"
#import "G9XexTranslator.h"

@implementation G9PatchSet (Access)

+ (G9PatchSet *) createPatchSetWithName:(NSString *)name
				 inManagedObjectContext:(NSManagedObjectContext *)context
{
	// There is only one patch set per Core Data document
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"G9PatchSet"];
	
	NSError *error = nil;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	G9PatchSet *patchSet = nil;
	
	if (!matches || matches.count > 0) {
		// delete them and start over
		for (G9PatchSet *patchSet in matches) {
			[context deleteObject:patchSet];
		}
		matches = nil;
	}
	
	patchSet = [NSEntityDescription insertNewObjectForEntityForName:@"G9PatchSet"
											 inManagedObjectContext:context];
	patchSet.name = name;
	
	return patchSet;
}

- (G9Patch *) patchForGroup:(NSString *)group
				  bankIndex:(NSNumber *)bank
				 patchIndex:(NSNumber *)patchIndex
{
	for (G9Patch *patch in self.patches) {
		if ([patch.patchBank isEqualToString:[NSString stringWithFormat:@"%@%@", group, bank]]  && [patchIndex isEqualToNumber:patch.patchIndex])
		{
			return patch;
		}
	}
	return nil;
}

- (G9Patch *) patchForBank:(NSString *)bank
				patchIndex:(NSNumber *)patchIndex
{
	for (G9Patch *patch in self.patches) {
		if ([patch.patchBank isEqualToString:bank] && [patchIndex isEqualToNumber:patch.patchIndex])
		{
			return patch;
		}
	}
	return nil;
}

- (void) swapPatchAtIndex:(NSNumber *)indexA
		  forPatchAtIndex:(NSNumber *)indexB
				   inBank:(NSString *)bank
{
	G9Patch *patchA = [self patchForBank:bank patchIndex:indexA];
	G9Patch *patchB = [self patchForBank:bank patchIndex:indexB];
	
	if (patchA && patchB)
	{
		NSNumber *temp = patchA.patchIndex;
		patchA.patchIndex = patchB.patchIndex;
		patchB.patchIndex = temp;
	}
}

- (void) movePatch:(G9Patch *)patch toIndex:(NSNumber *)index
{
	if (patch && index.longValue > 0 && index.longValue <= 5)
	{
		NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:5];
		for (NSInteger i = 1; i <= 5; i++)
		{
			NSNumber *originalIndex = [NSNumber numberWithInteger:i];
			G9Patch *otherPatch = [self patchForBank:patch.patchBank patchIndex:originalIndex];
			if (patch != otherPatch)
			{
				[array addObject:otherPatch];
			}
		}
		[array insertObject:patch atIndex:[index unsignedIntegerValue] - 1];
		
		for (NSInteger i = 1; i <= 5; i++)
		{
			G9Patch *p = array[i-1];
			p.patchIndex = [NSNumber numberWithInteger:i];
		}
	}
}
@end
