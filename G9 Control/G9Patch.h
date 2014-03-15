//
//  G9Patch.h
//  G9 Control
//
//  Created by Simon Biickert on 12/28/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class G9PatchSet;

@interface G9Patch : NSManagedObject

@property (nonatomic, retain) NSNumber * ampSelection;
@property (nonatomic, retain) NSNumber * patchLevel;
@property (nonatomic, retain) id ampA;
@property (nonatomic, retain) id ampB;
@property (nonatomic, retain) id arrm;
@property (nonatomic, retain) id cab;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) id comp;
@property (nonatomic, retain) id delay;
@property (nonatomic, retain) id eqA;
@property (nonatomic, retain) id eqB;
@property (nonatomic, retain) id extLoop;
@property (nonatomic, retain) id mod;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id pedal1v1;
@property (nonatomic, retain) id pedal1v2;
@property (nonatomic, retain) id pedal1v3;
@property (nonatomic, retain) id pedal1v4;
@property (nonatomic, retain) id pedal2h1;
@property (nonatomic, retain) id pedal2h2;
@property (nonatomic, retain) id pedal2h3;
@property (nonatomic, retain) id pedal2h4;
@property (nonatomic, retain) id pedal2v1;
@property (nonatomic, retain) id pedal2v2;
@property (nonatomic, retain) id pedal2v3;
@property (nonatomic, retain) id pedal2v4;
@property (nonatomic, retain) id reverb;
@property (nonatomic, retain) id total;
@property (nonatomic, retain) id wah;
@property (nonatomic, retain) id znrA;
@property (nonatomic, retain) id znrB;
@property (nonatomic, retain) NSString * patchBank;
@property (nonatomic, retain) NSNumber * patchIndex;
@property (nonatomic, retain) G9PatchSet *patchSet;

// Manually added
@property (retain, nonatomic) NSMutableArray *modules;

@end
