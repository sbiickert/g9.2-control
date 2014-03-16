//
//  G9RangeNumberFormatter.m
//  G9 Control
//
//  Created by Simon Biickert on 2014-03-16.
//  Copyright (c) 2014 Simon Biickert. All rights reserved.
//

#import "G9RangeNumberFormatter.h"

@implementation G9RangeNumberFormatter

@synthesize integerMaximum = _integerMaximum;
@synthesize integerMinimum = _integerMinimum;

- (id) initWithMinimum:(NSInteger)minimum andMaximum:(NSInteger)maximum
{
	self = [super init];
	
	if (self)
	{
		self.integerMinimum = minimum;
		self.integerMaximum = maximum;
	}
	
	return self;
}

- (void) setIntegerMinimum:(NSInteger)value
{
	_integerMinimum = value;
	self.minimum = [NSNumber numberWithInteger:value];
}

- (void) setIntegerMaximum:(NSInteger)value
{
	_integerMaximum = value;
	self.maximum = [NSNumber numberWithInteger:value];
}

- (BOOL) isPartialStringValid:(NSString *)partialString newEditingString:(NSString *__autoreleasing *)newString errorDescription:(NSString *__autoreleasing *)error
{
	if([partialString length] == 0) {
        return YES;
    }
	
    NSScanner* scanner = [NSScanner scannerWithString:partialString];
	
	int scannedValue = 0;
	
    if(!([scanner scanInt:&scannedValue] && [scanner isAtEnd])) {
        NSBeep();
        return NO;
    }
	
	if (scannedValue < self.integerMinimum || scannedValue > self.integerMaximum)
	{
        NSBeep();
        return NO;
	}
	
    return YES;
}

- (NSString *) correctedStringForInputString:(NSString *)inputString
{
	if ([inputString length] == 0)
	{
		return @"";
	}
	
    NSScanner* scanner = [NSScanner scannerWithString:inputString];
	
	int scannedValue = 0;
	
    if(!([scanner scanInt:&scannedValue] && [scanner isAtEnd])) {
        return @"";
    }
	
	if (scannedValue < self.integerMinimum)
	{
        return [NSString stringWithFormat:@"%ld", self.integerMinimum];
	}
	
	if (scannedValue > self.integerMaximum)
	{
        return [NSString stringWithFormat:@"%ld", self.integerMaximum];
	}
	
    return inputString;
}

@end
