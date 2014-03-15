//
//  ZGRangeDomain.m
//  G9 Control
//
//  Created by Simon Biickert on 12/5/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9RangeDomain.h"

@implementation G9RangeDomain

@synthesize minimum = _minimum;
@synthesize maximum = _maximum;

- (id) initWithMinimum:(NSInteger)minimum andMaximum:(NSInteger)maximum
{
	self = [super init];
	
	self.minimum = minimum;
	self.maximum = maximum;
	
	return self;
}

- (NSInteger) correctValueToClosestLegalValue:(NSInteger)value
{
	if (value < self.minimum) {
		return self.minimum;
	}
	else if (value > self.maximum) {
		return self.maximum;
	}
	return value;
}

@end
