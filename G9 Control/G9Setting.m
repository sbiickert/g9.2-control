//
//  Setting.m
//  G9 Control
//
//  Created by Simon Biickert on 11/28/2013.
//  Copyright (c) 2013 Simon Biickert. All rights reserved.
//

#import "G9Setting.h"


@implementation G9Setting

@synthesize enabled;
@synthesize param1;
@synthesize param2;
@synthesize param3;
@synthesize param4;
@synthesize param5;
@synthesize param6;
@synthesize type;

- (id)initWithCoder:(NSCoder *)coder
{
	self = [self init];
	self.enabled = [coder decodeBoolForKey:@"enabled"];
	self.param1 = [coder decodeIntegerForKey:@"param1"];
	self.param2 = [coder decodeIntegerForKey:@"param2"];
	self.param3 = [coder decodeIntegerForKey:@"param3"];
	self.param4 = [coder decodeIntegerForKey:@"param4"];
	self.param5 = [coder decodeIntegerForKey:@"param5"];
	self.param6 = [coder decodeIntegerForKey:@"param6"];
	self.type = [coder decodeIntegerForKey:@"type"];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeBool:self.enabled forKey:@"enabled"];
	[coder encodeInteger:self.param1 forKey:@"param1"];
	[coder encodeInteger:self.param2 forKey:@"param2"];
	[coder encodeInteger:self.param3 forKey:@"param3"];
	[coder encodeInteger:self.param4 forKey:@"param4"];
	[coder encodeInteger:self.param5 forKey:@"param5"];
	[coder encodeInteger:self.param6 forKey:@"param6"];
	[coder encodeInteger:self.type forKey:@"type"];
}

- (void) copyValuesTo:(G9Setting *)other
{
	other.enabled = self.enabled;
	other.param1 = self.param1;
	other.param2 = self.param2;
	other.param3 = self.param3;
	other.param4 = self.param4;
	other.param5 = self.param5;
	other.param6 = self.param6;
	other.type = self.type;
}

@end
