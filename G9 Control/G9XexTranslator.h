//
//  G9XexTranslator.h
//  G9 Control
//
//  Created by Simon Biickert on 12/13/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class G9PatchSet;

@interface G9XexTranslator : NSObject

+ (G9PatchSet *) loadDefaultPatchesIntoManagedObjectContext:(NSManagedObjectContext *)context;

+ (G9PatchSet *) loadXexFileAtPath:(NSString *)filePath
		  intoManagedObjectContext:(NSManagedObjectContext *)context
						  withName:(NSString *)name;

+ (void) savePatchSetAtDefaultLocation:(G9PatchSet *)patchSet;

+ (void) savePatchSet:(G9PatchSet *)patchSet
		 toFileAtPath:(NSString *)filePath;
@end
