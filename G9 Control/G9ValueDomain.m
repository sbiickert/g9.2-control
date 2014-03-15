//
//  ZGValueDomain.m
//  G9 Control
//
//  Created by Simon Biickert on 12/5/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9ValueDomain.h"

@interface G9ValueDomain()

@property (nonatomic, retain) NSMutableArray *mutableValues;

@end

@implementation G9ValueDomain

@synthesize mutableValues = _mutableValues;

- (id) init
{
	self = [super init];
	self.mutableValues = [[NSMutableArray alloc] init];
	
	return self;
}

- (NSUInteger) valueCount
{
	return self.mutableValues.count;
}

- (NSArray *) values
{
	return [self.mutableValues copy];
}

- (G9Value *) valueAtIndex:(NSUInteger)index
{
	return self.mutableValues[index];
}

- (void) addValue:(G9Value *)value
{
	[self.mutableValues addObject:value];
}

- (NSInteger) minimum
{
	NSInteger min = NSIntegerMax;
	for (G9Value *val in self.mutableValues) {
		if (val.value < min) {
			min = val.value;
		}
	}
	return min;
}

- (NSInteger) maximum
{
	NSInteger max = NSIntegerMin;
	for (G9Value *val in self.mutableValues) {
		if (val.value > max) {
			max = val.value;
		}
	}
	return max;
}

- (NSInteger) correctValueToClosestLegalValue:(NSInteger)value
{
	// overriding implementation in G9RangeDomain
	G9Value *closest = nil;
	NSInteger smallestDiff = NSIntegerMax;
	
	for (G9Value *v in self.mutableValues) {
		NSInteger diff = ABS(v.value - value);
		if (diff < smallestDiff) {
			closest = v;
			smallestDiff = diff;
		}
		if (diff == 0) {
			break;
		}
	}
	return closest.value;
}

@end
