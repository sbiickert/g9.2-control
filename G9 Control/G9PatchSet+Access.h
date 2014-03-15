//
//  G9PatchSet+Access.h
//  G9 Control
//
//  Created by Simon Biickert on 12/24/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9PatchSet.h"

@interface G9PatchSet (Access)

+ (G9PatchSet *) createPatchSetWithName:(NSString *)name
				 inManagedObjectContext:(NSManagedObjectContext *)context;

- (G9Patch *) patchForGroup:(NSString *)group
				  bankIndex:(NSNumber *)bank
				 patchIndex:(NSNumber *)patchIndex;

- (void) swapPatchAtIndex:(NSNumber *)indexA forPatchAtIndex:(NSNumber *)indexB inBank:(NSString *)bank;

- (void) movePatch:(G9Patch *)patch toIndex:(NSNumber *)index;

@end
