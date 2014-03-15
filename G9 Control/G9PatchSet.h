//
//  G9PatchSet.h
//  G9 Control
//
//  Created by Simon Biickert on 12/24/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class G9Patch;

@interface G9PatchSet : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSSet *patches;
@end

@interface G9PatchSet (CoreDataGeneratedAccessors)

- (void)addPatchesObject:(G9Patch *)value;
- (void)removePatchesObject:(G9Patch *)value;
- (void)addPatches:(NSSet *)values;
- (void)removePatches:(NSSet *)values;

@end
