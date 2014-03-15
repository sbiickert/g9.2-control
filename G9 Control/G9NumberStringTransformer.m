//
//  G9IntegerStringTransformer.m
//  G9 Control
//
//  Created by Simon Biickert on 2014-03-04.
//  Copyright (c) 2014 Simon Biickert. All rights reserved.
//

#import "G9NumberStringTransformer.h"

@implementation G9NumberStringTransformer

+ (Class) transformedValueClass
{
	return [NSString class];
}

+ (BOOL) allowsReverseTransformation
{
	return YES;
}

- (id) transformedValue:(id)value
{
	NSNumber *num = (NSNumber *)value;
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.numberStyle = NSNumberFormatterDecimalStyle;
	
	return [formatter stringFromNumber:num];
}

@end
