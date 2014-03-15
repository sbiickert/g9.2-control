//
//  G9Patch+Access.h
//  G9 Control
//
//  Created by Simon Biickert on 12/24/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9Patch.h"

@class G9Setting;

@interface G9Patch (Access)

+ (G9Patch *) createPatchWithGroup:(NSString *)group
							  bank:(NSNumber *)bank
						patchIndex:(NSNumber *)patchIndex
			inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void) clearAllPatchesInManagedObjectContext:(NSManagedObjectContext *)context;


- (void) copyValuesTo:(G9Patch *)other;

@property (readonly) BOOL isWahBefore;
@property (readonly) BOOL isAmpPre;
@property (readonly) NSArray *arrangedModules;

- (G9Setting *) settingForName:(NSString *)moduleName;

@end
