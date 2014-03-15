//
//  ZGValue.m
//  G9 Control
//
//  Created by Simon Biickert on 12/5/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9Value.h"

@implementation G9Value

@synthesize value = _value;
@synthesize label = _label;

- (id) initWithValue:(NSInteger)value andLabel:(NSString *)label
{
	self = [super init];
	
	self.value = value;
	self.label = label;
	
	return self;
}

@end
